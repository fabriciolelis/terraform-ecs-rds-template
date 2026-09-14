data "aws_ec2_managed_prefix_list" "cloudfront" {
  name = "com.amazonaws.global.cloudfront.origin-facing"
}

resource "aws_security_group" "alb" {
  name   = "${var.name}-sg-alb-${var.environment}"
  vpc_id = var.vpc_id

  # CloudFront reaches the origin over HTTPS only, so port 80 stays shut. One
  # rule, because a prefix list spends its max-entries count against the
  # per-security-group rule quota.
  ingress {
    protocol        = "tcp"
    from_port       = 443
    to_port         = 443
    prefix_list_ids = [data.aws_ec2_managed_prefix_list.cloudfront.id]
  }

  egress {
    protocol         = "-1"
    from_port        = 0
    to_port          = 0
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  tags = {
    "Name" = "alb-security-group"
  }
}

resource "aws_security_group" "ecs_task" {
  name   = "${var.name}-sg-task-${var.environment}"
  vpc_id = var.vpc_id

  ingress {
    protocol        = "tcp"
    from_port       = var.container_port
    to_port         = var.container_port
    security_groups = [aws_security_group.alb.id]
  }

  egress {
    protocol         = "-1"
    from_port        = 0
    to_port          = 0
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

resource "aws_security_group" "db_access_sg" {
  name        = "${var.name}-db-access-sg-${var.environment}"
  vpc_id      = var.vpc_id
  description = "Allow access to RDS"

  tags = {
    "Name"        = "${var.name}-db-access-sg"
    "Environment" = "${var.environment}"
  }
}

resource "aws_security_group" "rds_sg" {
  name        = "${var.name}-rds-sg-${var.environment}"
  vpc_id      = var.vpc_id
  description = "Security group to RDS"

  ingress {
    from_port = 0
    protocol  = "-1"
    self      = true
    to_port   = 0
  }

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.db_access_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
