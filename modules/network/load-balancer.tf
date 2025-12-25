# TLS Certification from ACM
resource "aws_acm_certificate" "alb_cert" {
  domain_name       = "api.mydomain.com"  # Replace with your domain
  validation_method = "DNS"

  tags = {
    Name = "alb-cert"
  }
} 


resource "aws_lb" "app_alb" {
  name               = "private-alb"
  internal           = true
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = [aws_subnet.private.id]

  tags = {
    Name = "private-alb"
  }
}


# Target group
resource "aws_lb_target_group" "alb_tg" {
  name     = "alb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id

  health_check {
    interval            = 30
    path                = "/"
    protocol            = "HTTP"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
  }
}

# Attach EC2 to target group
resource "aws_lb_target_group_attachment" "ec2_alb_attachment" {
  target_group_arn = aws_lb_target_group.alb_tg.arn
  target_id = var.ec2_instance_id
  port = 80
}

# ALB Listener 
resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.app_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {        # Redirect http (80) traffic to https (443)
    type = "redirect"
    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_listener" "https_listener" {
  load_balancer_arn = aws_lb.app_alb.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = aws_acm_certificate.alb_cert.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_tg.arn
  }
}
