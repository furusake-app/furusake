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

output "database_instance_name" {
  description = "Database instance name"
  value       = google_sql_database_instance.postgresql.name
}

output "database_name" {
  description = "Database name"
  value       = google_sql_database.database.name
}

output "db_password_secret_id" {
  description = "Secret Manager secret ID for database password"
  value       = google_secret_manager_secret.db_password.secret_id
}

output "db_password_secret_name" {
  description = "Secret Manager secret name for database password"
  value       = google_secret_manager_secret.db_password.name
}
