#!/bin/sh
set -e

# Fix Laravel permissions
chown -R www-data:www-data /var/www/storage /var/www/bootstrap/cache
chmod -R 775 /var/www/storage /var/www/bootstrap/cache

# Install composer dependencies if missing
if [ ! -d "/var/www/vendor" ]; then
    composer install --no-interaction --prefer-dist --optimize-autoloader
fi

# Replace ENV variables in opcache.ini
if [ -f /usr/local/etc/php/conf.d/opcache.ini ]; then
    envsubst < /usr/local/etc/php/conf.d/opcache.ini > /usr/local/etc/php/conf.d/opcache.tmp
    mv /usr/local/etc/php/conf.d/opcache.tmp /usr/local/etc/php/conf.d/opcache.ini
fi

# Execute container CMD
exec "$@"
