data "aws_route53_zone" "product" {
  name = var.hosted_zone
}

resource "aws_route53_record" "django" {
  zone_id = data.aws_route53_zone.product.zone_id
  name    = terraform.workspace == "prod" ? "${var.project_name}.${var.hosted_zone}" : "${terraform.workspace}-${var.project_name}.${var.hosted_zone}"
  type    = "CNAME"
  ttl     = 300
  records = [aws_lb.production.dns_name]
}