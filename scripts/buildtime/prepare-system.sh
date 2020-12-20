#!/bin/sh

apk add --no-cache git netcat-openbsd nodejs npm bash make
cd $APP_INSTALL_PATH/runtime
npm init -y
npm install request
cd $APP_INSTALL_PATH/utils/report-converter
npm init -y
npm install xml-js