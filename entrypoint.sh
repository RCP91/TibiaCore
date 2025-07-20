#!/bin/bash
set -e

# Create system directories if missing
mkdir -p /var/www/html/system/cache
mkdir -p /var/www/html/system/php_sessions

chmod -R 777 /var/www/
chmod -R 770 /var/www/html/system

# Run Apache in foreground
exec apache2-foreground
