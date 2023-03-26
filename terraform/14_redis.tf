resource "aws_elasticache_subnet_group" "production" {
  name       = "${terraform.workspace}-${var.project_name}-main"
  subnet_ids = module.vpc.private_subnets

  tags = {
    "project" : var.project_name
    "type" : terraform.workspace
  }
}

resource "aws_elasticache_cluster" "redis" {
  cluster_id         = "${terraform.workspace}-${var.project_name}-cluster"
  engine             = "redis"
  node_type          = "cache.t3.micro"
  num_cache_nodes    = 1
  port               = 6379
  apply_immediately  = true
  security_group_ids = [aws_security_group.elasticache.id]
  subnet_group_name  = aws_elasticache_subnet_group.production.name
  log_delivery_configuration {
    destination      = aws_cloudwatch_log_group.redis-log-group.name
    destination_type = "cloudwatch-logs"
    log_format       = "text"
    log_type         = "slow-log"
  }
  tags = {
    "project" : var.project_name
    "type" : terraform.workspace
  }
}