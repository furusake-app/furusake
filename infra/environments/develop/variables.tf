variable "google_project_id" {
  description = "The Google Cloud project ID"
  type        = string
}

variable "google_region" {
  description = "The Google Cloud region"
  type        = string
  default     = "asia-northeast1"
}

variable "google_zone" {
  description = "The Google Cloud zone"
  type        = string
  default     = "asia-northeast1-a"
}

variable "db_name" {
  description = "PostgreSQL database name"
  type        = string
  default     = "furusake_dev"
}

variable "db_user" {
  description = "PostgreSQL database user"
  type        = string
  default     = "furusake_user_dev"
}

variable "allowed_members" {
  description = "List of members allowed to access Cloud Run service"
  type        = list(string)
  default     = []
}
