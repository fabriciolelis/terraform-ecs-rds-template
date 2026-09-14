output "hostname" {
  description = "Address the application connects to"
  value       = aws_db_instance.main.address
}

output "endpoint" {
  description = "Address and port, joined as host:port"
  value       = aws_db_instance.main.endpoint
}

output "database-name" {
  description = "Name of the database created on the instance"
  value       = aws_db_instance.main.db_name
}

output "master_user_secret_arn" {
  description = "ARN of the RDS-managed secret holding the master credentials"
  value       = aws_db_instance.main.master_user_secret[0].secret_arn
}
