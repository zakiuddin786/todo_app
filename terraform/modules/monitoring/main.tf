resource "aws_instance" "monitoring" {
    ami = var.instance_config.ami_id
    instance_type = var.instance_config.instance_type
    subnet_id = element(var.instance_config.subnet_ids, count.index % length(var.instance_config.subnet_ids))
    count = var.instance_config.instance_count
    vpc_security_group_ids = [aws_security_group.monitoring-sg.id]
    key_name = var.instance_config.ssh_key_name
    iam_instance_profile = aws_iam_instance_profile.monitoring_profile.name

    root_block_device {
      volume_size = 20
    }

    tags = {
        Name = "${var.environment}-monitoring"
        Environment = var.environment
    }
}


resource "aws_security_group" "monitoring-sg" {
  name = "${var.environment}-monitoring-sg"
  description = "Security group for monitoring stack"
  vpc_id = var.instance_config.vpc_id

  ingress {
    from_port = 3000 # Grafana
    to_port = 3000
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 9090 # Prometheus
    to_port = 9090
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

    ingress {
    from_port = 3100 # Loki
    to_port = 3100
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 22 # ssh
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_iam_role" "monitoring_role" {
  name = "${var.environment}-monitoring-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
        {
            Action = "sts:AssumeRole"
            Effect = "Allow"
            Principal = {
                Service = "ec2.amazonaws.com"
            }
        }
    ]
  })
}


resource "aws_iam_role_policy" "prometheus_ec2_discovery" {
  name = "${var.environment}-prometheus-ec2-discovery"
  role = aws_iam_role.monitoring_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
        {
            Effect = "Allow"
            Action = [
                "ec2:DescribeInstances",
                "ec2:DescribeTags",
            ]
            Resource = "*"
        }
    ]
  })
}

resource "aws_iam_instance_profile" "monitoring_profile" {
  name = "${var.environment}-monitoring-profile"
  role = aws_iam_role.monitoring_role.name
}