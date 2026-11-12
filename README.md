# WoWFisher

Аддон для рыбалки в World of Warcraft (Forever / Retail).

## Особенности
- 🎣 **Одна огромная кнопка** «Забросить (0)» — 360×140 px, идеально для пальца
- 🔊 Звук на клюв + мигание кнопки
- 🖱 Перетаскивание, масштаб 0.5–2.0, закрепление
- 📍 Addon Compartment — иконка у миникарты

## Установка
1. Распакуй `WoWFisher.zip` или скопируй папку `WoWFisher` в:
   ```
   World of Warcraft/_forever_/Interface/AddOns/
   ```
2. В игре: `/reload`
3. Аддон появится в центре экрана (немного ниже центра)

## Настройка
| Действие | Команда |
|---|---|
| Разблокировать перетаскивание | `/wf unlock` |
| Закрепить | `/wf lock` |
| Сбросить позицию | `/wf reset` |
| Вкл/выкл звук клюва | `/wf sound` |
| Меню | **ПКМ по фрейму** |

---

## 📱 Игра с телефона (Moonlight + Sunshine + Tailscale)

### Этап 1: ПК (хост)
```powershell
winget install Tailscale.Tailscale
winget install LizardByte.Sunshine
```
1. Tailscale: авторизуйся, запомни IP `100.x.y.z`
2. Sunshine: http://localhost:47989 → пароль → Network: **Tailscale** ✓ → Apply
3. `Restart-Service sunshine` (PowerShell Admin)

### Этап 2: Телефон
1. Tailscale (тот же аккаунт) → подключится к ПК
2. Moonlight → добавь хост по `100.x.y.z` → прими сертификат
3. Settings → On-screen controls → **Add button ×1**:
   - Кнопка → `0` (крупно, по центру)
4. Сделай кнопку очень большой (почти весь низ экрана)

### Этап 3: WoW бинды
В игре: **Esc → Key Bindings → Action Bar**
- Слот 1 → клавиша **`0`** → спелл **Рыбная ловля**

### Этап 4: Играй
Moonlight → коннект → тыкаешь огромную кнопку на телефоне → кастуется Рыбалка.

---

## Troubleshooting
| Проблема | Решение |
|---|---|
| Moonlight не находит хост | Tailscale Online? Sunshine Network→Tailscale ✅? `Restart-Service sunshine` |
| Высокая задержка | Битрейт 15–20 Mbps, 720p, H.264; `tailscale ping <IP>` |
| Кнопка не нажимается | Moonlight Mouse Mode → Relative; WoW Hardware Cursor ✅ |
| Нет звука | Sunshine Audio → Desktop Audio ✅; перезапуск Sunshine |
| Чёрный экран | Sunshine Capture Method → Desktop Duplication; WoW в Windowed Fullscreen |

---

## Структура
```
WoWFisher/
├── WoWFisher.toc        # Interface: 16001, 120105
├── WoWFisher.lua        # Код аддона
├── .pkgmeta
├── README.md
└── .github/workflows/
    └── release.yml
```

## Лицензия
MIT