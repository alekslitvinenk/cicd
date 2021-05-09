#!/bin/bash

docker image prune --all --force
docker container prune --force
echo "Cleaning up generated docker images at $(date)" >> $APP_INSTALL_PATH/cleanup_log.txt