#!/bin/bash

CRON_CFG="$APP_INSTALL_PATH/crontab"

cat $CRON_CFG > /var/spool/cron/crontabs/root