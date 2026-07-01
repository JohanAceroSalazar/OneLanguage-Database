# Proyecto OneLanguage - PostgreSQL + Liquibase con Docker

Este proyecto utiliza:

- PostgreSQL 15 como base de datos
- Liquibase para el control de versiones y migraciones
- Docker Compose para la orquestación de contenedores

---

# Estructura del Proyecto

```bash
project/
│
├── docker-compose.yml
├── changelog-master.yaml
├── postgresql-42.7.9.jar
├── liquibase.properties
└── migrations/
```

---

# Docker Compose

Archivo: `docker-compose.yml`

```yaml
services:

  postgres:
    image: postgres:15
    container_name: database-proyect
    restart: always
    environment:
      POSTGRES_USER: postgres
      POSTGRES_PASSWORD: Johan2509
      POSTGRES_DB: proyect_onelanguage
    ports:
      - "5438:5432"
    volumes:
      - postgres_data:/var/lib/postgresql/data

  liquibase:
    image: liquibase/liquibase
    container_name: liquibase_proyect
    depends_on:
      - postgres
    volumes:
      - ./:/liquibase/changelog
      - ./postgresql-42.7.9.jar:/liquibase/lib/postgresql.jar
    working_dir: /liquibase/changelog
    command: >
      --url=jdbc:postgresql://postgres:5432/proyect_onelanguage
      --username=postgres
      --password=Johan2509
      --driver=org.postgresql.Driver
      --changeLogFile=changelog-master.yaml
      update

volumes:
  postgres_data:
```

---

# Configuración de Liquibase

Archivo: `liquibase.properties`

```properties
url=jdbc:postgresql://postgres:5432/proyect_onelanguage
username=postgres
password=Johan2509
driver=org.postgresql.Driver
changeLogFile=changelog-master.yaml
```

---

# Variables de Entorno

Archivo: `.env.example`

```env
POSTGRES_DB=proyect_onelanguage
POSTGRES_USER=postgres
POSTGRES_PASSWORD=your_password
POSTGRES_PORT=5438
```

---

# Explicación de Puertos

```text
5432 -> Puerto interno del contenedor PostgreSQL
5438 -> Puerto expuesto en la máquina local
```

Conexiones:

## Desde otros contenedores Docker

```text
jdbc:postgresql://postgres:5432/proyect_onelanguage
```

## Desde tu máquina local

```text
jdbc:postgresql://localhost:5438/proyect_onelanguage
```

---

# Ejecutar el Proyecto

## Levantar contenedores

```bash
docker compose up -d
```

---

## Ejecutar los nuevos cambios

```bash
docker compose up
```

---

## Ver contenedores activos

```bash
docker ps
```

---

## Ver logs de Liquibase

```bash
docker logs liquibase_proyect
```

---

## Detener contenedores

```bash
docker compose down
```

---

## Eliminar contenedores y volúmenes

```bash
docker compose down -v
```

---

# Verificar conexión a PostgreSQL

Puedes conectarte desde:

- DBeaver
- pgAdmin
- IntelliJ IDEA
- Spring Boot

Configuración:

```text
Host: localhost
Port: 5438
Database: proyect_onelanguage
User: postgres
Password: Johan2509
```

---

# Recomendaciones

## No subir credenciales reales al repositorio

Agregar `.env` al `.gitignore`.

# Tecnologías

- PostgreSQL 15
- Liquibase
- Docker
- Docker Compose
