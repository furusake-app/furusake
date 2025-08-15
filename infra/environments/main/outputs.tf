output "cloud_run_url" {
  description = "URL of the Cloud Run service"
  value       = module.cloud_run.cloud_run_url
}

output "database_connection_name" {
  description = "PostgreSQL instance connection name"
  value       = module.cloud_sql.database_connection_name
}

output "database_public_ip" {
  description = "PostgreSQL instance public IP"
  value       = module.cloud_sql.database_public_ip
}

output "artifact_registry_repository" {
  description = "Artifact Registry repository URL"
  value       = module.artifact_registry.repository_url
}

output "vercel_project_id" {
  description = "Vercel project ID"
  value       = module.vercel.project_id
}

output "vercel_project_url" {
  description = "Vercel project URL"
  value       = module.vercel.project_url
}

output "expo_project_id" {
  description = "Expo EAS project ID"
  value       = module.expo.project_id
}

output "expo_project_slug" {
  description = "Expo project slug"
  value       = module.expo.project_slug
}

# Workload Identity Federation outputs for GitHub Actions setup
output "workload_identity_provider" {
  description = "Workload Identity Provider ID for GitHub Actions"
  value       = module.workload_identity.workload_identity_provider
  sensitive   = false
}

output "service_account_email" {
  description = "Service account email for Terraform CI"
  value       = module.workload_identity.service_account_email
  sensitive   = false
}
