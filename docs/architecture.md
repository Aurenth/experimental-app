# Architecture

## Monorepo Layout

```
experimental-app/
├── apps/
│   ├── mobile/          # Flutter app (Riverpod, GoRouter, RevenueCat)
│   └── api/             # NestJS backend (Prisma, PostgreSQL, Redis)
├── packages/
│   └── shared-types/    # Shared TypeScript types (optional)
├── infra/
│   ├── docker-compose.yml      # Production compose
│   ├── docker-compose.dev.yml  # Dev compose (infra only)
│   └── postgres/
│       └── init.sql     # PostgreSQL init script
├── scripts/
│   ├── dev.sh           # Start everything locally
│   └── seed.sh          # Seed DB with test data
├── docs/
│   └── architecture.md  # This file
├── .env.example         # All environment variables documented
├── Makefile             # One-command local setup
└── README.md
```

## Backend Stack (apps/api)

| Layer | Technology |
|-------|-----------|
| Framework | NestJS 10+ |
| Language | TypeScript (strict mode) |
| ORM | Prisma 5 |
| Database | PostgreSQL 16 |
| Cache / Queues | Redis 7 + BullMQ |
| File Storage | MinIO (S3-compatible) |
| Auth | JWT + Refresh token rotation |
| Validation | class-validator + class-transformer |
| Config | @nestjs/config + Joi schema validation |
| API Docs | Swagger / OpenAPI (at /api) |
| Health Check | @nestjs/terminus (at /health) |
| Payments | Razorpay (one-time charges + orders) |
| Push | Firebase Admin SDK + FCM |
| Security | Helmet, CORS, rate limiting |

## Frontend Stack (apps/mobile)

| Layer | Technology |
|-------|-----------|
| Framework | Flutter 3.x |
| Language | Dart 3.x (null-safe) |
| State Management | Riverpod |
| Navigation | GoRouter |
| Local DB | Hive / Drift (offline-first) |
| Purchases | RevenueCat |
| Push | Firebase Cloud Messaging |
| Analytics | PostHog |
| Crash Reporting | Sentry |
| HTTP | Dio |

## Infrastructure (local dev)

All services are run via Docker Compose:

| Service | Port | Purpose |
|---------|------|---------|
| PostgreSQL | 5432 | Primary database |
| Redis | 6379 | Cache, queues, sessions |
| MinIO | 9000 | Object storage (S3-compatible) |
| MinIO Console | 9001 | MinIO web UI |
| NestJS API | 3000 | Backend API |

## Key Endpoints

| Endpoint | Description |
|----------|-------------|
| `GET /health` | Service health check (Terminus) |
| `GET /api` | Swagger UI |
| `POST /auth/register` | User registration |
| `POST /auth/login` | Login + JWT issuance |
| `POST /auth/refresh` | Refresh token rotation |
| `POST /auth/logout` | Invalidate refresh token |

## Environment Configuration

All config lives in `.env` (from `.env.example`). The NestJS app validates
all env vars at startup via Joi — missing required vars cause a hard crash
with a clear error message.

## Local Development

```bash
# One-command start (installs services + starts API)
make dev

# Or step by step:
make dev-services   # Start Postgres, Redis, MinIO
make install        # Install npm deps
make migrate        # Run Prisma migrations
make dev-api        # Start API in watch mode
```

The API will be available at:
- API:     http://localhost:3000
- Swagger: http://localhost:3000/api
- Health:  http://localhost:3000/health

## Database Migrations

Migrations are managed by Prisma Migrate:

```bash
# Create and apply a new migration
make migrate

# Apply existing migrations (no new migration file)
cd apps/api && npx prisma migrate deploy

# View/edit data via Prisma Studio
cd apps/api && npx prisma studio
```

## Security Notes

- JWT secrets must be generated with `openssl rand -base64 64`
- Never commit `.env` (gitignored)
- All secrets are in `.env.example` as placeholders only
- MinIO default credentials are for local dev only — change in production
