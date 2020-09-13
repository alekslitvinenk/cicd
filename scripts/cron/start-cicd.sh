#!/bin/bash

# Iterate all directories in $APP_INSTALL_PATH/repos
REPOS=$APP_INSTALL_PATH/repos

BADGES=$APP_INSTALL_PATH/badges
BUILD_BADGE="$BADGES/build"
BUILT_BADGE="$BADGES/built"
VERSION_BADGE="$BADGES/version"
TESTS_BADGE="$BADGES/tests"

TESTS_REPORT=""

MAKE_FILE="Makefile"
BUILD_FILE="build.sh"
VERSION_FILE="VERSION"

function processOnce() {
    PROJECT="$1"

    cd "$REPOS/$PROJECT" || exit

    git pull
    git checkout releases || echo "Could not check out release branch."

    buildOnce && \
    testOnce

    # Magic
    echo " "
}

function buildOnce() {
    local BUILD_RES=0

    if [ -f "$MAKE_FILE" ]; then
        make
        REBUILD_RESS="$?"
    elif [ -f "$BUILD_FILE" ]; then
        ./build.sh
        BUILD_RES="$?"
    else
        BUILD_RES=1
    fi

    if [ $BUILD_RES -eq 0 ]; then
        echo "passing" > "$BUILD_BADGE/$PROJECT.txt"
    else
        echo "failing" > "$BUILD_BADGE/$PROJECT.txt"
    fi

    date > "$BUILT_BADGE/$PROJECT.txt"

    if [ -f "$VERSION_FILE" ]; then
        cat "$VERSION_FILE" > "$VERSION_BADGE/$PROJECT.txt"
    fi
}

function testOnce() {
    local TEST_RES=0

    if [ -f "$MAKE_FILE" ]; then
        make test
        TEST_RES="$?"
    fi

    if [ $TEST_RES -eq 0 ]; then
        # Tests status should be read straight from tests report
        # It's tests executor responsibility to generate tests report and put it into reports/tests folder
        local status="passing"
        echo "$status" > "$TESTS_BADGE/$PROJECT.txt"
    else
        echo "not found" > "$TESTS_BADGE/$PROJECT.txt"
    fi
}

cd "$REPOS" || exit

for entry in $(ls -d *)
do
    # Launch build job in a parallel shell
    processOnce "$entry" &
done