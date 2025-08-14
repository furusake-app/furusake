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

module "google" {
  source = "../../modules/google-cloud"

  project_id               = var.google_project_id
  region                   = var.google_region
  environment              = local.environment
  resource_prefix          = local.resource_prefix
  env_config               = local.env_config
  db_name                  = local.db_config.name
  db_user                  = local.db_config.user
  common_tags              = local.common_tags
  allowed_members          = var.allowed_members
  create_workload_identity = true
}

module "vercel" {
  source = "../../modules/vercel"

  environment     = local.environment
  resource_prefix = local.resource_prefix
  api_url         = module.google.cloud_run_url
  github_repo     = "furusake-app/furusake"
}

module "expo" {
  source = "../../modules/expo"
}
