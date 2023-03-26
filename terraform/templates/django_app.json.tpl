[
  {
    "name": "${project_name}_django",
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
        "name": "DJANGO_SECRET_KEY",
        "value": "${django_secret_key}"
      },
      {
        "name": "DJANGO_SUPERUSER_PASSWORD",
        "value": "${django_superuser_password}"
      },
      {
        "name": "DJANGO_SUPERUSER_USERNAME",
        "value": "admin"
      },
      {
        "name": "DJANGO_SUPERUSER_EMAIL",
        "value": "test@test.com"
      },
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
      },
      {
        "name": "REDIS_HOST",
        "value": "${elc_host}"
      },
      {
        "name": "REDIS_PORT",
        "value": "${elc_port}"
      },
      {
        "name": "REDIS_DB",
        "value": "${elc_db}"
      }
    ],
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-group": "/ecs/${project_name}-${terraform_workspace}",
        "awslogs-region": "${region}",
        "awslogs-stream-prefix": "${project_name}-log-stream-${terraform_workspace}"
      }
    }
  },
  {
    "name": "${project_name}_nginx",
    "image": "${docker_image_url_nginx}",
    "essential": true,
    "cpu": 10,
    "memory": 128,
    "links": ["${project_name}_django"],
    "portMappings": [
      {
        "containerPort": 80,
        "hostPort": 0,
        "protocol": "tcp"
      }
    ],
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-group": "/ecs/${project_name}-nginx-${terraform_workspace}",
        "awslogs-region": "${region}",
        "awslogs-stream-prefix": "${project_name}-nginx-log-stream-${terraform_workspace}"
      }
    }
  }
]