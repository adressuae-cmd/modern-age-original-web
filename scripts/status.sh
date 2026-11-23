#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
echo '=== Containers ==='
docker compose ps
echo '=== Android startup messages ==='
docker compose logs --tail=40 android
echo '=== Web streamer messages ==='
docker compose logs --tail=40 web
echo '=== Web HTTP response (must be served through local port) ==='
if command -v curl >/dev/null; then curl -I --max-time 10 http://127.0.0.1:8000/ || true; fi
