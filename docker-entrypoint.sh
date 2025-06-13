#!/bin/bash
set -e

echo "==> Configurando .env"
# Si no existe .env, copia ejemplo
cp .env.example .env 2>/dev/null || true

# Reemplazar variables de entorno de Railway / Docker en .env
# DB_*
if [ -n "$DB_HOST" ]; then
  sed -i "s|DB_HOST=.*|DB_HOST=${DB_HOST}|" .env
fi
if [ -n "$DB_PORT" ]; then
  sed -i "s|DB_PORT=.*|DB_PORT=${DB_PORT}|" .env
fi
if [ -n "$DB_DATABASE" ]; then
  sed -i "s|DB_DATABASE=.*|DB_DATABASE=${DB_DATABASE}|" .env
fi
if [ -n "$DB_USERNAME" ]; then
  sed -i "s|DB_USERNAME=.*|DB_USERNAME=${DB_USERNAME}|" .env
fi
if [ -n "$DB_PASSWORD" ]; then
  sed -i "s|DB_PASSWORD=.*|DB_PASSWORD=${DB_PASSWORD}|" .env
fi

# APP_KEY
if [ -z "${APP_KEY:-}" ]; then
  # Si no se pasó APP_KEY en env, Laravel lo generará:
  echo "APP_KEY no proporcionada, generando nueva"
  php artisan key:generate --force
else
  # Reemplazar o agregar APP_KEY
  if grep -q "^APP_KEY=" .env; then
    sed -i "s|^APP_KEY=.*|APP_KEY=${APP_KEY}|" .env
  else
    echo "APP_KEY=${APP_KEY}" >> .env
  fi
fi

echo "==> Esperando a que la base de datos esté disponible..."
# Espera a PostgreSQL con pg_isready (postgresql-client ya instalado)
export PGPASSWORD=$DB_PASSWORD
until pg_isready -h "$DB_HOST" -p "${DB_PORT:-5432}" -U "$DB_USERNAME"; do
  echo "  Base de datos no disponible aún..."
  sleep 3
done

echo "==> Base de datos disponible. Ejecutando migraciones..."
# Ajusta si no quieres fresh en producción; aquí asumimos fresh+seed para pruebas:
php artisan migrate:fresh --seed --force

echo "==> Limpiando y caché de Laravel..."
php artisan config:clear
php artisan route:clear
php artisan view:clear
php artisan config:cache
php artisan route:cache
php artisan view:cache

echo "==> Corrigiendo permisos"
chmod -R 775 storage bootstrap/cache
chown -R www-data:www-data storage bootstrap/cache

echo "==> Iniciando Supervisor (PHP-FPM + Nginx)..."
exec supervisord -c /etc/supervisor/conf.d/supervisor.conf
