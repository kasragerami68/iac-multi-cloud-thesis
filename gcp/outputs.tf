output "application_url" {
  description = "Application URL"
  value       = "http://${google_compute_address.main.address}:9090"
}

output "web_server_public_ip" {
  description = "Web server public IP"
  value       = google_compute_address.main.address
}

output "web_server_private_ip" {
  description = "Web server private IP"
  value       = google_compute_instance.main.network_interface[0].network_ip
}

output "database_host" {
  description = "Database host"
  value       = google_sql_database_instance.main.public_ip_address
}

output "database_connection_name" {
  description = "Database connection name"
  value       = google_sql_database_instance.main.connection_name
}

output "database_name" {
  description = "Database name"
  value       = var.db_name
}

output "vpc_name" {
  description = "VPC name"
  value       = google_compute_network.main.name
}

output "subnet_name" {
  description = "Subnet name"
  value       = google_compute_subnetwork.main.name
}
# Test CI/CD Trigger