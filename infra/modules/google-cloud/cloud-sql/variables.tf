variable "resource_prefix" {
  description = "Resource naming prefix"
  type        = string
}

variable "region" {
  description = "Google Cloud region"
  type        = string
}

variable "env_config" {
  description = "Environment-specific database configuration"
  type = object({
    db_tier             = string
    db_backup_retention = number
    deletion_protection = bool
    db_log_statement    = string
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

variable "vpc_network_id" {
  description = "VPC network ID for private connectivity"
  type        = string
}

variable "private_vpc_connection" {
  description = "Service networking connection for dependency"
  type        = any
}
