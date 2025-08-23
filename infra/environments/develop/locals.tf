locals {
  project_name = "furusake"
  environment  = "develop"

  resource_prefix = "${local.project_name}-${local.environment}"

  common_tags = {
    project     = local.project_name
    environment = local.environment
    managed_by  = "terraform"
  }

  env_config = {
    cloud_run_cpu            = "1000m"
    cloud_run_memory         = "512Mi"
    cloud_run_max_scale      = "3"
    cloud_run_min_scale      = "0"
    cloud_run_concurrency    = 50
    cloud_run_cpu_throttling = true
    cloud_run_execution_env  = "gen2"

    db_tier             = "db-f1-micro"
    db_backup_retention = 7
    deletion_protection = false
    db_log_statement    = "all"

    enable_public_access = true
  }

  db_config = {
    name = var.db_name
    user = var.db_user
  }
}
