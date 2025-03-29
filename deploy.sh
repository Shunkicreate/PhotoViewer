#!/bin/bash

echo "🚀 Pulling latest images..."
docker compose -f frontend/docker-compose.yml pull
docker compose -f backend/docker-compose.prod.yml pull

echo "🔄 Restarting containers..."
docker compose -f frontend/docker-compose.yml up -d --remove-orphans
docker compose -f backend/docker-compose.prod.yml up -d --remove-orphans

echo "🧹 Cleaning up unused Docker resources..."
docker system prune -f --volumes

echo "✅ Deployment complete!"
