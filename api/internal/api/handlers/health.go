package handlers

import (
	"context"
)

type HealthResponse struct {
	Body struct {
		Status string `json:"status" example:"ok" doc:"Health status"`
	}
}

func (h *GreetingHandler) Health(ctx context.Context, input *struct{}) (*HealthResponse, error) {
	resp := &HealthResponse{}
	resp.Body.Status = "ok"
	return resp, nil
}
