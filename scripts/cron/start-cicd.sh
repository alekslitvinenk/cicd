#!/bin/bash

# Iterate all directories in $APP_INSTALL_PATH/repos
REPOS=$APP_INSTALL_PATH/repos
BADGES=$APP_INSTALL_PATH/badges
BUILD_BADGE="$BADGES/build"
BUILT_BADGE="$BADGES/built"

function buildOnce() {
    PROJECT="$1"

    cd "$REPOS/$PROJECT"

    git pull

    ./build.sh

    if [ $? -eq 0 ]; then
        echo "passing" > "$BUILD_BADGE/$PROJECT.txt"
    else
        echo "failing" > "$BUILD_BADGE/$PROJECT.txt"
    fi

    date > "$BUILT_BADGE/$PROJECT.txt"

    # Update bages (script yet has to be created)

    # Magic
    echo " "
}

cd "$REPOS"

for entry in $(ls -d *)
do
    # Launch build job in a parallel shell
    buildOnce "$entry" &
done