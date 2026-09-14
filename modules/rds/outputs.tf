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
  value       = aws_db_instance.main.db_name
  sensitive   = true
}

output "master_user_secret_arn" {
  description = "ARN of the RDS-managed secret holding the master credentials"
  value       = aws_db_instance.main.master_user_secret[0].secret_arn
}
