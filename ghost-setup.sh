#!/bin/bash

ghost_setup() {
    chown node:node /var/www/ghost
    chmod 775 /var/www/ghost
    gosu node ghost install --production --db sqlite3 --no-prompt --no-stack --no-setup --dir /var/www/ghost
    cd /var/www/ghost
    gosu node ghost config --ip 0.0.0.0 --port $GHOST_PORT --no-prompt --db sqlite3 --url $GHOST_URL --admin-url $GHOST_ADMIN_URL --dbpath /var/www/ghost/content/data/ghost.db
    gosu node ghost config paths.contentPath /var/www/ghost/content

    gosu node npm cache clean --force
    npm cache clean --force
    rm -rv /tmp/yarn* /tmp/v8*
}

if [ ! -f /init/ghost ]; then
    ghost_setup
    touch /init/ghost
else
    sleep 2
fi
