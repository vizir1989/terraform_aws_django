resource "aws_cloudwatch_log_group" "django-log-group" {
  name              = "/ecs/${var.project_name}-${terraform.workspace}"
  retention_in_days = var.log_retention_in_days
  tags = {
    "project" : var.project_name
    "type" : terraform.workspace
  }
}

resource "aws_cloudwatch_log_stream" "django-log-stream" {
  name           = "${var.project_name}-log-stream-${terraform.workspace}"
  log_group_name = aws_cloudwatch_log_group.django-log-group.name
}

resource "aws_cloudwatch_log_group" "nginx-log-group" {
  name              = "/ecs/${var.project_name}-nginx-${terraform.workspace}"
  retention_in_days = var.log_retention_in_days
  tags = {
    "project" : var.project_name
    "type" : terraform.workspace
  }
}

resource "aws_cloudwatch_log_stream" "nginx-log-stream" {
  name           = "${var.project_name}-nginx-log-stream-${terraform.workspace}"
  log_group_name = aws_cloudwatch_log_group.nginx-log-group.name
}