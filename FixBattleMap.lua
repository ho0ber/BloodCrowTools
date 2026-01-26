local addonName, NS = ...
local zoneMapScale = 150

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
BattleMapEvents:SetScript("OnEvent", function(self, event, ...)
    if not NS.checkSetting("FixBattleMap") then
        return
    end
    
    if event == "ADDON_LOADED" then
        local addon = ...
        if addon == "BloodCrowTools" then
            fixBattleMap()
        end
    elseif event == "CVAR_UPDATE" then
        cvarUpdate(...)
    end
end);
