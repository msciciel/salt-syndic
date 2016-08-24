#!/bin/bash
docker build -t salt/syndic .
docker-compose down
docker-compose up -d
