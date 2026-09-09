-- TABLE: auth.sessions
CREATE TABLE auth.sessions (
    id_session UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    id_user UUID NOT NULL,

    token VARCHAR(255) NOT NULL,
    ip_address VARCHAR(45),

    expires_at TIMESTAMP NOT NULL,

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_sessions_user
        FOREIGN KEY (id_user)
        REFERENCES auth.users(id_user)
        ON DELETE CASCADE
);
