-- Drop existing tables and Liquibase tracking
DROP TABLE IF EXISTS public.posts CASCADE;
DROP TABLE IF EXISTS public.chats CASCADE;
DROP TABLE IF EXISTS public.messages CASCADE;
DROP TABLE IF EXISTS public.users CASCADE;
DROP TABLE IF EXISTS public.user_roles CASCADE;
DROP TABLE IF EXISTS public.roles CASCADE;
DROP TABLE IF EXISTS public.user_stats CASCADE;
DROP TABLE IF EXISTS public.followers CASCADE;
DROP TABLE IF EXISTS public.reviews CASCADE;
DROP TABLE IF EXISTS public.ratings CASCADE;
DROP TABLE IF EXISTS public.notifications CASCADE;
DROP TABLE IF EXISTS public.awards CASCADE;
DROP TABLE IF EXISTS public.achievements CASCADE;
DROP TABLE IF EXISTS public.user_achievements CASCADE;
DROP TABLE IF EXISTS public.moderation_reports CASCADE;
DROP TABLE IF EXISTS public.search_index CASCADE;
DROP TABLE IF EXISTS public.news_feed CASCADE;
DROP TABLE IF EXISTS public.user_preferences CASCADE;
DROP TABLE IF EXISTS public.databasechangelog CASCADE;
DROP TABLE IF EXISTS public.databasechangeloglock CASCADE;

-- Clear any existing connections to the database
SELECT pg_terminate_backend(pid) 
FROM pg_stat_activity 
WHERE datname = 'celebratedb' AND pid <> pg_backend_pid();

-- Grant all necessary permissions to the celebrate user
ALTER USER celebrate WITH CREATEDB;

-- Grant schema permissions
GRANT ALL ON SCHEMA public TO celebrate;
ALTER SCHEMA public OWNER TO celebrate;

-- Grant table permissions (including future tables)
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON TABLES TO celebrate;
GRANT ALL ON ALL TABLES IN SCHEMA public TO celebrate;

-- Grant sequence permissions (for auto-incrementing IDs)
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON SEQUENCES TO celebrate;
GRANT ALL ON ALL SEQUENCES IN SCHEMA public TO celebrate;

-- Grant function permissions
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON FUNCTIONS TO celebrate;
GRANT ALL ON ALL FUNCTIONS IN SCHEMA public TO celebrate;

-- Grant type permissions
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON TYPES TO celebrate;
GRANT ALL ON ALL TYPES IN SCHEMA public TO celebrate; 