package handlers

import (
	"context"
	"furusake/internal/db"
)

type HealthHandler struct{}

type HealthResponse struct {
	Body struct {
		Status   string            `json:"status" example:"ok" doc:"Health status"`
		Database string            `json:"database" example:"ok" doc:"Database connection status"`
		Checks   map[string]string `json:"checks,omitempty" doc:"Individual health check results"`
	}
}

func (h *HealthHandler) Health(ctx context.Context, _ *struct{}) (*HealthResponse, error) {
	resp := &HealthResponse{}
	resp.Body.Checks = make(map[string]string)

	if err := db.HealthCheck(ctx); err != nil {
		resp.Body.Database = "error"
		resp.Body.Status = "degraded"
		resp.Body.Checks["database"] = err.Error()
	} else {
		resp.Body.Database = "ok"
		resp.Body.Status = "ok"
		resp.Body.Checks["database"] = "connected"
	}

	return resp, nil
}