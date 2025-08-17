terraform {
  required_version = ">= 1.0"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 6.47.0"
    }
    vercel = {
      source  = "vercel/vercel"
      version = "~> 3.9.1"
    }
    eas = {
      source  = "fintreal/eas"
      version = "~> 1.16.1"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6.0"
    }
  }

  backend "gcs" {
    bucket = "furusake-terraform-state-main"
    prefix = "terraform/state"
  }
}

provider "google" {
  project = var.google_project_id
  region  = var.google_region
  zone    = var.google_zone

  default_labels = local.common_tags
}

provider "vercel" {
  api_token = var.vercel_api_token
  team      = var.vercel_team_id
}

provider "eas" {
  token        = var.expo_eas_token
  account_name = var.expo_account_name
}

module "project_apis" {
  source = "../../modules/google-cloud/project-apis"
}

module "networking" {
  source = "../../modules/google-cloud/networking"

  resource_prefix = local.resource_prefix
  region          = var.google_region

  depends_on = [module.project_apis]
}

module "cloud_sql" {
  source = "../../modules/google-cloud/cloud-sql"

  resource_prefix        = local.resource_prefix
  region                 = var.google_region
  env_config             = local.env_config
  db_name                = local.db_config.name
  db_user                = local.db_config.user
  vpc_network_id         = module.networking.vpc_network_id
  private_vpc_connection = module.networking.private_vpc_connection

  depends_on = [module.project_apis, module.networking]
}

module "artifact_registry" {
  source = "../../modules/google-cloud/artifact-registry"

  resource_prefix = local.resource_prefix
  region          = var.google_region
  environment     = local.environment
  project_id      = var.google_project_id

  depends_on = [module.project_apis]
}

module "cloud_run" {
  source = "../../modules/google-cloud/cloud-run"

  resource_prefix          = local.resource_prefix
  region                   = var.google_region
  environment              = local.environment
  project_id               = var.google_project_id
  env_config               = local.env_config
  db_name                  = local.db_config.name
  db_user                  = local.db_config.user
  common_tags              = local.common_tags
  allowed_members          = var.allowed_members
  container_image          = "${module.artifact_registry.repository_url}/api:latest"
  database_private_ip      = module.cloud_sql.database_private_ip
  database_connection_name = module.cloud_sql.database_connection_name
  db_password_secret_id    = module.cloud_sql.db_password_secret_id
  vpc_connector_name       = module.networking.vpc_connector_name

  depends_on = [module.project_apis, module.networking, module.cloud_sql, module.artifact_registry]
}

module "workload_identity" {
  source = "../../modules/google-cloud/workload-identity"

  resource_prefix   = local.resource_prefix
  project_id        = var.google_project_id
  github_repository = "furusake-app/furusake"

  depends_on = [module.project_apis]
}

module "vercel" {
  source = "../../modules/vercel"

  environment = local.environment
  project_id  = local.resource_prefix
  api_url     = module.cloud_run.cloud_run_url
}

module "expo" {
  source = "../../modules/expo"
}
