#!/usr/bin/env python3
"""Print the UDID of an available iPhone simulator, preferring recent devices."""

import json
import subprocess
import sys

preferred = [
    "iPhone 16",
    "iPhone 16 Pro",
    "iPhone 15",
    "iPhone 17",
    "iPhone 14",
    "iPhone 16 Plus",
    "iPhone 15 Pro",
]

raw = subprocess.check_output(["xcrun", "simctl", "list", "devices", "available", "-j"])
data = json.loads(raw)
devices = []
for runtime, items in data.get("devices", {}).items():
    if "iOS" not in runtime:
        continue
    for device in items:
        name = device.get("name", "")
        if device.get("isAvailable") and name.startswith("iPhone"):
            devices.append((name, device["udid"], runtime))

if not devices:
    sys.stderr.write("No available iPhone simulators.\n")
    sys.exit(1)

for wanted in preferred:
    for name, udid, runtime in devices:
        if name == wanted:
            print(udid)
            sys.exit(0)

print(devices[0][1])
