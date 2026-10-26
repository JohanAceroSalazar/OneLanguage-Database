CREATE UNIQUE INDEX IF NOT EXISTS ux_accessibility_language_code
    ON accessibility.language (code);

INSERT INTO accessibility.language (name, code, is_default, is_active)
VALUES
    ('Español', 'es', TRUE, TRUE),
    ('English', 'en', FALSE, TRUE),
    ('Português', 'pt', FALSE, TRUE),
    ('Italiano', 'it', FALSE, TRUE)
ON CONFLICT (code) DO UPDATE
SET name = EXCLUDED.name,
    is_active = TRUE,
    is_default = EXCLUDED.is_default,
    updated_at = CURRENT_TIMESTAMP;
