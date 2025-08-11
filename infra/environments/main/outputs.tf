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
