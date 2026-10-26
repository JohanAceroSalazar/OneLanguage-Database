-- Ensure every account has persisted accessibility preferences from creation.
INSERT INTO accessibility.accessibility_settings (
    id_user,
    id_language,
    text_size,
    theme_color,
    voice_feedback
)
SELECT
    users.id_user,
    language.id_language,
    'medium',
    'light',
    TRUE
FROM auth.users AS users
JOIN accessibility.language AS language
    ON language.is_default = TRUE
   AND language.is_active = TRUE
LEFT JOIN accessibility.accessibility_settings AS settings
    ON settings.id_user = users.id_user
WHERE settings.id_user IS NULL;
