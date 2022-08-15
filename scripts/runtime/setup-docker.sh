#!/bin/bash

dockerd &

sleep 15

echo "Docker login"
docker login --username $DOCKER_USER --password $DOCKER_PASSWORD

# By some strange reason we need to do echo command to get to the next command
echo " "