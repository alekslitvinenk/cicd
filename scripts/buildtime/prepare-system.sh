#!/bin/sh

apk add --no-cache git netcat-openbsd nodejs npm bash make python3

cd $APP_INSTALL_PATH/runtime

npm init -y
npm install request
npm install --global xml-js junit-merge

wget https://github.com/dockovpn/reports-converter/archive/v0.1.tar.gz

tar xvfz v0.1.tar.gz

pip3 install -e reports-converter-0.1