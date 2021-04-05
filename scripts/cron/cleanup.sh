#!/bin/bash

docker image prune --all --force
echo "Cleaning up generated docker images at $(date)" >> $APP_INSTALL_PATH/cleanup_log.txt