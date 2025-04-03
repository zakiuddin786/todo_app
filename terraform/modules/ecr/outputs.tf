output "backend_ecr_uri" {
  value = aws_ecr_repository.backend.repository_url
}

output "backend_ecr_arn" {
  value = aws_ecr_repository.backend.arn
}

output "aws_account_id" {
  value = aws_ecr_repository.backend.registry_id
}

output "backend_ecr_repository_name" {
  value = aws_ecr_repository.backend.name
}