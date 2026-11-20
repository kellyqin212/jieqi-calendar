#!/bin/bash
# Build the unsigned simulator app and save screenshots.
# Today, the solar-term detail, the month, about, and the widgets use 2026-06-21 (夏至).
# The festival screen uses 2026-02-17 (春节).
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

WIDGET="$(find "${APP}/PlugIns" -type d -name "SuishiWidget.appex" -print -quit)"
if [ -z "${WIDGET}" ]; then
  echo "SuishiWidget.appex was not embedded." >&2
  exit 1
fi
app_count="$(find "${APP}/Illustrations" -name '*.jpg' | wc -l | tr -d ' ')"
widget_count="$(find "${WIDGET}/Illustrations" -name '*.jpg' | wc -l | tr -d ' ')"
app_bytes="$(find "${APP}/Illustrations" -name '*.jpg' -exec stat -f%z {} + | awk '{s+=$1} END {print s}')"
widget_bytes="$(find "${WIDGET}/Illustrations" -name '*.jpg' -exec stat -f%z {} + | awk '{s+=$1} END {print s}')"
echo "Illustrations app=${app_count} (${app_bytes} bytes) widget=${widget_count} (${widget_bytes} bytes)"
if [ "${app_count}" -ne 35 ] || [ "${widget_count}" -ne 35 ]; then
  echo "Expected 35 JPEG plates in the app and the widget." >&2
  exit 1
fi
if [ "${widget_bytes}" -ge "${app_bytes}" ]; then
  echo "Widget plates should be the downsampled copies." >&2
  exit 1
fi
if [ ! -f "${APP}/Illustrations/placeholder.png" ] || [ ! -f "${WIDGET}/Illustrations/placeholder.png" ]; then
  echo "placeholder.png is missing from the app or the widget." >&2
  exit 1
fi

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
  local date="$4"
  xcrun simctl terminate "${UDID}" app.suishi.calendar >/dev/null 2>&1 || true
  if ! xcrun simctl launch "${UDID}" app.suishi.calendar -screenshot "${screen}" -fixed-date "${date}"; then
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

launch_and_shot home "${ROOT}/screenshots/home.png" 15 2026-06-21
launch_and_shot term "${ROOT}/screenshots/term.png" 8 2026-06-21
launch_and_shot festival "${ROOT}/screenshots/festival.png" 8 2026-02-17
launch_and_shot month "${ROOT}/screenshots/month.png" 5 2026-06-21
launch_and_shot about "${ROOT}/screenshots/about.png" 5 2026-06-21
launch_and_shot widgets "${ROOT}/screenshots/widgets.png" 5 2026-06-21

for name in home term festival month about widgets; do
  if [ ! -s "${ROOT}/screenshots/${name}.png" ]; then
    echo "Missing screenshots/${name}.png" >&2
    exit 1
  fi
done
