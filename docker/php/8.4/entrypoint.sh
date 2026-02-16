#!/bin/bash
set -e
# 1. FORCE create directories (This fixes the "Invalid Cache Path")
echo "→ Ensuring storage structure exists..."
mkdir -p /var/www/storage/framework/cache/data \
         /var/www/storage/framework/sessions \
         /var/www/storage/framework/views \
         /var/www/storage/logs \
         /var/www/bootstrap/cache
         
# Create .env if missing
if [ "$APP_ENV" = "local" ] || [ "$APP_ENV" = "testing" ]; then
    if [ ! -f ".env" ]; then
        echo "→ Creating .env from example (local/testing only)"
        cp .env.example .env
        php artisan key:generate --ansi --no-interaction
    fi
fi

# Permissions
echo "→ Fixing storage & cache permissions..."
chown -R www-data:www-data /var/www/storage /var/www/bootstrap/cache
find /var/www/storage /var/www/bootstrap/cache -type d -exec chmod 775 {} \;
find /var/www/storage /var/www/bootstrap/cache -type f -exec chmod 664 {} \;
if [ "$APP_ENV" = "production" ] || [ "$APP_ENV" = "staging" ]; then
    echo "→ Caching configuration for faster startup..."
    php artisan config:cache --no-interaction || true
    php artisan route:cache  --no-interaction || true
fi
if [ "$APP_ENV" != "production" ]; then
    echo "→ Running migrations (non-production)..."
    php artisan migrate --force --no-interaction || true
fi

echo "→ Starting PHP-FPM..."
exec "$@"