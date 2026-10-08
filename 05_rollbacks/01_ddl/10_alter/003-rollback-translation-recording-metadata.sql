ALTER TABLE translation.translations
    DROP COLUMN IF EXISTS recording_size,
    DROP COLUMN IF EXISTS recording_content_type,
    DROP COLUMN IF EXISTS recording_path;
