output "cloud_run_url" {
  description = "URL of the Cloud Run service"
  value       = module.google.cloud_run_url
}

output "database_connection_name" {
  description = "PostgreSQL instance connection name"
  value       = module.google.database_connection_name
}

output "database_public_ip" {
  description = "PostgreSQL instance public IP"
  value       = module.google.database_public_ip
}

output "artifact_registry_repository" {
  description = "Artifact Registry repository URL"
  value       = module.google.artifact_registry_repository
}

# Workload Identity Federation outputs for GitHub Actions setup
output "workload_identity_provider" {
  description = "Workload Identity Provider ID for GitHub Actions"
  value       = module.google.workload_identity_provider
  sensitive   = false
}

output "service_account_email" {
  description = "Service account email for Terraform CI"
  value       = module.google.service_account_email
  sensitive   = false
}

