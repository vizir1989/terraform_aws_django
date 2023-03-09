[
  {
    "name": "terraform_aws_django",
    "image": "${docker_image_url_django}",
    "essential": true,
    "cpu": 10,
    "memory": 512,
    "links": [],
    "portMappings": [
      {
        "containerPort": 8000,
        "hostPort": 0,
        "protocol": "tcp"
      }
    ],
    "command": ["./scripts/run_server.sh"],
    "environment": [
      {
        "name": "RDS_DB_NAME",
        "value": "${rds_db_name}"
      },
      {
        "name": "RDS_PASSWORD_KMS_ID",
        "value": "${rds_password_kms_id}"
      },
      {
        "name": "AWS_DEFAULT_REGION",
        "value": "${region}"
      },
      {
        "name": "RDS_HOSTNAME",
        "value": "${rds_hostname}"
      },
      {
        "name": "RDS_PORT",
        "value": "5432"
      },
      {
        "name": "ALLOWED_HOSTS",
        "value": "${allowed_hosts}"
      },
      {
        "name": "AWS_STORAGE_BUCKET_NAME",
        "value": "${bucket_name}"
      }
    ],
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-group": "/ecs/django-app-${terraform_workspace}",
        "awslogs-region": "${region}",
        "awslogs-stream-prefix": "django-app-log-stream-${terraform_workspace}"
      }
    }
  },
  {
    "name": "nginx",
    "image": "${docker_image_url_nginx}",
    "essential": true,
    "cpu": 10,
    "memory": 128,
    "links": ["terraform_aws_django"],
    "portMappings": [
      {
        "containerPort": 443,
        "hostPort": 0,
        "protocol": "tcp"
      }
    ],
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-group": "/ecs/nginx-${terraform_workspace}",
        "awslogs-region": "${region}",
        "awslogs-stream-prefix": "nginx-log-stream-${terraform_workspace}"
      }
    }
  }
]