FROM php:8.4-fpm-alpine

# Install system dependencies
RUN apk add --no-cache \
    git unzip zip curl \
    libpng-dev oniguruma-dev libxml2-dev postgresql-dev icu-dev \
    freetype-dev libjpeg-turbo-dev libwebp-dev gettext inotify-tools \
    $PHPIZE_DEPS

# Configure GD
RUN docker-php-ext-configure gd \
    --with-freetype \
    --with-jpeg \
    --with-webp

# Install PHP extensions
RUN docker-php-ext-install \
    pdo pdo_pgsql mbstring exif pcntl bcmath gd opcache

# Redis extension
RUN pecl install redis \
    && docker-php-ext-enable redis

# Remove build dependencies
RUN apk del $PHPIZE_DEPS

# Copy custom PHP configs
COPY conf.d/ /usr/local/etc/php/conf.d/

WORKDIR /var/www

# Composer
COPY --from=composer:2.9.5 /usr/bin/composer /usr/bin/composer

# Entrypoint

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

CMD ["php-fpm"]
