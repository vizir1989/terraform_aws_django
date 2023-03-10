resource "aws_iam_role" "ecs-host-role" {
  name               = "ecs_host_role_${terraform.workspace}_${var.project_name}"
  assume_role_policy = file("policies/ecs-role.json")
}

resource "aws_iam_role_policy" "ecs-instance-role-policy" {
  name   = "ecs_instance_role_policy_${terraform.workspace}_${var.project_name}"
  policy = file("policies/ecs-instance-role-policy.json")
  role   = aws_iam_role.ecs-host-role.id
}

resource "aws_iam_role" "ecs-service-role" {
  name               = "ecs_service_role_${terraform.workspace}_${var.project_name}"
  assume_role_policy = file("policies/ecs-role.json")
  tags = {
    "project" : var.project_name
    "type" : terraform.workspace
  }
}

resource "aws_iam_role_policy" "ecs-service-role-policy" {
  name   = "ecs_service_role_policy_${terraform.workspace}_${var.project_name}"
  policy = file("policies/ecs-service-role-policy.json")
  role   = aws_iam_role.ecs-service-role.id
}

resource "aws_iam_instance_profile" "ecs" {
  name = "ecs_instance_profile_${terraform.workspace}_${var.project_name}"
  path = "/"
  role = aws_iam_role.ecs-host-role.name
  tags = {
    "project" : var.project_name
    "type" : terraform.workspace
  }
}