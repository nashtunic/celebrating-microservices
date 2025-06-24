-- Clear Liquibase checksums
UPDATE databasechangelog SET md5sum = NULL;

-- Drop existing tables and functions
DROP TABLE IF EXISTS followers CASCADE;
DROP TABLE IF EXISTS user_stats CASCADE;
DROP TABLE IF EXISTS celebrity_profiles CASCADE;
DROP TABLE IF EXISTS users CASCADE;
DROP FUNCTION IF EXISTS update_updated_at CASCADE;

-- Clear Liquibase lock if it exists
DELETE FROM databasechangeloglock WHERE id = 1; 