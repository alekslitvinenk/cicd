#!/bin/bash

BADGES=$APP_INSTALL_PATH/badges
BUILD_BADGE="$BADGES/build"
BUILT_BADGE="$BADGES/built"
VERSION_BADGE="$BADGES/version"
TESTS_BADGE="$BADGES/tests"

# Stages badges directories
mkdir -p "$BUILD_BADGE"
mkdir -p "$BUILT_BADGE"
mkdir -p "$VERSION_BADGE"
mkdir -p "$TESTS_BADGE"

# Schedule crone job
"$APP_INSTALL_PATH"/cron/start-cicd.sh

crond