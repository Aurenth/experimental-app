-- Initial PostgreSQL setup
-- Prisma migrations handle schema creation
-- This file runs once on first container startup

-- Create extensions if needed
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pgcrypto";
