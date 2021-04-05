#!/bin/bash
export REPOS="$APP_INSTALL_PATH/repos"
export BADGES="$APP_INSTALL_PATH/badges"
export REPORTS="$APP_INSTALL_PATH/reports"

export BUILD_BADGE="$BADGES/build"
export BUILT_BADGE="$BADGES/built"
export VERSION_BADGE="$BADGES/version"
export TESTS_BADGE="$BADGES/tests"
# export TESTS_REPORT="$REPORTS/tests"

# Stages badges directories
mkdir -p "$BUILD_BADGE"
mkdir -p "$BUILT_BADGE"
mkdir -p "$VERSION_BADGE"
mkdir -p "$TESTS_BADGE"
mkdir -p "$REPORTS"
# mkdir -p "$TESTS_REPORT"

# Schedule crone job
"$APP_INSTALL_PATH"/cron/start-cicd.sh

# Running Cron daemn as a child makes all the exported paths here available to it 
crond