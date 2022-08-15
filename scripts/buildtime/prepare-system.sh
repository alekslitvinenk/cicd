#!/bin/sh

apk add --no-cache git iptables netcat-openbsd nodejs npm bash make python3

cd $APP_INSTALL_PATH/runtime

npm init -y
npm install request pug
npm install --global xml-js junit-merge

# Example: https://github.com/dockovpn/reports-converter/archive/v0.2.tar.gz
wget "https://github.com/dockovpn/reports-converter/archive/v$REPORT_CONVERTER_VERSION.tar.gz"

tar xvfz "v$REPORT_CONVERTER_VERSION.tar.gz"

pip3 install -e "reports-converter-$REPORT_CONVERTER_VERSION"