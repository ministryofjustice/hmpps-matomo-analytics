#!/bin/sh
set -e

# Function to handle shutdown
shutdown() {
    echo "Shutting down gracefully..."
    kill -TERM "$php_fpm_pid" 2>/dev/null || true
    kill -TERM "$nginx_pid" 2>/dev/null || true
    wait "$php_fpm_pid" "$nginx_pid"
    exit 0
}

# Trap SIGTERM and SIGINT
trap shutdown TERM INT

# Start PHP-FPM in the background
php-fpm -F &
php_fpm_pid=$!

# Start nginx in the background
nginx -g "daemon off;" &
nginx_pid=$!

# Wait for any process to exit
wait -n

# Exit with status of process that exited first
exit $?
