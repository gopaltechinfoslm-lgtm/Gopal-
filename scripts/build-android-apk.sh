#!/usr/bin/env bash
set -Eeuo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ANDROID_DIR="$ROOT_DIR/android"
APK="$ANDROID_DIR/app/build/outputs/apk/debug/app-debug.apk"
DEST_DIR="$ROOT_DIR/dist-apk"
DEST="$DEST_DIR/salem-cluster-mis-debug.apk"
cd "$ROOT_DIR"

for command in node npm; do
  command -v "$command" >/dev/null 2>&1 || { echo "Error: $command is required." >&2; exit 1; }
done
if ! command -v java >/dev/null 2>&1; then
  echo 'Error: Java 17 is required. Install a JDK and configure JAVA_HOME.' >&2
  exit 1
fi
if [[ -z "${ANDROID_HOME:-}${ANDROID_SDK_ROOT:-}" ]]; then
  echo 'Error: Android SDK not found. Set ANDROID_HOME or ANDROID_SDK_ROOT.' >&2
  exit 1
fi

if [[ ! -x node_modules/.bin/cap ]]; then
  echo 'Installing npm dependencies...'
  npm install
fi

printf '%s\n' 'Building web assets...'
npm run build

if [[ ! -d "$ANDROID_DIR" ]]; then
  echo 'Creating native Android project...'
  npx cap add android
fi

printf '%s\n' 'Syncing Capacitor Android project...'
npx cap sync android

if [[ ! -f "$ANDROID_DIR/gradlew" ]]; then
  echo "Error: Gradle wrapper not found: $ANDROID_DIR/gradlew" >&2
  exit 1
fi
printf '%s\n' 'Building debug APK...'
(
  cd "$ANDROID_DIR"
  chmod +x ./gradlew
  ./gradlew assembleDebug
)

if [[ ! -f "$APK" ]]; then
  echo "Error: APK was not created at $APK" >&2
  exit 1
fi
mkdir -p "$DEST_DIR"
cp "$APK" "$DEST"
printf 'Build successful. APK: %s\n' "$DEST"
