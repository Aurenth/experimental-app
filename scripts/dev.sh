#!/usr/bin/env bash
# Start everything locally for development

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"

cd "$ROOT_DIR"

# Create .env from example if not exists
if [ ! -f .env ]; then
  echo "Creating .env from .env.example..."
  cp .env.example .env
fi

# Start infrastructure services
echo "Starting infrastructure services..."
docker compose -f infra/docker-compose.dev.yml --env-file .env up -d

echo "Waiting for services to be healthy..."
sleep 5

# Run migrations
echo "Running Prisma migrations..."
cd apps/api
npx prisma migrate dev

# Start API in dev mode
echo ""
echo "Starting NestJS API..."
echo "  API:     http://localhost:3000"
echo "  Swagger: http://localhost:3000/api"
echo "  Health:  http://localhost:3000/health"
echo ""
npm run start:dev
