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

resource "google_project_service" "gcp_services" {
  count   = length(var.apis)
  project = var.project
  service = var.apis[count.index]
  disable_on_destroy = false
}


locals {
onprem = ["0.0.0.0/0"]
}

resource "google_sql_database_instance" "master" {
  name = var.master_instance_name
  database_version = var.database_version
  region = var.region
  settings {
    tier = var.tier
    disk_size = var.disk_size
    disk_type = var.disk_type
    availability_type = var.availability_type
    activation_policy = var.activation_policy
    ip_configuration {

      ipv4_enabled = true
        
        dynamic "authorized_networks" {
          for_each = local.onprem
          iterator = onprem

        content {
          name  = "onprem-${onprem.key}"
          value = onprem.value
        }
      }
    }
  }
}
resource "google_sql_database" "database" {
  name     = var.db_name
  instance = google_sql_database_instance.master.name
}

resource "random_id" "user-password" {
  byte_length = 8
}

resource "google_sql_user" "default" {
  name     = var.user_name
  instance = google_sql_database_instance.master.name
  host     = var.user_host
  password = var.user_password == "" ? random_id.user-password.hex : var.user_password
}