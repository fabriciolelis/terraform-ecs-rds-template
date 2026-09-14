variable "name" {
  description = "the name of your stack, e.g. \"demo\""
}

variable "environment" {
  description = "the name of your environment, e.g. \"prod\""
}

variable "region" {
  description = "the AWS region in which resources are created"
}

variable "subnets" {
  description = "List of subnet IDs"
}

variable "ecs_service_security_groups" {
  description = "Comma separated list of security groups"
}

variable "container_port" {
  description = "Port of container"
}

variable "container_cpu" {
  description = "The number of cpu units used by the task"
}

variable "container_memory" {
  description = "The amount (in MiB) of memory used by the task"
}

variable "aws_ecr_repository_url" {
  description = "Docker image to be launched"
}

variable "aws_alb_target_group_arn" {
  description = "ARN of the alb target group"
}

variable "service_desired_count" {
  description = "Number of services running in parallel"
}

variable "container_environment" {
  description = "The container environmnent variables"
  type        = list(any)
}

variable "container_secrets" {
  description = "The container secret environmnent variables"
  type        = list(any)
}

variable "container_secrets_arns" {
  description = "ARN for secrets"
}

variable "health_check_grace_period_seconds" {
  description = "How long the load balancer ignores health checks after a task starts, so a slow boot is not mistaken for a failure"
  type        = number
  default     = 60
}

variable "app_bucket" {
  description = "S3 bucket the application reads and writes. Empty grants the task no bucket access"
  type        = string
  default     = ""
}
