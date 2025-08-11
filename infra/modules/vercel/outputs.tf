output "project_id" {
  description = "Vercel project ID"
  value       = vercel_project.nextjs.id
}

output "project_name" {
  description = "Vercel project name"
  value       = vercel_project.nextjs.name
}

output "project_url" {
  description = "Vercel project URL"
  value       = "https://${vercel_project.nextjs.name}.vercel.app"
}
