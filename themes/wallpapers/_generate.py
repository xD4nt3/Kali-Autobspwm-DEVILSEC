#!/usr/bin/env python3
"""
DEVILSEC · wallpaper generator
Generates four 1920x1080 wallpapers with subtle DMC-inspired motifs:

  1. limbo.png     — base sigil over deep onyx with violet bleed
  2. inferno.png   — radial ember + crimson cracks
  3. purgatory.png — fog + dim moon, very minimal
  4. ascend.png    — vertical light shaft + circular sigil
"""
from PIL import Image, ImageDraw, ImageFilter, ImageFont
import math, random, os

W, H = 1920, 1080
OUT = os.path.dirname(os.path.abspath(__file__))

# ─── Palette ──────────────────────────────────────────────────────────────────
ONYX     = (14, 11, 18)
ONYX_2   = (22, 18, 28)
ASH      = (120, 120, 140)
FOG      = (200, 200, 215)
CRIMSON  = (220, 38, 65)
BLOOD    = (139, 0, 30)
VIOLET   = (138, 43, 226)
PURPLE   = (88, 28, 135)
EMBER    = (255, 94, 77)
GOLD     = (212, 175, 55)

# ─── Helpers ─────────────────────────────────────────────────────────────────
def vignette(im, strength=0.75):
    """Soft radial dark vignette."""
    mask = Image.new("L", im.size, 0)
    md = ImageDraw.Draw(mask)
    for i in range(0, 300, 2):
        alpha = int(strength * 255 * (i / 300))
        md.ellipse(
            (-i, -i, W + i, H + i),
            outline=alpha,
            width=2,
        )
    mask = mask.filter(ImageFilter.GaussianBlur(radius=120))
    dark = Image.new("RGB", im.size, (0, 0, 0))
    im.paste(dark, mask=mask)
    return im

