resource "random_password" "rds_password" {
  length  = 16
  special = false
}

resource "random_password" "django_secret_key" {
  length           = 24
  override_special = "_$#%^&*@!_-+<>?"
}

resource "random_password" "django_superuser_password" {
  length  = 8
  special = false
}

resource "aws_secretsmanager_secret" "secret_master_db" {
  name = "${terraform.workspace}-${var.secret_id}"
}

resource "aws_secretsmanager_secret_version" "secret_version" {
  secret_id     = aws_secretsmanager_secret.secret_master_db.id
  secret_string = <<EOF
  {
      "django_secret_key": "${random_password.django_secret_key.result}",
      "django_superuser_password": "${random_password.django_superuser_password.result}",
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
