-- Clear Liquibase checksums
DELETE FROM public.databasechangelog;
DROP TABLE IF EXISTS public.notifications;
DROP FUNCTION IF EXISTS update_updated_at_column() CASCADE; 