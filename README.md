Based on [deploying-django-to-ecs-with-terraform](https://testdriven.io/blog/deploying-django-to-ecs-with-terraform)

S3 static file based on this [article](https://medium.com/the-geospatials/serve-django-static-files-on-aws-s3-part-1-da41b05f3a79)

TODO: 
1. added AWS Secret Manager with rotation for [DB1](https://stackoverflow.com/questions/60879366/django-aws-secret-manager-password-rotation) [DB2](https://blog.gruntwork.io/a-comprehensive-guide-to-managing-secrets-in-your-terraform-code-1d586955ace1) +
2. added certificate (433 port) ([see](https://testdriven.io/blog/deploying-django-to-ecs-with-terraform/#domain-and-ssl-certificate)) +
3. added github ci/cd +
4. added different branch - different sites
5. added AWS Secret Manager for saving Django [security key](https://www.prplbx.com/resources/blog/django-part2/) +
6. added s3 as backend for terraform +
7. on prod use rds cluster instead of rds instance