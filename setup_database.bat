@echo off
echo Setting up database...

REM Create database and initialize schema
psql -U postgres -f db_setup.sql

REM Connect to celebratedb and create extensions and tables
psql -U postgres -d celebratedb -c "CREATE EXTENSION IF NOT EXISTS \"uuid-ossp\";"
psql -U postgres -d celebratedb -c "CREATE EXTENSION IF NOT EXISTS \"pgcrypto\";"

REM Create users table
psql -U postgres -d celebratedb -c "CREATE TABLE IF NOT EXISTS users (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);"

REM Create indexes
psql -U postgres -d celebratedb -c "CREATE INDEX IF NOT EXISTS idx_users_username ON users(username);"
psql -U postgres -d celebratedb -c "CREATE INDEX IF NOT EXISTS idx_users_email ON users(email);"

echo Database setup complete! 