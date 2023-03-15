# ALB Security Group (Traffic Internet -> ALB)
resource "aws_security_group" "load-balancer" {
  name        = "${terraform.workspace}_${var.project_name}_load_balancer_security_group"
  description = "Controls access to the ALB"
  vpc_id      = module.vpc.vpc_id

  tags = {
    "project" : var.project_name
    "type" : terraform.workspace
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# ECS Security group (traffic ALB -> ECS, ssh -> ECS)
resource "aws_security_group" "ecs" {
  name        = "${terraform.workspace}_${var.project_name}_ecs_security_group"
  description = "Allows inbound access from the ALB only"
  vpc_id      = module.vpc.vpc_id

  tags = {
    "project" : var.project_name
    "type" : terraform.workspace
  }

  ingress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = [aws_security_group.load-balancer.id]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# RDS Security Group (traffic ECS -> RDS)
resource "aws_security_group" "rds" {
  name        = "${terraform.workspace}_${var.project_name}_rds-security-group"
  description = "Allows inbound access from ECS only"
  vpc_id      = module.vpc.vpc_id

  tags = {
    "project" : var.project_name
    "type" : terraform.workspace
  }

  ingress {
    protocol        = "tcp"
    from_port       = "5432"
    to_port         = "5432"
    security_groups = [aws_security_group.ecs.id]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}
