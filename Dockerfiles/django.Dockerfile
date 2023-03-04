FROM python:3.10-slim as base

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

COPY ./app/pyproject.toml ./app/poetry.lock /code/

RUN poetry config virtualenvs.create false \
    && poetry install --no-interaction --no-ansi \
    && mkdir -p /var/log && chown -R 1777 /var/log

COPY ./app /code
ENTRYPOINT bash -c "gunicorn terraform_aws_django.wsgi:application --bind 0.0.0.0:8000"
