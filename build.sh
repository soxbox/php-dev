#!/bin/sh

# build dockers
docker buildx use fbm
docker buildx build --platform linux/amd64,linux/arm64 -t soxbox/php-dev:latest --push 7.0/