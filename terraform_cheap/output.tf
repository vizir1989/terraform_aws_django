output "alb_hostname" {
  value = aws_lb.production.dns_name
}

output "hostname" {
  value = "https://${aws_route53_record.django.name}/admin"
}