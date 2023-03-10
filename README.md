## About

This is a template for creating Django + NGINX application and automatically deploying on AWS.

Stack: Python 3.10, Django 4.1, NGINX, PostgreSQL 15, AWS, Docker, Terraform, GitAction, poetry.

## Architecture
<p align="center">
  <img alt="aws_architecture" src="https://github.com/vizir1989/terraform_aws_django/blob/feature/doc/aws-architecture.png" />
  <p align="center">AWS Architecture.</p>
</p>


[//]: # (Based on [deploying-django-to-ecs-with-terraform]&#40;https://testdriven.io/blog/deploying-django-to-ecs-with-terraform&#41;)

[//]: # ()
[//]: # (S3 static file based on this [article]&#40;https://medium.com/the-geospatials/serve-django-static-files-on-aws-s3-part-1-da41b05f3a79&#41;)

[//]: # ()
[//]: # (TODO: )

[//]: # (1. added AWS Secret Manager with rotation for [DB1]&#40;https://stackoverflow.com/questions/60879366/django-aws-secret-manager-password-rotation&#41; [DB2]&#40;https://blog.gruntwork.io/a-comprehensive-guide-to-managing-secrets-in-your-terraform-code-1d586955ace1&#41; +)

[//]: # (2. added certificate &#40;433 port&#41; &#40;[see]&#40;https://testdriven.io/blog/deploying-django-to-ecs-with-terraform/#domain-and-ssl-certificate&#41;&#41; +)

[//]: # (3. added github ci/cd +)

[//]: # (4. added different branch - different sites)

[//]: # (5. added AWS Secret Manager for saving Django [security key]&#40;https://www.prplbx.com/resources/blog/django-part2/&#41; +)

[//]: # (6. added s3 as backend for terraform +)

[//]: # (7. on prod use rds cluster instead of rds instance)