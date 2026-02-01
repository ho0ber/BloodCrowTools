local addonName, NS = ...

NS.checkSetting = function(settingName)
    local settingKey = "enable" .. settingName
    if BloodCrowToolsSettings[settingKey] == nil then
        return false
    end

    return BloodCrowToolsSettings[settingKey]
end

NS.registerEvents = function(events, active)
    for _,event in ipairs(events) do
        if active then
            QuestHelperFrame:RegisterEvent(event)
        else
            QuestHelperFrame:UnregisterEvent(event)
        end
    end
end

NS.settingsCategory = Settings.RegisterVerticalLayoutCategory("BloodCrowTools")
NS.settingsSubcategories = {}

local function configureSettings()
    for _, f in ipairs(NS.settingsSubcategories) do
        f()
    end
    -- DevTools_Dump(BloodCrowToolsSettings)
    Settings.RegisterAddOnCategory(NS.settingsCategory)
end

local bct = CreateFrame("Frame")
bct:RegisterEvent("ADDON_LOADED")
bct:SetScript("OnEvent", function(self, event, addon) 
        if addon == "BloodCrowTools" then
            if BloodCrowToolsSettings == nil then
                BloodCrowToolsSettings = {}
            end
            configureSettings()
            print("Loaded BloodCrowTools!")
        end
end);
