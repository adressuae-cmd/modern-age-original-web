#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
docker compose stop
printf 'Stopped. Android save data kept in docker volume.\n'
