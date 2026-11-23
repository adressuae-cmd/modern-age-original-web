#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
if ! command -v docker >/dev/null; then
  echo 'ERROR: Docker is not installed. Requires ARM64 Linux with Android binder kernel support.' >&2
  exit 1
fi
if ! docker compose version >/dev/null 2>&1; then
  echo 'ERROR: Docker Compose plugin is missing.' >&2
  exit 1
fi
arch="$(uname -m)"
if [[ "$arch" != "aarch64" && "$arch" != "arm64" ]]; then
  echo "ERROR: This XAPK is arm64-v8a; choose a native ARM64 host. Current: $arch" >&2
  exit 1
fi
if [[ ! -f game/original.xapk ]]; then
  echo 'ERROR: place the original game XAPK at game/original.xapk.' >&2
  exit 1
fi
if [[ -f game/SHA256SUMS ]]; then
  ( cd game && sha256sum --check SHA256SUMS )
fi
echo 'Starting native ARM64 Android and browser streaming services...'
docker compose up -d android web
echo 'Installing the three unmodified original APK splits...'
docker compose --profile setup run --rm --build install_game
echo 'Ready for user-side test: http://127.0.0.1:8000 (on the ARM64 host)'
echo 'If connecting from iPhone, use a private authenticated HTTPS tunnel (for example Tailscale Serve).'
