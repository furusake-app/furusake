package services

import (
	"fmt"
	"strings"
)

type GreetingService struct{}

func NewGreetingService() *GreetingService {
	return &GreetingService{}
}

func (s *GreetingService) CreateGreeting(name string) (string, error) {
	if strings.TrimSpace(name) == "" {
		return "", fmt.Errorf("name cannot be empty")
	}

	return fmt.Sprintf("Hello, %s!", name), nil
}
