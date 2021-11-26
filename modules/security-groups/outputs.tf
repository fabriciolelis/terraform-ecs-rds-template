output "alb" {
  value = aws_security_group.alb.id
}

output "ecs_tasks" {
  value = aws_security_group.ecs_task.id
}

output "rds_sg" {
  value = aws_security_group.rds_sg.id
}

output "db_access_sg" {
  value = aws_security_group.db_access_sg.id
}
