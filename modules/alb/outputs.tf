output "aws_alb_target_group_arn" {
  value = aws_alb_target_group.main.arn

  # A service with a load_balancer block cannot be created before a listener
  # forwards to its target group. Carrying the dependency on the output lets
  # callers wire the ARN without a module-wide depends_on.
  depends_on = [aws_lb_listener_rule.from_cloudfront]
}

output "alb_dns_name" {
  value = aws_lb.main.dns_name
}
