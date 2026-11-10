# WoWFisher

Легальный аддон для рыбалки в World of Warcraft (Forever / Retail).

## Особенности
- 🎣 3 большие тач-френдли кнопки: **Забросить** / **Собрать** / **Наживка**
- 🔊 Звуковое оповещение на клюв + визуальная индикация (мигание)
- ⌨️ Бинды на клавиши (по умолчанию F1/F2/F3), настраиваются в меню
- 🖱 Перетаскивание мышью, масштаб 0.5–2.0, закрепление позиции
- 📍 Addon Compartment — иконка у миникарты
- ✅ **100% легально**: никакой автоматизации, только UI + бинды клавиш

## Установка
1. Распакуй `WoWFisher.zip` или скопируй папку `WoWFisher` в:
   ```
   World of Warcraft/_retail_/Interface/AddOns/
   ```
2. В игре: `/reload`
3. Аддон появится в центре экрана (немного ниже центра)

## Настройка аддона
| Действие | Команда / Способ |
|---|---|
| Разблокировать перетаскивание | `/wf unlock` |
| Закрепить | `/wf lock` |
| Сбросить позицию | `/wf reset` |
| Вкл/выкл звук клюва | `/wf sound` |
| Полное меню (масштаб, бинды, закреп) | **ПКМ по фрейму** |

### Бинды (по умолчанию)
- `F1` — Забросить удочку
- `F2` — Собрать улов / Взаимодействие
- `F3` — Нажать наживку

В меню (ПКМ) можно переназначить: нажми кнопку «нажми клавишу…» → нажми нужную клавишу.

---

## 📱 Подробная инструкция: Игра с телефона (Moonlight + Sunshine + Tailscale)

Этот способ даёт **минимальную задержку**, работает **через интернет** (не только локально), **бесплатен** и не требует GPU на сервере (стримит с твоего домашнего ПК).

### Почему именно этот стек?
| Компонент | Роль | Почему |
|---|---|---|
| **Tailscale** | WireGuard VPN mesh | Соединяет телефон и ПК через NAT без проброса портов, работает везде где есть интернет |
| **Sunshine** | Хост стриминга (на ПК) | Низкая латентность, H.264/HEVC/AV1, открытый исходный код, поддерживает Tailscale нативно |
| **Moonlight** | Клиент (на телефоне) | Официальный клиент для Sunshine, есть на iOS/Android, поддерживает тач-оверлеи |

---

### 🖥 Этап 1: Настройка ПК (хост)

#### 1.1 Установка Tailscale
```powershell
# В PowerShell (Admin)
winget install Tailscale.Tailscale
```
- Запусти Tailscale → авторизуйся (Google / Microsoft / GitHub / email)
- После входа: в меню Tailscale (трей) → **My IP addresses** → запомни адрес `100.x.y.z` (CGNAT, доступен только в твоей Tailnet)
- Включи **Exit node** (опционально, если хочешь весь трафик телефона через ПК)

#### 1.2 Установка Sunshine
```powershell
winget install LizardByte.Sunshine
```
- Запусти `Sunshine.exe` (в трее появится иконка солнца)
- Откроется браузер: **http://localhost:47989** (или `https://<твой-100.x.y.z>:47990` через Tailscale)
- **Первый вход**: задай логин/пароль для веб-интерфейса Sunshine
- **Settings → Network**:
  - ✅ **Tailscale** (включает автоматическое обнаружение Tailscale IP)
  - Port: `47989` (HTTP), `47990` (HTTPS) — не меняй
  - **Apply** → перезапуск службы
- **Settings → Video**:
  - Encoder: **HEVC (H.265)** — если телефон поддерживает (современные iPhone/Android да)
  - Bitrate: **30–50 Mbps** (для 1080p60), **15–25 Mbps** (для 720p60)
  - FPS: **60**
  - **Apply**
- **Settings → Audio**:
  - ✅ **Desktop Audio** (захват звука игры)
  - ✅ **Microphone** (если нужен голосовой чат)
  - **Apply**

#### 1.3 Перезапуск службы Sunshine (важно после смены сети)
```powershell
# В PowerShell (Admin)
Restart-Service sunshine
# Или через Services.msc → Sunshine → Restart
```

