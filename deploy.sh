#!/bin/bash

set -e

echo "===== PhotoViewer Deploy ====="

# -----------------------------
# Dockerネットワークの確認と作成
# -----------------------------
NETWORK_NAME="webnet"
echo "🔍 Checking Docker network '$NETWORK_NAME'..."
if ! docker network ls --format '{{.Name}}' | grep -q "^${NETWORK_NAME}\$"; then
  echo "➕ Creating Docker network '$NETWORK_NAME'..."
  docker network create "$NETWORK_NAME"
else
  echo "✅ Docker network '$NETWORK_NAME' already exists"
fi

# -----------------------------
# イメージの取得と起動
# -----------------------------
echo "🚀 Pulling latest images..."
docker compose -f frontend/docker-compose.yml pull
docker compose -f backend/docker-compose.prod.yml pull

echo "🔄 Restarting containers..."
docker compose -f frontend/docker-compose.yml up -d --remove-orphans
docker compose -f backend/docker-compose.prod.yml up -d --remove-orphans

# -----------------------------
# クリーンアップ
# -----------------------------
echo "🧹 Cleaning up unused Docker resources..."
docker system prune -f --volumes

echo "✅ Deployment complete!"
