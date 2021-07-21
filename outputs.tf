output "vm_instance_name" {
  description = "The name of the sql database instance"
  value       = google_compute_instance.vm.name
}

output "self_link" {
  description = "Self link to the master instance"
  value       = google_compute_instance.vm.self_link
}