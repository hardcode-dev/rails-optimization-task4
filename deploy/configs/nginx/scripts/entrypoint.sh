#!/bin/bash

# When we get killed, kill all our children
trap "exit" INT TERM
trap "kill 0"

APP_NAME=${CUSTOM_APP_NAME:="server_app"}
APP_PORT=${CUSTOM_APP_PORT:="3000"}
APP_VHOST=${CUSTOM_APP_VHOST:="dev.railsdev.site"}
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

# Source in util.sh so we can have our nice tools
. $(cd $(dirname $0); pwd)/util.sh

# first include any user configs if they've been mounted
template_user_configs

# Immediately run auto_enable_configs so that nginx is in a runnable state
auto_enable_configs

# Start up nginx, save PID so we can reload config inside of run_certbot.sh
nginx -g "daemon off;" &
export NGINX_PID=$!

# Lastly, run startup scripts
for f in /scripts/startup/*.sh; do
    if [ -x "$f" ]; then
        echo "Running startup script $f"
        $f
    fi
done
echo "Done with startup"

# Instead of trying to run `cron` or something like that, just sleep and run `certbot`.
while [ true ]; do
    echo "Run certbot"
    /scripts/run_certbot.sh

    # Sleep for 1 week
    sleep 604810 &
    SLEEP_PID=$!

    # Wait for 1 week sleep or nginx
    wait -n $SLEEP_PID $NGINX_PID

    # Make sure we do not run container empty (without nginx process).
    # If nginx quit for whatever reason then stop the container.
    # Leave the restart decision to the container orchestration.
    if ! jobs | grep --quiet nginx ; then
        exit 1
    fi
done
