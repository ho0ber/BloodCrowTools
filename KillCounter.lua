local addonName, NS = ...
local moduleName = "KillCounter"
local moduleDescription = "Tracks honorable kills above the player unit frame"

local skull = "\124TInterface\\TargetingFrame\\UI-RaidTargetingIcon_8:0\124t"

local KillCounterFrame = CreateFrame("Frame", nil, PlayerFrame.PlayerFrameContainer);
KillCounterFrame.title = KillCounterFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlightLarge");
local file, size = KillCounterFrame.title:GetFont()
KillCounterFrame.title:SetFont(file, size, "THICKOUTLINE")
KillCounterFrame.title:SetPoint("BOTTOM", PlayerFrame.PlayerFrameContainer.PlayerPortrait, "TOP", 0, 2)
KillCounterFrame.title:SetText("?" .. skull)

KillCounterFrame:RegisterEvent("PLAYER_IN_COMBAT_CHANGED")
KillCounterFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
KillCounterFrame:RegisterEvent("CHAT_MSG_COMBAT_HONOR_GAIN")
KillCounterFrame:RegisterEvent("ADDON_LOADED")
KillCounterFrame:SetScript("OnEvent", function(self, event, ...)
    if not NS.checkSetting(moduleName) then
        KillCounterFrame.title:SetText("")
        return
    end

    local hk, dk = GetPVPSessionStats()
    if hk ~= null then
        KillCounterFrame.title:SetText(hk .. skull)
    else
        KillCounterFrame.title:SetText("")
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
end);
