# Integración continua

GitHub Actions ejecuta dos workflows sin conectarse a infraestructura externa:

- `Secret scan`: se ejecuta en pull requests y en pushes a `dev`, `main`, `qa` y ramas `HU-*`. Descarga el historial completo y ejecuta Gitleaks. Un hallazgo debe bloquear el cambio; no hay allowlists ni ejecución tolerante a errores.
- `Database CI`: se ejecuta en pull requests dirigidos a `dev` y en pushes a `dev` y ramas `HU-*`. Valida Docker Compose con valores exclusivos de CI y ejecuta Liquibase sobre PostgreSQL 15 temporal del runner.

## Interpretación

`compose-validation` verifica que la configuración sea válida con variables ficticias y que falle si falta `POSTGRES_PASSWORD`. No inicia los servicios definidos por el repositorio.

`liquibase-integration` valida el árbol de changelogs, aplica las migraciones a una base PostgreSQL 15 aislada, comprueba tablas, claves foráneas y `DATABASECHANGELOG`, y aplica Liquibase por segunda vez para confirmar idempotencia.

Los contenedores y datos de estos jobs pertenecen al runner efímero de GitHub Actions. Ningún job usa `.env`, el VPS ni una base externa.

Antes de aprobar un pull request, los dos workflows deben finalizar correctamente. Una alerta histórica de Gitleaks requiere tratamiento de seguridad; retirar el texto del archivo actual no equivale a rotar ni a borrar el secreto de Git.
