# Application Load Balancer
resource "aws_lb" "app_lb" {
  name               = "${var.app_name}-alb"
  load_balancer_type = "application"
  subnets            = aws_subnet.public[*].id
  security_groups    = [aws_security_group.lb_sg.id]

  tags = {
    Name = "${var.app_name}-alb"
  }
}

# Target Group for ECS tasks
resource "aws_lb_target_group" "app_tg" {
  name     = "${var.app_name}-tg"
  port     = var.container_port
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id   # <-- Use the actual VPC resource

  health_check {
    path                = "/"
    protocol            = "HTTP"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = {
    Name = "${var.app_name}-tg"
  }
}

# Listener for the ALB
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.app_lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_tg.arn
  }
}
