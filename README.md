# OneLanguage-Database

Repositorio de esquema y migraciones de One Language para PostgreSQL, administradas con Liquibase.

## Tecnologías y requisitos

- PostgreSQL 15, mediante Docker Compose.
- Liquibase, mediante la imagen `liquibase/liquibase`.
- Docker Compose y JDBC PostgreSQL 42.7.9 (`postgresql-42.7.9.jar`).

## Estructura

```text
OneLanguage-Database/
├── changelog-master.yaml
├── docker-compose.yml
├── .env.example
├── 01_ddl/       # extensiones, esquemas, tablas, vistas, funciones, índices y alteraciones
├── 02_dml/       # inserts, updates, deletes y parches
├── 03_dcl/       # roles, grants y políticas
├── 04_tcl/       # bloques transaccionales y recuperaciones manuales
├── 05_rollbacks/ # SQL de rollback versionado
├── docs/
└── docs/documentation.md
```

Cada área contiene `changelog.yaml`. `changelog-master.yaml` incluye DDL, DML, DCL y TCL en ese orden. Las alteraciones recientes se encadenan desde `01_ddl/10_alter/changelog.yaml`.

## Configuración

Copie `.env.example` a `.env` y reemplace todos los marcadores por valores exclusivos del entorno. Nunca versione `.env`, ni use los ejemplos como credenciales reales.

```dotenv
POSTGRES_USER=REPLACE_WITH_POSTGRES_USER
POSTGRES_PASSWORD=REPLACE_WITH_SECURE_PASSWORD
POSTGRES_DB=REPLACE_WITH_DATABASE_NAME
```

PostgreSQL se publica en el puerto host 5438 y escucha en 5432 dentro de Docker Compose. El volumen `postgres_data` conserva los datos y Liquibase espera el healthcheck antes de ejecutar `update`.

## Aplicar migraciones

```bash
docker compose up -d
docker compose logs -f liquibase
docker compose ps
```

Para detener los contenedores sin eliminar información persistida:

```bash
docker compose down
```

El servicio Liquibase monta el repositorio en `/liquibase/changelog` y ejecuta `update` con `changelog-master.yaml`. La existencia de un changeset no demuestra que se haya aplicado en una base real; verifique la salida de Liquibase.

## Esquemas, tablas y relaciones

Los scripts crean principalmente los esquemas `auth`, `translation` y `accessibility`. Entre las tablas se encuentran:

- `auth.users`, con UUID, estado, bloqueo, auditoría y eliminación lógica.
- `auth.permissions` y `auth.user_permissions`, con claves foráneas hacia usuarios y permisos.
- `auth.password_reset_tokens` y `auth.sessions`, según las migraciones aplicadas.
- `translation.translations`, `translation.signs`, `translation.translation_signs` y `translation.audio_files`.
- `accessibility.language` y `accessibility.accessibility_settings`.

Índices, vistas, funciones, triggers, restricciones y políticas se definen en los changelogs y deben aplicarse mediante Liquibase.

## Permisos funcionales

Después de aplicar las migraciones vigentes:

- `auth.permissions` conserva `camera` y `audio`.
- `auth.user_permissions` conserva sus relaciones.
- `files` se elimina mediante el changeset `011-remove-files-feature-permission`.

La migración está en `01_ddl/10_alter/007-remove-files-feature-permission.sql` y se registra en `01_ddl/10_alter/changelog.yaml`. Su rollback es `05_rollbacks/01_ddl/10_alter/007-rollback-remove-files-feature-permission.sql`.

El rollback restaura únicamente la fila de catálogo `files`; no reconstruye asignaciones históricas de usuarios, por lo que una restauración exacta requiere respaldo de la base.

## Rollback y despliegue

Los changesets que lo soportan declaran rollback y apuntan a `05_rollbacks`. Antes de ejecutar cambios en un entorno compartido:

1. Respalde la base de datos.
2. Revise estado y logs de Liquibase.
3. Use credenciales de mínimo privilegio obtenidas del entorno privado.
4. Valide las tablas afectadas.

El Compose no ofrece rollback automático. Los scripts de reversión deben ejecutarse mediante el procedimiento Liquibase aprobado para cada entorno.

## Seguridad de secretos

- `.env`, `.env.*` y `liquibase.properties` están excluidos del control de versiones.
- No incluya credenciales, tokens ni cadenas de conexión con contraseña en documentación, ejemplos o changelogs.
- Consulte [docs/security-secrets.md](docs/security-secrets.md) para ejecutar el control de secretos y responder a un hallazgo.

## Consideraciones

- No edite la base para simular un changeset aplicado.
- Backend y base deben coincidir en nombre, usuario, contraseña y puerto mediante su configuración privada de entorno.
- `05_rollbacks` contiene scripts versionados; no implica que se haya ejecutado una reversión.
