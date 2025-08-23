package repositories

import (
	"context"
	"furusake/internal/models"

	sqlc "furusake/internal/db/sqlc"

	"github.com/google/uuid"
)

type ExampleRepository interface {
	Create(ctx context.Context, req *models.CreateExampleRequest) (*models.Example, error)
	GetByID(ctx context.Context, id uuid.UUID) (*models.Example, error)
	List(ctx context.Context) ([]*models.Example, error)
	Update(ctx context.Context, id uuid.UUID, req *models.UpdateExampleRequest) (*models.Example, error)
	Delete(ctx context.Context, id uuid.UUID) error
}

type exampleRepository struct {
	queries *sqlc.Queries
}

func NewExampleRepository(queries *sqlc.Queries) ExampleRepository {
	return &exampleRepository{
		queries: queries,
	}
}

func (r *exampleRepository) Create(ctx context.Context, req *models.CreateExampleRequest) (*models.Example, error) {
	dbExample, err := r.queries.CreateExample(ctx, req.Name)
	if err != nil {
		return nil, err
	}

	return r.convertToModel(&dbExample), nil
}

func (r *exampleRepository) GetByID(ctx context.Context, id uuid.UUID) (*models.Example, error) {
	dbExample, err := r.queries.GetExample(ctx, id)
	if err != nil {
		return nil, err
	}

	return r.convertToModel(&dbExample), nil
}

func (r *exampleRepository) List(ctx context.Context) ([]*models.Example, error) {
	dbExamples, err := r.queries.ListExamples(ctx)
	if err != nil {
		return nil, err
	}

	examples := make([]*models.Example, len(dbExamples))
	for i, dbExample := range dbExamples {
		examples[i] = r.convertToModel(&dbExample)
	}

	return examples, nil
}

func (r *exampleRepository) Update(ctx context.Context, id uuid.UUID, req *models.UpdateExampleRequest) (*models.Example, error) {
	dbExample, err := r.queries.UpdateExample(ctx, id, req.Name)
	if err != nil {
		return nil, err
	}

	return r.convertToModel(&dbExample), nil
}

func (r *exampleRepository) Delete(ctx context.Context, id uuid.UUID) error {
	return r.queries.DeleteExample(ctx, id)
}

func (r *exampleRepository) convertToModel(dbExample *sqlc.Example) *models.Example {
	return &models.Example{
		ID:        dbExample.ID,
		Name:      dbExample.Name,
		CreatedAt: dbExample.CreatedAt.Time,
		UpdatedAt: dbExample.UpdatedAt.Time,
	}
}
