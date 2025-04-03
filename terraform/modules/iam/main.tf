# Role for EC2 access
resource "aws_iam_role" "ec2_role" {
  name = "${var.environment}-ec2-ecr-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
        {
            Action = "sts:AssumeRole"
            Effect = "Allow"
            Principal = {
                Service = "ec2.amazonaws.com"
            }
        },
        {
            Action = "sts:AssumeRole"
            Effect = "Allow"
            Principal = {
              AWS = "arn:aws:iam::688567260640:role/dev-ec2-ecr-role"
            }
        }
    ]
  })
}

#ECR Access policy for Ec2 role

resource "aws_iam_role_policy" "ecr_access" {
  name = "${var.environment}-ecr-access"
  role = aws_iam_role.ec2_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
        {
            Effect = "Allow"
            Action = [
                "ecr:GetAuthorizationToken",
                "ecr:GetDownloadUrlForLayer",
                "ecr:BatchCheckLayerAvailability",
                "ecr:BatchGetImage",
                "ecr:DescribeRepositories",
                "ecr:PutImage",
                "ec2:DescribeInstances"
            ]
            Resource = "*"
        }
    ]
  })
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "${var.environment}-ec2-ecr-profile"
  role = aws_iam_role.ec2_role.name
}