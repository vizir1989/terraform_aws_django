FROM python:3.10.0-slim-buster as base

ARG POETRY_VERSION=1.4.0

ENV C_FORCE_ROOT=True
ENV PYTHONUNBUFFERED=1
ENV PYTHONPATH=/usr/src/app
ENV XDG_CACHE_HOME=/usr/src/app

WORKDIR /usr/src/app

RUN chgrp -R 0 /var/log && \
    chmod -R g=u /var/log && \
    python -m pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir poetry==${POETRY_VERSION}

# install psycopg2 dependencies
RUN apt-get update \
  && apt-get -y install gcc postgresql \
  && apt-get clean

COPY ./app/pyproject.toml ./app/poetry.lock /usr/src/app/

RUN poetry config virtualenvs.create false \
    && poetry install --no-interaction --no-ansi --without dev \
    && mkdir -p /var/log && chown -R 1777 /var/log

COPY ./app /usr/src/app
COPY ./README.md /usr/src/app

RUN chmod +x ./scripts/run_server.sh

FROM base as test
RUN poetry config virtualenvs.create false \
    && poetry install --no-interaction --no-ansi
RUN chmod +x ./scripts/test.sh
RUN ./scripts/test.sh

FROM base as lint
RUN poetry config virtualenvs.create false \
    && poetry install --no-interaction --no-ansi
RUN chmod +x ./scripts/lint.sh
RUN ./scripts/lint.sh

FROM base as dist-image
CMD ./scripts/run_server.sh