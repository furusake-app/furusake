package services

import (
	"context"
	"fmt"
	"furusake/internal/models"
	"furusake/internal/repositories"
	"strings"

	"github.com/google/uuid"
)

type ExampleService interface {
	Create(ctx context.Context, req *models.CreateExampleRequest) (*models.Example, error)
	GetByID(ctx context.Context, id uuid.UUID) (*models.Example, error)
	List(ctx context.Context) ([]*models.Example, error)
	Update(ctx context.Context, id uuid.UUID, req *models.UpdateExampleRequest) (*models.Example, error)
	Delete(ctx context.Context, id uuid.UUID) error
}

type exampleService struct {
	repo repositories.ExampleRepository
}

func NewExampleService(repo repositories.ExampleRepository) ExampleService {
	return &exampleService{
		repo: repo,
	}
}

func (s *exampleService) Create(ctx context.Context, req *models.CreateExampleRequest) (*models.Example, error) {
	if err := s.validateCreateRequest(req); err != nil {
		return nil, err
	}

	return s.repo.Create(ctx, req)
}

func (s *exampleService) GetByID(ctx context.Context, id uuid.UUID) (*models.Example, error) {
	if id == uuid.Nil {
		return nil, fmt.Errorf("invalid ID: ID cannot be empty")
	}

	return s.repo.GetByID(ctx, id)
}

func (s *exampleService) List(ctx context.Context) ([]*models.Example, error) {
	return s.repo.List(ctx)
}

func (s *exampleService) Update(ctx context.Context, id uuid.UUID, req *models.UpdateExampleRequest) (*models.Example, error) {
	if id == uuid.Nil {
		return nil, fmt.Errorf("invalid ID: ID cannot be empty")
	}

	if err := s.validateUpdateRequest(req); err != nil {
		return nil, err
	}

	return s.repo.Update(ctx, id, req)
}

func (s *exampleService) Delete(ctx context.Context, id uuid.UUID) error {
	if id == uuid.Nil {
		return fmt.Errorf("invalid ID: ID cannot be empty")
	}

	return s.repo.Delete(ctx, id)
}

func (s *exampleService) validateCreateRequest(req *models.CreateExampleRequest) error {
	if req == nil {
		return fmt.Errorf("request cannot be nil")
	}

	if strings.TrimSpace(req.Name) == "" {
		return fmt.Errorf("name cannot be empty")
	}

	if len(req.Name) > 100 {
		return fmt.Errorf("name cannot exceed 100 characters")
	}

	return nil
}

func (s *exampleService) validateUpdateRequest(req *models.UpdateExampleRequest) error {
	if req == nil {
		return fmt.Errorf("request cannot be nil")
	}

	if strings.TrimSpace(req.Name) == "" {
		return fmt.Errorf("name cannot be empty")
	}

	if len(req.Name) > 100 {
		return fmt.Errorf("name cannot exceed 100 characters")
	}

	return nil
}
