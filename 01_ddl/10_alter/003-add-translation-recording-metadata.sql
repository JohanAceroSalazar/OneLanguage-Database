ALTER TABLE translation.translations
    ADD COLUMN recording_path VARCHAR(255),
    ADD COLUMN recording_content_type VARCHAR(100),
    ADD COLUMN recording_size BIGINT;
