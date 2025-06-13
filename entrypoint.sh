#!/bin/bash
set -e

echo "==> Verificando variables de entorno..."
echo "Render DB_HOST: $DB_HOST"
echo "Render DB_PORT: $DB_PORT"
echo "Render DB_USERNAME: $DB_USERNAME"
echo "Render DB_DATABASE: $DB_DATABASE"

if [ ! -f .env ]; then
  echo "==> Copiando .env.example"
  cp .env.example .env
fi

# Reemplazar variables
sed -i "s/DB_HOST=.*/DB_HOST=${DB_HOST}/" .env
sed -i "s/DB_PORT=.*/DB_PORT=${DB_PORT}/" .env
sed -i "s/DB_DATABASE=.*/DB_DATABASE=${DB_DATABASE}/" .env
sed -i "s/DB_USERNAME=.*/DB_USERNAME=${DB_USERNAME}/" .env
sed -i "s/DB_PASSWORD=.*/DB_PASSWORD=${DB_PASSWORD}/" .env

# APP_KEY (muy importante)
if grep -q "^APP_KEY=" .env; then
  sed -i "s|^APP_KEY=.*|APP_KEY=${APP_KEY}|" .env
else
  echo "APP_KEY=${APP_KEY}" >> .env
fi

echo "==> Esperando a que la base de datos esté disponible..."
export PGPASSWORD=$DB_PASSWORD
until pg_isready -h "$DB_HOST" -p "$DB_PORT" -U "$DB_USERNAME"; do
  echo "Esperando la base de datos..."
  sleep 3
done

echo "==> Base de datos disponible. Ejecutando comandos de Laravel..."
php artisan key:generate --force
php artisan migrate:fresh --seed --force

# Limpieza y caché
php artisan config:clear
php artisan route:clear
php artisan view:clear
php artisan config:cache
php artisan route:cache
php artisan view:cache

echo "==> Iniciando servidor PHP embebido..."
exec php -S 0.0.0.0:${PORT:-8000} -t public

