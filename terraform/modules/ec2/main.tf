resource "aws_instance" "backend" {
    ami = var.instance_config.ami_id
    instance_type = var.instance_config.instance_type
    subnet_id = element(var.instance_config.subnet_ids, count.index % length(var.instance_config.subnet_ids))
    count = var.instance_config.instance_count
    vpc_security_group_ids = [aws_security_group.backend.id, aws_security_group.ssh.id]
    key_name = var.instance_config.ssh_key_name
    iam_instance_profile = var.instance_config.instance_profile_name

    tags = {
        Name = "${var.environment}-backend"
        Environment = var.environment
    }
}

resource "aws_security_group" "ssh" {
  name = "${var.environment}-ssh-sg"
  description = "Security group for SSH access"
  vpc_id = var.instance_config.vpc_id

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.environment}-ssh-sg"
    Environment = var.environment
  }
}

resource "aws_security_group" "backend" {
  name = "${var.environment}-backend-sg"
  description = "Security group for backend instances"
  vpc_id = var.instance_config.vpc_id

  ingress {
    from_port = 3000
    to_port = 3002
    protocol = "tcp"
    security_groups = [var.instance_config.alb_security_group_id]
  }


  ingress {
    from_port = 9100
    to_port = 9100
    protocol = "tcp"
    security_groups = [var.monitoring_security_group_id]
    description = "Allow node exporter metrics scraping"
  }

  ingress {
    from_port = 3002
    to_port = 3002
    protocol = "tcp"
    security_groups = [var.monitoring_security_group_id]
    description = "Allow application metrics scraping"
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_lb_target_group_attachment" "backend" {
  count = var.instance_config.instance_count
  target_group_arn =  var.instance_config.target_group_arn
  target_id = aws_instance.backend[count.index].id
  port = 3002

  lifecycle {
    create_before_destroy = true
  }
}