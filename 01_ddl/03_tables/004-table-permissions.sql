-- TABLE: auth.permissions
CREATE TABLE auth.permissions (
    id_permission UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    permission_name VARCHAR(100) NOT NULL,
    description VARCHAR(255),

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
