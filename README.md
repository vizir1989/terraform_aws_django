Based on [deploying-django-to-ecs-with-terraform](https://testdriven.io/blog/deploying-django-to-ecs-with-terraform)

S3 static file based on this [article](https://medium.com/the-geospatials/serve-django-static-files-on-aws-s3-part-1-da41b05f3a79)

TODO: 
1. added AWS Secret Manager with rotation for [DB](https://stackoverflow.com/questions/60879366/django-aws-secret-manager-password-rotation)
2. added certificate (433 port) ([see](https://testdriven.io/blog/deploying-django-to-ecs-with-terraform/#domain-and-ssl-certificate))
3. added github ci/cd
4. added different branch - different sites