package db

import (
	"context"
	"fmt"
	"os"

	"github.com/jackc/pgx/v5/pgxpool"
)

var DB *pgxpool.Pool

func Connect() error {
	databaseURL := os.Getenv("DATABASE_URL")
	if databaseURL == "" {
		return fmt.Errorf("DATABASE_URL environment variable is not set")
	}

	var err error
	DB, err = pgxpool.New(context.Background(), databaseURL)
	if err != nil {
		return fmt.Errorf("failed to create connection pool: %w", err)
	}

	if err := DB.Ping(context.Background()); err != nil {
		return fmt.Errorf("failed to ping database: %w", err)
	}

	return nil
}

func Close() {
	if DB != nil {
		DB.Close()
	}
}

func HealthCheck(ctx context.Context) error {
	if DB == nil {
		return fmt.Errorf("database connection is not initialized")
	}

	return DB.Ping(ctx)
}
