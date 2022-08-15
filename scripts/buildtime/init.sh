#!/bin/sh

CUR_DIR=$APP_INSTALL_PATH/buildtime

$CUR_DIR/prepare-system.sh

if [[ $START_CRON == true ]]; then
    $CUR_DIR/prepare-cron.sh
fi

$CUR_DIR/prepare-runtime.sh