local addonName, NS = ...

NS.checkSetting = function(settingName)
    local settingKey = "enable" .. settingName
    if BloodCrowToolsSettings[settingKey] == nil then
        return false
    end

    return BloodCrowToolsSettings[settingKey]
end

local function configureSettings()
    NS.settingsCategory = Settings.RegisterVerticalLayoutCategory("BloodCrowTools")

    local modules = {
        ["TargetSpecIcon"] = "Shows a class/specialization icon for your current (player) target",
        ["HonorLevel"] = "Shows the honor level of your current (player) target over their emblem",
        ["FixBattleMap"] = "Scales and moves the battlefield map to the upper left corner of the screen",
        ["MuteAnnoyingSounds"] = "Mutes assorted annoying/repetitive sounds",
        ["DebuffWatch"] = "Watches for major self-debuffs and warns when they appear",
    }
    for name, tooltip in pairs(modules) do
        local variable = "enable" .. name
        local variableKey = variable
        local variableTbl = BloodCrowToolsSettings
        local defaultValue = true
    
        local setting = Settings.RegisterAddOnSetting(NS.settingsCategory, variable, variableKey, variableTbl, type(defaultValue), name, defaultValue)
        -- setting:SetValueChangedCallback(OnSettingChanged)
        Settings.CreateCheckbox(NS.settingsCategory, setting, tooltip)
    end
    DevTools_Dump(BloodCrowToolsSettings)
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
