output "alb_hostname" {
  value = aws_lb.production.dns_name
}

output "hostname" {
  value = "https://${aws_route53_record.django.name}/admin"
}

output "django_superuser_password" {
  value = random_password.django_superuser_password.result
}