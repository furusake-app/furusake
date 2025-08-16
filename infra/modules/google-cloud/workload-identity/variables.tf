variable "resource_prefix" {
  description = "Resource naming prefix"
  type        = string
}

variable "project_id" {
  description = "Google Cloud project ID"
  type        = string
}

variable "github_repository" {
  description = "GitHub repository name in the format 'owner/repo' for Workload Identity Federation"
  type        = string
  default     = "furusake-app/furusake"
}
