package routes

import (
	"furusake/internal/api/handlers"
	"net/http"

	"github.com/danielgtaylor/huma/v2"
	"github.com/danielgtaylor/huma/v2/adapters/humachi"
	"github.com/go-chi/chi/v5"
	"github.com/go-chi/chi/v5/middleware"
)

func Setup() http.Handler {
	router := chi.NewMux()
	router.Use(middleware.Logger)
	router.Use(middleware.Recoverer)

	config := huma.DefaultConfig("Hello World API", "1.0.0")
	api := humachi.New(router, config)

	greetingHandler := handlers.NewGreetingHandler()

	huma.Register(api, huma.Operation{
		OperationID: "simple-hello",
		Method:      http.MethodGet,
		Path:        "/hello",
		Summary:     "Simple Hello World",
		Tags:        []string{"Greetings"},
	}, greetingHandler.SimpleHello)

	huma.Register(api, huma.Operation{
		OperationID: "hello-name",
		Method:      http.MethodGet,
		Path:        "/hello/{name}",
		Summary:     "Hello with name",
		Tags:        []string{"Greetings"},
	}, greetingHandler.Hello)

	huma.Register(api, huma.Operation{
		OperationID: "health-check",
		Method:      http.MethodGet,
		Path:        "/health",
		Summary:     "Health check endpoint",
		Tags:        []string{"Health"},
	}, greetingHandler.Health)

	return router
}
