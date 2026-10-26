-- Compatibility bridge for databases created by the original baseline.
-- New installations already create these tables in auth, so this is a no-op.
DO $$
BEGIN
    IF to_regclass('public.users') IS NOT NULL THEN
        EXECUTE 'ALTER TABLE public.users SET SCHEMA auth';
    END IF;

    IF to_regclass('public.password_reset_tokens') IS NOT NULL THEN
        EXECUTE 'ALTER TABLE public.password_reset_tokens SET SCHEMA auth';
    END IF;
END
$$;
