package models

import (
	"time"

	"github.com/google/uuid"
)

type Example struct {
	ID        uuid.UUID `json:"id"`
	Name      string    `json:"name"`
	CreatedAt time.Time `json:"created_at"`
	UpdatedAt time.Time `json:"updated_at"`
}

type CreateExampleRequest struct {
	Name string `json:"name" validate:"required,min=1,max=100"`
}

type UpdateExampleRequest struct {
	Name string `json:"name" validate:"required,min=1,max=100"`
}
