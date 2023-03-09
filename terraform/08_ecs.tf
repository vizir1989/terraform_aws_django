resource "aws_ecs_cluster" "production" {
  name = "${terraform.workspace}-cluster"
}

resource "aws_launch_configuration" "ecs" {
  name                        = "${terraform.workspace}-cluster"
  image_id                    = lookup(var.amis, var.region)
  instance_type               = var.instance_type
  security_groups             = [aws_security_group.ecs.id]
  iam_instance_profile        = aws_iam_instance_profile.ecs.name
  key_name                    = aws_key_pair.production.key_name
  associate_public_ip_address = true
  user_data                   = "#!/bin/bash\necho ECS_CLUSTER='${terraform.workspace}-cluster' > /etc/ecs/ecs.config"
}

data "template_file" "app" {
  template = file("templates/django_app.json.tpl")

  vars = {
    docker_image_url_django = var.docker_image_url_django
    docker_image_url_nginx  = var.docker_image_url_nginx
    region                  = data.aws_region.current.name
    rds_db_name             = aws_db_instance.production.id
    rds_password_kms_id     = aws_secretsmanager_secret.secret_master_db.id
    rds_hostname            = aws_db_instance.production.address
    allowed_hosts           = var.allowed_hosts
    bucket_name             = aws_s3_bucket.bucket.bucket
    terraform_workspace     = terraform.workspace
  }
}

resource "aws_ecs_task_definition" "app" {
  family                = "terraform_aws_django"
  container_definitions = data.template_file.app.rendered
  depends_on            = [aws_db_instance.production]
}

resource "aws_ecs_service" "production" {
  name            = "${terraform.workspace}-service"
  cluster         = aws_ecs_cluster.production.id
  task_definition = aws_ecs_task_definition.app.arn
  iam_role        = aws_iam_role.ecs-service-role.arn
  desired_count   = var.app_count
  depends_on      = [aws_alb_listener.ecs-alb-https-listener, aws_iam_role_policy.ecs-service-role-policy]

  load_balancer {
    target_group_arn = aws_alb_target_group.default-target-group.arn
    container_name   = "nginx"
    container_port   = 443
  }
}
