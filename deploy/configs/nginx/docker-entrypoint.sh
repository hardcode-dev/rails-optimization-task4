#!/usr/bin/env bash

set -e

APP_NAME=${CUSTOM_APP_NAME:="server_app"}
APP_PORT=${CUSTOM_APP_PORT:="3000"}
APP_VHOST=${CUSTOM_APP_VHOST:="dev.lvh.me"}
#APP_VHOST=${CUSTOM_APP_VHOST:="$(curl http://13.239.133.150/latest/meta-data/public-hostname))"}

for f in "/etc/nginx/sites-enabled/*.conf"
do
  echo "Processing $f file conf.d"
  sed -i "s+APP_NAME+${APP_NAME}+g"       $f
  sed -i "s+APP_PORT+${APP_PORT}+g"       $f
  sed -i "s+APP_VHOST+${APP_VHOST}+g"     $f
  sed -i "s+STATIC_PATH+${STATIC_PATH}+g" $f
done

for f in "/etc/nginx/snippets/*.conf"
do
  echo "Processing $f file snippets"
  sed -i "s+APP_NAME+${APP_NAME}+g"         $f
  sed -i "s+APP_PORT+${APP_PORT}+g"         $f
  sed -i "s+APP_VHOST+${APP_VHOST}+g"       $f
  sed -i "s+STATIC_PATH+${STATIC_PATH}+g"   $f
done


exec "$@"
