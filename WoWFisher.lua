-- WoWFisher — легальный аддон для рыбалки (WoW Forever / Retail)
-- Только UI + бинды. Никакой автоматизации: CastSpellByName, авто-лут, авто-заброс — ЗАПРЕЩЕНО Warden'ом.
-- Использование: биндишь F1/F2/F3 (или свои) → на телефоне в Moonlight вешаешь экранные кнопки на эти клавиши.

local addonName, ns = ...
WoWFisher = ns

local L = {
    CAST = "Забросить",
    LOOT = "Собрать",
    BAIT = "Наживка",
    TITLE = "WoWFisher",
    SOUND_ENABLED = "Звук на клюв",
    SCALE = "Масштаб кнопок",
    LOCKED = "Закрепить позицию",
    RESET_POS = "Сбросить позицию",
    KEY_CAST = "Клавиша: Забросить",
    KEY_LOOT = "Клавиша: Собрать",
    KEY_BAIT = "Клавиша: Наживка",
}

-- Дефолтовые настройки
local defaults = {
    profile = {
        point = "CENTER",
        x = 0,
        y = -150,
        scale = 1.2,
        locked = false,
        soundEnabled = true,
        keyCast = "F1",
        keyLoot = "F2",
        keyBait = "F3",
    }
}

-- Звук клюва (встроенный игровой)
local BOBBER_SOUND = "Sound\\Interface\\UI_FishingReelIn.ogg"
local LOOT_SOUND = "Sound\\Interface\\MoneyFrameOpen.ogg"

-- Создание фрейма кнопки
local function CreateBigButton(parent, name, text, key, onClick)
    local btn = CreateFrame("Button", name, parent, "UIPanelButtonTemplate")
    btn:SetSize(180, 70)
    btn:SetText(text)
    btn:SetNormalFontObject(GameFontNormalLarge)
    btn:SetHighlightFontObject(GameFontHighlightLarge)
    btn:GetFontString():SetPoint("CENTER", 0, 0)
    
    -- Регистрируем клики
    btn:RegisterForClicks("AnyUp")
    btn:SetScript("OnClick", onClick)
    
    -- Подсказка с клавишей
    btn:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_TOP")
        GameTooltip:AddLine(self:GetText())
        GameTooltip:AddLine("Клавиша: " .. (key or "—"), 1, 1, 0.5)
        GameTooltip:Show()
    end)
    btn:SetScript("OnLeave", GameTooltip_Hide)
    
    return btn
end

-- Главный фрейм
local frame = CreateFrame("Frame", "WoWFisherFrame", UIParent, "BackdropTemplate")
frame:SetSize(560, 100)
frame:SetPoint("CENTER", 0, -150)
frame:SetMovable(true)
frame:SetClampedToScreen(true)
frame:SetFrameStrata("MEDIUM")
frame:SetFrameLevel(10)
frame:EnableMouse(true)
frame:RegisterForDrag("LeftButton")
frame:SetBackdrop({
    bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
    edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
    tile = true, tileSize = 32, edgeSize = 32,
    insets = { left = 11, right = 12, top = 12, bottom = 11 }
})
frame:SetBackdropColor(0, 0, 0, 0.7)

-- Заголовок
local title = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
title:SetPoint("TOP", 0, -10)
title:SetText(L.TITLE)
title:SetTextColor(1, 0.82, 0)

-- Кнопки
local btnCast = CreateBigButton(frame, "WoWFisherBtnCast", L.CAST, "F1", function()
    -- Заброс удочки — нужно, чтобы на F1 висел спелл Рыбалки (action bar slot)
    -- Аддон НЕ кастует сам — просто эмулирует нажатие клавиши, если нужно
    -- Но проще: пользователь биндит Рыбалку на F1 в игре, мы просто показываем кнопку
    -- При нажатии кнопки мышью — отправляем ключевое событие
    -- ВАЖНО: Secure кнопки нельзя кликать программно. Только железо.
    -- Поэтому кнопка — просто визуал. Нажатие по экрану телефона = железо.
    PlaySound(843) -- IG_MAINMENU_OPTION_CHECKBOX_ON
end)

local btnLoot = CreateBigButton(frame, "WoWFisherBtnLoot", L.LOOT, "F2", function()
    PlaySound(843)
end)

local btnBait = CreateBigButton(frame, "WoWFisherBtnBait", L.BAIT, "F3", function()
    PlaySound(843)
end)

-- Расположение кнопок
btnCast:SetPoint("LEFT", frame, "LEFT", 20, 0)
btnLoot:SetPoint("CENTER", frame, "CENTER", 0, 0)
btnBait:SetPoint("RIGHT", frame, "RIGHT", -20, 0)

