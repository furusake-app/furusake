package main

import (
	"encoding/json"
	"fmt"
	"furusake/internal/api/routes"
	"os"

	"github.com/danielgtaylor/huma/v2"
	"github.com/danielgtaylor/huma/v2/adapters/humachi"
	"github.com/go-chi/chi/v5"
)

func main() {
	router := chi.NewMux()
	config := huma.DefaultConfig("Furusake Backend API", "0.0.0")
	api := humachi.New(router, config)

	routes.RegisterRoutes(api)

	schema := api.OpenAPI()

	jsonData, err := json.MarshalIndent(schema, "", "  ")

	if err != nil {
		fmt.Fprintf(os.Stderr, "Error marshaling OpenAPI schema: %v\n", err)
		os.Exit(1)
	}

	outputPath := "../openapi.json"
	if len(os.Args) > 1 {
		outputPath = os.Args[1]
	}

	if outputPath == "-" || outputPath == "" {
		fmt.Println(string(jsonData))
	} else {
		err := os.WriteFile(outputPath, jsonData, 0644)

		if err != nil {
			fmt.Fprintf(os.Stderr, "Error writing to file %s: %v\n", outputPath, err)
			os.Exit(1)
		}

		fmt.Printf("OpenAPI JSON written to %s\n", outputPath)
	}
}
