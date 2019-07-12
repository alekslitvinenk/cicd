#!/bin/bash

REPOS=$APP_INSTALL_PATH/repos
BADGES=$APP_INSTALL_PATH/badges
BUILD_BADGE="$BADGES/build"
BUILT_BADGE="$BADGES/built"

# Stages bades directories

# 1. Build
mkdir -p "$BUILD_BADGE"

# 1. Build
mkdir -p "$BUILT_BADGE"

# Schedule crone job
$APP_INSTALL_PATH/cron/start-cicd.sh

crond