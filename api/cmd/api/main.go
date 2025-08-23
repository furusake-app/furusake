package main

import (
	"fmt"
	"furusake/internal/api/routes"
	"furusake/internal/db"
	"net/http"

	"github.com/joho/godotenv"
)

func main() {
	if err := godotenv.Load(); err != nil {
		fmt.Println("Warning: .env file not found or failed to load")
	}

	if err := db.Connect(); err != nil {
		fmt.Printf("Failed to connect to database: %v\n", err)
		return
	}
	defer db.Close()

	router := routes.Setup()

	addr := ":8080"
	fmt.Printf("Starting server on %s\n", addr)
	fmt.Printf("Docs: http://localhost%s/docs\n", addr)

	if err := http.ListenAndServe(addr, router); err != nil {
		fmt.Printf("Server failed: %v\n", err)
	}
}
