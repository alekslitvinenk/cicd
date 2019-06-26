#!/bin/bash

CUR_DIR=$APP_INSTALL_PATH/runtime

$CUR_DIR/setup-docker.sh
$CUR_DIR/setup-cicd.sh

exec bash