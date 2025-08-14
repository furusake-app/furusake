plugin "terraform" {
  enabled = true
  preset  = "recommended"
}

plugin "google" {
  enabled = true
  version = "0.30.0"
  source  = "github.com/terraform-linters/tflint-ruleset-google"
}

config {
  force = false
  disabled_by_default = false
}

rule "terraform_deprecated_interpolation" {
  enabled = true
}

rule "terraform_deprecated_index" {
  enabled = true
}

rule "terraform_unused_declarations" {
  enabled = true
}

rule "terraform_comment_syntax" {
  enabled = true
}

rule "terraform_documented_outputs" {
  enabled = true
}

rule "terraform_documented_variables" {
  enabled = true
}

rule "terraform_typed_variables" {
  enabled = true
}

rule "terraform_module_pinned_source" {
  enabled = true
}

rule "terraform_naming_convention" {
  enabled = true
  format  = "snake_case"
}

rule "terraform_standard_module_structure" {
  enabled = true
}

rule "terraform_workspace_remote" {
  enabled = true
}

rule "google_compute_instance_machine_type" {
  enabled = true
}

rule "google_sql_database_instance_backup_enabled" {
  enabled = true
}

rule "google_sql_database_instance_deletion_protection_enabled" {
  enabled = true
}

rule "google_compute_network_auto_create_subnetworks_disabled" {
  enabled = true
}

rule "google_project_service_disable_on_destroy" {
  enabled = true
}