#!/bin/sh

set -e
set -x

pytest \
    --cov . \
    --cov-report xml \
    --no-cov-on-fail \
    .

coverage report --skip-covered --show-missing
