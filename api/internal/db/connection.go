package db

import (
	"context"
	"fmt"
	"os"

	"github.com/jackc/pgx/v5/pgxpool"
)

var DB *pgxpool.Pool

func Connect() error {
	dbHost := os.Getenv("DB_HOST")
	dbPort := os.Getenv("DB_PORT")
	dbName := os.Getenv("DB_NAME")
	dbUser := os.Getenv("DB_USER")
	dbPassword := os.Getenv("DB_PASSWORD")
	
	if dbHost == "" || dbName == "" || dbUser == "" || dbPassword == "" {
		return fmt.Errorf("DB_HOST, DB_NAME, DB_USER, DB_PASSWORD environment variables must be set")
	}
	
	if dbPort == "" {
		dbPort = "5432"
	}
	
	databaseURL := fmt.Sprintf("postgres://%s:%s@%s:%s/%s?sslmode=disable", dbUser, dbPassword, dbHost, dbPort, dbName)

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
