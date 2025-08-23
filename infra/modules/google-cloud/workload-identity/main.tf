resource "google_iam_workload_identity_pool" "github_actions" {
  workload_identity_pool_id = "github-actions"
  display_name              = "GitHub Actions Pool"
  description               = "Identity pool for GitHub Actions workflows"
}

resource "google_iam_workload_identity_pool_provider" "github_actions" {
  workload_identity_pool_id          = google_iam_workload_identity_pool.github_actions.workload_identity_pool_id
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
  account_id   = "${var.resource_prefix}-terraform-ci"
  display_name = "Terraform CI Service Account"
  description  = "Service account for Terraform operations in CI/CD"
}

# Cloud Run Developer - Create, update, delete Cloud Run services
resource "google_project_iam_member" "terraform_ci_run_developer" {
  project = var.project_id
  role    = "roles/run.developer"
  member  = "serviceAccount:${google_service_account.terraform_ci.email}"
}

# Service Account User - Required to assign service accounts to Cloud Run
resource "google_project_iam_member" "terraform_ci_service_account_user" {
  project = var.project_id
  role    = "roles/iam.serviceAccountUser"
  member  = "serviceAccount:${google_service_account.terraform_ci.email}"
}

# Artifact Registry Reader - Access container images
resource "google_project_iam_member" "terraform_ci_artifact_reader" {
  project = var.project_id
  role    = "roles/artifactregistry.reader"
  member  = "serviceAccount:${google_service_account.terraform_ci.email}"
}

# Cloud SQL Editor - Manage Cloud SQL instances (no delete permissions)
resource "google_project_iam_member" "terraform_ci_sql_editor" {
  project = var.project_id
  role    = "roles/cloudsql.editor"
  member  = "serviceAccount:${google_service_account.terraform_ci.email}"
}

# Secret Manager Secret Accessor - Read secrets
resource "google_project_iam_member" "terraform_ci_secret_accessor" {
  project = var.project_id
  role    = "roles/secretmanager.secretAccessor"
  member  = "serviceAccount:${google_service_account.terraform_ci.email}"
}

# Secret Manager Version Manager - Create/update secret versions
resource "google_project_iam_member" "terraform_ci_secret_version_manager" {
  project = var.project_id
  role    = "roles/secretmanager.secretVersionManager"
  member  = "serviceAccount:${google_service_account.terraform_ci.email}"
}

# Secret Manager Admin - Create secrets (limited scope)
resource "google_project_iam_member" "terraform_ci_secret_admin" {
  project = var.project_id
  role    = "roles/secretmanager.admin"
  member  = "serviceAccount:${google_service_account.terraform_ci.email}"
}

# Compute Network Admin - Manage VPC, subnets
resource "google_project_iam_member" "terraform_ci_compute_network_admin" {
  project = var.project_id
  role    = "roles/compute.networkAdmin"
  member  = "serviceAccount:${google_service_account.terraform_ci.email}"
}

# Compute Instance Admin - Required for VPC connectors
resource "google_project_iam_member" "terraform_ci_compute_instance_admin" {
  project = var.project_id
  role    = "roles/compute.instanceAdmin"
  member  = "serviceAccount:${google_service_account.terraform_ci.email}"
}

# Service Usage Admin - Enable/disable APIs
resource "google_project_iam_member" "terraform_ci_service_usage_admin" {
  project = var.project_id
  role    = "roles/serviceusage.serviceUsageAdmin"
  member  = "serviceAccount:${google_service_account.terraform_ci.email}"
}

# Service Account Creator - Create service accounts only
resource "google_project_iam_member" "terraform_ci_service_account_creator" {
  project = var.project_id
  role    = "roles/iam.serviceAccountCreator"
  member  = "serviceAccount:${google_service_account.terraform_ci.email}"
}

# Project IAM Admin - Assign roles to service accounts
resource "google_project_iam_member" "terraform_ci_project_iam_admin" {
  project = var.project_id
  role    = "roles/resourcemanager.projectIamAdmin"
  member  = "serviceAccount:${google_service_account.terraform_ci.email}"
}

# Storage Admin - Access Terraform state in Cloud Storage
resource "google_project_iam_member" "terraform_ci_storage_admin" {
  project = var.project_id
  role    = "roles/storage.admin"
  member  = "serviceAccount:${google_service_account.terraform_ci.email}"
}

# VPC Access Admin - Manage VPC connectors for Cloud Run
resource "google_project_iam_member" "terraform_ci_vpc_access_admin" {
  project = var.project_id
  role    = "roles/vpcaccess.admin"
  member  = "serviceAccount:${google_service_account.terraform_ci.email}"
}

# Service Networking Admin - Manage private service connections
resource "google_project_iam_member" "terraform_ci_service_networking_admin" {
  project = var.project_id
  role    = "roles/servicenetworking.networksAdmin"
  member  = "serviceAccount:${google_service_account.terraform_ci.email}"
}

# Artifact Registry Repository Administrator - Full registry management
resource "google_project_iam_member" "terraform_ci_artifact_repo_admin" {
  project = var.project_id
  role    = "roles/artifactregistry.repoAdmin"
  member  = "serviceAccount:${google_service_account.terraform_ci.email}"
}

resource "google_service_account_iam_member" "github_actions_workload_identity" {
  service_account_id = google_service_account.terraform_ci.name
  role               = "roles/iam.workloadIdentityUser"
  member             = "principalSet://iam.googleapis.com/${google_iam_workload_identity_pool.github_actions.name}/attribute.repository/${var.github_repository}"
}
