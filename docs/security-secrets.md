# Control de secretos

El repositorio ejecuta Gitleaks en GitHub Actions para detectar credenciales, claves y tokens introducidos en cambios nuevos. El control no requiere credenciales de PostgreSQL ni acceso a un entorno desplegado.

El workflow obtiene el historial completo (`fetch-depth: 0`). Por ello, una exposición histórica conocida puede hacer fallar el escaneo incluso cuando el árbol actual esté limpio. Ese resultado no debe ocultarse: primero se deben rotar las credenciales afectadas y luego planificar el saneamiento coordinado del historial, clones, forks y cachés.

## Ejecución local

Instale Gitleaks y ejecute desde la raíz del repositorio:

```bash
gitleaks detect --source . --no-git --redact
```

`--no-git` revisa el árbol actual sin imprimir valores detectados. El historial expuesto antes de este control requiere un proceso separado de saneamiento y rotación de las credenciales afectadas.

## Si se detecta un secreto

1. No publique el valor en issues, chats, logs ni mensajes de commit.
2. Elimine el valor del archivo versionado y reemplácelo por una variable de entorno o un marcador inequívoco.
3. Si el valor fue real, trátelo como comprometido y rótelo en el entorno correspondiente.
4. Informe al responsable de seguridad para evaluar limpieza de historial, clones, forks y registros de CI.
5. Ejecute nuevamente el control antes de solicitar revisión.

No se deben crear excepciones generales para ocultar hallazgos. Todo falso positivo debe analizarse de forma puntual antes de considerar una exclusión.
