# Production Load Balancer

resource "aws_lb" "production" {
  name               = "${terraform.workspace}-${var.project_name}-alb"
  load_balancer_type = "application"
  internal           = false
  security_groups    = [aws_security_group.load-balancer.id]
  subnets            = module.vpc.public_subnets
  # subnets            = [aws_subnet.public-subnet-1.id, aws_subnet.public-subnet-2.id]

  tags = {
    "project" : var.project_name
    "type" : terraform.workspace
  }

  access_logs {
    bucket  = aws_s3_bucket.bucket.id
    prefix  = "aws_lb"
    enabled = true
  }
}

# Target group
resource "aws_alb_target_group" "default-target-group" {
  name     = "${terraform.workspace}-${var.project_name}-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = module.vpc.vpc_id

  tags = {
    "project" : var.project_name
    "type" : terraform.workspace
  }

  health_check {
    path                = var.health_check_path
    port                = "traffic-port"
    protocol            = "HTTP"
    healthy_threshold   = 5
    unhealthy_threshold = 2
    timeout             = 2
    interval            = 5
    matcher             = "200"
  }
}

resource "aws_lb_listener" "ecs-alb-http-listener" {
  load_balancer_arn = aws_lb.production.id
  port              = "80"
  protocol          = "HTTP"

  tags = {
    "project" : var.project_name
    "type" : terraform.workspace
  }

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

# Listener (redirects traffic from the load balancer to the target group)
resource "aws_alb_listener" "ecs-alb-https-listener" {
  load_balancer_arn = aws_lb.production.id
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.certificate_arn
  depends_on        = [aws_alb_target_group.default-target-group]

  tags = {
    "project" : var.project_name
    "type" : terraform.workspace
  }

  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.default-target-group.arn
  }
}