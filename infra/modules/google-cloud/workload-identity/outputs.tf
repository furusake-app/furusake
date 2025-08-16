output "workload_identity_provider" {
  description = "Workload Identity Provider ID for GitHub Actions"
  value       = google_iam_workload_identity_pool_provider.github_actions.name
}

output "service_account_email" {
  description = "Service account email for Terraform CI"
  value       = google_service_account.terraform_ci.email
}

output "workload_identity_pool_id" {
  description = "Workload Identity Pool ID"
  value       = google_iam_workload_identity_pool.github_actions.workload_identity_pool_id
}
