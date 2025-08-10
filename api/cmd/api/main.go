package main

import (
	"fmt"
	"net/http"

	"furusake/internal/api/routes"
)

func main() {
	router := routes.Setup()

	fmt.Println("Starting server on :8080")
	fmt.Println("Docs: http://localhost:8080/docs")

	if err := http.ListenAndServe(":8080", router); err != nil {
		panic(err)
	}
}
