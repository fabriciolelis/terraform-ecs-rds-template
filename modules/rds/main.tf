locals {
  monitoring_enabled = var.monitoring_interval > 0
}

resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "${var.environment}-rds-subnet-group"
  subnet_ids = var.subnets.*.id
  tags = {
    "Environment" = var.environment
    "Name"        = "${var.environment}-rds-subnet-group"
  }
}

# A parameter change replaces the group, so it must exist before the instance
# stops referencing the old one.
resource "aws_db_parameter_group" "main" {
  name_prefix = "${var.name}-${var.environment}-"
  family      = "mysql8.0"

  parameter {
    name  = "character_set_server"
    value = "utf8"
  }

  parameter {
    name  = "character_set_client"
    value = "utf8"
  }

  tags = {
    Name        = "${var.name}-${var.environment}"
    Environment = var.environment
  }

  lifecycle {
    create_before_destroy = true
  }
}

data "aws_iam_policy_document" "monitoring_assume" {
  count = local.monitoring_enabled ? 1 : 0

  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["monitoring.rds.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "monitoring" {
  count              = local.monitoring_enabled ? 1 : 0
  name_prefix        = "${var.name}-rds-monitoring-"
  assume_role_policy = data.aws_iam_policy_document.monitoring_assume[0].json
}

resource "aws_iam_role_policy_attachment" "monitoring" {
  count      = local.monitoring_enabled ? 1 : 0
  role       = aws_iam_role.monitoring[0].name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
}

resource "aws_db_instance" "main" {
  identifier     = "${var.name}-database-${var.environment}"
  engine         = "mysql"
  engine_version = var.engine_version
  instance_class = var.instance_class

  db_name                     = "${var.name}db"
  username                    = var.username
  manage_master_user_password = true
  port                        = 3306

  allocated_storage     = var.allocated_storage
  max_allocated_storage = var.max_allocated_storage
  storage_type          = "gp3"
  storage_encrypted     = var.storage_encrypted
  kms_key_id            = var.storage_encrypted && var.kms_key_id != "" ? var.kms_key_id : null

  parameter_group_name   = aws_db_parameter_group.main.name
  db_subnet_group_name   = aws_db_subnet_group.rds_subnet_group.name
  vpc_security_group_ids = var.rds_security_groups
  publicly_accessible    = false
  multi_az               = var.multi_az

  backup_retention_period    = var.backup_retention_period
  backup_window              = var.backup_window
  maintenance_window         = var.maintenance_window
  auto_minor_version_upgrade = var.auto_minor_version_upgrade
  copy_tags_to_snapshot      = true

  deletion_protection       = var.deletion_protection
  skip_final_snapshot       = var.skip_final_snapshot
  final_snapshot_identifier = var.skip_final_snapshot ? null : "${var.name}-database-${var.environment}-final"

  monitoring_interval          = var.monitoring_interval
  monitoring_role_arn          = local.monitoring_enabled ? aws_iam_role.monitoring[0].arn : null
  performance_insights_enabled = var.performance_insights_enabled

  tags = {
    Name        = "${var.name}-database-${var.environment}"
    Environment = var.environment
  }
}
