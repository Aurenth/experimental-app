#!/usr/bin/env bash
# Seed the database with test data

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"

cd "$ROOT_DIR/apps/api"

echo "Seeding database..."
npm run prisma:seed
echo "Done."
