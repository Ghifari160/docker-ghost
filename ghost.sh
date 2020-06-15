#!/bin/bash

while : ; do
    [[ -f "/init/ghost" ]] && break
    echo "Waiting for Ghost installation."
    sleep 30
done

cd /var/www/ghost
gosu node node /var/www/ghost/current/index.js