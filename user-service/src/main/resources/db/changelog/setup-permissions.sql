-- Connect as superuser first
-- This script should be run as a PostgreSQL superuser (usually 'postgres')

-- Grant all privileges on the database
GRANT ALL PRIVILEGES ON DATABASE celebratedb TO celebrate;

-- Grant schema usage and create permissions
GRANT USAGE, CREATE ON SCHEMA public TO celebrate;

-- Grant permissions on all existing tables
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO celebrate;

-- Grant permissions on all sequences
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO celebrate;

-- Grant permissions on all functions
GRANT ALL PRIVILEGES ON ALL FUNCTIONS IN SCHEMA public TO celebrate;

-- Make celebrate the owner of the Liquibase tables if they exist
ALTER TABLE IF EXISTS public.databasechangelog OWNER TO celebrate;
ALTER TABLE IF EXISTS public.databasechangeloglock OWNER TO celebrate;

-- Set default privileges for future objects
ALTER DEFAULT PRIVILEGES IN SCHEMA public
GRANT ALL PRIVILEGES ON TABLES TO celebrate;

ALTER DEFAULT PRIVILEGES IN SCHEMA public
GRANT ALL PRIVILEGES ON SEQUENCES TO celebrate;

ALTER DEFAULT PRIVILEGES IN SCHEMA public
GRANT ALL PRIVILEGES ON FUNCTIONS TO celebrate;

-- If tables exist, change their ownership
DO $$
DECLARE
    r RECORD;
BEGIN
    FOR r IN SELECT tablename FROM pg_tables WHERE schemaname = 'public'
    LOOP
        EXECUTE 'ALTER TABLE public.' || quote_ident(r.tablename) || ' OWNER TO celebrate';
    END LOOP;
END $$; 