resource "google_service_account" "cloud_run" {
  account_id   = "${var.resource_prefix}-cloudrun"
  display_name = "Cloud Run Service Account for ${var.environment}"
  description  = "Service account used by Cloud Run service"
}

resource "google_secret_manager_secret_iam_member" "cloud_run_secret_access" {
  secret_id = var.db_password_secret_id
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${google_service_account.cloud_run.email}"
}

resource "google_project_iam_member" "cloud_run_sql_client" {
  project = var.project_id
  role    = "roles/cloudsql.client"
  member  = "serviceAccount:${google_service_account.cloud_run.email}"
}

resource "google_cloud_run_service" "backend" {
  name     = "${var.resource_prefix}-backend"
  location = var.region

  template {
    spec {
      containers {
        image = var.container_image

        ports {
          container_port = 8080
        }

        env {
          name  = "DB_HOST"
          value = var.database_private_ip
        }

        env {
          name  = "DB_PORT"
          value = "5432"
        }

        env {
          name  = "DB_NAME"
          value = var.db_name
        }

        env {
          name  = "DB_USER"
          value = var.db_user
        }

        env {
          name = "DB_PASSWORD"
          value_from {
            secret_key_ref {
              name = var.db_password_secret_id
              key  = "latest"
            }
          }
        }

        env {
          name  = "ENVIRONMENT"
          value = var.environment
        }

        env {
          name  = "DB_CONNECTION_NAME"
          value = var.database_connection_name
        }

        resources {
          limits = {
            cpu    = var.env_config.cloud_run_cpu
            memory = var.env_config.cloud_run_memory
          }
        }

        startup_probe {
          http_get {
            path = "/health"
            port = 8080
          }
          initial_delay_seconds = 30
          period_seconds        = 30
          timeout_seconds       = 5
          failure_threshold     = 3
        }
      }

      container_concurrency = var.env_config.cloud_run_concurrency
      timeout_seconds       = 300
      service_account_name  = google_service_account.cloud_run.email
    }

    metadata {
      annotations = {
        "autoscaling.knative.dev/maxScale"         = var.env_config.cloud_run_max_scale
        "autoscaling.knative.dev/minScale"         = var.env_config.cloud_run_min_scale
        "run.googleapis.com/client-name"           = "terraform"
        "run.googleapis.com/vpc-access-connector"  = var.vpc_connector_name
        "run.googleapis.com/vpc-access-egress"     = "private-ranges-only"
        "run.googleapis.com/execution-environment" = var.env_config.cloud_run_execution_env
        "run.googleapis.com/cpu-throttling"        = var.env_config.cloud_run_cpu_throttling ? "true" : "false"
      }

      labels = var.common_tags
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }
}

resource "google_cloud_run_service_iam_member" "public_access" {
  count    = var.env_config.enable_public_access ? 1 : 0
  service  = google_cloud_run_service.backend.name
  location = google_cloud_run_service.backend.location
  role     = "roles/run.invoker"
  member   = "allUsers"
}

resource "google_cloud_run_service_iam_member" "private_access" {
  for_each = var.env_config.enable_public_access ? [] : toset(var.allowed_members)
  service  = google_cloud_run_service.backend.name
  location = google_cloud_run_service.backend.location
  role     = "roles/run.invoker"
  member   = each.value
}
