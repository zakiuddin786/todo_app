output "monitoring_public_dns" {
  value = aws_instance.monitoring[*].public_dns
}