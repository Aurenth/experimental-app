.PHONY: dev dev-services dev-api stop clean migrate seed logs help

# Start all services (Postgres, Redis, MinIO) + API in dev mode
dev: dev-services
	@echo "Starting NestJS API in dev mode..."
	@cd apps/api && npm run start:dev

# Start only infrastructure services (Postgres, Redis, MinIO)
dev-services:
	@echo "Starting infrastructure services..."
	@cp -n .env.example .env 2>/dev/null || true
	@docker compose -f infra/docker-compose.dev.yml --env-file .env up -d
	@echo "Waiting for services to be healthy..."
	@sleep 5
	@echo "Services ready:"
	@echo "  Postgres:  localhost:5432"
	@echo "  Redis:     localhost:6379"
	@echo "  MinIO:     http://localhost:9000 (console: http://localhost:9001)"

# Start API only (requires services already running)
dev-api:
	@echo "Starting NestJS API..."
	@cd apps/api && npm run start:dev

# Install dependencies
install:
	@echo "Installing API dependencies..."
	@cd apps/api && npm install

# Run Prisma migrations
migrate:
	@echo "Running Prisma migrations..."
	@cd apps/api && npx prisma migrate dev

# Seed the database
seed:
	@echo "Seeding database..."
	@cd apps/api && npm run prisma:seed

# Run migrations then seed
db-reset: migrate seed

# Stop all services
stop:
	@docker compose -f infra/docker-compose.dev.yml down

# Stop and remove volumes (destructive — wipes all data)
clean:
	@docker compose -f infra/docker-compose.dev.yml down -v
	@echo "All data volumes removed."

# View service logs
logs:
	@docker compose -f infra/docker-compose.dev.yml logs -f

# Build production Docker image
build:
	@docker compose -f infra/docker-compose.yml build

# Show help
help:
	@echo "Available commands:"
	@echo "  make dev           - Start infrastructure services + API (dev mode)"
	@echo "  make dev-services  - Start infrastructure services only"
	@echo "  make dev-api       - Start API only (services must be running)"
	@echo "  make install       - Install npm dependencies"
	@echo "  make migrate       - Run Prisma database migrations"
	@echo "  make seed          - Seed database with test data"
	@echo "  make db-reset      - Run migrations + seed"
	@echo "  make stop          - Stop all services"
	@echo "  make clean         - Stop and wipe all data volumes"
	@echo "  make logs          - Tail service logs"
	@echo "  make build         - Build production Docker image"
