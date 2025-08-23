resource "random_password" "db_password" {
  length  = 32
  special = true
  # Exclude characters that can cause issues in connection URLs
  override_special = "!@#$%^&*()-_=+[]|;:,.<>?"
}

resource "google_secret_manager_secret" "db_password" {
  secret_id = "${var.resource_prefix}-db-password"

  replication {
    user_managed {
      replicas {
        location = var.region
      }
    }
  }
}

resource "google_secret_manager_secret_version" "db_password" {
  secret      = google_secret_manager_secret.db_password.id
  secret_data = random_password.db_password.result
}

resource "google_sql_database_instance" "postgresql" {
  name                = "${var.resource_prefix}-postgres"
  database_version    = "POSTGRES_15"
  region              = var.region
  deletion_protection = var.env_config.deletion_protection

  settings {
    tier = var.env_config.db_tier

    backup_configuration {
      enabled                        = true
      start_time                     = "03:00"
      point_in_time_recovery_enabled = true
      backup_retention_settings {
        retained_backups = var.env_config.db_backup_retention
      }
    }

    ip_configuration {
      ipv4_enabled                                  = false
      private_network                               = var.vpc_network_id
      enable_private_path_for_google_cloud_services = true
    }

    database_flags {
      name  = "log_statement"
      value = var.env_config.db_log_statement
    }
  }

  depends_on = [var.private_vpc_connection]
}

resource "google_sql_database" "database" {
  name     = var.db_name
  instance = google_sql_database_instance.postgresql.name
}

resource "google_sql_user" "user" {
  name     = var.db_user
  instance = google_sql_database_instance.postgresql.name
  password = random_password.db_password.result
}
