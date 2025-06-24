-- Drop all tables first
DROP TABLE IF EXISTS followers CASCADE;
DROP TABLE IF EXISTS user_stats CASCADE;
DROP TABLE IF EXISTS celebrity_profiles CASCADE;
DROP TABLE IF EXISTS users CASCADE;

-- Drop Liquibase tables to start fresh
DROP TABLE IF EXISTS databasechangelog CASCADE;
DROP TABLE IF EXISTS databasechangeloglock CASCADE;

-- Drop the update function if it exists
DROP FUNCTION IF EXISTS update_updated_at CASCADE; 