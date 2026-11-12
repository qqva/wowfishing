-- WoWFisher — аддон для рыбалки (WoW Forever / Retail)
-- ОДНА большая кнопка. Бинд на "0" настраивается в игре + Moonlight.
-- Красная надпись "НЕТ НАЖИВКИ" загорается, когда на удочке нет зачарования (наживки)

local addonName, ns = ...
WoWFisher = ns

local L = {
    CAST = "Забросить (0)",
    TITLE = "WoWFisher",
    NO_BAIT = "НЕТ НАЖИВКИ",
    SOUND_ENABLED = "Звук на клюв",
    SCALE = "Масштаб кнопки",
    LOCKED = "Закрепить позицию",
    RESET_POS = "Сбросить позицию",
}

local defaults = {
    profile = {
        point = "CENTER",
        x = 0,
        y = -150,
        scale = 1.2,
        locked = false,
        soundEnabled = true,
    }
}

local BOBBER_SOUND = "Sound\\Interface\\UI_FishingReelIn.ogg"

local function CreateBigButton(parent, name, text, onClick)
    local btn = CreateFrame("Button", name, parent, "UIPanelButtonTemplate")
    btn:SetSize(360, 140)
    btn:SetText(text)
    btn:SetNormalFontObject(GameFontNormalHuge)
    btn:SetHighlightFontObject(GameFontHighlightHuge)
    btn:GetFontString():SetPoint("CENTER", 0, 0)
    
    btn:RegisterForClicks("AnyUp")
    btn:SetScript("OnClick", onClick)
    
    btn:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_TOP")
        GameTooltip:AddLine(self:GetText())
        GameTooltip:AddLine("В игре забиндь Рыбалку на клавишу 0", 1, 1, 0.5)
        GameTooltip:AddLine("В Moonlight: экранная кнопка → 0", 1, 1, 0.5)
        GameTooltip:Show()
    end)
    btn:SetScript("OnLeave", GameTooltip_Hide)
    
    return btn
end

local frame = CreateFrame("Frame", "WoWFisherFrame", UIParent, "BackdropTemplate")
frame:SetSize(400, 200)
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

local title = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
title:SetPoint("TOP", 0, -10)
title:SetText(L.TITLE)
title:SetTextColor(1, 0.82, 0)

-- Красная надпись "НЕТ НАЖИВКИ" (по умолчанию скрыта)
local noBaitText = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalHuge")
noBaitText:SetPoint("BOTTOM", frame, "TOP", 0, 5)
noBaitText:SetText(L.NO_BAIT)
noBaitText:SetTextColor(1, 0, 0)
noBaitText:Hide()

local btnCast = CreateBigButton(frame, "WoWFisherBtnCast", L.CAST, function()
    PlaySound(843)
end)

btnCast:SetPoint("CENTER", frame, "CENTER", 0, 10)

-- Проверка наживки: GetWeaponEnchantInfo() возвращает hasMainHandEnchant, mainHandExpiration, ...
local function CheckBait()
    local hasMainHandEnchant = GetWeaponEnchantInfo()
    if hasMainHandEnchant then
        noBaitText:Hide()
    else
        noBaitText:Show()
    end
end

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

frame:SetScript("OnMouseUp", function(self, button)
    if button == "RightButton" and not self:IsMoving() then
        WoWFisher_OpenOptions()
    end
end)

-- Таймер для проверки наживки каждую секунду
local baitCheckFrame = CreateFrame("Frame")
baitCheckFrame:SetScript("OnUpdate", function(self, elapsed)
    self.elapsed = (self.elapsed or 0) + elapsed
    if self.elapsed >= 1 then
        CheckBait()
        self.elapsed = 0
    end
end)

local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("LOOT_READY")
eventFrame:RegisterEvent("UI_ERROR_MESSAGE")
eventFrame:RegisterEvent("PLAYER_LOGIN")
eventFrame:RegisterEvent("UNIT_INVENTORY_CHANGED")
eventFrame:SetScript("OnEvent", function(self, event, ...)
    if event == "PLAYER_LOGIN" then
        WoWFisherDB = WoWFisherDB or { profile = {} }
        for k, v in pairs(defaults.profile) do
            if WoWFisherDB.profile[k] == nil then
                WoWFisherDB.profile[k] = v
            end
        end
        frame:SetScale(WoWFisherDB.profile.scale)
        frame:SetPoint(WoWFisherDB.profile.point, UIParent, WoWFisherDB.profile.point, WoWFisherDB.profile.x, WoWFisherDB.profile.y)
        if WoWFisherDB.profile.locked then
            frame:EnableMouse(false)
        end
        CheckBait()  -- начальная проверка
        print("|cFFFFD100WoWFisher|r загружен. ПКМ — настройки. Забиндь Рыбалку на 0.")
    
    elseif event == "LOOT_READY" then
        if WoWFisherDB.profile.soundEnabled then
            PlaySoundFile(BOBBER_SOUND, "Master")
        end
        UIFrameFlash(btnCast, 0.3, 0.3, 3, false, 0, 0)
        
    elseif event == "UI_ERROR_MESSAGE" then
        local msg = ...
        
    elseif event == "UNIT_INVENTORY_CHANGED" then
        local unit = ...
        if unit == "player" then
            CheckBait()
        end
    end
end)

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
        print("  /wf sound — toggle звук")
        print("  ПКМ по фрейму — меню")
    end
end

function WoWFisher_OpenOptions()
    if not WoWFisherOptionsFrame then
        local f = CreateFrame("Frame", "WoWFisherOptionsFrame", UIParent, "BasicFrameTemplateWithInset")
        f:SetSize(320, 280)
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
        
        local cbSound = CreateFrame("CheckButton", nil, f, "InterfaceOptionsCheckButtonTemplate")
        cbSound:SetPoint("TOPLEFT", 20, -40)
        cbSound.Text:SetText(L.SOUND_ENABLED)
        cbSound:SetChecked(WoWFisherDB.profile.soundEnabled)
        cbSound:SetScript("OnClick", function(self)
            WoWFisherDB.profile.soundEnabled = self:GetChecked()
        end)
        
        local cbLock = CreateFrame("CheckButton", nil, f, "InterfaceOptionsCheckButtonTemplate")
        cbLock:SetPoint("TOPLEFT", cbSound, "BOTTOMLEFT", 0, -10)
        cbLock.Text:SetText(L.LOCKED)
        cbLock:SetChecked(WoWFisherDB.profile.locked)
        cbLock:SetScript("OnClick", function(self)
            WoWFisherDB.profile.locked = self:GetChecked()
            frame:EnableMouse(not self:GetChecked())
        end)
        
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
        
        local btnClose = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
        btnClose:SetSize(80, 25)
        btnClose:SetPoint("BOTTOMRIGHT", -20, 15)
        btnClose:SetText("Закрыть")
        btnClose:SetScript("OnClick", function() f:Hide() end)
        
        WoWFisherOptionsFrame = f
    end
    WoWFisherOptionsFrame:Show()
end

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