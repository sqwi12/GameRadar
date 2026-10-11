# Рисует иконку GameRadar: радар с засечкой на тёмном фоне.
# Запуск из папки app: python tool/make_icon.py
# Результат: assets/icon/{icon,foreground,background,notification}.png,
# из них flutter_launcher_icons делает иконки Android и iOS.
import math
import os

import numpy as np
from PIL import Image

S = 2048  # рисуем в 2 раза крупнее и уменьшаем — сглаживание краёв
OUT = 1024
os.makedirs('assets/icon', exist_ok=True)

y, x = np.mgrid[0:S, 0:S].astype(np.float32)
cx = cy = S / 2
dx, dy = x - cx, y - cy
r = np.hypot(dx, dy)
# Угол от «12 часов» по часовой стрелке, 0..360.
ang = (np.degrees(np.arctan2(dx, -dy)) + 360) % 360

TEAL = np.array([63, 216, 230], np.float32)
MINT = np.array([120, 255, 196], np.float32)


def over(dst, color, alpha):
    """Накладывает цвет с альфой (массив) на RGBA-изображение."""
    a = np.clip(alpha, 0, 1)[..., None]
    dst[..., :3] = dst[..., :3] * (1 - a) + color * a
    dst[..., 3:] = dst[..., 3:] * (1 - a) + 255 * a


def ring(radius, width, opacity):
    return np.clip(1 - np.abs(r - radius) / (width / 2), 0, 1) * opacity


def disc(px, py, radius):
    return np.clip(radius - np.hypot(x - px, y - py), 0, 1.5) / 1.5


def radar(img, k):
    """Радар; k — масштаб (для адаптивной иконки он меньше)."""
    for rad, op in ((240, 0.60), (440, 0.46), (640, 0.32)):
        over(img, TEAL, ring(rad * k, 18 * k, op))
    # Луч: конический градиент, ярче всего у ведущего края (угол 40°).
    lead, tail = 40.0, 110.0
    behind = (lead - ang) % 360
    sweep = np.clip(1 - behind / tail, 0, 1) ** 1.6
    sweep *= np.clip((700 * k - r) / (30 * k), 0, 1)
    over(img, TEAL, sweep * 0.62)
    # Ведущая кромка луча.
    edge = np.clip(1 - np.abs(((ang - lead + 180) % 360) - 180) * r * math.pi / 180 / (10 * k), 0, 1)
    over(img, TEAL, edge * np.clip((700 * k - r) / (30 * k), 0, 1) * 0.9)
    # Засечка — найденная скидка: яркая точка с ореолом.
    a = math.radians(20)
    bx, by = cx + 470 * k * math.sin(a), cy - 470 * k * math.cos(a)
    d = np.hypot(x - bx, y - by)
    over(img, MINT, np.exp(-(d / (120 * k)) ** 2) * 0.6)
    over(img, MINT, disc(bx, by, 68 * k))
    over(img, np.array([235, 255, 245], np.float32), disc(bx, by, 32 * k))
    # Центр.
    over(img, TEAL, disc(cx, cy, 38 * k))


def save(img, name):
    Image.fromarray(img.astype(np.uint8), 'RGBA').resize((OUT, OUT), Image.LANCZOS).save(f'assets/icon/{name}')


def background():
    img = np.zeros((S, S, 4), np.float32)
    t = np.clip((x + y) / (2 * S), 0, 1)[..., None]
    top, bottom = np.array([14, 30, 52], np.float32), np.array([3, 7, 16], np.float32)
    img[..., :3] = top * (1 - t) + bottom * t
    img[..., 3] = 255
    glow = np.exp(-(r / (S * 0.42)) ** 2) * 0.35
    over(img, np.array([10, 90, 110], np.float32), glow)
    return img


# Полная иконка (iOS и старые Android): фон + радар.
full = background()
radar(full, 1.0)
save(full, 'icon.png')

# Адаптивная иконка Android: фон отдельно, радар в безопасной зоне (66 из 108 dp)
# с учётом отступа 16%, который добавляет flutter_launcher_icons.
save(background(), 'background.png')
fg = np.zeros((S, S, 4), np.float32)
radar(fg, 1.3)  # утилита добавит отступ 16% с каждой стороны
save(fg, 'foreground.png')
print('ok')
