resource "aws_autoscaling_group" "ecs-cluster" {
  name                 = "${terraform.workspace}_${var.project_name}_auto_scaling_group"
  min_size             = terraform.workspace == "prod" ? var.autoscale_min : 1
  max_size             = terraform.workspace == "prod" ? var.autoscale_max : 4
  desired_capacity     = terraform.workspace == "prod" ? var.autoscale_desired : 2
  health_check_type    = "EC2"
  launch_configuration = aws_launch_configuration.ecs.name
  vpc_zone_identifier  = module.vpc.private_subnets
}