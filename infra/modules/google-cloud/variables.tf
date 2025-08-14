variable "project_id" {
  description = "Google Cloud project ID"
  type        = string
}

variable "region" {
  description = "Google Cloud region"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "resource_prefix" {
  description = "Resource naming prefix"
  type        = string
}

variable "env_config" {
  description = "Environment-specific configuration"
  type = object({
    cloud_run_cpu            = string
    cloud_run_memory         = string
    cloud_run_max_scale      = string
    cloud_run_min_scale      = string
    cloud_run_concurrency    = number
    cloud_run_cpu_throttling = bool
    cloud_run_execution_env  = string
    db_tier                  = string
    db_backup_retention      = number
    deletion_protection      = bool
    db_log_statement         = string
    enable_public_access     = bool
  })
}

variable "db_name" {
  description = "Database name"
  type        = string
}

variable "db_user" {
  description = "Database user"
  type        = string
}

variable "common_tags" {
  description = "Common tags to apply to resources"
  type        = map(string)
}

variable "allowed_members" {
  description = "List of members allowed to access Cloud Run service when public access is disabled"
  type        = list(string)
  default     = []
}

variable "github_repository" {
  description = "GitHub repository name in the format 'owner/repo' for Workload Identity Federation"
  type        = string
  default     = "furusake-app/furusake"
}
