#!/bin/bash

# Salir si algo falla
set -e

# Mostrar variables (debug)
echo "==> Verificando variables de entorno..."
echo "DB_HOST: $DB_HOST"
echo "DB_PORT: $DB_PORT"
echo "DB_USERNAME: $DB_USERNAME"
echo "DB_DATABASE: $DB_DATABASE"

# Si Render no exporta las variables, cargarlas desde el .env
if [ -f .env ]; then
  echo "==> Cargando variables desde .env"
  export $(grep -v '^#' .env | xargs)
fi

# Copiar .env si no existe (primera vez)
if [ ! -f .env ]; then
  echo "==> Copiando .env.example"
  cp .env.example .env
fi

echo "==> Esperando a que la base de datos esté disponible..."

# Usar pg_isready para esperar la base de datos PostgreSQL
export PGPASSWORD=$DB_PASSWORD

until pg_isready -h "$DB_HOST" -p "$DB_PORT" -U "$DB_USERNAME"; do
  echo "Esperando la base de datos..."
  sleep 3
done

echo "==> Base de datos disponible. Ejecutando comandos de Laravel..."

# Generar la clave de aplicación
php artisan key:generate --force

# Limpiar caché si es necesario
php artisan config:clear
php artisan cache:clear

# Migrar base de datos y ejecutar seed
php artisan migrate:fresh --seed --force

# Iniciar servidor en puerto 8000
echo "==> Iniciando servidor Laravel en puerto 8000"
exec php artisan serve --host=0.0.0.0 --port=8000
