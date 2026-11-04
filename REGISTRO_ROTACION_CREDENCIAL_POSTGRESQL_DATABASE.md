# Registro de rotación de credencial — OneLanguage Database

**Estado:** Completado  
**Fecha de documentación:** 2026-11-03  
**Hallazgo relacionado:** H-02 — Exposición de la contraseña de PostgreSQL

## 1. Objetivo

Dejar constancia del cambio de la contraseña de PostgreSQL utilizada por el proyecto de base de datos, sin registrar, reproducir ni almacenar valores secretos.

## 2. Acción realizada

Se cambió la contraseña del usuario de PostgreSQL que se encontraba expuesta en archivos de configuración y documentación del repositorio.

La configuración de despliegue fue ajustada para recibir la contraseña mediante una variable de entorno (`POSTGRES_PASSWORD`), evitando mantener la credencial real directamente en los archivos versionados.

El archivo `.env` se conserva como configuración local y no debe subirse al repositorio. El archivo `.env.example` debe contener únicamente el nombre de la variable y un valor de ejemplo no funcional, nunca la contraseña real.

## 3. Verificaciones

Como parte de la revisión se comprobó que:

- La contraseña anterior fue reemplazada por una nueva.
- La configuración vigente de despliegue utiliza una variable de entorno para recibir la contraseña.
- Los ejemplos vigentes no deben contener la contraseña real.
- Este documento no contiene la contraseña anterior ni la nueva.

## 4. Resultado

**H-02: rotación de la contraseña de PostgreSQL completada.**

La contraseña de PostgreSQL fue cambiada y la configuración del repositorio se preparó para recibirla mediante una variable de entorno, sin publicar su valor.

Esta constancia documenta la remediación aplicada al repositorio de base de datos. No afirma que se hayan eliminado todos los objetos o referencias históricas administrados por GitHub; cualquier rastro histórico debe distinguirse de la configuración vigente y de la validez de la contraseña, que fue rotada.

## 5. Tratamiento de información sensible

Por seguridad, no se incluye en este documento:

- La contraseña anterior ni la nueva de PostgreSQL.
- Archivos `.env` con credenciales reales.
- Capturas, registros o ejemplos que permitan recuperar el valor secreto.

La contraseña real se administra únicamente mediante el mecanismo privado de configuración del entorno de ejecución.
