variable "resource_prefix" {
  description = "Resource naming prefix"
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

variable "project_id" {
  description = "Google Cloud project ID"
  type        = string
}

variable "env_config" {
  description = "Environment-specific Cloud Run configuration"
  type = object({
    cloud_run_cpu            = string
    cloud_run_memory         = string
    cloud_run_max_scale      = string
    cloud_run_min_scale      = string
    cloud_run_concurrency    = number
    cloud_run_cpu_throttling = bool
    cloud_run_execution_env  = string
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

variable "container_image" {
  description = "Container image URL for the Cloud Run service"
  type        = string
}

variable "database_private_ip" {
  description = "Database private IP address"
  type        = string
}

variable "database_connection_name" {
  description = "Database connection name"
  type        = string
}

variable "db_password_secret_id" {
  description = "Secret Manager secret ID for database password"
  type        = string
}

variable "vpc_connector_name" {
  description = "VPC Access Connector name"
  type        = string
}
