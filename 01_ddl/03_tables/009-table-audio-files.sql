-- TABLE: translation.audio_files
CREATE TABLE translation.audio_files (
    id_audio UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    id_translation UUID NOT NULL,

    file_url VARCHAR(255),

    file_type VARCHAR(50),

    file_size INT,

    duration_seconds INT,

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_audio_translation
        FOREIGN KEY (id_translation)
        REFERENCES translation.translations(id_translation)
        ON DELETE CASCADE
);
