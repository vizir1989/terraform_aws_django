data "aws_route53_zone" "product" {
  name = var.hosted_zone
}

resource "aws_route53_record" "django" {
  zone_id = data.aws_route53_zone.product.zone_id
  name    = "${var.subdomain}.${var.hosted_zone}"
  type    = "CNAME"
  ttl     = 300
  records = [aws_lb.production.dns_name]
}