#!/bin/bash

# Iterate all directories in $APP_INSTALL_PATH/repos
REPOS=$APP_INSTALL_PATH/repos
BADGES=$APP_INSTALL_PATH/badges
BUILD_BADGE="$BADGES/build"
BUILT_BADGE="$BADGES/built"
VERSION_BADGE="$BADGES/version"
MAKE_FILE="Makefile"
BUILD_FILE="build.sh"

function processOnce() {
    PROJECT="$1"

    cd "$REPOS/$PROJECT" || exit

    git pull
    git checkout releases

    buildOnce && \
    testOnce && \
    deployOnce

    # Magic
    echo " "
}

function buildOnce() {
    RES=0

    if [ -f "$MAKE_FILE" ]; then
        make
        RES="$?"
    elif [ -f "$BUILD_FILE" ]; then
        ./build.sh
        RES="$?"
    else
        RES=1
    fi

    if [ $RES -eq 0 ]; then
        echo "passing" > "$BUILD_BADGE/$PROJECT.txt"
    else
        echo "failing" > "$BUILD_BADGE/$PROJECT.txt"
    fi

    date > "$BUILT_BADGE/$PROJECT.txt"
    cat ./VERSION > "$VERSION_BADGE/$PROJECT.txt"
}

function testOnce() {
    if [ -f "$MAKE_FILE" ]; then
        make test
        RES="$?"
    fi
}

function deployOnce() {
    if [ -f "$MAKE_FILE" ]; then
        make deploy
        RES="$?"
    fi
}

cd "$REPOS" || exit

for entry in $(ls -d *)
do
    # Launch build job in a parallel shell
    processOnce "$entry" &
done