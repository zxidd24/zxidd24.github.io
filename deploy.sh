#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$ROOT_DIR"

echo "[deploy] Building project..."
npm run build

touch dist/.nojekyll

echo "[deploy] Committing and pushing to main..."
git add -A
if git commit -m "Deploy: $(date '+%Y-%m-%d %H:%M:%S')"; then
  echo "[deploy] Commit created."
else
  echo "[deploy] Nothing to commit, continuing..."
fi

git push origin main

echo "[deploy] Done. Visit: https://zxidd24.github.io (等待 1-2 分钟刷新)"
