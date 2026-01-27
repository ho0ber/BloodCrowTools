local addonName, NS = ...
local moduleName = "CrateAlert"
local moduleDescription = "Shows an icon and plays a loud alert when a crate is announced"
local soundChannels = {"Master", "SFX"}

local messages = {
    ["I see some valuable resources in the area! Get ready to grab them!"] = true,
    ["Looks like there's treasure nearby. And that means treasure hunters. Watch your back."] = true,
    ["Opportunity's knocking! If you've got the mettle, there are valuables waiting to be won."] = true,
    ["There's a cache of resources nearby. Find it before you have to fight over it!"] = true,
}

local CrateIcon = CreateFrame("Frame", nil, UIParent);
CrateIcon:SetPoint("CENTER", UIParent, "TOP", 0, -200);
CrateIcon:SetSize(120, 120);

CrateIcon.icon = CrateIcon:CreateTexture(nil, "BACKGROUND");
CrateIcon.icon:SetAllPoints(CrateIcon);
CrateIcon.icon:SetTexture(132763);
CrateIcon:SetAlpha(0.55);
CrateIcon:Hide()

CrateIcon:RegisterEvent("CHAT_MSG_MONSTER_SAY")
CrateIcon:SetScript("OnEvent", function(self, event, message, npc, ...)
    if not NS.checkSetting(moduleName) then
        CrateIcon:Hide()
        return
    end

    if npc ~= "Ruffious" then
        return
    end

    if messages[message] ~= nil then
        CrateIcon:Show()
        if BloodCrowToolsSettings.crateAlertSoundChannel ~= nil and BloodCrowToolsSettings.crateAlertSoundChannel ~= 3 then
            PlaySoundFile("Interface\\Addons\\BloodCrowTools\\PowerAurasMedia\\Sounds\\shipswhistle.ogg", soundChannels[BloodCrowToolsSettings.crateAlertSoundChannel])
        end

        C_Timer.After(10, function()
            CrateIcon:Hide()
        end);
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
            true --defaultValue
        )
        Settings.CreateCheckbox(subCat, setting, moduleDescription)
    end

    do
        local variable = "crateAlertSoundChannel"
        local defaultValue = 1
        local name = "Sound Channel"
        local tooltip = "Which sound channel for crate alerts"
        local variableKey = "crateAlertSoundChannel"
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
