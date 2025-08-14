output "cloud_run_url" {
  description = "URL of the Cloud Run service"
  value       = google_cloud_run_service.backend.status[0].url
}

output "database_connection_name" {
  description = "PostgreSQL instance connection name"
  value       = google_sql_database_instance.postgresql.connection_name
}

output "database_private_ip" {
  description = "PostgreSQL instance private IP"
  value       = google_sql_database_instance.postgresql.private_ip_address
}

output "database_public_ip" {
  description = "PostgreSQL instance public IP (should be null for private-only instances)"
  value       = google_sql_database_instance.postgresql.public_ip_address
}

output "artifact_registry_repository" {
  description = "Artifact Registry repository URL"
  value       = "${var.region}-docker.pkg.dev/${var.project_id}/${google_artifact_registry_repository.backend.repository_id}"
}

output "database_instance_name" {
  description = "Database instance name"
  value       = google_sql_database_instance.postgresql.name
}

output "database_name" {
  description = "Database name"
  value       = google_sql_database.database.name
}

output "vpc_network_name" {
  description = "VPC network name"
  value       = google_compute_network.private_network.name
}

output "vpc_connector_name" {
  description = "VPC Access Connector name"
  value       = google_vpc_access_connector.cloud_run_connector.name
}

# Workload Identity Federation outputs
output "workload_identity_provider" {
  description = "Workload Identity Provider ID for GitHub Actions"
  value       = var.create_workload_identity ? google_iam_workload_identity_pool_provider.github_actions[0].name : ""
}

output "service_account_email" {
  description = "Service account email for Terraform CI"
  value       = var.create_workload_identity ? google_service_account.terraform_ci[0].email : ""
}

output "workload_identity_pool_id" {
  description = "Workload Identity Pool ID"
  value       = var.create_workload_identity ? google_iam_workload_identity_pool.github_actions[0].workload_identity_pool_id : ""
}
