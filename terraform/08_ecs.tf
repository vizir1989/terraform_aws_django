resource "aws_ecs_cluster" "production" {
  name = "${terraform.workspace}-${var.project_name}-cluster"
  tags = {
    "project" : var.project_name
    "type" : terraform.workspace
  }
}

resource "aws_launch_configuration" "ecs" {
  name                        = "${terraform.workspace}-${var.project_name}-cluster"
  image_id                    = lookup(var.amis, var.region)
  instance_type               = var.instance_type
  security_groups             = [aws_security_group.ecs.id]
  iam_instance_profile        = aws_iam_instance_profile.ecs.name
  key_name                    = aws_key_pair.production.key_name
  associate_public_ip_address = true
  user_data                   = "#!/bin/bash\necho ECS_CLUSTER='${terraform.workspace}-${var.project_name}-cluster' > /etc/ecs/ecs.config"
}

data "template_file" "app" {
  template = file("templates/django_app.json.tpl")

  vars = {
    elc_host                  = aws_elasticache_cluster.redis.cache_nodes.0.address
    elc_port                  = aws_elasticache_cluster.redis.cache_nodes.0.port
    elc_db                    = 0
    docker_image_url_django   = var.docker_image_url_django
    docker_image_url_nginx    = var.docker_image_url_nginx
    region                    = data.aws_region.current.name
    rds_db_name               = aws_db_instance.production.id
    rds_password_kms_id       = aws_secretsmanager_secret.secret_master_db.id
    rds_hostname              = aws_db_instance.production.address
    allowed_hosts             = ".${var.hosted_zone} .amazonaws.com"
    bucket_name               = aws_s3_bucket.bucket.bucket
    terraform_workspace       = terraform.workspace
    django_superuser_password = random_password.django_superuser_password.result
    django_secret_key         = random_password.django_secret_key.result
    project_name              = var.project_name
  }
}

resource "aws_ecs_task_definition" "app" {
  family                = var.project_name
  container_definitions = data.template_file.app.rendered
  depends_on            = [aws_db_instance.production]

  tags = {
    "project" : var.project_name
    "type" : terraform.workspace
  }
}

resource "aws_ecs_service" "production" {
  name            = "${terraform.workspace}-${var.project_name}-service"
  cluster         = aws_ecs_cluster.production.id
  task_definition = aws_ecs_task_definition.app.arn
  iam_role        = aws_iam_role.ecs-service-role.arn
  desired_count   = var.app_count
  depends_on      = [aws_alb_listener.ecs-alb-https-listener, aws_iam_role_policy.ecs-service-role-policy]

  tags = {
    "project" : var.project_name
    "type" : terraform.workspace
  }

  load_balancer {
    target_group_arn = aws_alb_target_group.default-target-group.arn
    container_name   = "${var.project_name}_nginx"
    container_port   = 80
  }
}
