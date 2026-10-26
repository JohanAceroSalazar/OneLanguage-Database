-- Remove only the functional files permission and its user assignments.
-- Liquibase runs this change set transactionally; no other permission is affected.
DELETE FROM auth.user_permissions AS up
USING auth.permissions AS p
WHERE up.id_permission = p.id_permission
  AND p.permission_name = 'files';

DELETE FROM auth.permissions
WHERE permission_name = 'files';
