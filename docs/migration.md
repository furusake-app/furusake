# Gooseによるデータベースマイグレーション

## 前提条件

- Gooseがインストール済みであること
- .envにDATABASE_URLを設定していること
- PostgreSQLが起動していること

## 基本フロー

### 1. マイグレーション作成

```bash
# SQLマイグレーション
just migrate-create add_user_table

# Goマイグレーション (複雑なロジック用)
just migrate-create complex_data_migration go
```

### 2. ファイル編集

#### SQL例

作成ファイル (例: `002_add_user_table.sql`) を編集:

```sql
-- +goose Up
CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    email VARCHAR(255) NOT NULL UNIQUE,
    name VARCHAR(100) NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_active ON users(is_active);

-- +goose Down
DROP INDEX IF EXISTS idx_users_active;
DROP INDEX IF EXISTS idx_users_email;
DROP TABLE IF EXISTS users;
```

#### Go例

複雑なデータ変換:

```go
package main

import (
    "database/sql"
    "fmt"
    "github.com/pressly/goose/v3"
)

func init() {
    goose.AddMigration(upComplexDataMigration, downComplexDataMigration)
}

func upComplexDataMigration(tx *sql.Tx) error {
    // 既存データを新形式に変換
    rows, err := tx.Query("SELECT id, old_field FROM example")
    if err != nil {
        return err
    }
    defer rows.Close()

    for rows.Next() {
        var id int
        var oldField string
        if err := rows.Scan(&id, &oldField); err != nil {
            return err
        }

        // データ変換ロジック
        newValue := processOldField(oldField)

        _, err = tx.Exec("UPDATE example SET new_field = $1 WHERE id = $2", newValue, id)
        if err != nil {
            return err
        }
    }

    return nil
}

func downComplexDataMigration(tx *sql.Tx) error {
    // ロールバック処理
    _, err := tx.Exec("ALTER TABLE example DROP COLUMN IF EXISTS new_field")
    return err
}

func processOldField(oldValue string) string {
    // 変換ロジック実装
    return fmt.Sprintf("processed_%s", oldValue)
}
```

## Justfile

利用可能コマンド

```makefile
# マイグレーション実行
migrate-up:
    goose -dir migrations postgres "${DATABASE_URL}" up

# マイグレーションロールバック
migrate-down:
    goose -dir migrations postgres "${DATABASE_URL}" down

# マイグレーション状態確認
migrate-status:
    goose -dir migrations postgres "${DATABASE_URL}" status

# マイグレーション作成
migrate-create name type="sql":
    goose -dir migrations create {{name}} {{type}}

# マイグレーションリセット
migrate-reset:
    goose -dir migrations postgres "${DATABASE_URL}" reset

# マイグレーションバージョン確認
migrate-version:
    goose -dir migrations postgres "${DATABASE_URL}" version
```
