output "sql_instance_name" {
  description = "The name of the sql database instance"
  value       = google_sql_database_instance.master.name
}

output "sql_db_name" {
  description = "The name of the sql database"
  value       = google_sql_database.database.name
}

output "user_name" {
  description = "The name of the sql database user"
  value       = google_sql_user.default.name 
}

output "generated_user_password" {
  description = "The auto generated default user password if no input password was provided"
  value       = random_id.user-password.hex
  sensitive   = true
}


output "instance_address" {
  description = "The IPv4 address of the master database instance"
  value       = google_sql_database_instance.master.ip_address.0.ip_address
}



