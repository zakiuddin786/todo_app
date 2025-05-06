output "monitoring_public_dns" {
  value = aws_instance.monitoring[*].public_dns
}

output "monitoring_security_group_id" {
  value = aws_security_group.monitoring-sg.id
}