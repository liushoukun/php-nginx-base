#!/bin/bash


# Start crond in background
crond -l 2 -b

# Start supervisord
/usr/bin/supervisord -n -c /etc/supervisord.conf