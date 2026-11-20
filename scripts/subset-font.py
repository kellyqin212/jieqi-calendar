#!/usr/bin/env python3
"""Subset Source Han Serif CN Regular and rename it under the OFL.

Source is a Reserved Font Name, so a modified (subset) font must not be
called Source Han. The app registers the result as Jieqi Song.

Usage:
    python3 scripts/subset-font.py /path/to/SourceHanSerifCN-Regular.otf
"""

import subprocess
import sys
from pathlib import Path

from fontTools.ttLib import TTFont

ROOT = Path(__file__).resolve().parents[1]
OUTPUT = ROOT / "App" / "Resources" / "Fonts" / "JieqiSong-Regular.otf"

REQUIRED = "素历岁时立春夏至冬至闰五月初七丙午马蛇龙乙巳甲辰人工智能生成思源宋体清明端午中秋"


def collect_text() -> str:
    chars = set()
    chars.update(chr(code) for code in range(0x20, 0x7F))
    extras = "·・—…「」『』、。，！？：；～（）()《》【】“”‘’〇○"
    chars.update(extras)
    for path in ROOT.rglob("*"):
        if not path.is_file():
            continue
        if path.suffix.lower() not in {".swift", ".md", ".plist", ".txt", ".yml", ".storekit"}:
            continue
        if "build" in path.parts or path.suffix == ".otf":
            continue
        try:
            chars.update(path.read_text(encoding="utf-8"))
        except UnicodeError:
            continue
    for high in range(0xA1, 0xF8):
        for low in range(0xA1, 0xFF):
            try:
                chars.add(bytes([high, low]).decode("gb2312"))
            except UnicodeDecodeError:
                pass
    return "".join(sorted(chars))


def rename(font: TTFont) -> None:
    table = font["name"]
    copyrights = [record for record in table.names if record.nameID == 0]
    table.names = copyrights

    english = {
        1: "Jieqi Song",
        2: "Regular",
        3: "Jieqi Song Regular 0.1",
        4: "Jieqi Song Regular",
        6: "JieqiSong-Regular",
        16: "Jieqi Song",
        17: "Regular",
    }
    chinese = {
        1: "岁时宋",
        4: "岁时宋 Regular",
        16: "岁时宋",
    }
    for name_id, value in english.items():
        table.setName(value, name_id, 3, 1, 0x409)
        table.setName(value, name_id, 1, 0, 0)
    for name_id, value in chinese.items():
        table.setName(value, name_id, 3, 1, 0x804)


def main() -> None:
    if len(sys.argv) != 2:
        sys.exit("usage: subset-font.py SourceHanSerifCN-Regular.otf")
    source = Path(sys.argv[1])
    text_file = Path("/tmp/jieqi-font-chars.txt")
    text_file.write_text(collect_text(), encoding="utf-8")
    OUTPUT.parent.mkdir(parents=True, exist_ok=True)
    subprocess.check_call(
        [
            "pyftsubset",
            str(source),
            f"--text-file={text_file}",
            f"--output-file={OUTPUT}",
            "--layout-features=*",
            "--recommended-glyphs",
            "--name-IDs=*",
            "--drop-tables+=DSIG",
            "--notdef-outline",
        ]
    )
    font = TTFont(OUTPUT)
    rename(font)
    font.save(OUTPUT)
    font = TTFont(OUTPUT)
    cmap = font.getBestCmap() or {}
    missing = [char for char in REQUIRED if ord(char) not in cmap]
    if missing:
        sys.exit("missing glyphs: " + "".join(missing))
    print(f"wrote {OUTPUT} ({OUTPUT.stat().st_size} bytes, {len(cmap)} cmap entries)")


if __name__ == "__main__":
    main()
