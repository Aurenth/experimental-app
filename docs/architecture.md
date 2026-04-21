# Architecture

## Monorepo Layout

```
experimental-app/
├── apps/
│   ├── mobile/          # Flutter 3.x mobile app (Riverpod, GoRouter, RevenueCat)
│   └── api/             # NestJS 10 backend (Prisma, PostgreSQL, Redis)
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

---

## Flutter App — `apps/mobile`

### Technology Choices

| Concern | Library | Version | Rationale |
|---------|---------|---------|-----------|
| State management | Riverpod | ^2.5 | Code-gen, compile-time safety, no BuildContext dependency |
| Navigation | GoRouter | ^14 | Typed routes, deep linking, web support |
| Networking | Dio | ^5.4 | Interceptors for JWT refresh, cancellation tokens |
| Crash reporting | Sentry | ^8 | Source maps, performance tracing, release health |
| In-app purchases | RevenueCat | ^7 | Cross-platform, one-time purchases + consumables |
| Analytics | PostHog | ^4 | Privacy-first, self-hostable, feature flags |
| Local storage | Hive | ^2.2 | Offline-first key-value + typed boxes |
| Serialisation | Freezed + json_serializable | ^2.5 / ^6.8 | Immutable models, union types |

### Folder Structure

```
lib/
├── main.dart              # Default entry (→ prod)
├── main_dev.dart          # Dev flavour entry
├── main_staging.dart      # Staging flavour entry
├── main_prod.dart         # Prod flavour entry
│
├── app/
│   ├── app.dart           # Root MaterialApp.router
│   └── router.dart        # GoRouter with typed routes + auth redirect guard
│
├── core/
│   ├── config/
│   │   └── app_config.dart      # Immutable per-flavour config (API URL, DSNs, keys)
│   ├── di/
│   │   └── providers.dart       # Root Riverpod providers
│   ├── network/
│   │   ├── dio_client.dart      # Configured Dio instance
│   │   └── auth_interceptor.dart # JWT attach + transparent refresh on 401
│   ├── storage/
│   │   └── hive_service.dart    # Hive init + typed box accessors
│   └── utils/
│       └── bootstrap.dart       # Shared startup: Hive, Sentry, RevenueCat, PostHog
│
├── features/
│   └── <feature>/
│       ├── data/          # Repository impl, remote/local sources, DTOs
│       ├── domain/        # Entities, repository interfaces, use cases
│       └── presentation/  # Screens, notifiers (Riverpod), widgets
│
└── shared/
    ├── theme/
    │   └── app_theme.dart  # Material 3 light/dark themes
    └── widgets/            # Reusable UI components
```

### Flavours

Three flavours are configured, each with its own:
- API base URL
- Sentry DSN
- RevenueCat API key
- PostHog project key

| Flavour | Android build variant | iOS xcconfig | Main entry |
|---------|-----------------------|--------------|------------|
| dev | `devDebug` | `dev.xcconfig` | `main_dev.dart` |
| staging | `stagingDebug` / `stagingRelease` | `staging.xcconfig` | `main_staging.dart` |
| prod | `prodRelease` | `prod.xcconfig` | `main_prod.dart` |

**Run commands:**
```bash
# Dev
flutter run --flavor dev -t lib/main_dev.dart

# Staging
flutter run --flavor staging -t lib/main_staging.dart

# Prod build
flutter build apk --flavor prod -t lib/main_prod.dart
flutter build ipa --flavor prod -t lib/main_prod.dart
```

### Network Layer

`DioClient` wraps Dio with:
- Per-environment `baseUrl` from `AppConfig`
- `AuthInterceptor` that attaches `Authorization: Bearer <access_token>` and
  transparently refreshes on 401 (single-flight — no concurrent refresh)
- `PrettyDioLogger` in debug mode only

### State Management Patterns

All providers are generated via `riverpod_generator`. Run:
```bash
dart run build_runner watch --delete-conflicting-outputs
```

Feature state uses `@riverpod` annotated `AsyncNotifier` or `Notifier` subclasses.
Global ephemeral state (e.g. auth token) uses `StateProvider`.

### Auth Flow

1. App starts → `AppRouter` checks `authTokenProvider`
2. Token absent → redirect to `/login`
3. User signs in → `AuthNotifier.signIn` sets token in `authTokenProvider`
4. Token persisted to `HiveService.authBox` (encrypted via `flutter_secure_storage` key)
5. API calls → `AuthInterceptor` attaches token
6. 401 → interceptor calls `AuthNotifier.refreshToken`; on failure → `signOut`

---

## Backend Stack — `apps/api`

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
