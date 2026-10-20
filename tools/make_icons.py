"""Generate launcher icons: adaptive foreground + legacy square icons."""
from PIL import Image, ImageDraw, ImageFont
import os

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
INK = (31, 26, 19, 255)
CREAM = (255, 244, 217, 255)
TOMATO = (255, 90, 54, 255)
YOLK = (255, 197, 61, 255)
# 画「¥」用的字体：按顺序找第一个存在的，也可以用环境变量 ICON_FONT 指定
FONT_CANDIDATES = [
    os.environ.get("ICON_FONT", ""),
    "/System/Library/Fonts/Hiragino Sans GB.ttc",                 # macOS
    "/System/Library/Fonts/STHeiti Medium.ttc",                   # 旧版 macOS
    "/usr/share/fonts/opentype/noto/NotoSansCJK-Black.ttc",       # Linux
    "C:/Windows/Fonts/msyhbd.ttc",                                # Windows
]
FONT = next((f for f in FONT_CANDIDATES if f and os.path.exists(f)), None)
if FONT is None:
    raise SystemExit("找不到可用的字体，请用环境变量 ICON_FONT 指定一个 .ttf/.ttc 文件")


def coin(size, scale):
    """Coin with ¥ centred on a transparent canvas; scale = coin diameter / size."""
    S = size * 4  # supersample
    im = Image.new("RGBA", (S, S), (0, 0, 0, 0))
    d = ImageDraw.Draw(im)
    r = S * scale / 2
    cx = cy = S / 2
    off = S * 0.035
    bw = S * 0.035
    d.ellipse([cx - r + off, cy - r + off, cx + r + off, cy + r + off], fill=INK)  # hard shadow
    d.ellipse([cx - r, cy - r, cx + r, cy + r], fill=INK)
    d.ellipse([cx - r + bw, cy - r + bw, cx + r - bw, cy + r - bw], fill=YOLK)
    ir = r * 0.78
    d.ellipse([cx - ir, cy - ir, cx + ir, cy + ir], outline=INK, width=int(S * 0.012))
    font = ImageFont.truetype(FONT, int(r * 1.15))
    box = d.textbbox((0, 0), "¥", font=font)
    w, h = box[2] - box[0], box[3] - box[1]
    d.text((cx - w / 2 - box[0], cy - h / 2 - box[1]), "¥", font=font, fill=INK)
    return im.resize((size, size), Image.LANCZOS)


def legacy(size):
    S = size * 4
    im = Image.new("RGBA", (S, S), (0, 0, 0, 0))
    d = ImageDraw.Draw(im)
    pad = S * 0.06
    d.rounded_rectangle([pad, pad, S - pad, S - pad], radius=S * 0.22, fill=TOMATO, outline=INK, width=int(S * 0.03))
    im = im.resize((size, size), Image.LANCZOS)
    c = coin(size, 0.62)
    im.alpha_composite(c)
    return im


densities = {"mdpi": 1, "hdpi": 1.5, "xhdpi": 2, "xxhdpi": 3, "xxxhdpi": 4}
for name, f in densities.items():
    d = os.path.join(ROOT, "res", f"mipmap-{name}")
    os.makedirs(d, exist_ok=True)
    legacy(int(48 * f)).save(os.path.join(d, "ic_launcher.png"))
    # adaptive foreground: 108dp canvas, art inside the 66dp safe zone
    coin(int(108 * f), 0.5).save(os.path.join(d, "ic_launcher_fg.png"))
print("icons done")