#### 1.4 Проверка
- Открой в браузере телефона (в Tailscale): `https://100.x.y.z:47990`
- Должен открыться веб-интерфейс Sunshine (прими самоподписанный сертификат)
- В логах Sunshine (Web UI → Logs) не должно быть ошибок

---

### 📱 Этап 2: Настройка телефона

#### 2.1 Tailscale
- **App Store / Play Market** → **Tailscale** → войди в **тот же аккаунт**
- Подключение к твоему ПК должно появиться автоматически (зелёная точка)
- Проверка: в приложении Tailscale → Devices → твой ПК → **Online**

#### 2.2 Moonlight
- **iOS**: App Store → **Moonlight Game Streaming** (официальный, бесплатный)
- **Android**: Play Store / F-Droid / GitHub Releases → **Moonlight**
- Запусти Moonlight → он сам найдёт хост через Tailscale (или добавь вручную: `100.x.y.z`)
- Нажми на хост → **Pair** → введи PIN из веб-интерфейса Sunshine (Settings → Pairing) или прими сертификат

#### 2.3 Настройка Moonlight для WoW
В Moonlight → **Settings** (шестерёнка хоста):
| Настройка | Рекомендация |
|---|---|
| **Resolution** | 1920×1080 (или 1280×720 если слабый канал) |
| **Frame Rate** | 60 FPS |
| **Bitrate** | 30–50 Mbps (HEVC) / 20–35 Mbps (H.264) |
| **Video Codec** | HEVC (H.265) — если телефон поддерживает |
| **Hardware Decoding** | ✅ Включено |
| **Mouse Mode** | **Relative** (как в игре) или **Absolute** (для тача) — попробуй оба |
| **On-Screen Controls** | ✅ Включено (настроим ниже) |
| **Touch to Mouse** | ✅ Для кликов по экрану |

#### 2.4 Создание тач-оверлея (экранные кнопки)
В Moonlight → хост → **On-Screen Controls** → **Edit Layout** → **Add Button** ×3:

| Кнопка | Назначение | Позиция | Размер |
|---|---|---|---|
| **1. Cast** | `F1` | Лево-низу | Крупно (под большой палец) |
| **2. Loot** | `F2` | Центр-низу | Крупно |
| **3. Bait** | `F3` | Право-низу | Крупно |

**Детали настройки каждой кнопки:**
- **Action Type**: `Keyboard` → `Key Press` → `F1` / `F2` / `F3`
- **Style**: `Circle` или `Rounded Square`
- **Opacity**: `70–80%` (чтобы видеть игру под кнопкой)
- **Color**: золотой/оранжевый (видно на фоне воды)
- **Haptic Feedback**: ✅ Включено (вибрация при нажатии)

> 💡 **Совет**: Сделай кнопки **очень большими** (1/3 ширины экрана каждая) — попавание пальцем гарантировано, даже если смотришь на поплавок.

#### 2.5 Тест подключения
1. В Moonlight → нажми на хост → **Start Streaming**
2. Должен появиться рабочий стол ПК
3. Запусти WoW на ПК (или уже запущена)
4. Проверь: нажатие экранной кнопки `F1` → в игре срабатывает бинд

---

### ⚙️ Этап 3: Настройка WoW (бинд клавиш)

В игре: **Esc → Key Bindings → Action Bar** (или используй аддон типа Bartender):

| Слот панели | Клавиша | Спелл / Макрос |
|---|---|---|
| **1** (или любой) | `F1` | **Рыбалка** (spell: `Рыбная ловля`) |
| **2** | `F2` | **Взаимодействие** (Interact / Лут) |
| **3** | `F3` | **Наживка** — макрос: `/use [btn:1] Наживка` или просто положи наживку в слот и забинди его |

**Макрос для наживки (вставь в макрос, забинди на F3):**
```lua
/use [btn:1] Яркая наживка
/use [btn:1] Наживка для ледяной воды
/use [btn:1] Наживка
/click StaticPopup1Button1
```
(Подставит первую имеющуюся наживку в сумках)

---

### 🎮 Этап 4: Игровой процесс

