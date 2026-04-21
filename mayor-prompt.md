# Mayor Briefing — experimental-app

> Paste the block below verbatim into the Mayor session after running `gt mayor attach`.

---

## MISSION BRIEF

You are the Mayor of this Gas Town workspace. Your mandate is to **research, design, architect, and build a production-quality mobile application** that will generate significant passive and active revenue for its owner — targeting crores of Indian rupees.

This is a **full-cycle autonomous mission**. You will:
1. Research the Indian market deeply
2. Generate and validate a unique, monetisable app idea
3. Design the full technical architecture
4. Spawn polecats to implement it
5. Wire everything up so the app runs locally end-to-end

Do not stop for approval between phases unless you need an API key or a credential. All other decisions are yours to make.

---

## PHASE 1 — DEEP INDIAN MARKET RESEARCH

Before writing a single line of code, spend serious time researching. Use web search, browse Indian news sources, startup databases (Inc42, YourStory, Tracxn), government data (MCA21, RBI reports, DPIIT), and Reddit/Quora India threads.

**Research axes — cover ALL of these:**

### Demographic & Behavioural Signals
- Tier-2 and Tier-3 city digital adoption curves (UPI penetration outside metros)
- Gen-Z and millennial spending patterns on apps (average session time, willingness to pay)
- Vernacular language usage and demand for regional-language-first apps
- Smartphone model distribution (budget Android dominance, mid-range iOS growth)
- Mobile data cost vs usage patterns (JioFiber, BSNL, Airtel pricing)

### Economic & Regulatory Gaps
- Sectors where digital penetration is <30% but demand is high (agriculture, MSME, skilled trades, healthcare Tier-2+, logistics last-mile)
- SEBI, RBI, FSSAI, MCA regulatory whitespacesthat protect a first mover
- GST composition scheme complexity for small traders — are they underserved by current apps?
- ONDC (Open Network for Digital Commerce) opportunities not yet exploited by consumer apps
- PM Vishwakarma and artisan/craftsperson digitisation — are 30M+ artisans digitally excluded?
- Gig worker financial infrastructure gaps (Swiggy/Zomato partners, construction daily wage, domestic workers)

