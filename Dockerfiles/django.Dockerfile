FROM python:3.10.0-slim-buster

ARG POETRY_VERSION=1.4.0

ENV C_FORCE_ROOT=True
ENV PYTHONUNBUFFERED=1
ENV PYTHONPATH=/code
ENV XDG_CACHE_HOME=/code

WORKDIR /code

RUN chgrp -R 0 /var/log && \
    chmod -R g=u /var/log && \
    python -m pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir poetry==${POETRY_VERSION}

# install psycopg2 dependencies
RUN apt-get update \
  && apt-get -y install gcc postgresql \
  && apt-get clean

COPY ./app/pyproject.toml ./app/poetry.lock /code/

RUN poetry config virtualenvs.create false \
    && poetry install --no-interaction --no-ansi \
    && mkdir -p /var/log && chown -R 1777 /var/log

COPY ./app /code

RUN python manage.py collectstatic --no-input
# ENTRYPOINT bash -c "while :; do echo 'Hit CTRL+C'; sleep 1; done"
# ENTRYPOINT bash -c "gunicorn terraform_aws_django.wsgi:application --bind 0.0.0.0:8000"
