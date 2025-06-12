
FROM php:8.2-fpm


RUN apt-get update && apt-get install -y \
    git \
    curl \
    zip \
    unzip \
    libpq-dev \
    libzip-dev \
    libonig-dev \
    && docker-php-ext-install pdo pdo_pgsql mbstring zip


COPY --from=composer:2 /usr/bin/composer /usr/bin/composer


WORKDIR /var/www


COPY . .


RUN composer install --no-dev --optimize-autoloader


RUN cp .env.example .env && \
    php artisan key:generate && \
    php artisan migrate --force


RUN chmod -R 775 storage bootstrap/cache && \
    chown -R www-data:www-data .


EXPOSE 8000


CMD php artisan serve --host=0.0.0.0 --port=8000
