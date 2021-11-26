output "executionRoleArn" {
  value = aws_iam_role.ecs_task_role.arn
}

output "taskRoleArn" {
  value = aws_iam_role.ecs_task_role.arn
}

output "cluster_name" {
  value = aws_ecs_cluster.main.name
}
