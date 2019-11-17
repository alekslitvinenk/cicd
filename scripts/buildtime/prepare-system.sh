#!/bin/sh

apk add --no-cache git netcat-openbsd nodejs npm bash
cd $APP_INSTALL_PATH/runtime
npm init -y
npm install request