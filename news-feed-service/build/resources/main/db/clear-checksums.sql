-- Drop existing triggers first
DROP TRIGGER IF EXISTS update_news_feed_updated_at ON news_feed;

-- Drop tables
DROP TABLE IF EXISTS news_feed;

-- Clear Liquibase changelog
DELETE FROM databasechangelog;
DELETE FROM databasechangeloglock; 