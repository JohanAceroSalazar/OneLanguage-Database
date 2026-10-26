-- Restore the normalized permission model for profile feature permissions.
-- A user can independently enable camera, audio, and file access.
CREATE TABLE IF NOT EXISTS auth.permissions (
    id_permission UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    permission_name VARCHAR(100) NOT NULL UNIQUE,
    description VARCHAR(255),
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS auth.user_permissions (
    id_user UUID NOT NULL,
    id_permission UUID NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'disabled',
    granted_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id_user, id_permission),
    CONSTRAINT chk_user_permissions_status CHECK (status IN ('enabled', 'disabled')),
    CONSTRAINT fk_user_permissions_user
        FOREIGN KEY (id_user)
        REFERENCES auth.users(id_user)
        ON DELETE CASCADE,
    CONSTRAINT fk_user_permissions_permission
        FOREIGN KEY (id_permission)
        REFERENCES auth.permissions(id_permission)
        ON DELETE CASCADE
);

INSERT INTO auth.permissions (permission_name, description)
VALUES
    ('camera', 'Permite usar la camara para interpretar senas.'),
    ('audio', 'Permite reproducir las traducciones por voz.'),
    ('files', 'Permite descargar y guardar grabaciones de senas.')
ON CONFLICT (permission_name) DO UPDATE
SET description = EXCLUDED.description,
    updated_at = CURRENT_TIMESTAMP;

-- Existing accounts receive an explicit disabled setting for every feature.
INSERT INTO auth.user_permissions (id_user, id_permission, status)
SELECT users.id_user, permissions.id_permission, 'disabled'
FROM auth.users AS users
CROSS JOIN auth.permissions AS permissions
WHERE permissions.permission_name IN ('camera', 'audio', 'files')
ON CONFLICT (id_user, id_permission) DO NOTHING;
