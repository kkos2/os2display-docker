#!/bin/sh
# Run the search_node app as the app user.
exec /sbin/setuser app node /home/app/search_node/app.js
