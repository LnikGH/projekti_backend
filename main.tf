terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "3.5.0"
    }
  }
}

provider "google" {
  credentials = var.credentials_file
  
  project = var.project
  region = var.region
  zone = var.zone
}
module "child"{
  source = ".//child"
  project = var.project
  user_name = var.user_name
  credentials_file = var.credentials_file
}
resource "google_project_service" "gcp_services" {
  count   = length(var.apis)
  project = var.project
  service = var.apis[count.index]
  disable_on_destroy = false
}

resource "google_compute_firewall" "default" {
  name    = "email"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["2525"]
  }
  source_tags = ["email"]
}

resource "google_compute_instance" "vm" {
    name = var.vm_instance_name
    machine_type = var.vm_instance_type

    tags = ["email"]

    boot_disk {
        initialize_params {
            image = var.vm_disc_type
        }
    }

    metadata = {
      kek = module.child.generated_user_password
      kak = module.child.user_name
      kok = module.child.instance_address
    }
    metadata_startup_script = file("${path.module}/startup.sh")

    network_interface {
        network ="default"
        access_config {

        }
      }

  }

resource "local_file" "pw" {
    content = module.child.generated_user_password
    filename = "${path.module}/foo1.txt"
}
resource "local_file" "username" {
    content = module.child.user_name
    filename = "${path.module}/foo2.txt"
}

resource "local_file" "ipv4" {
    content = module.child.instance_address
    filename = "${path.module}/foo3.txt"
}
