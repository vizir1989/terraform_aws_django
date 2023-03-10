## About

This is a template for creating Django + NGINX application and automatically deploying on AWS.

Stack: Python 3.10, Django 4.1, NGINX, PostgreSQL 15, AWS, Docker, Terraform, GitAction, pytest, poetry, black, flake8.

## Architecture
<p align="center">
  <img alt="aws_architecture" src="https://github.com/vizir1989/terraform_aws_django/blob/main/aws-architecture.png" />
  <p align="center">AWS Architecture.</p>
</p>


## AWS
- [EC2](https://aws.amazon.com/ec2/)
- [S3](https://aws.amazon.com/s3/)
- [VPC](https://aws.amazon.com/vpc/)
- [ALB](https://aws.amazon.com/elasticloadbalancing/)
- [IAM](https://aws.amazon.com/iam/)
- [CloudWatch](https://aws.amazon.com/cloudwatch/)
- [Secrets Manager](https://aws.amazon.com/secrets-manager/)
- [ECS](https://aws.amazon.com/ecs/)
- [Autoscaling](https://aws.amazon.com/ec2/autoscaling/)
- [RDS](https://aws.amazon.com/rds/)
- [Route 53](https://aws.amazon.com/route53/)

## Backend
- [NGINX](https://www.nginx.com/)
- [Django 4.1](https://www.djangoproject.com/)

## CI/CD
- [Terraform](https://www.terraform.io/)
- [GitAction](https://github.com/features/actions)


## Secrets and Variables

### Secrets
- AWS_ACCOUNT_ID
- AWS_ACCESS_KEY_ID
- AWS_SECRET_ACCESS_KEY
- AWS_CERTIFICATE_ARN (need for aws alb)
- AWS_PUB_KEY (generate by command `aws ecr get-login-password --region <region>`. Need for AWS KeyPair)
- TOKEN (need for GitAction)

# Variables
- AWS_DEFAULT_REGION
- AWS_SECRET_ID (name for secrets in AWS Secrets Manager)
- DELETION_DELAY (delay before delete infrastructure on AWS)
- HOSTED_ZONE
- PROJECT_NAME (only alphabets symbols)

# Preparation of AWS
1. Create repo in ECR with name \$\{\{ PROJECT_NAME \}\}_django and \$\{\{ PROJECT_NAME \}\}_nginx

# Reference
1. [Deploying Django to AWS ECS with Terraform](https://testdriven.io/blog/deploying-django-to-ecs-with-terraform/)
2. Serve Django Static & Media files on AWS S3 [1](https://medium.com/the-geospatials/serve-django-static-files-on-aws-s3-part-1-da41b05f3a79) [2](https://medium.com/the-geospatials/serve-django-static-media-files-on-aws-s3-part-2-d0e8578dd2db)
3. AWS Secret Manager with Rotation [1](https://blog.gruntwork.io/a-comprehensive-guide-to-managing-secrets-in-your-terraform-code-1d586955ace1) [2](https://stackoverflow.com/questions/60879366/django-aws-secret-manager-password-rotation)
4. Ultimate Guide to Securely Deploy Django at Scale on AWS ECS [2](https://www.prplbx.com/resources/blog/django-part2/) [3](https://www.prplbx.com/resources/blog/django-part3/)
5. [How to Manage Terraform S3 Backend – Best Practices](https://spacelift.io/blog/terraform-s3-backend)
6. [Automate Terraform with GitHub Actions](https://developer.hashicorp.com/terraform/tutorials/automation/github-actions)
7. [Become an AWS and Terraform Expert](https://www.educative.io/path/become-an-aws-and-terraform-expert)
8. [What are Terraform Workspaces? Overview with Examples](https://spacelift.io/blog/terraform-workspaces)
9. [Docker. Multi-stage builds](https://docs.docker.com/build/building/multi-stage/)
10. [Gitflow Workflow](https://www.atlassian.com/git/tutorials/comparing-workflows/gitflow-workflow)