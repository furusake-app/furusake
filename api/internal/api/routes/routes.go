package routes

import (
	"furusake/internal/api/handlers"
	"furusake/internal/db"
	"furusake/internal/repositories"
	"furusake/internal/services"
	"net/http"

	sqlc "furusake/internal/db/sqlc"

	"github.com/danielgtaylor/huma/v2"
	"github.com/danielgtaylor/huma/v2/adapters/humachi"
	"github.com/go-chi/chi/v5"
	"github.com/go-chi/chi/v5/middleware"
)

func RegisterRoutes(api huma.API) {
	queries := sqlc.New(db.DB)
	exampleRepo := repositories.NewExampleRepository(queries)
	exampleService := services.NewExampleService(exampleRepo)
	exampleHandler := handlers.NewExampleHandler(exampleService)

	healthHandler := &handlers.HealthHandler{}

	huma.Register(api, huma.Operation{
		OperationID: "list-examples",
		Method:      http.MethodGet,
		Path:        "/examples",
		Summary:     "List all examples",
		Tags:        []string{"Examples"},
	}, exampleHandler.List)

	huma.Register(api, huma.Operation{
		OperationID: "create-example",
		Method:      http.MethodPost,
		Path:        "/examples",
		Summary:     "Create a new example",
		Tags:        []string{"Examples"},
	}, exampleHandler.Create)

	huma.Register(api, huma.Operation{
		OperationID: "get-example",
		Method:      http.MethodGet,
		Path:        "/examples/{id}",
		Summary:     "Get example by ID",
		Tags:        []string{"Examples"},
	}, exampleHandler.GetByID)

	huma.Register(api, huma.Operation{
		OperationID: "update-example",
		Method:      http.MethodPut,
		Path:        "/examples/{id}",
		Summary:     "Update example by ID",
		Tags:        []string{"Examples"},
	}, exampleHandler.Update)

	huma.Register(api, huma.Operation{
		OperationID: "delete-example",
		Method:      http.MethodDelete,
		Path:        "/examples/{id}",
		Summary:     "Delete example by ID",
		Tags:        []string{"Examples"},
	}, exampleHandler.Delete)

	huma.Register(api, huma.Operation{
		OperationID: "health-check",
		Method:      http.MethodGet,
		Path:        "/health",
		Summary:     "Health check endpoint",
		Tags:        []string{"Health"},
	}, healthHandler.Health)
}

func Setup() http.Handler {
	router := chi.NewMux()
	router.Use(middleware.Logger)
	router.Use(middleware.Recoverer)

	config := huma.DefaultConfig("Furusake Backend API", "0.0.0")
	api := humachi.New(router, config)

	RegisterRoutes(api)

	return router
}
