#!/usr/bin/env python3
"""Draw the neutral placeholder illustration and the app icon.

Neither image contains text. The placeholder is a paper texture used only
when a plate is missing. It does not replace the JPEG plates.
"""

from pathlib import Path

from PIL import Image, ImageDraw, ImageFilter

ROOT = Path(__file__).resolve().parents[1]
ILLUSTRATIONS = ROOT / "App" / "Resources" / "Illustrations"
ICON = ROOT / "App" / "Resources" / "Assets.xcassets" / "AppIcon.appiconset" / "AppIcon.png"


def paper(width: int, height: int, seed: int) -> Image.Image:
    del seed
    base = Image.new("RGB", (width, height), (243, 228, 205))
    noise = Image.effect_noise((width, height), 10).convert("L")
    noise = noise.filter(ImageFilter.GaussianBlur(radius=0.8))
    grain = Image.merge("RGB", (noise, noise, noise))
    return Image.blend(base, grain, 0.07)


def write_placeholder() -> None:
    image = paper(768, 1280, seed=24)
    draw = ImageDraw.Draw(image, "RGBA")
    draw.ellipse((180, 360, 620, 800), fill=(196, 154, 112, 28))
    image = image.filter(ImageFilter.GaussianBlur(radius=0.4))
    ILLUSTRATIONS.mkdir(parents=True, exist_ok=True)
    image.save(ILLUSTRATIONS / "placeholder.png", optimize=True)


def write_icon() -> None:
    image = paper(1024, 1024, seed=7)
    draw = ImageDraw.Draw(image)
    draw.ellipse((300, 168, 724, 592), fill=(214, 146, 78))
    draw.line((150, 820, 430, 690, 640, 760, 900, 640), fill=(48, 38, 30), width=22, joint="curve")
    draw.line((640, 760, 760, 900), fill=(48, 38, 30), width=16)
    ICON.parent.mkdir(parents=True, exist_ok=True)
    image.save(ICON, optimize=True)


if __name__ == "__main__":
    write_placeholder()
    write_icon()
    print(f"wrote {ILLUSTRATIONS / 'placeholder.png'}")
    print(f"wrote {ICON}")
