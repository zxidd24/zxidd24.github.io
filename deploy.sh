## 更新脚本 执行 ./deploy.sh 即可部署到 GitHub Pages

#!/usr/bin/env bash
set -euo pipefail

# One-click deploy script for ZZX-HomePage
# Usage:
#   ./deploy.sh
# Environment overrides:
#   REPO_URL  - target repo (default: https://github.com/zxidd24/zxidd24.github.io.git)
#   BRANCH    - target branch (default: main)
#   MSG       - commit message (default: timestamped)

REPO_URL=${REPO_URL:-https://github.com/zxidd24/zxidd24.github.io.git}
BRANCH=${BRANCH:-main}
MSG=${MSG:-"Deploy: $(date '+%Y-%m-%d %H:%M:%S')"}

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$ROOT_DIR"

echo "[deploy] Building project..."
npm run build

echo "[deploy] Preparing dist git repo..."
cd dist

# init or ensure branch exists
if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  git checkout -B "$BRANCH"
else
  if git init -b "$BRANCH" >/dev/null 2>&1; then
    :
  else
    git init >/dev/null 2>&1
    git checkout -B "$BRANCH"
  fi
fi

# avoid Jekyll interference on GitHub Pages
touch .nojekyll

# ensure basic git identity
git config user.email >/dev/null 2>&1 || git config user.email "actions@users.noreply.github.com"
git config user.name  >/dev/null 2>&1 || git config user.name  "Local Deployer"

echo "[deploy] Committing build artifacts..."
git add -A
if git commit -m "$MSG"; then
  echo "[deploy] Commit created."
else
  echo "[deploy] Nothing to commit, continuing..."
fi

echo "[deploy] Setting remote and pushing..."
git remote remove origin >/dev/null 2>&1 || true
git remote add origin "$REPO_URL"
git push -u origin "$BRANCH"

echo "[deploy] Done. Visit: https://zxidd24.github.io (首次或变更后需等待 1-2 分钟刷新)"