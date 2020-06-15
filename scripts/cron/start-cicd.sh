#!/bin/bash

# Iterate all directories in $APP_INSTALL_PATH/repos
REPOS=$APP_INSTALL_PATH/repos
BADGES=$APP_INSTALL_PATH/badges
BUILD_BADGE="$BADGES/build"
BUILT_BADGE="$BADGES/built"
VERSION_BADGE="$BADGES/version"
MAKE_FILE="Makefile"
BUILD_FILE="build.sh"

function buildOnce() {
    PROJECT="$1"

    cd "$REPOS/$PROJECT" || exit

    git pull
    git checkout releases

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

    # Update bages (script yet has to be created)

    # Magic
    echo " "
}

cd "$REPOS" || exit

for entry in $(ls -d *)
do
    # Launch build job in a parallel shell
    buildOnce "$entry" &
done