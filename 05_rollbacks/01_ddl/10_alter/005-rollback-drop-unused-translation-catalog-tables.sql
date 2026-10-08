CREATE TABLE translation.signs (
    id_sign UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(100) NOT NULL,
    description TEXT,
    gesture_reference VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE translation.translation_signs (
    id_translation UUID NOT NULL,
    id_sign UUID NOT NULL,
    confidence FLOAT,
    position INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id_translation, id_sign),
    CONSTRAINT fk_translation_signs_translation
        FOREIGN KEY (id_translation) REFERENCES translation.translations(id_translation) ON DELETE CASCADE,
    CONSTRAINT fk_translation_signs_sign
        FOREIGN KEY (id_sign) REFERENCES translation.signs(id_sign) ON DELETE CASCADE
);

CREATE TABLE translation.audio_files (
    id_audio UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    id_translation UUID NOT NULL,
    file_url VARCHAR(255),
    file_type VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_audio_translation
        FOREIGN KEY (id_translation) REFERENCES translation.translations(id_translation) ON DELETE CASCADE
);
