#!/bin/bash

CUR_DIR=$APP_INSTALL_PATH/repos

mkdir -p "$CUR_DIR"
cd "$CUR_DIR"

git clone https://github.com/alekslitvinenk/docker-openvpn.git