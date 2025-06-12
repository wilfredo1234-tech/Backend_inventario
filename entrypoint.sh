#!/bin/bash

# Salir si algo falla
set -e

# Copiar .env si no existe
if [ ! -f .env ]; then
  cp .env.example .env
fi

echo "Esperando a que la base de datos esté disponible..."

# Usa pg_isready con contraseña
export PGPASSWORD=$DB_PASSWORD

until pg_isready -h "$DB_HOST" -p "$DB_PORT" -U "$DB_USERNAME"; do
  echo "Esperando la base de datos..."
  sleep 2
done

echo "Base de datos disponible. Ejecutando migraciones..."

# Generar clave y migraciones con seed y --force
php artisan key:generate --force
php artisan migrate:fresh --seed --force

# Ejecutar Laravel en puerto 8000
exec php artisan serve --host=0.0.0.0 --port=8000
