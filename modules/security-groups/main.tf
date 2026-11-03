data "aws_ec2_managed_prefix_list" "cloudfront" {
  name = "com.amazonaws.global.cloudfront.origin-facing"
}

# Rules live in their own resources rather than inline blocks: inline and
# standalone rules on the same group fight each other, and a standalone rule
# can change without rewriting every other rule on the group.

resource "aws_security_group" "alb" {
  name   = "${var.name}-sg-alb-${var.environment}"
  vpc_id = var.vpc_id

  tags = {
    "Name" = "alb-security-group"
  }
}

# CloudFront reaches the origin over HTTPS only, so port 80 stays shut. One
# rule, because a prefix list spends its max-entries count against the
# per-security-group rule quota.
resource "aws_vpc_security_group_ingress_rule" "alb_https_from_cloudfront" {
  security_group_id = aws_security_group.alb.id
  ip_protocol       = "tcp"
  from_port         = 443
  to_port           = 443
  prefix_list_id    = data.aws_ec2_managed_prefix_list.cloudfront.id
}

resource "aws_vpc_security_group_egress_rule" "alb_all_ipv4" {
  security_group_id = aws_security_group.alb.id
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_vpc_security_group_egress_rule" "alb_all_ipv6" {
  security_group_id = aws_security_group.alb.id
  ip_protocol       = "-1"
  cidr_ipv6         = "::/0"
}

resource "aws_security_group" "ecs_task" {
  name   = "${var.name}-sg-task-${var.environment}"
  vpc_id = var.vpc_id
}

resource "aws_vpc_security_group_ingress_rule" "ecs_task_from_alb" {
  security_group_id            = aws_security_group.ecs_task.id
  ip_protocol                  = "tcp"
  from_port                    = var.container_port
  to_port                      = var.container_port
  referenced_security_group_id = aws_security_group.alb.id
}

resource "aws_vpc_security_group_egress_rule" "ecs_task_all_ipv4" {
  security_group_id = aws_security_group.ecs_task.id
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_vpc_security_group_egress_rule" "ecs_task_all_ipv6" {
  security_group_id = aws_security_group.ecs_task.id
  ip_protocol       = "-1"
  cidr_ipv6         = "::/0"
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
}

resource "aws_vpc_security_group_ingress_rule" "rds_self" {
  security_group_id            = aws_security_group.rds_sg.id
  ip_protocol                  = "-1"
  referenced_security_group_id = aws_security_group.rds_sg.id
}

resource "aws_vpc_security_group_ingress_rule" "rds_mysql_from_db_access" {
  security_group_id            = aws_security_group.rds_sg.id
  ip_protocol                  = "tcp"
  from_port                    = 3306
  to_port                      = 3306
  referenced_security_group_id = aws_security_group.db_access_sg.id
}

resource "aws_vpc_security_group_egress_rule" "rds_all_ipv4" {
  security_group_id = aws_security_group.rds_sg.id
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"
}
