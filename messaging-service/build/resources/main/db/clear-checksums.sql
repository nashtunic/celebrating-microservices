-- Drop existing triggers first
DROP TRIGGER IF EXISTS update_messages_updated_at ON messages;
DROP TRIGGER IF EXISTS update_chats_updated_at ON chats;
DROP TRIGGER IF EXISTS update_notifications_updated_at ON notifications;

-- Now safe to drop function
DROP FUNCTION IF EXISTS update_updated_at_column();

-- Drop tables in correct order due to foreign key constraints
DROP TABLE IF EXISTS messages;
DROP TABLE IF EXISTS chats;

-- Clear Liquibase changelog
DELETE FROM databasechangelog;
DELETE FROM databasechangeloglock; 