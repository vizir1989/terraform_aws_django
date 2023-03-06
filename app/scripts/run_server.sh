#!/bin/bash

python manage.py collectstatics --noinput
gunicorn -w 3 -b :8000 terraform_aws_django.wsgi:application
