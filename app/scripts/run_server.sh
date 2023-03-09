#!/bin/bash

python manage.py collectstatic --noinput
python manage.py createsuperuser --no-input
gunicorn -w 3 -b :8000 terraform_aws_django.wsgi:application
