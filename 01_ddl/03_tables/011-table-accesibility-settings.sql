-- TABLE: accessibility.accessibility_settings
CREATE TABLE accessibility.accessibility_settings (
    id_settings UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    id_user UUID UNIQUE NOT NULL,
    id_language UUID NOT NULL,

    text_size VARCHAR(50),
    theme_color VARCHAR(20),

    voice_feedback BOOLEAN DEFAULT TRUE,

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_accessibility_user
        FOREIGN KEY (id_user)
        REFERENCES auth.users(id_user)
        ON DELETE CASCADE,

    CONSTRAINT fk_accessibility_language
        FOREIGN KEY (id_language)
        REFERENCES accessibility.language(id_language)
);
