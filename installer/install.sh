#!/bin/sh
set -eu
XAPK=/game/original.xapk
DIR=/tmp/game-splits
DEVICE=android:5555
PACKAGE=com.oxiwyle.modernage
if [ ! -s "$XAPK" ]; then
  echo 'ERROR: original XAPK is missing. We do not substitute a recreated game.' >&2
  exit 1
fi
mkdir -p "$DIR"
unzip -t "$XAPK" >/dev/null
unzip -jo "$XAPK" 'com.oxiwyle.modernage.apk' 'config.arm64_v8a.apk' 'config.xxhdpi.apk' -d "$DIR"
for f in com.oxiwyle.modernage.apk config.arm64_v8a.apk config.xxhdpi.apk; do
  if [ ! -s "$DIR/$f" ]; then
    echo "ERROR: missing original split $f" >&2
    exit 1
  fi
done

i=0
until [ "$i" -ge 90 ]; do
  adb connect "$DEVICE" >/dev/null 2>&1 || true
  ready=$(adb -s "$DEVICE" shell getprop sys.boot_completed 2>/dev/null | tr -d '\r' || true)
  if [ "$ready" = 1 ]; then break; fi
  i=$((i+1))
  sleep 3
done
if [ "$i" -ge 90 ]; then
  echo 'ERROR: Android did not boot; see docker compose logs android' >&2
  exit 1
fi
ABI=$(adb -s "$DEVICE" shell getprop ro.product.cpu.abi | tr -d '\r')
echo "Android ABI: $ABI"
if [ "$ABI" != 'arm64-v8a' ]; then
  echo "ERROR: requires arm64-v8a. Got $ABI" >&2
  exit 1
fi

adb -s "$DEVICE" install-multiple -r \
  "$DIR/com.oxiwyle.modernage.apk" \
  "$DIR/config.arm64_v8a.apk" \
  "$DIR/config.xxhdpi.apk"
adb -s "$DEVICE" shell pm path "$PACKAGE"
echo 'Starting the untouched Modern Age application ...'
adb -s "$DEVICE" shell monkey -p "$PACKAGE" -c android.intent.category.LAUNCHER 1
printf '\nOriginal app install/launch command sent. Check the game in the browser and verify it stays running.\n'
