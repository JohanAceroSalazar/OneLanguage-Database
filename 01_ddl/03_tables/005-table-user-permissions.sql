-- TABLE: auth.user_permissions
CREATE TABLE auth.user_permissions (
    id_user UUID NOT NULL,
    id_permission UUID NOT NULL,

    status VARCHAR(20) NOT NULL,

    granted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (id_user, id_permission),

    CONSTRAINT fk_user_permissions_user
        FOREIGN KEY (id_user)
        REFERENCES auth.users(id_user)
        ON DELETE CASCADE,

    CONSTRAINT fk_user_permissions_permission
        FOREIGN KEY (id_permission)
        REFERENCES auth.permissions(id_permission)
        ON DELETE CASCADE
);
