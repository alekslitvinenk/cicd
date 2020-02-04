#!/bin/bash

BADGES=$APP_INSTALL_PATH/badges
BUILD_BADGE="$BADGES/build"
BUILT_BADGE="$BADGES/built"
VERSION_BADGE="$BADGES/version"

# Stages bades directories
mkdir -p "$BUILD_BADGE"
mkdir -p "$BUILT_BADGE"
mkdir -p "$VERSION_BADGE"

# Schedule crone job
"$APP_INSTALL_PATH"/cron/start-cicd.sh

crond