-- +goose Up
CREATE TABLE example (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(100) NOT NULL,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_example_name ON example(name);

-- +goose Down
DROP INDEX IF EXISTS idx_example_name;
DROP TABLE IF EXISTS example;