-- Drag для перемещения
frame:SetScript("OnDragStart", function(self)
    if not WoWFisherDB.profile.locked then
        self:StartMoving()
    end
end)
frame:SetScript("OnDragStop", function(self)
    self:StopMovingOrSizing()
    local point, _, _, x, y = self:GetPoint()
    WoWFisherDB.profile.point = point
    WoWFisherDB.profile.x = x
    WoWFisherDB.profile.y = y
end)

-- Правый клик по фрейму = меню настроек
frame:SetScript("OnMouseUp", function(self, button)
    if button == "RightButton" and not self:IsMoving() then
        WoWFisher_OpenOptions()
    end
end)

-- События: звук на клюв
local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("LOOT_READY")
eventFrame:RegisterEvent("UI_ERROR_MESSAGE")
eventFrame:RegisterEvent("PLAYER_LOGIN")
eventFrame:SetScript("OnEvent", function(self, event, ...)
    if event == "PLAYER_LOGIN" then
        -- Инициализация БД
        WoWFisherDB = WoWFisherDB or { profile = {} }
        for k, v in pairs(defaults.profile) do
            if WoWFisherDB.profile[k] == nil then
                WoWFisherDB.profile[k] = v
            end
        end
        -- Применяем настройки
        frame:SetScale(WoWFisherDB.profile.scale)
        frame:SetPoint(WoWFisherDB.profile.point, UIParent, WoWFisherDB.profile.point, WoWFisherDB.profile.x, WoWFisherDB.profile.y)
        if WoWFisherDB.profile.locked then
            frame:EnableMouse(false)
        end
        
        -- Бинды (показываем в подсказках)
        btnCast.key = WoWFisherDB.profile.keyCast
        btnLoot.key = WoWFisherDB.profile.keyLoot
        btnBait.key = WoWFisherDB.profile.keyBait
        
        print("|cFFFFD100WoWFisher|r загружен. ПКМ по фрейму — настройки. Бинды: " .. 
            WoWFisherDB.profile.keyCast .. "/" .. WoWFisherDB.profile.keyLoot .. "/" .. WoWFisherDB.profile.keyBait)
    
    elseif event == "LOOT_READY" then
        -- Клюв! (поплавок под'eau)
        if WoWFisherDB.profile.soundEnabled then
            PlaySoundFile(BOBBER_SOUND, "Master")
        end
        -- Визуальная индикация: мигание кнопки "Собрать"
        UIFrameFlash(btnLoot, 0.3, 0.3, 3, false, 0, 0)
        
    elseif event == "UI_ERROR_MESSAGE" then
        local msg = ...
        -- Можно отслеживать "Ваша наживка съедена" и т.д.
    end
end)

-- Слэш-команды
SLASH_WOWFISHER1 = "/wf"
SLASH_WOWFISHER2 = "/wowfisher"
SlashCmdList["WOWFISHER"] = function(msg)
    msg = msg:lower():trim()
    if msg == "lock" then
        WoWFisherDB.profile.locked = true
        frame:EnableMouse(false)
        print("WoWFisher: закреплено")
    elseif msg == "unlock" then
        WoWFisherDB.profile.locked = false
        frame:EnableMouse(true)
        print("WoWFisher: разблокировано")
    elseif msg == "reset" then
        frame:ClearAllPoints()
        frame:SetPoint("CENTER", 0, -150)
        WoWFisherDB.profile.point = "CENTER"
        WoWFisherDB.profile.x = 0
        WoWFisherDB.profile.y = -150
        print("WoWFisher: позиция сброшена")
    elseif msg == "sound" then
        WoWFisherDB.profile.soundEnabled = not WoWFisherDB.profile.soundEnabled
        print("WoWFisher: звук " .. (WoWFisherDB.profile.soundEnabled and "вкл" or "выкл"))
    else
        print("WoWFisher команды:")
        print("  /wf lock — закрепить")
        print("  /wf unlock — разблокировать")
        print("  /wf reset — сбросить позицию")
        print("  /wf sound —.toggle звук")
        print("  ПКМ по фрейму — полное меню")
    end
end

-- Меню настроек (через Interface Options / Addon Compartment)
function WoWFisher_OpenOptions()
    if not WoWFisherOptionsFrame then
        local f = CreateFrame("Frame", "WoWFisherOptionsFrame", UIParent, "BasicFrameTemplateWithInset")
        f:SetSize(320, 380)
        f:SetPoint("CENTER")
        f:SetMovable(true)
        f:SetClampedToScreen(true)
        f:EnableMouse(true)
        f:RegisterForDrag("LeftButton")
        f:SetScript("OnDragStart", f.StartMoving)
        f:SetScript("OnDragStop", f.StopMovingOrSizing)
        f.title = f:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
        f.title:SetPoint("TOP", 0, -10)
        f.title:SetText(L.TITLE .. " — Настройки")
        
        -- Чекбокс: Звук
        local cbSound = CreateFrame("CheckButton", nil, f, "InterfaceOptionsCheckButtonTemplate")
        cbSound:SetPoint("TOPLEFT", 20, -40)
        cbSound.Text:SetText(L.SOUND_ENABLED)
        cbSound:SetChecked(WoWFisherDB.profile.soundEnabled)
        cbSound:SetScript("OnClick", function(self)
            WoWFisherDB.profile.soundEnabled = self:GetChecked()
        end)
        
        -- Чекбокс: Закреплено
        local cbLock = CreateFrame("CheckButton", nil, f, "InterfaceOptionsCheckButtonTemplate")
        cbLock:SetPoint("TOPLEFT", cbSound, "BOTTOMLEFT", 0, -10)
        cbLock.Text:SetText(L.LOCKED)
        cbLock:SetChecked(WoWFisherDB.profile.locked)
        cbLock:SetScript("OnClick", function(self)
            WoWFisherDB.profile.locked = self:GetChecked()
            frame:EnableMouse(not self:GetChecked())
        end)
        
        -- Слайдер: Масштаб
        local sliderScale = CreateFrame("Slider", nil, f, "OptionsSliderTemplate")
        sliderScale:SetPoint("TOPLEFT", cbLock, "BOTTOMLEFT", 0, -30)
        sliderScale:SetWidth(260)
        sliderScale:SetMinMaxValues(0.5, 2.0)
        sliderScale:SetValueStep(0.05)
        sliderScale:SetValue(WoWFisherDB.profile.scale)
        sliderScale.Text:SetText(L.SCALE .. ": " .. WoWFisherDB.profile.scale)
        sliderScale.Low:SetText("0.5")
        sliderScale.High:SetText("2.0")
        sliderScale:SetScript("OnValueChanged", function(self, val)
            val = math.floor(val * 20 + 0.5) / 20
            self:SetValue(val)
            self.Text:SetText(L.SCALE .. ": " .. val)
            WoWFisherDB.profile.scale = val
            frame:SetScale(val)
        end)
        
        -- Бинды: простые кнопки для смены (клик -> жди нажатия клавиши)
        local function CreateKeyButton(parent, label, dbKey, yOffset)
            local btn = CreateFrame("Button", nil, parent, "UIPanelButtonTemplate")
            btn:SetSize(260, 30)
            btn:SetPoint("TOPLEFT", 20, yOffset)
            btn:SetText(label .. ": " .. WoWFisherDB.profile[dbKey])
            btn:SetScript("OnClick", function(self)
                self:SetText(label .. ": нажми клавишу...")
                self:EnableKeyboard(true)
                self:SetPropagateKeyboardInput(true)
                self:SetScript("OnKeyDown", function(s, key)
                    if key ~= "ESCAPE" then
                        WoWFisherDB.profile[dbKey] = key
                        s:SetText(label .. ": " .. key)
                        -- Обновляем подсказки на главных кнопках
                        if dbKey == "keyCast" then btnCast.key = key end
                        if dbKey == "keyLoot" then btnLoot.key = key end
                        if dbKey == "keyBait" then btnBait.key = key end
                    end
                    s:EnableKeyboard(false)
                    s:SetScript("OnKeyDown", nil)
                end)
            end)
            return btn
        end
        
        CreateKeyButton(f, L.KEY_CAST, "keyCast", -160)
        CreateKeyButton(f, L.KEY_LOOT, "keyLoot", -200)
        CreateKeyButton(f, L.KEY_BAIT, "keyBait", -240)
        
        -- Кнопка сброса позиции
        local btnReset = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
        btnReset:SetSize(120, 25)
        btnReset:SetPoint("BOTTOMLEFT", 20, 15)
        btnReset:SetText(L.RESET_POS)
        btnReset:SetScript("OnClick", function()
            frame:ClearAllPoints()
            frame:SetPoint("CENTER", 0, -150)
            WoWFisherDB.profile.point = "CENTER"
            WoWFisherDB.profile.x = 0
            WoWFisherDB.profile.y = -150
        end)
        
        -- Закрыть
        local btnClose = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
        btnClose:SetSize(80, 25)
        btnClose:SetPoint("BOTTOMRIGHT", -20, 15)
        btnClose:SetText("Закрыть")
        btnClose:SetScript("OnClick", function() f:Hide() end)
        
        WoWFisherOptionsFrame = f
    end
    WoWFisherOptionsFrame:Show()
end

-- Регистрация в Addon Compartment (мини-карта)
if AddonCompartmentFrame then
    local function RegisterCompartment()
        AddonCompartmentFrame:RegisterAddon({
            text = L.TITLE,
            icon = "Interface\\Icons\\Trade_Fishing",
            registerForAnyClick = true,
            func = function() WoWFisher_OpenOptions() end,
        })
    end
    if AddonCompartmentFrame:IsShown() then RegisterCompartment() else
        hooksecurefunc(AddonCompartmentFrame, "Show", RegisterCompartment)
    end
end