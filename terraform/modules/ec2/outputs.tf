output "backend_public_dns" {
    value = aws_instance.backend[*].public_dns
}