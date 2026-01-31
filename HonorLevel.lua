local addonName, NS = ...
local moduleName = "HonorLevel"
local moduleDescription = "Shows the honor level of your current (player) target over their emblem"

local HonorLevelFrame = CreateFrame("Frame", nil, TargetFrame.TargetFrameContainer);
HonorLevelFrame.title = HonorLevelFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlightLarge");
local file, size = HonorLevelFrame.title:GetFont()
HonorLevelFrame.title:SetFont(file, size, "THICKOUTLINE")
HonorLevelFrame.title:SetPoint("CENTER", TargetFrame.TargetFrameContent.TargetFrameContentContextual.PrestigePortrait, "CENTER", 0, -1)
HonorLevelFrame.title:SetText("100")

HonorLevelFrame:RegisterEvent("PLAYER_TARGET_CHANGED")
HonorLevelFrame:RegisterEvent("UNIT_TARGET")
HonorLevelFrame:SetScript("OnEvent", function(self, event, ...)
    if not NS.checkSetting(moduleName) then
        HonorLevelFrame.title:SetText("")
        return
    end

    local hl = UnitHonorLevel("target")
    if hl ~= null and hl > 0 then
        if UnitIsPVP("target") or not BloodCrowToolsSettings["honorLevelTargetPVP"] then
            if UnitIsPVP("player") or not BloodCrowToolsSettings["honorLevelPlayerPVP"] then
                HonorLevelFrame.title:SetText(hl)
                return
            end
        end
    end
    HonorLevelFrame.title:SetText("")
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
        local setting = Settings.RegisterAddOnSetting(
            subCat, --category
            "honorLevelTargetPVP", --variable
            "honorLevelTargetPVP", --variableKey
            BloodCrowToolsSettings, --variableTbl
            type(true), --type
            "PvP Targets Only", --label?
            true --defaultValue
        )
        Settings.CreateCheckbox(subCat, setting, "Show honor level only for PVP-flagged players")
    end
    do 
        local setting = Settings.RegisterAddOnSetting(
            subCat, --category
            "honorLevelPlayerPVP", --variable
            "honorLevelPlayerPVP", --variableKey
            BloodCrowToolsSettings, --variableTbl
            type(true), --type
            "Hide When Not PvP", --label?
            true --defaultValue
        )
        Settings.CreateCheckbox(subCat, setting, "Show honor level only if you are PVP flagged")
    end
end);
