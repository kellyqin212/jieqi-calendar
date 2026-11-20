#!/bin/bash
# Pin the compiler used by GitHub Actions. Xcode 16.4 matches the iOS 17
# deployment target without jumping to the Xcode 26 toolchain.
set -euo pipefail

if [ -d /Applications/Xcode_16.4.app ]; then
  sudo xcode-select -s /Applications/Xcode_16.4.app
elif [ -d /Applications/Xcode_16.4.0.app ]; then
  sudo xcode-select -s /Applications/Xcode_16.4.0.app
else
  echo "Xcode 16.4 is not installed on this image. Using $(xcode-select -p)."
fi

xcodebuild -version
