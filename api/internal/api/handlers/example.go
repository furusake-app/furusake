package handlers

import (
	"context"
	"furusake/internal/models"
	"furusake/internal/services"

	"github.com/danielgtaylor/huma/v2"
	"github.com/google/uuid"
)

type ExampleHandler struct {
	service services.ExampleService
}

func NewExampleHandler(service services.ExampleService) *ExampleHandler {
	return &ExampleHandler{
		service: service,
	}
}

type CreateExampleRequest struct {
	Body models.CreateExampleRequest `json:"body"`
}

type ExampleResponse struct {
	Body models.Example `json:"body"`
}

type ExampleListResponse struct {
	Body []*models.Example `json:"body"`
}

type GetExampleRequest struct {
	ID string `path:"id" doc:"Example ID"`
}

type UpdateExampleRequest struct {
	ID   string                      `path:"id" doc:"Example ID"`
	Body models.UpdateExampleRequest `json:"body"`
}

type DeleteExampleRequest struct {
	ID string `path:"id" doc:"Example ID"`
}

func (h *ExampleHandler) Create(ctx context.Context, input *CreateExampleRequest) (*ExampleResponse, error) {
	example, err := h.service.Create(ctx, &input.Body)
	if err != nil {
		return nil, huma.Error400BadRequest("Failed to create example", err)
	}

	return &ExampleResponse{Body: *example}, nil
}

func (h *ExampleHandler) GetByID(ctx context.Context, input *GetExampleRequest) (*ExampleResponse, error) {
	id, err := uuid.Parse(input.ID)
	if err != nil {
		return nil, huma.Error400BadRequest("Invalid ID format", err)
	}

	example, err := h.service.GetByID(ctx, id)
	if err != nil {
		return nil, huma.Error404NotFound("Example not found", err)
	}

	return &ExampleResponse{Body: *example}, nil
}

func (h *ExampleHandler) List(ctx context.Context, input *struct{}) (*ExampleListResponse, error) {
	examples, err := h.service.List(ctx)
	if err != nil {
		return nil, huma.Error500InternalServerError("Failed to list examples", err)
	}

	return &ExampleListResponse{Body: examples}, nil
}

func (h *ExampleHandler) Update(ctx context.Context, input *UpdateExampleRequest) (*ExampleResponse, error) {
	id, err := uuid.Parse(input.ID)
	if err != nil {
		return nil, huma.Error400BadRequest("Invalid ID format", err)
	}

	example, err := h.service.Update(ctx, id, &input.Body)
	if err != nil {
		return nil, huma.Error400BadRequest("Failed to update example", err)
	}

	return &ExampleResponse{Body: *example}, nil
}

func (h *ExampleHandler) Delete(ctx context.Context, input *DeleteExampleRequest) (*struct{}, error) {
	id, err := uuid.Parse(input.ID)
	if err != nil {
		return nil, huma.Error400BadRequest("Invalid ID format", err)
	}

	err = h.service.Delete(ctx, id)
	if err != nil {
		return nil, huma.Error500InternalServerError("Failed to delete example", err)
	}

	return &struct{}{}, nil
}
