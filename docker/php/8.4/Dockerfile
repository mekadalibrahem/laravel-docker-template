#-----------------------------
# Stage 1: composer dependencies
FROM composer:2.8 AS vendor 
WORKDIR /app
COPY composer.json composer.lock ./
RUN composer install \
    --no-interaction \
    --no-dev \
    --prefer-dist \
    --optimize-autoloader \
    --no-scripts \
    --no-progress
#-----------------------------
# Stage 2 (Last stage): prodcution image 
FROM php:8.4-fpm AS php

# Install system dependencies + extensions
RUN apt-get update && apt-get install -y \
    unzip \
    libpq-dev \
    libcurl4-gnutls-dev \
    && rm -rf /var/lib/apt/lists/*
RUN docker-php-ext-install pdo pdo_pgsql

RUN pecl install -o -f redis \
    && rm -rf /tmp/pear \
    && docker-php-ext-enable redis

COPY docker/php/8.4/php.ini $PHP_INI_DIR/conf.d/custom.ini
WORKDIR /var/www
COPY --from=vendor /app/vendor ./vendor
COPY --from=vendor /app/composer.* ./
COPY . .


COPY docker/php/8.4/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["php-fpm"]