resource "google_project_service" "apis" {
  for_each = toset([
    "cloudresourcemanager.googleapis.com",
    "run.googleapis.com",
    "cloudbuild.googleapis.com",
    "sqladmin.googleapis.com",
    "artifactregistry.googleapis.com",
    "secretmanager.googleapis.com",
    "compute.googleapis.com",
    "servicenetworking.googleapis.com",
    "vpcaccess.googleapis.com",
    "iamcredentials.googleapis.com",
    "sts.googleapis.com"
  ])

  service = each.key
}

resource "google_compute_network" "private_network" {
  name                    = "${var.resource_prefix}-vpc"
  auto_create_subnetworks = false

  depends_on = [google_project_service.apis]
}

resource "google_compute_subnetwork" "private_subnet" {
  name          = "${var.resource_prefix}-subnet"
  ip_cidr_range = "10.0.0.0/24"
  region        = var.region
  network       = google_compute_network.private_network.id

  depends_on = [google_project_service.apis]
}

resource "google_compute_global_address" "private_ip_range" {
  name          = "${var.resource_prefix}-private-ip"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = google_compute_network.private_network.id

  depends_on = [google_project_service.apis]
}

resource "google_service_networking_connection" "private_vpc_connection" {
  network                 = google_compute_network.private_network.id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_ip_range.name]

  depends_on = [google_project_service.apis]
}

resource "google_vpc_access_connector" "cloud_run_connector" {
  name          = "${substr(replace(var.resource_prefix, "_", "-"), 0, 19)}-conn"
  region        = var.region
  network       = google_compute_network.private_network.name
  ip_cidr_range = "10.8.0.0/28"
  max_instances = 3
  min_instances = 2

  depends_on = [google_project_service.apis]
}

resource "google_service_account" "cloud_run" {
  account_id   = "${var.resource_prefix}-cloudrun"
  display_name = "Cloud Run Service Account for ${var.environment}"
  description  = "Service account used by Cloud Run service"
}

resource "google_secret_manager_secret_iam_member" "cloud_run_secret_access" {
  secret_id = google_secret_manager_secret.db_password.secret_id
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${google_service_account.cloud_run.email}"
}

resource "google_project_iam_member" "cloud_run_sql_client" {
  project = var.project_id
  role    = "roles/cloudsql.client"
  member  = "serviceAccount:${google_service_account.cloud_run.email}"
}

resource "google_artifact_registry_repository" "backend" {
  location      = var.region
  repository_id = "${var.resource_prefix}-backend"
  description   = "Docker repository for Go backend - ${var.environment}"
  format        = "DOCKER"

  depends_on = [google_project_service.apis]
}

resource "random_password" "db_password" {
  length  = 32
  special = true
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

  depends_on = [google_project_service.apis]
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
      private_network                               = google_compute_network.private_network.id
      enable_private_path_for_google_cloud_services = true
    }

    database_flags {
      name  = "log_statement"
      value = var.env_config.db_log_statement
    }
  }

  depends_on = [
    google_project_service.apis,
    google_service_networking_connection.private_vpc_connection
  ]
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

resource "google_cloud_run_service" "backend" {
  name     = "${var.resource_prefix}-backend"
  location = var.region

  template {
    spec {
      containers {
        image = "${var.region}-docker.pkg.dev/${var.project_id}/${google_artifact_registry_repository.backend.repository_id}/api:latest"

        ports {
          container_port = 8080
        }

        env {
          name  = "DB_HOST"
          value = google_sql_database_instance.postgresql.private_ip_address
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
              name = google_secret_manager_secret.db_password.secret_id
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
          value = google_sql_database_instance.postgresql.connection_name
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
        "run.googleapis.com/vpc-access-connector"  = google_vpc_access_connector.cloud_run_connector.name
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

  depends_on = [
    google_project_service.apis,
    google_vpc_access_connector.cloud_run_connector,
    google_service_account.cloud_run,
    google_secret_manager_secret_iam_member.cloud_run_secret_access
  ]
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

resource "google_iam_workload_identity_pool" "github_actions" {
  count = var.create_workload_identity ? 1 : 0

  workload_identity_pool_id = "github-actions"
  display_name              = "GitHub Actions Pool"
  description               = "Identity pool for GitHub Actions workflows"
}

resource "google_iam_workload_identity_pool_provider" "github_actions" {
  count = var.create_workload_identity ? 1 : 0

  workload_identity_pool_id          = google_iam_workload_identity_pool.github_actions[0].workload_identity_pool_id
  workload_identity_pool_provider_id = "github-actions-provider"
  display_name                       = "GitHub Actions Provider"
  description                        = "OIDC identity pool provider for GitHub Actions"

  attribute_mapping = {
    "google.subject"       = "assertion.sub"
    "attribute.repository" = "assertion.repository"
    "attribute.actor"      = "assertion.actor"
    "attribute.ref"        = "assertion.ref"
  }

  attribute_condition = "assertion.repository == '${var.github_repository}'"

  oidc {
    issuer_uri = "https://token.actions.githubusercontent.com"
  }
}

resource "google_service_account" "terraform_ci" {
  count = var.create_workload_identity ? 1 : 0

  account_id   = "${var.resource_prefix}-terraform-ci"
  display_name = "Terraform CI Service Account"
  description  = "Service account for Terraform operations in CI/CD"
}

resource "google_project_iam_member" "terraform_ci_storage_admin" {
  count = var.create_workload_identity ? 1 : 0

  project = var.project_id
  role    = "roles/storage.admin"
  member  = "serviceAccount:${google_service_account.terraform_ci[0].email}"
}

resource "google_project_iam_member" "terraform_ci_editor" {
  count = var.create_workload_identity ? 1 : 0

  project = var.project_id
  role    = "roles/editor"
  member  = "serviceAccount:${google_service_account.terraform_ci[0].email}"
}

resource "google_service_account_iam_member" "github_actions_workload_identity" {
  count = var.create_workload_identity ? 1 : 0

  service_account_id = google_service_account.terraform_ci[0].name
  role               = "roles/iam.workloadIdentityUser"
  member             = "principalSet://iam.googleapis.com/${google_iam_workload_identity_pool.github_actions[0].name}/attribute.repository/${var.github_repository}"
}
