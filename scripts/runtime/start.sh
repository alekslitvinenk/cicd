#!/bin/bash

CUR_DIR=$APP_INSTALL_PATH/runtime

"$CUR_DIR"/setup-docker.sh
"$CUR_DIR"/setup-cicd.sh

cd "$CUR_DIR" || exit

npm start "$APP_INSTALL_PATH/badges" "$APP_INSTALL_PATH/sslfiles"
# exec bash