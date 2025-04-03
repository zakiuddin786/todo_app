output "backend_ecr_uri" {
  value = aws_ecr_repository.backend.repository_url
}

output "backend_ecr_arn" {
  value = aws_ecr_repository.backend.arn
}