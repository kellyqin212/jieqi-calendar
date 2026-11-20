#!/bin/bash
# Build the widget copies of the plates.
# The app ships 768x1280 JPEGs. A widget extension is killed if it spends too
# much memory, and decoding one full plate is about 4 MB. These copies are
# 480x800, which still covers the medium widget at 3x.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SRC="${ROOT}/App/Resources/Illustrations"
DST="${ROOT}/Widget/Resources/Illustrations"
mkdir -p "${DST}"

if ! command -v ffmpeg >/dev/null 2>&1; then
  echo "ffmpeg is required to rebuild the widget plates." >&2
  exit 1
fi

count=0
for source in "${SRC}"/*.jpg; do
  name="$(basename "${source}")"
  ffmpeg -y -loglevel error -i "${source}" -vf "scale=480:800:flags=lanczos" -q:v 3 "${DST}/${name}"
  count=$((count + 1))
done

cp "${SRC}/placeholder.png" "${DST}/placeholder.png"
echo "Wrote ${count} widget plates to ${DST}"
