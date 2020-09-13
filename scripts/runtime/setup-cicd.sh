#!/bin/bash

BADGES="$APP_INSTALL_PATH/badges"
REPORTS="$APP_INSTALL_PATH/reports"

BUILD_BADGE="$BADGES/build"
BUILT_BADGE="$BADGES/built"
VERSION_BADGE="$BADGES/version"
TESTS_BADGE="$BADGES/tests"
TESTS_REPORT="$REPORTS/tests"

# Stages badges directories
mkdir -p "$BUILD_BADGE"
mkdir -p "$BUILT_BADGE"
mkdir -p "$VERSION_BADGE"
mkdir -p "$TESTS_BADGE"
mkdir -p "$TESTS_REPORT"

# Schedule crone job
"$APP_INSTALL_PATH"/cron/start-cicd.sh

crond