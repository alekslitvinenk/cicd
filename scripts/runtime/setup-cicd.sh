#!/bin/bash

REPOS=$APP_INSTALL_PATH/repos
BADGES=$APP_INSTALL_PATH/badges
BUILD_BADGE="$BADGES/build"

# Stages bades directories

# 1. Build
mkdir -p "$BUILD_BADGE"

# Schedule crone job
$APP_INSTALL_PATH/cron/start-cicd.sh

crond