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

variable "vercel_api_token" {
  description = "Vercel API token"
  type        = string
  sensitive   = true
}

variable "vercel_team_id" {
  description = "Vercel team ID"
  type        = string
  default     = null
}

variable "expo_eas_token" {
  description = "Expo EAS access token"
  type        = string
  sensitive   = true
}

variable "expo_account_name" {
  description = "Expo account name"
  type        = string
}

variable "db_name" {
  description = "PostgreSQL database name"
  type        = string
  default     = "furusake"
}

variable "db_user" {
  description = "PostgreSQL database user"
  type        = string
  default     = "furusake_user"
}

variable "allowed_members" {
  description = "List of members allowed to access Cloud Run service"
  type        = list(string)
  default     = []
}
