resource "google_artifact_registry_repository" "backend" {
  location      = var.region
  repository_id = "${var.resource_prefix}-backend"
  description   = "Docker repository for Go backend - ${var.environment}"
  format        = "DOCKER"
}
