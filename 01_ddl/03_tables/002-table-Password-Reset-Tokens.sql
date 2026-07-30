CREATE TABLE password_reset_tokens (
    id_token UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    id_user UUID NOT NULL,

    token_identifier UUID NOT NULL UNIQUE,

    token_hash VARCHAR(255) NOT NULL,

    expires_at TIMESTAMP NOT NULL,

    used_at TIMESTAMP NULL,

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_password_reset_user
        FOREIGN KEY (id_user)
        REFERENCES users(id_user)
        ON DELETE CASCADE
);