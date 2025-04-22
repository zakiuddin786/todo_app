resource "aws_lb" "backend" {
  name               = "${var.environment}-backend-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb-sg.id]
  subnets            = var.alb_config.public_subnet_ids

  tags = {
    Environment = var.environment
  }
}

resource "random_string" "target_group_suffix" {
  length = 4
  special = false
  upper = false 
}

resource "aws_lb_target_group" "backend" {
  name     = "${var.environment}-backend-tg-${random_string.target_group_suffix.result}"
  port     = 3002
  protocol = "HTTP"
  vpc_id   = var.alb_config.vpc_id

  health_check {
    enabled = true
    healthy_threshold = 2
    interval = 30
    matcher = "200"
    path = "/api/health"
    port = "traffic-port"
    timeout = 5
    unhealthy_threshold = 2
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name = "${var.environment}-backend-${random_string.target_group_suffix.result}"
    Environment = var.environment
  }
}

resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.backend.arn
  port = "443"
  protocol = "HTTPS"
  ssl_policy = "ELBSecurityPolicy-TLS13-1-2-2021-06"
  certificate_arn = var.alb_config.certificate_arn
  
  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.backend.arn
  }

  lifecycle {
    create_before_destroy = true
  }

}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.backend.arn
  port = "80"
  protocol = "HTTP"

  default_action {
    type = "redirect"
    redirect {
      port = "443"
      protocol = "HTTPS"
      status_code = "HTTP_301"
    }
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "alb-sg" {
  name = "${var.environment}-alb-sg"
  description = "Security group for ALB"
  vpc_id = var.alb_config.vpc_id

  ingress {
    from_port = 443
    to_port = 443
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