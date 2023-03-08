resource "random_password" "rds_password" {
  length  = 16
  special = false
}

resource "aws_secretsmanager_secret" "secret_master_db" {
  name = "${var.ecs_cluster_name}_rds_password"
}

resource "aws_secretsmanager_secret_version" "sversion" {
  secret_id     = aws_secretsmanager_secret.secret_master_db.id
  secret_string = <<EOF
   {
    "username": "django",
    "password": "${random_password.rds_password.result}"
   }
EOF
}

data "aws_secretsmanager_secret" "secret_master_db" {
  arn = aws_secretsmanager_secret.secret_master_db.arn
}

data "aws_secretsmanager_secret_version" "creds" {
  secret_id = data.aws_secretsmanager_secret.secret_master_db.arn
}

locals {
  db_creds = jsondecode(data.aws_secretsmanager_secret_version.creds.secret_string)
}
