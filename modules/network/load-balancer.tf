resource "aws_lb" "app_alb" {
  name               = "private-alb"
  internal           = true
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]

  idle_timeout = 120

  subnets            = [
    aws_subnet.private.id,
    aws_subnet.secondary_private.id
  ]

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
  load_balancing_cross_zone_enabled = false

  health_check {
    path = "/health"  # matches your FastAPI /health route
    timeout = 20      # give FastAPI some breathing room
    interval = 30
    healthy_threshold = 2
    unhealthy_threshold = 2
  }

}

# Attach EC2 to target group
resource "aws_lb_target_group_attachment" "ec2_alb_attachment" {
  target_group_arn = aws_lb_target_group.alb_tg.arn
  target_id = var.ec2_instance_id
  port = 80
}

# ALB Listener (HTTP -> 80)
resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.app_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_tg.arn
  }
}