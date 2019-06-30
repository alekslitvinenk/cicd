#!/bin/sh

CUR_DIR=$APP_INSTALL_PATH/buildtime

$CUR_DIR/prepare-system.sh
$CUR_DIR/prepare-cron.sh
$CUR_DIR/prepare-runtime.sh