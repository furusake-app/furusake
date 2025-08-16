output "vpc_network_id" {
  description = "VPC network ID"
  value       = google_compute_network.private_network.id
}

output "vpc_network_name" {
  description = "VPC network name"
  value       = google_compute_network.private_network.name
}

output "subnet_id" {
  description = "Private subnet ID"
  value       = google_compute_subnetwork.private_subnet.id
}

output "subnet_name" {
  description = "Private subnet name"
  value       = google_compute_subnetwork.private_subnet.name
}

output "vpc_connector_name" {
  description = "VPC Access Connector name"
  value       = google_vpc_access_connector.cloud_run_connector.name
}

output "vpc_connector_id" {
  description = "VPC Access Connector ID"
  value       = google_vpc_access_connector.cloud_run_connector.id
}

output "private_vpc_connection" {
  description = "Service networking connection"
  value       = google_service_networking_connection.private_vpc_connection
}
