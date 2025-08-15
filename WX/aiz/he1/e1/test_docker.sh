#!/usr/bin/env bash
set -euo pipefail

IMAGE_NAME="hexstrike-ai:local"
CONTAINER_NAME="hexstrike-ai-test"
PORT="8888"

# Build the image
echo "[1/4] Building image..."
docker build -t "$IMAGE_NAME" .

# Run the container in background
echo "[2/4] Starting container..."
docker rm -f "$CONTAINER_NAME" >/dev/null 2>&1 || true
docker run -d --name "$CONTAINER_NAME" -p ${PORT}:8888 "$IMAGE_NAME"

# Wait for health endpoint
echo "[3/4] Waiting for health..."
for i in {1..40}; do
  if curl -sf http://127.0.0.1:${PORT}/health >/dev/null; then
    echo "Service healthy"
    break
  fi
  sleep 2
  if [ $i -eq 40 ]; then
    echo "Service did not become healthy in time" >&2
    docker logs "$CONTAINER_NAME" || true
    exit 1
  fi
done

# Hit a couple endpoints
echo "[4/4] Testing endpoints..."
set -x
curl -sSf http://127.0.0.1:${PORT}/health | head -c 200 && echo
curl -sSf -X POST http://127.0.0.1:${PORT}/api/intelligence/analyze-target \
  -H 'Content-Type: application/json' \
  -d '{"target":"https://example.com"}' | head -c 200 && echo
set +x

# Print last logs and stop
echo "Container logs (tail):"
docker logs --tail 50 "$CONTAINER_NAME" || true

# Stop and remove
docker rm -f "$CONTAINER_NAME" >/dev/null 2>&1 || true

echo "Test completed successfully"