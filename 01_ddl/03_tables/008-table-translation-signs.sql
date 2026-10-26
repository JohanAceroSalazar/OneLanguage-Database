-- TABLE: translation.translation_signs
CREATE TABLE translation.translation_signs (
    id_translation UUID NOT NULL,
    id_sign UUID NOT NULL,

    confidence FLOAT,

    position INT,

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (id_translation, id_sign),

    CONSTRAINT fk_translation_signs_translation
        FOREIGN KEY (id_translation)
        REFERENCES translation.translations(id_translation)
        ON DELETE CASCADE,

    CONSTRAINT fk_translation_signs_sign
        FOREIGN KEY (id_sign)
        REFERENCES translation.signs(id_sign)
        ON DELETE CASCADE
);