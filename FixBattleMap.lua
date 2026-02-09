local addonName, NS = ...
local zoneMapScale = 150
local moduleName = "FixBattleMap"
local moduleDescription = "Scales and moves the battlefield map to the upper left corner of the screen"

local function fixBattleMap()
    if BattlefieldMapFrame ~= nil then
        BattlefieldMapFrame:SetScale(zoneMapScale/100)
        BattlefieldMapFrame.BorderFrame.CloseButton:Hide()
        BattlefieldMapFrame:SetPoint("TOPLEFT",UIParent,"TOPLEFT",0,0)
    end
end

local function cvarUpdate(varName, varValue)
    if varName == "showBattlefieldMinimap" and varValue == "1" then
        fixBattleMap()
        return true
    end
end

local BattleMapEvents = CreateFrame("Frame")
BattleMapEvents:RegisterEvent("ADDON_LOADED")
BattleMapEvents:RegisterEvent("CVAR_UPDATE")
BattleMapEvents:RegisterEvent("PLAYER_ENTERING_WORLD")
BattleMapEvents:SetScript("OnEvent", function(self, event, ...)
    if not NS.checkSetting(moduleName) then
        return
    end

    if event == "ADDON_LOADED" then
        local addon = ...
        if addon == "BloodCrowTools" then
            fixBattleMap()
        end
    elseif event == "CVAR_UPDATE" then
        cvarUpdate(...)
    else
        fixBattleMap()
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
