resource "google_compute_network" "private_network" {
  name                    = "${var.resource_prefix}-vpc"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "private_subnet" {
  name          = "${var.resource_prefix}-subnet"
  ip_cidr_range = "10.0.0.0/24"
  region        = var.region
  network       = google_compute_network.private_network.id
}

resource "google_compute_global_address" "private_ip_range" {
  name          = "${var.resource_prefix}-private-ip"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = google_compute_network.private_network.id
}

resource "google_service_networking_connection" "private_vpc_connection" {
  network                 = google_compute_network.private_network.id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_ip_range.name]
}

resource "google_vpc_access_connector" "cloud_run_connector" {
  name          = "${substr(replace(var.resource_prefix, "_", "-"), 0, 19)}-conn"
  region        = var.region
  network       = google_compute_network.private_network.name
  ip_cidr_range = "10.8.0.0/28"
  max_instances = 3
  min_instances = 2
}
