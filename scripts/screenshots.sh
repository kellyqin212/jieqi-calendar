#!/bin/bash
# Build the unsigned simulator app and save four screenshots.
# Fixed date is 2026-06-21, the day of 夏至, so the home screen shows that illustration.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

if ! command -v xcodegen >/dev/null 2>&1; then
  echo "xcodegen is not installed. On the runner: brew install xcodegen" >&2
  exit 1
fi

xcodegen generate

UDID="$(python3 scripts/select-simulator.py)"
echo "Using simulator ${UDID}"

DERIVED="${ROOT}/build/DerivedData"
xcodebuild build \
  -project Suishi.xcodeproj \
  -scheme Suishi \
  -configuration Debug \
  -destination "platform=iOS Simulator,id=${UDID}" \
  -destination-timeout 180 \
  -derivedDataPath "${DERIVED}" \
  -skipMacroValidation \
  -skipPackagePluginValidation \
  CODE_SIGNING_ALLOWED=NO \
  CODE_SIGNING_REQUIRED=NO \
  CODE_SIGN_IDENTITY=""

APP="$(find "${DERIVED}/Build/Products" -type d -name "Suishi.app" -path "*iphonesimulator*" -print -quit)"
if [ -z "${APP}" ]; then
  echo "Suishi.app was not produced." >&2
  exit 1
fi
echo "App: ${APP}"

xcrun simctl boot "${UDID}" || true
xcrun simctl bootstatus "${UDID}" -b

xcrun simctl install "${UDID}" "${APP}"
xcrun simctl status_bar "${UDID}" override \
  --time "9:41" \
  --batteryState charged \
  --batteryLevel 100 \
  --cellularMode active \
  --cellularBars 4 \
  --wifiMode active \
  --wifiBars 3 || true

mkdir -p "${ROOT}/screenshots"

launch_and_shot() {
  local screen="$1"
  local output="$2"
  local pause="$3"
  xcrun simctl terminate "${UDID}" app.suishi.calendar >/dev/null 2>&1 || true
  if ! xcrun simctl launch "${UDID}" app.suishi.calendar -screenshot "${screen}" -fixed-date 2026-06-21; then
    echo "Failed to launch ${screen}" >&2
    xcrun simctl spawn "${UDID}" log show --last 2m --style compact | tail -n 100 || true
    exit 1
  fi
  sleep "${pause}"
  xcrun simctl io "${UDID}" screenshot "${output}"
  bytes="$(stat -f%z "${output}")"
  if [ "${bytes}" -lt 20000 ]; then
    sleep 6
    xcrun simctl io "${UDID}" screenshot "${output}"
  fi
  echo "Wrote ${output}"
}

launch_and_shot home "${ROOT}/screenshots/home.png" 15
launch_and_shot month "${ROOT}/screenshots/month.png" 5
launch_and_shot about "${ROOT}/screenshots/about.png" 5
launch_and_shot widgets "${ROOT}/screenshots/widgets.png" 5