### Cultural & Social Behaviour Gaps
- Trust-based commerce (family referrals, community buying groups — India's oral commerce)
- Wedding, festival, and ritual planning complexity at Tier-2/3 scale
- Exam culture: UPSC, SSC, JEE, NEET — coaching vs peer learning gap
- Health: Ayurveda, home remedies, preventive wellness vs reactive medical care
- Real estate rental opacity outside metro cities (no MagicBricks equivalent for villages and qasbahs)

### What Currently Exists — Map the Landscape
- List the top 5–10 apps in each gap area you identify
- For each competitor: DAU/MAU estimate, revenue model, 1-star review themes (= unmet needs), ratings trend
- Identify markets where the leader has <4.0 stars or <500K installs despite high latent demand

---

## PHASE 2 — IDEA GENERATION AND SELECTION

After research, generate **at least 10 candidate app ideas**. For each idea produce a scorecard:

| Dimension | Score (1–10) | Rationale |
|-----------|-------------|-----------|
| Market size (TAM in INR) | | |
| Uniqueness / defensibility | | |
| Revenue potential (Year 1, Year 3 projections) | | |
| Technical feasibility in Flutter + NestJS | | |
| Time to MVP (weeks) | | |
| Regulatory risk | | |
| User willingness to pay (one-time + micro-tx) | | |
| Network effect potential | | |

**Hard filters — an idea must pass ALL of these:**
- NOT a me-too clone of Swiggy, Zepto, Urban Company, BYJU's, PhonePe, or any app with >10M installs
- The core problem MUST be solvable entirely within a mobile app (not hardware-dependent)
- Must support the **revenue model below** natively — not bolted on
- Must be implementable by a small team without a physical operations layer
- Must have a clear reason why it hasn't been built yet (regulatory change, new API, cultural shift, technology maturity)

**Revenue Model (non-negotiable constraints):**
- One-time purchase / unlock fee to access the app's core value
- In-app micro-transactions for enhancements, boosts, or premium features (à la carte, not subscription)
- NO recurring subscriptions
- NO ads as primary revenue (ads may be optional/secondary)
- The model must make economic sense at ₹99–₹499 one-time price point for India

**Select the single highest-scoring idea.** Write a 500-word "Investment Thesis" for it covering:
- The problem in vivid detail (user persona, pain point, current workaround)
- Why now (what changed in India in the last 2 years that makes this possible)
- Revenue mechanics (unit economics: CAC estimate, ARPU, LTV)
- Why a Flutter app with NestJS backend is the right stack
- What the MVP feature set is (10 features max)
- What the V1 monetisation triggers are (what actions cost micro-transaction credits)

---

## PHASE 3 — TECHNICAL ARCHITECTURE

Once the idea is selected, design the full system before coding starts.

### Flutter (Frontend)
- Flutter 3.x, Dart 3.x, null-safe
- State management: **Riverpod** (preferred) or Bloc — choose based on app complexity, justify the choice
- Navigation: **GoRouter**
- UI framework: Custom design system (no cookie-cutter Material widgets) — modern, Indian-aesthetic-aware, fast 60/120fps on mid-range Android
- Offline-first where applicable (Hive or Drift for local persistence)
- Flavours: `dev`, `staging`, `prod`
- In-app purchase integration: **RevenueCat** (cross-platform, handles one-time purchases + consumables)
- Push notifications: **Firebase Cloud Messaging**
- Analytics: **PostHog** (self-hosted or cloud) — not Firebase Analytics (privacy-first)
- Crash reporting: **Sentry**

### NestJS (Backend)
- NestJS 10+ with TypeScript strict mode
- Database: **PostgreSQL** (primary) + **Redis** (cache, queues, sessions)
- ORM: **Prisma**
- Auth: **JWT + Refresh tokens**, optional Google/Apple OAuth
- File storage: **MinIO** (local dev, S3-compatible for prod)
- Queue: **BullMQ** on Redis
- Payments: **Razorpay** (one-time charges + orders API) — Indian-first
- Push: **Firebase Admin SDK**
- API: **REST** with OpenAPI/Swagger, optionally **GraphQL** for complex data graphs
- Validation: **class-validator + class-transformer** on all DTOs
- Rate limiting, Helmet, CORS properly configured
- Environment config via `@nestjs/config` with Joi validation schema

### Infrastructure (local-first, prod-ready structure)
- **Docker Compose** for all local services: Postgres, Redis, MinIO, the NestJS API
- The Flutter app points to `localhost` API in dev flavour
- Makefile or shell scripts for one-command local startup: `make dev`
- `.env.example` with all variables documented (no real secrets committed)
- Database migrations via Prisma Migrate
- Seed script to populate test data for local testing

### Monorepo Layout
```
experimental-app/
├── apps/
│   ├── mobile/          # Flutter app
│   └── api/             # NestJS backend
├── packages/
│   └── shared-types/    # Shared TS types/interfaces (optional)
├── infra/
│   ├── docker-compose.yml
│   ├── docker-compose.dev.yml
│   └── postgres/
│       └── init.sql
├── scripts/
│   ├── dev.sh           # Start everything locally
│   └── seed.sh          # Seed DB with test data
├── .env.example
├── Makefile
└── README.md
```

### API Design
- Design and document all API endpoints before implementation
- OpenAPI spec committed to repo
- Auth endpoints: register, login, refresh, logout
- Core domain endpoints (derived from selected idea)
- Payment endpoints: create order, verify payment, webhook handler
- User profile + settings endpoints

---

## PHASE 4 — UI/UX DESIGN SYSTEM

Before writing Flutter code, define the design system:

**Visual Identity:**
- Choose a distinctive colour palette (NOT generic blue/white — think about what resonates with Indian aesthetic: warm tones, high contrast for outdoor visibility, bold typography)
- Typography: Use Google Fonts — pick a primary (display) and secondary (body) font pairing
- Design tokens: spacing scale, border radii, shadow elevations, animation durations
- Dark mode support from day one

**Core UI Patterns:**
- Custom bottom navigation with haptic feedback
- Skeleton loaders (never spinner-only)
- Pull-to-refresh with branded animation
- Empty states with illustration and CTA
- Error states with retry
- Micro-animations on key interactions (purchase completion, achievement unlock)
- Onboarding flow (max 3 screens, value-first)
- Paywall screen (one-time purchase) — must feel premium and trustworthy

**Performance Targets:**
- Cold start < 2 seconds on a Redmi Note 11 (Snapdragon 680)
- List views use `ListView.builder` / `SliverList` — no `ListView(children:[])`
- Images via `cached_network_image` with proper cache sizing
- Avoid `setState` at root widget level
- Widget rebuild profiling before shipping each screen

---

## PHASE 5 — IMPLEMENTATION (POLECAT DISPATCH)

Break the implementation into beads (issues) and dispatch polecats. Suggested breakdown:

**Backend beads:**
- `ea-001`: Project scaffold — NestJS init, Prisma setup, Docker Compose, env config
- `ea-002`: Auth module — register, login, JWT, refresh token rotation
- `ea-003`: Core domain module #1 (based on selected idea)
- `ea-004`: Core domain module #2
- `ea-005`: Payments module — Razorpay integration, webhook, entitlement system
- `ea-006`: Push notifications module — FCM integration
- `ea-007`: Seed script + migration + full local test pass

**Frontend beads:**
- `ea-008`: Flutter scaffold — project init, GoRouter, Riverpod, flavours, Sentry, RevenueCat
- `ea-009`: Design system — theme, tokens, reusable components library
- `ea-010`: Onboarding + Auth screens (register, login, forgot password)
- `ea-011`: Core domain screen #1
- `ea-012`: Core domain screen #2
- `ea-013`: Core domain screen #3
- `ea-014`: Paywall + one-time purchase flow (RevenueCat + Razorpay fallback)
- `ea-015`: Micro-transaction screens (credit packs, feature unlocks)
- `ea-016`: Profile + settings screen
- `ea-017`: Polish pass — animations, empty states, error states, skeleton loaders
- `ea-018`: Integration test — Flutter app talking to local NestJS API end-to-end

Use `mountain` convoy label for epic-scale autonomous execution of all beads.

---

## PHASE 6 — LOCAL RUN VERIFICATION

The definition of done is:
1. `make dev` starts Postgres, Redis, MinIO, and NestJS API via Docker Compose
2. NestJS API is healthy at `http://localhost:3000/health`
3. Swagger UI is accessible at `http://localhost:3000/api`
4. Flutter app in dev flavour connects to `localhost:3000`
5. User can register, log in, reach the paywall screen, and navigate core features
6. All API calls succeed end-to-end (no mocked responses in dev)

**API keys needed (do NOT hardcode — use .env.example and ask the user):**
- `RAZORPAY_KEY_ID` + `RAZORPAY_KEY_SECRET` — ask user when payment module starts
- `FCM_SERVICE_ACCOUNT_JSON` — ask user when push notifications module starts
- `REVENUECAT_PUBLIC_KEY` (iOS + Android) — ask user when paywall screen starts
- `SENTRY_DSN` — ask user (optional for local, but needed for staging)

Everything else (Postgres, Redis, MinIO, JWT secrets, internal configs) must be auto-generated or use local defaults so the app runs without any external account.

---

## WORKING STYLE DIRECTIVES

- **Momentum over perfection**: Ship each bead, get it green, move on. Perfect is the enemy of shipped.
- **No orphan work**: Every bead you close must have its code committed and pushed.
- **Escalate blockers immediately**: If you hit a dependency (missing API key, ambiguous requirement), escalate via `gt escalate -s HIGH` and continue on the next unblocked bead.
- **Research depth = revenue**: The quality of the idea directly determines the app's earning potential. Do not rush Phase 1 and 2. A weak idea well-executed still fails. A strong idea is defensible.
- **Indian-first, not India-adapted**: Do not take a Western app idea and localise it. Design for India from the ground up — UPI, vernacular, Tier-2 behaviour, mobile-first, low-bandwidth resilience.
- **Document as you go**: Every module gets a short README. The top-level README must have one-command local setup instructions by the time you're done.
- **Ask for API keys last**: Complete all architecture, scaffolding, and non-payment/non-push features first. When a module that needs a key is ready to be wired up, ask the user for that specific key.

---

## SUCCESS CRITERIA

You have succeeded when:
1. The idea thesis is documented and convincing — if shown to 10 Indian users in the target demographic, at least 7 would say "I would pay for this"
2. The full architecture is documented in `docs/architecture.md`
3. The app runs locally with `make dev` and the Flutter app connects to the local API
4. The paywall flow is implemented (even with test/sandbox Razorpay keys)
5. At least 3 core user journeys work end-to-end
6. The codebase is clean enough that a new developer can read it and contribute in <1 hour

**The owner's financial goal: build an app that generates ₹1 crore+ in its first year through one-time purchases and in-app micro-transactions, with a clear path to ₹10 crore by Year 3.**

Begin with Phase 1. Research deeply. Then present the 10 ideas with scorecards before selecting one. The owner trusts your judgment — make it count.
