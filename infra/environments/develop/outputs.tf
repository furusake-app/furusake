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

