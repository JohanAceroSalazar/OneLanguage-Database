-- TABLE: translation.translations
CREATE TABLE translation.translations (
    id_translation UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    id_user UUID NOT NULL,

    input_type VARCHAR(20) NOT NULL,

    translated_text TEXT NOT NULL,

    confidence FLOAT,

    processing_time FLOAT,

    translation_status VARCHAR(20),

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP NULL,

    CONSTRAINT fk_translations_user
        FOREIGN KEY (id_user)
        REFERENCES auth.users(id_user)
        ON DELETE CASCADE
);