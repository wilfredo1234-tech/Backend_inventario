FROM php:8.2-fpm

# Instalación de dependencias necesarias
RUN apt-get update && apt-get install -y \
    git \
    curl \
    zip \
    unzip \
    libpq-dev \
    libzip-dev \
    libonig-dev \
    && docker-php-ext-install pdo pdo_pgsql mbstring zip

# Instalar Composer desde otra imagen
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Establecer el directorio de trabajo
WORKDIR /var/www

# Copiar todos los archivos del proyecto
COPY . .

# Instalar dependencias
RUN composer install --no-dev --optimize-autoloader

# Asignar permisos
RUN chmod -R 775 storage bootstrap/cache && \
    chown -R www-data:www-data .

# Copiar el entrypoint personalizado
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh && dos2unix /entrypoint.sh



# Exponer el puerto
EXPOSE 8000

# Usar el script como punto de entrada
ENTRYPOINT ["/entrypoint.sh"]
