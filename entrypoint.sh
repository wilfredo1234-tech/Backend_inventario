#!/bin/bash

# Salir si algo falla
set -e

# Mostrar variables de entorno (debug)
echo "==> Verificando variables de entorno..."
echo "Render DB_HOST: $DB_HOST"
echo "Render DB_PORT: $DB_PORT"
echo "Render DB_USERNAME: $DB_USERNAME"
echo "Render DB_DATABASE: $DB_DATABASE"

# Copiar .env si no existe
if [ ! -f .env ]; then
  echo "==> Copiando .env.example"
  cp .env.example .env

  # Reemplazar variables en .env usando valores de entorno de Render
  sed -i "s/DB_HOST=.*/DB_HOST=${DB_HOST}/" .env
  sed -i "s/DB_PORT=.*/DB_PORT=${DB_PORT}/" .env
  sed -i "s/DB_DATABASE=.*/DB_DATABASE=${DB_DATABASE}/" .env
  sed -i "s/DB_USERNAME=.*/DB_USERNAME=${DB_USERNAME}/" .env
  sed -i "s/DB_PASSWORD=.*/DB_PASSWORD=${DB_PASSWORD}/" .env
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

echo "==> Iniciando servidor Laravel..."
exec php artisan serve --host=0.0.0.0 --port=8000
