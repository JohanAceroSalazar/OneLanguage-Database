-- 1. Eliminar los registros que se insertaron o actualizaron (por su código)
DELETE FROM accessibility.language 
WHERE code IN ('es', 'en', 'pt', 'it');

-- 2. Eliminar el índice único que se creó (si ya no lo necesitas)
DROP INDEX IF EXISTS accessibility.ux_accessibility_language_code;