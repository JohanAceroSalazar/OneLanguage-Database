-- Restores the files catalog entry only.
-- User assignments are intentionally not recreated because the forward migration
-- removes their original identifiers and statuses. Restore them from a backup
-- if an exact rollback is required.
INSERT INTO auth.permissions (permission_name, description)
VALUES ('files', 'Permite descargar y guardar grabaciones de senas.')
ON CONFLICT (permission_name) DO NOTHING;