1. **На ПК**: WoW запущена, персонаж у водоёма, удочка в руке
2. **На телефоне**: Moonlight → коннект → видишь экран ПК
3. **Рыбалка**:
   - Нажимаешь экранную кнопку **Cast (F1)** → персонаж закидывает удочку
   - Ждёшь клюв → **звук + мигает кнопка Loot в аддоне**
   - Нажимаешь **Loot (F2)** → собираешь улов
   - Наживка съедена → нажимаешь **Bait (F3)** → новая наживка
4. Повторяешь — **руки свободны, смотришь в телефон, играешь легально**

---

### 🔧 Troubleshooting / Частые проблемы

| Проблема | Решение |
|---|---|
| **Moonlight не находит хост** | Проверь: Tailscale на телефоне = Online; Sunshine Web UI → Network → Tailscale ✅; перезапусти службу `Restart-Service sunshine` |
| **Высокая задержка / лаги** | Понизь битрейт до 15–20 Mbps, разрешение 720p, кодек H.264; проверь ping в Tailscale (`tailscale ping <IP>`) |
| **Кнопки не нажимаются в игре** | В Moonlight: Mouse Mode → **Relative**; в WoW: Interface → Mouse → **Hardware Cursor** ✅; проверь бинды в игре |
| **Нет звука** | Sunshine Settings → Audio → Desktop Audio ✅; перезапуск Sunshine; в Moonlight Settings → Audio → ✅ Enable |
| **Чёрный экран / игра не захватывается** | Sunshine → Settings → Video → **Capture Method**: `Desktop Duplication` (или `WGC` для Win10/11); запуск WoW в **Windowed Fullscreen** |
| **Tailscale отключается на телефоне** | iOS: Settings → Tailscale → Background App Refresh ✅; Android: Battery Optimization → Tailscale → Don't optimize |
| **Сертификат не принимается** | В Moonlight: длинное нажатие на хост → **Forget** → переподключись; или зайди в браузере на `https://100.x.y.z:47990` → прими сертификат → вернись в Moonlight |

---

### 📊 Ориентировочные требования к каналу
| Качество | Битрейт | Пинг (Tailscale) | Минимум вверх (ПК) |
|---|---|---|---|
| 1080p60 HEVC | 30–50 Mbps | < 30 ms | 60 Mbps |
| 1080p60 H.264 | 40–60 Mbps | < 30 ms | 70 Mbps |
| 720p60 HEVC | 15–25 Mbps | < 50 ms | 30 Mbps |
| 720p60 H.264 | 20–35 Mbps | < 50 ms | 40 Mbps |

> 💡 **Мобильный интернет (4G/5G)** — обычно 20–100 Mbps вверх, пинг 20–60 ms через Tailscale → **720p60 HEVC идеален**.

---

## Публикация на CurseForge

### 1. Создай проект
https://authors.curseforge.com → Create Project → WoW → Addons → Professions & Fishing

### 2. Получи Project ID
В сайдбаре "About Project" → числовой ID (не slug в URL)

### 3. Обнови TOC
В `WoWFisher.toc` замени `YOUR_PROJECT_ID_HERE` на полученный ID.

### 4. GitHub репозиторий
```bash
cd WoWFisher
git init
git add .
git commit -m "Initial commit"
# Создай репо на GitHub и push
```

### 5. GitHub Secrets
Settings → Secrets and variables → Actions → New repository secret:
- `CF_API_KEY` — из CurseForge Author Dashboard → API Tokens
- (опционально) `WAGO_API_TOKEN`, `WOWI_API_TOKEN`

### 6. Релиз
```bash
git tag v1.0.0
git push --tags
```
GitHub Actions соберёт zip, заменит `@project-version@`, зальёт на CurseForge / Wago / WoWInterface и создаст GitHub Release.

---

## Структура проекта
```
WoWFisher/
├── WoWFisher.toc        # Манифест (с метаданными для пакетера)
├── WoWFisher.lua        # Код аддона
├── .pkgmeta             # Настройки пакетера
├── README.md            # Этот файл
└── .github/workflows/
    └── release.yml      # CI/CD pipeline
```

---

## Лицензия
MIT — делай что хочешь, но не нарушай ToS Blizzard.

---

## 📞 Поддержка
- Issues: https://github.com/qqva/wowfishing/issues
- CurseForge: страница проекта (комментарии)
- Discord: (добавь если есть)