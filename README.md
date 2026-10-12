# OneLanguage-Database

Repositorio de esquema y migraciones de One Language para PostgreSQL, administradas con Liquibase. Define autenticación, usuarios, permisos, accesibilidad, traducciones y objetos SQL de soporte.

## Tecnologías y requisitos

- PostgreSQL 15, mediante Docker Compose.
- Liquibase, mediante la imagen liquibase/liquibase.
- Docker Compose.
- JDBC PostgreSQL 42.7.9, incluido como postgresql-42.7.9.jar.

## Estructura

~~~text
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
└── docker/documentacion.md
~~~

Cada área contiene changelog.yaml. changelog-master.yaml incluye DDL, DML, DCL y TCL en ese orden. Las alteraciones recientes se encadenan desde 01_ddl/10_alter/changelog.yaml.

## Configuración

Copiar .env.example a .env:

~~~dotenv
POSTGRES_USER=postgres
POSTGRES_PASSWORD=
POSTGRES_DB=proyect_onelanguage
~~~

PostgreSQL se publica en el puerto host 5438 y escucha en 5432 dentro de la red de Compose. El volumen postgres_data conserva los datos. Liquibase espera el healthcheck antes de ejecutar update.

## Aplicar migraciones

~~~bash
docker compose up -d
docker compose logs -f liquibase
docker compose ps
~~~

El servicio monta el repositorio en /liquibase/changelog y ejecuta update con changelog-master.yaml. Para detener sin eliminar datos:

~~~bash
docker compose down
~~~

La existencia de un changeset no demuestra que haya sido aplicado en una base real; debe verificarse la salida de Liquibase.

## Esquemas, tablas y relaciones

Los scripts crean principalmente los esquemas auth y translation. Entre las tablas se encuentran:

- auth.users, con UUID, estado, bloqueo, auditoría y eliminación lógica.
- auth.permissions, catálogo de permisos.
- auth.user_permissions, relación compuesta usuario-permiso con claves foráneas a auth.users y auth.permissions, cascada y estado.
- auth.password_reset_tokens y auth.sessions, según las migraciones aplicadas.
- translation.translations, relacionada con auth.users, con texto, confianza, estado y marcas de tiempo.
- translation.audio_files, relacionada con traducciones mediante clave foránea.
- Tablas de idiomas y preferencias de accesibilidad.

Índices, vistas, funciones, triggers, restricciones y políticas se definen en los changelogs y deben aplicarse mediante Liquibase.

## Permisos funcionales

Después de aplicar las migraciones vigentes:

- auth.permissions conserva camera y audio.
- auth.user_permissions conserva sus relaciones.
- files se elimina mediante el changeset 011-remove-files-feature-permission.

La migración está en 01_ddl/10_alter/007-remove-files-feature-permission.sql y se registra en 01_ddl/10_alter/changelog.yaml. Su rollback es 05_rollbacks/01_ddl/10_alter/007-rollback-remove-files-feature-permission.sql.

El rollback restaura únicamente la fila de catálogo files; no reconstruye asignaciones históricas de usuarios, por lo que una restauración exacta requiere respaldo de la base.

## Rollback y despliegue

Los changesets que lo soportan declaran rollback y apuntan a 05_rollbacks. Antes de un entorno compartido:

1. Respaldar la base.
2. Revisar el estado de Liquibase y sus logs.
3. Ejecutar con credenciales de mínimo privilegio.
4. Validar las tablas afectadas.

El compose no ofrece rollback automático. Los scripts de reversión deben ejecutarse mediante el procedimiento Liquibase aprobado para cada entorno.

## Consideraciones

- No editar la base para simular un changeset aplicado.
- No publicar credenciales del archivo .env.
- Backend y base deben coincidir en nombre, usuario, contraseña y puerto.
- 05_rollbacks contiene scripts versionados; no implica que se haya ejecutado una reversión.

