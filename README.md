 Backend – Inventario API (Laravel 12)
Este es el backend de la aplicación de gestión de inventarios, desarrollado en Laravel 12. Proporciona una API RESTful para gestionar productos, categorías y usuarios (registro, login y perfil). Está conectado al frontend hecho en Vue.js y desplegado en Vercel. Este backend está en producción en Railway.


 Tecnologías Utilizadas
Laravel 12

PHP 8.2

Laravel Sanctum – Autenticación por tokens

PostgreSQL

Pail – Sistema de logs en tiempo real

Pint – Formateador de código

Sail – Entorno de desarrollo 

Artisan Commands personalizados

Railway – Despliegue backend

 Funcionalidades:

Registro y autenticación con tokens usando Sanctum

CRUD completo de productos

CRUD completo de categorías

Consultar y actualizar perfil de usuario

Cerrar sesion 

Middleware de autenticación protegido

Endpoints REST bien estructurados



##  Endpoints

###  Públicos

| Método | Ruta        | Descripción               |
|--------|-------------|---------------------------|
| GET    | `/ping`     | Verifica disponibilidad   |
| GET    | `/test`     | Prueba de funcionamiento  |
| POST   | `/register` | Registro de usuario       |
| POST   | `/login`    | Inicio de sesión          |

###  Protegidos (`auth:sanctum`)

| Método | Ruta                  | Descripción                       |
|--------|------------------------|-----------------------------------|
| GET    | `/profile`             | Obtener perfil                    |
| PUT    | `/profile`             | Actualizar perfil                 |
| POST   | `/logout`              | Cerrar sesión                     |

####  Categorías

| Método | Ruta                    | Descripción             |
|--------|-------------------------|-------------------------|
| GET    | `/categories`           | Listar categorías       |
| POST   | `/categories`           | Crear categoría         |
| PUT    | `/categories/{id}`      | Actualizar categoría    |
| DELETE | `/categories/{id}`      | Eliminar categoría      |

####  Productos

| Método | Ruta                    | Descripción             |
|--------|-------------------------|-------------------------|
| GET    | `/products`             | Listar productos        |
| POST   | `/products`             | Crear producto          |
| PUT    | `/products/{id}`        | Actualizar producto     |
| DELETE | `/products/{id}`        | Eliminar producto       |

---


 Seguridad y Middleware
auth:sanctum protege rutas privadas

CORS configurado para consumo desde el frontend (Vercel)

Tokens seguros y scoped

Variables como SANCTUM_STATEFUL_DOMAINS configuradas en .env


 Despliegue en Producción
Backend desplegado en Railway

Frontend (Vue.js) desplegado en Vercel





##  Instalación Local

```bash
git clone  https://github.com/wilfredo1234-tech/Backend_inventario.git
cd backend-inventario

composer install
cp .env.example .env
php artisan key:generate

# Configurar .env (PostgreSQL)
DB_CONNECTION=pgsql
DB_HOST=localhost
DB_PORT=5432
DB_DATABASE=inventario
DB_USERNAME=postgres
DB_PASSWORD=secret

php artisan migrate --seed
php artisan serve


 Autor
Desarrollado por Wilfredo Palacio.