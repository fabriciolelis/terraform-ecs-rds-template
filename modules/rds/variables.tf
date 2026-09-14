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

variable "username" {
  description = "Master username. RDS generates and rotates the password itself"
  type        = string
  default     = "admin"
}

variable "instance_class" {
  description = "RDS instance class"
  type        = string
  default     = "db.t4g.micro"
}

variable "engine_version" {
  description = "MySQL version to pin. Give major.minor only so RDS owns the patch level"
  type        = string
  default     = "8.0"
}

variable "allocated_storage" {
  description = "Initial storage in GiB. RDS enforces a floor of 20 for SSD-backed MySQL"
  type        = number
  default     = 20
}

variable "max_allocated_storage" {
  description = "Ceiling for storage autoscaling in GiB. 0 disables autoscaling"
  type        = number
  default     = 100
}

variable "backup_retention_period" {
  description = "Days of automated backups to keep. Also the point-in-time recovery window"
  type        = number
  default     = 7
}

variable "backup_window" {
  description = "Daily UTC window for automated backups"
  type        = string
  default     = "03:00-04:00"
}

variable "maintenance_window" {
  description = "Weekly UTC window for RDS-initiated maintenance"
  type        = string
  default     = "Mon:04:30-Mon:05:30"
}

variable "multi_az" {
  description = "Run a synchronous standby in a second availability zone"
  type        = bool
  default     = false
}

variable "monitoring_interval" {
  description = "Enhanced monitoring granularity in seconds. 0 disables it; any other value provisions the monitoring role"
  type        = number
  default     = 0
}

variable "performance_insights_enabled" {
  description = "Collect query-level performance data. Unsupported on micro and small burstable classes, including the default"
  type        = bool
  default     = false
}

variable "auto_minor_version_upgrade" {
  description = "Let RDS apply minor engine upgrades in the maintenance window"
  type        = bool
  default     = true
}

variable "deletion_protection" {
  description = "Refuse to delete the instance until this is turned off"
  type        = bool
  default     = true
}

variable "skip_final_snapshot" {
  description = "Destroy without a final snapshot. Only for disposable environments"
  type        = bool
  default     = false
}

variable "kms_key_id" {
  description = "Customer-managed KMS key for storage encryption. Empty uses the AWS-managed RDS key"
  type        = string
  default     = ""
}
