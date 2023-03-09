resource "aws_autoscaling_group" "ecs-cluster" {
  name                 = "${terraform.workspace}_auto_scaling_group"
  min_size             = terraform.workspace == "prod" ? var.autoscale_min : 1
  max_size             = terraform.workspace == "prod" ? var.autoscale_max : 1
  desired_capacity     = terraform.workspace == "prod" ? var.autoscale_desired : 1
  health_check_type    = "EC2"
  launch_configuration = aws_launch_configuration.ecs.name
  vpc_zone_identifier  = [aws_subnet.private-subnet-1.id, aws_subnet.private-subnet-2.id]
}