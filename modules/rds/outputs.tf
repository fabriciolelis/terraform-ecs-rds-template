output "hostname" {
  description = "RDS instance hostname"
  value       = aws_db_instance.main.address
  sensitive   = true
}

output "endpoint" {
  description = "RDS instance hostname"
  value       = aws_db_instance.main.endpoint
  sensitive   = true
}

output "database-name" {
  description = "RDS instance hostname"
  value       = aws_db_instance.main.name
  sensitive   = true
}

