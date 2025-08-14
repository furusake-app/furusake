terraform {
  required_version = ">= 1.0"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 6.47.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6.0"
    }
  }

  backend "gcs" {
    bucket = "furusake-terraform-state-develop"
    prefix = "terraform/state"
  }
}

provider "google" {
  project = var.google_project_id
  region  = var.google_region
  zone    = var.google_zone

  default_labels = local.common_tags
}

module "google" {
  source = "../../modules/google-cloud"

  project_id      = var.google_project_id
  region          = var.google_region
  zone            = var.google_zone
  environment     = local.environment
  resource_prefix = local.resource_prefix
  env_config      = local.env_config
  db_name         = local.db_config.name
  db_user         = local.db_config.user
  common_tags     = local.common_tags
  allowed_members = var.allowed_members
}

