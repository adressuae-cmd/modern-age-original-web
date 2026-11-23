#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
dest="game/original.xapk"
url="https://github.com/adressuae-cmd/modern-age-original-web/releases/download/original-v1.0.164/original.xapk"
if [[ -s "$dest" ]]; then
  (cd game && sha256sum -c SHA256SUMS) && exit 0
  echo "Existing file failed checksum; refusing to overwrite." >&2
  exit 1
fi
echo "Downloading user-provided original game asset from GitHub Release..."
mkdir -p game
if ! curl --fail --location --retry 3 --connect-timeout 20 --output "$dest.partial" "$url"; then
  rm -f "$dest.partial"
  echo "Release asset not found. Upload the original XAPK to the GitHub Release named original-v1.0.164 as original.xapk." >&2
  echo "https://github.com/adressuae-cmd/modern-age-original-web/releases/new" >&2
  exit 1
fi
mv "$dest.partial" "$dest"
(cd game && sha256sum -c SHA256SUMS) || { rm -f "$dest"; echo "Downloaded file checksum mismatch; removed." >&2; exit 1; }
echo "Verified original XAPK and ready for install."
