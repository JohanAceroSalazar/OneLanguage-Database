-- Remove authentication tables that are not used by the stateless JWT flow.
-- Drop dependents before referenced tables so existing foreign keys are valid.
DROP TABLE IF EXISTS auth.user_permissions;
DROP TABLE IF EXISTS auth.permissions;
DROP TABLE IF EXISTS auth.sessions;
