data "aws_secretsmanager_secret" "secrets" {
  arn = var.database_secret_arn
}

data "aws_secretsmanager_secret_version" "db_secret" {
  secret_id = data.aws_secretsmanager_secret.secrets.id
}

locals {
  db_creds = jsondecode(
    data.aws_secretsmanager_secret_version.db_secret.secret_string
  )
}

resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "${var.environment}-rds-subnet-group"
  subnet_ids = var.subnets.*.id
  tags = {
    "Environment" = var.environment
    "Name"        = "${var.environment}-rds-subnet-group"
  }
}

resource "aws_db_parameter_group" "main" {
  name   = "main"
  family = "mysql8.0"

  parameter {
    name  = "character_set_server"
    value = "utf8"
  }

  parameter {
    name  = "character_set_client"
    value = "utf8"
  }
}


resource "aws_db_instance" "main" {
  identifier             = "${var.name}-database-${var.environment}"
  allocated_storage      = 10
  engine                 = "mysql"
  engine_version         = "8.0.23"
  instance_class         = "db.t2.micro"
  name                   = "${var.name}db"
  username               = local.db_creds.username
  password               = local.db_creds.password
  parameter_group_name   = aws_db_parameter_group.main.name
  db_subnet_group_name   = aws_db_subnet_group.rds_subnet_group.name
  port                   = 3306
  publicly_accessible    = false
  skip_final_snapshot    = true
  vpc_security_group_ids = var.rds_security_groups


  tags = {
    Name        = "${var.name}-database-${var.environment}"
    Environment = "${var.environment}"
  }
}
