# OneLanguage: PostgreSQL y Liquibase con Docker

Este proyecto utiliza PostgreSQL 15, Liquibase y Docker Compose. Las credenciales se mantienen fuera del repositorio en un archivo `.env` local.

## Configuración inicial

1. Copie `.env.example` a `.env`.
2. Reemplace todos los marcadores por valores exclusivos del entorno.
3. Mantenga `.env` fuera del control de versiones.

```dotenv
POSTGRES_USER=REPLACE_WITH_POSTGRES_USER
POSTGRES_PASSWORD=REPLACE_WITH_SECURE_PASSWORD
POSTGRES_DB=REPLACE_WITH_DATABASE_NAME
```

No use los valores de ejemplo en entornos reales y no copie credenciales en documentación, tickets o registros.

## Docker Compose

`docker-compose.yml` conserva PostgreSQL 15, el volumen `postgres_data` y el servicio de Liquibase. Recibe `POSTGRES_USER`, `POSTGRES_PASSWORD` y `POSTGRES_DB` exclusivamente desde el entorno; Compose rechazará la ejecución si faltan.

El puerto 5432 se usa dentro del contenedor y el puerto 5438 se publica en el host. Liquibase espera el healthcheck de PostgreSQL y ejecuta `update` con `changelog-master.yaml`.

## Ejecución

```bash
docker compose up -d
docker compose logs -f liquibase
docker compose ps
```

Para detener contenedores sin eliminar información persistida:

```bash
docker compose down
```

No ejecute `docker compose down -v` en un entorno con datos que deban conservarse.

## Conexión a PostgreSQL

Desde otro contenedor use el host `postgres` y el puerto `5432`. Desde el host local use `localhost:5438`. Tome nombre de base, usuario y contraseña del archivo `.env` privado; no los incluya en comandos compartidos ni en archivos versionados.

## Seguridad

`.env`, `.env.*` y `liquibase.properties` están ignorados por Git. Antes de abrir un pull request, ejecute el control descrito en [docs/security-secrets.md](../docs/security-secrets.md).
