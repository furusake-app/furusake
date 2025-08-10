package handlers

import (
	"context"

	"furusake/internal/services"

	"github.com/danielgtaylor/huma/v2"
)

type GreetingHandler struct {
	service *services.GreetingService
}

func NewGreetingHandler() *GreetingHandler {
	return &GreetingHandler{
		service: services.NewGreetingService(),
	}
}

type HelloRequest struct {
	Name string `path:"name" maxLength:"30" example:"World" doc:"Name to greet"`
}

type HelloResponse struct {
	Body struct {
		Message string `json:"message" example:"Hello, World!" doc:"Greeting message"`
	}
}

func (h *GreetingHandler) Hello(ctx context.Context, input *HelloRequest) (*HelloResponse, error) {
	message, err := h.service.CreateGreeting(input.Name)
	if err != nil {
		return nil, huma.Error400BadRequest("Invalid name", err)
	}

	resp := &HelloResponse{}
	resp.Body.Message = message
	return resp, nil
}

type SimpleHelloResponse struct {
	Body struct {
		Message string `json:"message" example:"Hello, World!" doc:"Simple greeting message"`
		Info    string `json:"info" example:"This is a Huma API!" doc:"API information"`
	}
}

func (h *GreetingHandler) SimpleHello(ctx context.Context, input *struct{}) (*SimpleHelloResponse, error) {
	resp := &SimpleHelloResponse{}
	resp.Body.Message = "Hello, World!"
	resp.Body.Info = "This is a Huma API built with Go!"
	return resp, nil
}
