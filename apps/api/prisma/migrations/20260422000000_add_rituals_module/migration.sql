-- CreateTable
CREATE TABLE "rituals" (
    "id" TEXT NOT NULL,
    "slug" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "nameHi" TEXT,
    "description" TEXT,
    "category" TEXT NOT NULL,
    "tradition" TEXT NOT NULL,
    "language" TEXT NOT NULL DEFAULT 'hi',
    "isFree" BOOLEAN NOT NULL DEFAULT true,
    "durationMinutes" INTEGER,
    "imageUrl" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "rituals_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ritual_steps" (
    "id" TEXT NOT NULL,
    "ritualId" TEXT NOT NULL,
    "order" INTEGER NOT NULL,
    "title" TEXT NOT NULL,
    "titleHi" TEXT,
    "description" TEXT,
    "descHi" TEXT,

    CONSTRAINT "ritual_steps_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "samagri" (
    "id" TEXT NOT NULL,
    "ritualId" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "nameHi" TEXT,
    "quantity" TEXT,
    "optional" BOOLEAN NOT NULL DEFAULT false,

    CONSTRAINT "samagri_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "user_entitlements" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "tradition" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "user_entitlements_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "rituals_slug_key" ON "rituals"("slug");

-- CreateIndex
CREATE INDEX "rituals_category_idx" ON "rituals"("category");

-- CreateIndex
CREATE INDEX "rituals_tradition_idx" ON "rituals"("tradition");

-- CreateIndex
CREATE INDEX "rituals_isFree_idx" ON "rituals"("isFree");

-- CreateIndex
CREATE UNIQUE INDEX "user_entitlements_userId_tradition_key" ON "user_entitlements"("userId", "tradition");

-- AddForeignKey
ALTER TABLE "ritual_steps" ADD CONSTRAINT "ritual_steps_ritualId_fkey" FOREIGN KEY ("ritualId") REFERENCES "rituals"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "samagri" ADD CONSTRAINT "samagri_ritualId_fkey" FOREIGN KEY ("ritualId") REFERENCES "rituals"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "user_entitlements" ADD CONSTRAINT "user_entitlements_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;
