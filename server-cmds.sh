#!/bin/bash
echo "IMAGE=$1" > .env
export IMAGE=$1
docker-compose -f docker-compose.yaml up -d
echo "success"