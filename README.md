# WoWFisher

Аддон для рыбалки в World of Warcraft (Forever / Retail).

## Особенности
- 🎣 3 большие тач-френдли кнопки: **Забросить** / **Собрать** / **Наживка**
- 🔊 Звуковое оповещение на клюв + визуальная индикация (мигание)
- ⌨️ Бинды на клавиши (по умолчанию F1/F2/F3), настраиваются в меню
- 🖱 Перетаскивание мышью, масштаб 0.5–2.0, закрепление позиции
- 📍 Addon Compartment — иконка у миникарты

## Установка
1. Распакуй `WoWFisher.zip` или скопируй папку `WoWFisher` в:
   ```
   World of Warcraft/_forever_/Interface/AddOns/
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
3. Settings → On-screen controls → Add button ×3:
   - Кнопка 1 → `F1` (лево)
   - Кнопка 2 → `F2` (центр)
   - Кнопка 3 → `F3` (право)
4. Сделай кнопки крупными (1/3 ширины экрана)

### Этап 3: WoW бинды
| Слот | Клавиша | Спелл / Макрос |
|---|---|---|
| 1 | `F1` | **Рыбная ловля** |
| 2 | `F2` | **Взаимодействие** |
| 3 | `F3` | Макрос наживки: `/use [btn:1] Наживка` |

### Этап 4: Играй
Moonlight → коннект → тыкаешь кнопки на телефоне → кастуются спеллы.

---

## Troubleshooting
| Проблема | Решение |
|---|---|
| Moonlight не находит хост | Tailscale Online? Sunshine Network→Tailscale ✅? `Restart-Service sunshine` |
| Высокая задержка | Битрейт 15–20 Mbps, 720p, H.264; `tailscale ping <IP>` |
| Кнопки не нажимаются | Moonlight Mouse Mode → Relative; WoW Hardware Cursor ✅ |
| Нет звука | Sunshine Audio → Desktop Audio ✅; перезапуск Sunshine |
| Чёрный экран | Sunshine Capture Method → Desktop Duplication; WoW в Windowed Fullscreen |
| Tailscale отключается | iOS: Background App Refresh ✅; Android: Battery → Don't optimize |

---

## Публикация на CurseForge
1. Создай проект на authors.curseforge.com → WoW → Addons → Professions & Fishing
2. Получи Project ID (в About Project)
3. В `WoWFisher.toc`: `## X-Curse-Project-ID: ТВОЙ_ID`
4. GitHub репо + Secret `CF_API_KEY` (CurseForge API Token)
5. `git tag v1.0.0 && git push --tags` → GitHub Actions собирает и публикует

---

## Структура
```
WoWFisher/
├── WoWFisher.toc        # Interface: 16001, 120105
├── WoWFisher.lua        # Код аддона
├── .pkgmeta             # Настройки пакетера
├── README.md            # Этот файл
└── .github/workflows/
    └── release.yml      # CI/CD
```

## Лицензия
MIT