
variable "environment" {
  description = "Environment name"
  type        = string
}

variable "resource_prefix" {
  description = "Resource naming prefix"
  type        = string
}

variable "api_url" {
  description = "Backend API URL"
  type        = string
}

variable "github_repo" {
  description = "GitHub repository"
  type        = string
  default     = "furusake-app/furusake"
}

