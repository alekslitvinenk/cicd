#!/bin/bash

# Iterate all directories in $APP_INSTALL_PATH/repos
CUR_DIR=$APP_INSTALL_PATH/repos

function buildOnce() {
    REPO="$1"

    cd "$REPO"

    git pull

    ./build.sh

    # Update bages (script yet has to be created)

    # Magic
    echo " "
}

cd "$CUR_DIR"

for entry in $(ls -d */)
do
    # Launch build job in a parallel shell
    buildOnce "$entry" &
done