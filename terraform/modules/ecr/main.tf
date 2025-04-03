resource "aws_ecr_repository" "backend" {
  name = "${var.environment}-todo-backend"

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecr_lifecycle_policy" "ecr_policy" {
  repository = aws_ecr_repository.backend.name
  policy = jsonencode({
    rules = [
        {
            rulePriority = 1
            description = "Keep last 10 images"
            selection = {
                tagStatus = "any"
                countType = "imageCountMoreThan"
                countNumber = 10
            }
            action = {
                type = "expire"
            }
        }
    ]
  })
}