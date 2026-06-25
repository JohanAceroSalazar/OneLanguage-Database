CREATE TABLE users (
    id_user UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    email VARCHAR(255) UNIQUE NOT NULL,

    full_name VARCHAR(150) NOT NULL,

    password_hash TEXT NOT NULL,

    user_status BOOLEAN DEFAULT TRUE,

    failed_attempts INT DEFAULT 0,

    locked_until TIMESTAMPTZ NULL,

    last_access TIMESTAMPTZ NULL,

    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,

    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,

    deleted_at TIMESTAMPTZ NULL
);