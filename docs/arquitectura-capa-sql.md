# Arquitectura de la Capa SQL

## Posición Arquitectónica

Este repositorio está organizado primero por responsabilidad SQL y después por familia de objetos.

Eso significa que:

- la primera división es semántica: `DDL`, `DML`, `DCL`, `TCL`
- la segunda división es técnica: tablas, vistas, funciones, grants, parches, etc.

Este es un modelo más sólido que colocar todo bajo una carpeta genérica `db/` o dividir únicamente por tipo de objeto desde el inicio.

## Por Qué se Eliminó `db/`

A nivel de repositorio, `db/` agrega un contenedor más, pero no un significado adicional.

En un proyecto exclusivamente de base de datos, el propio repositorio ya es el espacio de trabajo de la base de datos.

Colocar el changelog activo dentro de `db/` agrega un nivel extra de navegación sin mejorar la arquitectura.

Mantener `changelog-master.yaml` en la raíz hace que el contrato de despliegue sea explícito y más fácil de auditar.

## Modelo de Capas

### 1. DDL

`01_ddl/` es la capa estructural.

Úsala para:

- extensiones
- esquemas
- tipos
- tablas
- vistas
- vistas materializadas
- funciones
- procedimientos
- triggers
- índices

El despliegue activo actual vive aquí.

### 2. DML

`02_dml/` es la capa de manipulación de datos.

Úsala para:

- inserts
- updates
- deletes
- upserts
- parches de transformación de una sola ejecución

Esta capa debe mantenerse explícita e intencional, no mezclada con cambios estructurales.

Para equipos que necesitan una trazabilidad operativa más fuerte, organizar el DML por verbo principal suele ser mejor que organizarlo únicamente por intención de negocio.

Carriles recomendados:

- `02_dml/00_inserts`
- `02_dml/01_updates`
- `02_dml/02_deletes`
- `02_dml/03_upserts`
- `02_dml/04_patches`

### 3. DCL

`03_dcl/` es la capa de control de acceso.

Úsala para:

- roles
- grants
- policies

Esto es especialmente útil cuando los entornos difieren en postura de seguridad y cuando los permisos deben versionarse por separado de la creación del esquema.

### 4. TCL

`04_tcl/` es la capa de control transaccional.

Nota experta:

En proyectos gestionados con Liquibase, `TCL` suele ser mínimo.

Liquibase ya orquesta los límites de ejecución, el orden y el comportamiento transaccional para la mayoría de los cambios.

Por eso, `TCL` debe tratarse como un carril excepcional, no como un carril ocupado por defecto.

Aun así, vale la pena reservarlo para casos como:

- secuencias de recuperación manual
- wrappers transaccionales excepcionales
- scripts operacionales específicos por entorno

## Regla Práctica

No todas las carpetas deben estar ocupadas.

Una buena arquitectura no es aquella donde todos los carriles están llenos.

Una buena arquitectura es aquella donde cada carril tiene un significado claro antes de que el equipo lo necesite.

## Regla de Activación

Solo los archivos incluidos desde `changelog-master.yaml` forman parte del camino de despliegue activo.

Hoy, la ruta activa es:

- `01_ddl/00_extensions`
- `01_ddl/01_schemas`
- `01_ddl/03_tables`

Todo lo demás está reservado de manera intencional, no accidental.

## Recomendación Experta

Si el proyecto sigue siendo pequeño, mantén el flujo activo concentrado en `DDL`.

Cuando el proyecto crezca:

- promueve las operaciones de datos hacia carriles explícitos de `DML`
- promueve seguridad y grants hacia `DCL`
- mantén `TCL` únicamente para casos operacionales excepcionales

Ese equilibrio suele ser más limpio que intentar forzar todas las responsabilidades dentro de un único árbol de directorios plano.

## Realidad del Rollback en DML

Aquí importa una distinción propia de un DBA experto:

- `DDL` suele ser reversible mecánicamente
- `DML` suele ser reversible solo de manera lógica

Eso significa que:

- `INSERT` normalmente puede revertirse con un `DELETE` dirigido
- `UPDATE` normalmente necesita un `UPDATE` compensatorio o un snapshot previo al cambio
- `DELETE` normalmente necesita datos de recuperación, no solo un comando de rollback

Por esa razón, la gobernanza de `DML` debería incluir:

- tags explícitos antes de despliegues riesgosos
- previsualización SQL mediante `update-sql`
- planificación de compensación para `UPDATE` y `DELETE`
- evitar confiar ciegamente en rollback para cambios destructivos de datos