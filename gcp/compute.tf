resource "google_compute_address" "main" {
  name   = "${var.project_name}-${var.environment}-ip"
  region = var.region
}

resource "google_compute_instance" "main" {
  name         = "${var.project_name}-${var.environment}-web-server"
  machine_type = var.machine_type
  zone         = var.zone
  tags         = ["web-server"]

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2204-lts"
      size  = 30
      type  = "pd-standard"
    }
  }

  network_interface {
    network    = google_compute_network.main.name
    subnetwork = google_compute_subnetwork.main.name

    access_config {
      nat_ip = google_compute_address.main.address
    }
  }
shielded_instance_config {
    enable_secure_boot          = true
    enable_vtpm                 = true
    enable_integrity_monitoring = true
  }
  metadata_startup_script = templatefile("${path.module}/startup-script.sh", {
    db_host     = google_sql_database_instance.main.public_ip_address
    db_name     = var.db_name
    db_user     = var.db_user
    db_password = var.db_password
  })

  depends_on = [
    google_sql_database_instance.main
  ]
}
# Test CI/CD Trigger