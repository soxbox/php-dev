ock#!/bin/sh

# build dockers
docker buildx build --platform linux/amd64,linux/arm64,linux/arm/v7,linux/arm/v6 -t soxbox/fbm-devs:latest 7.0/