local addonName, NS = ...
local moduleName = "IdleWarning"
local moduleDescription = "Alerts the player if they go AFK"
local soundChannels = {"Master", "SFX"}

local afk_message = "You are now Away: AFK"
local back_message = "You are no longer Away."

local handle = nil
local afk = false

local IdleIcon = CreateFrame("Frame", nil, UIParent);
IdleIcon:SetPoint("CENTER", UIParent, "TOP", 0, -200);
IdleIcon:SetSize(120, 120);

IdleIcon.icon = IdleIcon:CreateTexture(nil, "BACKGROUND");
IdleIcon.icon:SetAllPoints(IdleIcon);
IdleIcon.icon:SetTexture(3193418);
IdleIcon:SetAlpha(0.55);
IdleIcon:Hide()

local function repeatSound()
    if afk then
        _, handle = PlaySound(279274, soundChannels[BloodCrowToolsSettings.idleWarningSoundChannel], false)
        C_Timer.After(1, repeatSound)
    end
end

IdleIcon:RegisterEvent("CHAT_MSG_SYSTEM")
IdleIcon:SetScript("OnEvent", function(self, event, message, ...)
    if not NS.checkSetting(moduleName) then
        IdleIcon:Hide()
        return
    end

    if message == afk_message then
        IdleIcon:Show()
        if BloodCrowToolsSettings.idleWarningSoundChannel ~= nil and BloodCrowToolsSettings.idleWarningSoundChannel ~= 3 then
            -- PlaySoundFile("Interface\\Addons\\BloodCrowTools\\PowerAurasMedia\\Sounds\\huh_1.ogg", soundChannels[BloodCrowToolsSettings.idleWarningSoundChannel])
        --    _, handle = PlaySound(279274, soundChannels[BloodCrowToolsSettings.idleWarningSoundChannel])
            afk = true
            repeatSound()
        end

        C_Timer.After(30, function()
            IdleIcon:Hide()
            afk = false
            if handle ~= nil then
                StopSound(handle)
                handle = nil
            end
        end);
    elseif message == back_message then
        afk = false
        IdleIcon:Hide()
        if handle ~= nil then
            StopSound(handle)
            handle = nil
        end
    end
end);

-- settings
table.insert(NS.settingsSubcategories, function()
    local subCat = Settings.RegisterVerticalLayoutSubcategory(NS.settingsCategory, moduleName)
    do 
        local setting = Settings.RegisterAddOnSetting(
            subCat, --category
            "enable" .. moduleName, --variable
            "enable" .. moduleName, --variableKey
            BloodCrowToolsSettings, --variableTbl
            type(true), --type
            "Enable " .. moduleName, --label?
            false --defaultValue
        )
        Settings.CreateCheckbox(subCat, setting, moduleDescription)
    end

    do
        local variable = "idleWarningSoundChannel"
        local defaultValue = 1
        local name = "Sound Channel"
        local tooltip = "Which sound channel for idle alerts"
        local variableKey = "idleWarningSoundChannel"
        local variableTbl = BloodCrowToolsSettings
    
        local function GetOptions()
            local container = Settings.CreateControlTextContainer()
            container:Add(1, "Master")
            container:Add(2, "SFX")
            container:Add(3, "Disabled")
            return container:GetData()
        end
    
        local setting = Settings.RegisterAddOnSetting(subCat, variable, variableKey, variableTbl, type(defaultValue), name, defaultValue)
        Settings.CreateDropdown(subCat, setting, GetOptions, tooltip)
    end
end);
