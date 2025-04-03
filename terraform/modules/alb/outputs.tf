output "alb_security_group_id" {
  value = aws_security_group.alb-sg.id
}

output "target_group_arn" {
  value = aws_lb_target_group.backend.arn
}