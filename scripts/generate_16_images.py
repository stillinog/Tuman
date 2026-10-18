from pathlib import Path
import random
from PIL import Image, ImageDraw

# ===== Config =====
OUTPUT_DIR = Path(__file__).resolve().parent.parent / "img"
OUTPUT_DIR.mkdir(parents=True, exist_ok=True)
random.seed(42)

# ===== Helpers =====
def fog(name: str, dots: int = 0, lines: int = 0, size: tuple[int, int] = (1024, 1024)):
    img = Image.new("RGB", size, (10, 10, 15))
    d = ImageDraw.Draw(img)

    for _ in range(5000):
        x = random.randint(0, size[0] - 1)
        y = random.randint(0, size[1] - 1)
        g = random.randint(10, 30)
        d.point((x, y), fill=(g, g, g + 5))

    for _ in range(dots):
        x = random.randint(100, size[0] - 100)
        y = random.randint(100, size[1] - 100)
        d.ellipse([x - 3, y - 3, x + 3, y + 3], fill=(126, 184, 218))

    for i in range(lines):
        y = 200 + i * 200
        d.line([(100, y), (size[0] - 100, y)], fill=(126, 184, 218), width=2)

    img.save(OUTPUT_DIR / f"{name}.jpg", quality=85)


def cell(name: str, color: tuple[int, int, int], size: tuple[int, int] = (256, 256)):
    img = Image.new("RGB", size, color)
    img.save(OUTPUT_DIR / f"{name}.jpg", quality=85)

# ===== 16 images =====
fog("01_slepy")
fog("02_idushchiy", dots=1)
fog("03_ishchiy", dots=3)
fog("04_znayushchiy", lines=1)
fog("05_pamyatuyushchiy", lines=2)
fog("06_molchavshiy", lines=1)
fog("07_bereg", lines=1)

cell("08_dry", (42, 42, 58))
cell("09_water", (26, 58, 92))
cell("10_fire", (92, 42, 26))
cell("11_scar", (58, 58, 58))
cell("12_silence", (10, 10, 18))

img = Image.new("RGB", (1024, 512), (10, 10, 15))
d = ImageDraw.Draw(img)
for _ in range(3000):
    x = random.randint(0, 1023)
    y = random.randint(0, 511)
    g = random.randint(10, 30)
    d.point((x, y), fill=(g, g, g + 5))
img.save(OUTPUT_DIR / "15_fog.jpg", quality=85)

img = Image.new("RGB", (512, 512), (10, 10, 15))
d = ImageDraw.Draw(img)
d.ellipse([246, 246, 266, 266], fill=(224, 224, 224))
img.save(OUTPUT_DIR / "16_logo.jpg", quality=85)

img = Image.new("RGB", (256, 256), (42, 42, 58))
d = ImageDraw.Draw(img)
for i in range(5):
    x = 20 + i * 50
    d.rectangle([x, 100, x + 40, 140], fill=(126, 184, 218))
img.save(OUTPUT_DIR / "13_redut.jpg", quality=85)

img = Image.new("RGB", (256, 256), (10, 10, 15))
d = ImageDraw.Draw(img)
d.rectangle([40, 80, 100, 140], fill=(126, 184, 218))
d.rectangle([156, 80, 216, 140], fill=(218, 126, 184))
img.save(OUTPUT_DIR / "14_meeting.jpg", quality=85)

print(f"Generated 16 files in {OUTPUT_DIR}")
