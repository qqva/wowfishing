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

## Настройка
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

## Игра с телефона (Moonlight + Sunshine + Tailscale)

### На ПК (хост)
```powershell
winget install Tailscale.Tailscale
winget install LizardByte.Sunshine
```
1. Tailscale: авторизуйся, запомни IP `100.x.y.z`
2. Sunshine: http://localhost:47989 → пароль → Network: **Tailscale** ✓ → Apply → `Restart-Service sunshine`

### На телефоне
1. Tailscale (тот же аккаунт) → подключится к ПК
2. Moonlight → добавь хост по `100.x.y.z` → прими сертификат
3. Settings → On-screen controls → Add button ×3:
   - Кнопка 1 → `F1` (лево)
   - Кнопка 2 → `F2` (центр)
   - Кнопка 3 → `F3` (право)
4. Растяни по экрану под большой палец

### В WoW
Поставь на панели действий:
- Слот `F1` → спелл **Рыбалка**
- Слот `F2` → **Взаимодействие** (или Лут)
- Слот `F3` → **Наживка** (макрос `/use Наживка` или предмет в сумке)

Теперь тыкаешь пальцем в кнопки на телефоне → уходит нажатие клавиши на ПК → кастуется спелл. **Железное событие = легально.**

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

## Структура проекта
```
WoWFisher/
├── WoWFisher.toc        # Манифест (с метаданными для пакетера)
├── WoWFisher.lua        # Код аддона
├── .pkgmeta             # Настройки пакетера
└── .github/workflows/
    └── release.yml      # CI/CD pipeline
```

## Лицензия
MIT — делай что хочешь, но не нарушай ToS Blizzard.