#!/usr/bin/env bash
# tmp test helper for HexStrike AI container build and smoke test
set -euo pipefail

IMAGE_NAME="hexstrike-ai:dev"
CONTAINER_NAME="hexstrike-ai-test"
PORT="8888"

# Build args allow toggling optional deps
BUILD_ARGS=(
  --build-arg INSTALL_PLAYWRIGHT_DEPS=false
  --build-arg INSTALL_BROWSER_DEPS=true
)

echo "[1/5] Building Docker image: ${IMAGE_NAME}"
docker build "${BUILD_ARGS[@]}" -t "$IMAGE_NAME" .

# Ensure no leftover container
if docker ps -a --format '{{.Names}}' | grep -q "^${CONTAINER_NAME}$"; then
  echo "[i] Removing existing container ${CONTAINER_NAME}"
  docker rm -f "$CONTAINER_NAME" >/dev/null 2>&1 || true
fi

echo "[2/5] Running container in the background"
docker run -d --name "$CONTAINER_NAME" -p ${PORT}:${PORT} -e HEXSTRIKE_PORT=${PORT} "$IMAGE_NAME"

# Wait for health endpoint to respond
echo "[3/5] Waiting for health endpoint..."
for i in {1..40}; do
  if curl -sf "http://127.0.0.1:${PORT}/health" >/dev/null; then
    echo "[ok] Health endpoint is up"
    break
  fi
  sleep 2
  if [[ "$i" -eq 40 ]]; then
    echo "[x] Server did not become healthy in time" >&2
    docker logs "$CONTAINER_NAME" || true
    exit 1
  fi
done

# Basic smoke tests
echo "[4/5] Running smoke tests"
set -x
curl -sf "http://127.0.0.1:${PORT}/health" | sed -e 's/.*/[health] &/'
# Example POST to an intelligence endpoint that should exist, but allow failure if feature deps missing
curl -s -X POST "http://127.0.0.1:${PORT}/api/intelligence/select-tools" \
  -H "Content-Type: application/json" \
  -d '{"target_profile": {"technologies": ["nginx", "react"], "type": "web"}}' || true
set +x

# Cleanup
echo "[5/5] Stopping and removing container"
docker rm -f "$CONTAINER_NAME" >/dev/null 2>&1 || true

echo "[done] Docker image built and basic tests completed: ${IMAGE_NAME}"