def radial_gradient(size, inner, outer, center=None, radius=None):
    w, h = size
    if center is None: center = (w // 2, h // 2)
    if radius is None: radius = math.hypot(w, h) / 2
    im = Image.new("RGB", size, outer)
    px = im.load()
    cx, cy = center
    for y in range(h):
        for x in range(w):
            d = math.hypot(x - cx, y - cy) / radius
            d = min(1.0, max(0.0, d))
            r = int(inner[0] * (1 - d) + outer[0] * d)
            g = int(inner[1] * (1 - d) + outer[1] * d)
            b = int(inner[2] * (1 - d) + outer[2] * d)
            px[x, y] = (r, g, b)
    return im

def linear_gradient_vertical(size, top, bottom):
    w, h = size
    im = Image.new("RGB", size, top)
    px = im.load()
    for y in range(h):
        t = y / (h - 1)
        r = int(top[0] * (1 - t) + bottom[0] * t)
        g = int(top[1] * (1 - t) + bottom[1] * t)
        b = int(top[2] * (1 - t) + bottom[2] * t)
        for x in range(w):
            px[x, y] = (r, g, b)
    return im

def noise(size, amount=12):
    im = Image.new("L", size)
    px = im.load()
    for y in range(size[1]):
        for x in range(size[0]):
            px[x, y] = random.randint(0, amount)
    return im.convert("RGB")

def draw_sigil(draw, cx, cy, r, color, line_w=2):
    """
    A subtle DMC-inspired sigil: outer ring + inverted-pentacle hint + inner ring.
    Not literal pentagram (too obvious / triggering for some). Instead: a ring of
    five small notches around a circle, with a single vertical accent — a calm,
    runic feel.
    """
    # outer ring
    draw.ellipse((cx - r, cy - r, cx + r, cy + r), outline=color, width=line_w)
    # inner ring
    inner = int(r * 0.70)
    draw.ellipse((cx - inner, cy - inner, cx + inner, cy + inner),
                 outline=color, width=max(1, line_w - 1))
    # five notches on the outer ring
    for i in range(5):
        ang = -math.pi / 2 + i * (2 * math.pi / 5)
        x1 = cx + math.cos(ang) * r
        y1 = cy + math.sin(ang) * r
        x2 = cx + math.cos(ang) * (r + 18)
        y2 = cy + math.sin(ang) * (r + 18)
        draw.line((x1, y1, x2, y2), fill=color, width=line_w)
    # vertical bar across the centre, but soft (thinner)
    draw.line((cx, cy - r, cx, cy + r), fill=color, width=max(1, line_w - 1))
    # central dot
    d = max(3, line_w * 2)
    draw.ellipse((cx - d, cy - d, cx + d, cy + d), fill=color)

def draw_cracks(draw, n=8, start_min=0.3, color=BLOOD, alpha_im=None):
    """A few stylised lightning/crack lines starting from upper area."""
    for _ in range(n):
        x = random.randint(int(W * 0.15), int(W * 0.85))
        y = random.randint(0, int(H * start_min))
        path = [(x, y)]
        for _ in range(random.randint(6, 12)):
            x += random.randint(-40, 40)
            y += random.randint(15, 50)
            path.append((x, y))
            if y > H: break
        for i in range(len(path) - 1):
            draw.line((path[i], path[i+1]), fill=color, width=2)

# ─── 1. Limbo ────────────────────────────────────────────────────────────────
def make_limbo():
    im = radial_gradient((W, H), ONYX_2, ONYX, center=(W//2, int(H*0.45)))
    # subtle violet bleed from one corner
    bleed = Image.new("RGB", (W, H), ONYX)
    bd = ImageDraw.Draw(bleed)
    bd.ellipse((-400, -400, 700, 700), fill=PURPLE)
    bleed = bleed.filter(ImageFilter.GaussianBlur(320))
    im = Image.blend(im, bleed, 0.30)

    draw = ImageDraw.Draw(im, "RGBA")
    # huge faint sigil, centre
    draw_sigil(draw, W // 2, H // 2 + 30, 260, (138, 43, 226, 38), line_w=2)
    # smaller mirror sigil, off-centre
    draw_sigil(draw, int(W * 0.78), int(H * 0.82), 80, (220, 38, 65, 30), line_w=1)
    # noise
    nz = noise((W, H), amount=8)
    im = Image.blend(im, nz, 0.05)
    im = vignette(im, strength=0.6)
    im.save(os.path.join(OUT, "limbo.png"), "PNG", optimize=True)
    print("✓ limbo.png")

# ─── 2. Inferno ──────────────────────────────────────────────────────────────
def make_inferno():
    im = radial_gradient((W, H), (40, 12, 16), ONYX, center=(W//2, H//2),
                        radius=W*0.7)
    # Embers (small bright dots, scattered)
    draw = ImageDraw.Draw(im, "RGBA")
    random.seed(7)
    for _ in range(140):
        x = random.randint(0, W)
        y = random.randint(int(H * 0.4), H)
        r = random.randint(1, 3)
        c = random.choice([(255, 94, 77, 200), (220, 38, 65, 200), (212, 175, 55, 160)])
        draw.ellipse((x - r, y - r, x + r, y + r), fill=c)
    # Heat haze blur on lower half
    bottom = im.crop((0, H // 2, W, H)).filter(ImageFilter.GaussianBlur(2))
    im.paste(bottom, (0, H // 2))
    # Big faint sigil
    draw_sigil(draw, W // 2, H // 2, 320, (220, 38, 65, 26), line_w=2)
    # Cracks
    draw_cracks(draw, n=6, color=(139, 0, 30, 80))
    im = vignette(im, strength=0.7)
    im.save(os.path.join(OUT, "inferno.png"), "PNG", optimize=True)
    print("✓ inferno.png")

# ─── 3. Purgatory ────────────────────────────────────────────────────────────
def make_purgatory():
    # very dim, cold purple
    im = linear_gradient_vertical((W, H), (10, 8, 16), (8, 6, 12))
    draw = ImageDraw.Draw(im, "RGBA")
    # dim moon
    cx, cy, r = int(W * 0.78), int(H * 0.22), 110
    moon = Image.new("RGBA", (W, H), (0, 0, 0, 0))
    md = ImageDraw.Draw(moon)
    md.ellipse((cx - r, cy - r, cx + r, cy + r), fill=(220, 220, 235, 90))
    moon = moon.filter(ImageFilter.GaussianBlur(8))
    im.paste(moon, (0, 0), moon)
    # halo
    halo = Image.new("RGBA", (W, H), (0, 0, 0, 0))
    hd = ImageDraw.Draw(halo)
    hd.ellipse((cx - r*2, cy - r*2, cx + r*2, cy + r*2), fill=(138, 43, 226, 30))
    halo = halo.filter(ImageFilter.GaussianBlur(80))
    im.paste(halo, (0, 0), halo)
    # fog bands (low contrast horizontal strips)
    for i in range(3):
        y = int(H * (0.45 + i * 0.18))
        band = Image.new("RGBA", (W, 80), (0, 0, 0, 0))
        bd = ImageDraw.Draw(band)
        bd.rectangle((0, 0, W, 80), fill=(120, 120, 140, 18))
        band = band.filter(ImageFilter.GaussianBlur(40))
        im.paste(band, (0, y), band)
    # subtle small sigil bottom-left
    draw = ImageDraw.Draw(im, "RGBA")
    draw_sigil(draw, int(W * 0.18), int(H * 0.78), 70, (138, 43, 226, 50), line_w=1)
    im = vignette(im, strength=0.5)
    im.save(os.path.join(OUT, "purgatory.png"), "PNG", optimize=True)
    print("✓ purgatory.png")

# ─── 4. Ascend ───────────────────────────────────────────────────────────────
def make_ascend():
    im = linear_gradient_vertical((W, H), (8, 6, 14), (20, 14, 28))
    draw = ImageDraw.Draw(im, "RGBA")
    # central light shaft (vertical)
    shaft = Image.new("RGBA", (W, H), (0, 0, 0, 0))
    sd = ImageDraw.Draw(shaft)
    # diagonal soft beam
    for i, alpha in enumerate(range(40, 0, -2)):
        sd.polygon([(W//2 - 8 - i, 0), (W//2 + 8 + i, 0),
                    (W//2 + 80 + i*2, H), (W//2 - 80 - i*2, H)],
                   fill=(138, 43, 226, alpha))
    shaft = shaft.filter(ImageFilter.GaussianBlur(40))
    im.paste(shaft, (0, 0), shaft)
    # Sigil centred where the beam narrows
    draw_sigil(draw, W // 2, int(H * 0.55), 180, (220, 38, 65, 50), line_w=2)
    # tiny stars
    random.seed(13)
    for _ in range(80):
        x, y = random.randint(0, W), random.randint(0, int(H * 0.45))
        a = random.randint(40, 180)
        draw.ellipse((x, y, x + 1, y + 1), fill=(232, 227, 242, a))
    im = vignette(im, strength=0.55)
    im.save(os.path.join(OUT, "ascend.png"), "PNG", optimize=True)
    print("✓ ascend.png")

if __name__ == "__main__":
    make_limbo()
    make_inferno()
    make_purgatory()
    make_ascend()
    print("\nDone. Wallpapers generated in:", OUT)
