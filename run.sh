#!/bin/bash
docker build --no-cache --pull --rm=true -t salt/syndic .
docker-compose down
docker-compose up -d
