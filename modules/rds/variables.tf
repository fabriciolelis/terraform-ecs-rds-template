variable "name" {
  description = "the name of your stack, e.g. \"demo\""
}

variable "environment" {
  description = "the name of your environment, e.g. \"prod\""
}

variable "subnets" {
  description = "Comma separated list of subnet IDs"
}

variable "rds_security_groups" {
  description = "Comma separated list of security groups"
}

variable "database_secret_arn" {
  description = "ARN value from database secrets"
}
