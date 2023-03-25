resource "aws_db_subnet_group" "production" {
  name       = "${terraform.workspace}-${var.project_name}-main"
  subnet_ids = module.vpc.private_subnets

  tags = {
    "project" : var.project_name
    "type" : terraform.workspace
  }
}

resource "aws_db_instance" "production" {
  identifier              = "${terraform.workspace}${var.project_name}db"
  db_name                 = "${terraform.workspace}${var.project_name}db"
  username                = local.db_creds.username
  password                = local.db_creds.password
  port                    = "5432"
  engine                  = "postgres"
  engine_version          = "15.2"
  instance_class          = var.rds_instance_class
  allocated_storage       = "20"
  storage_encrypted       = false
  vpc_security_group_ids  = [aws_security_group.rds.id]
  db_subnet_group_name    = aws_db_subnet_group.production.name
  multi_az                = false
  storage_type            = "gp2"
  publicly_accessible     = false
  backup_retention_period = 7
  skip_final_snapshot     = true

  tags = {
    "project" : var.project_name
    "type" : terraform.workspace
  }
}
