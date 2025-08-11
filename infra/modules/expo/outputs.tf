output "project_id" {
  description = "Expo EAS project ID"
  value       = eas_app.mobile_app.id
}

output "project_slug" {
  description = "Expo project slug"
  value       = eas_app.mobile_app.slug
}

output "project_name" {
  description = "Expo project name"
  value       = eas_app.mobile_app.name
}
