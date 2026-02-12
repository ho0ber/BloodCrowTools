local addonName, NS = ...
local moduleName = "TeleportClicker"
local moduleDescription = "Selects teleportation gossip options for you automatically"

local gossipOptions = {
        [125350]=1,
        [125351]=1,
        [125349]=1,
        [125352]=1,
        [125434]=1,
        [125433]=1,
}

local TeleportEvents = CreateFrame("Frame")
TeleportEvents:RegisterEvent("GOSSIP_SHOW")
TeleportEvents:SetScript("OnEvent", function(self, event, ...)
    if not NS.checkSetting(moduleName) then
        return
    end
    for i,option in ipairs(C_GossipInfo.GetOptions()) do
        if gossipOptions[option.gossipOptionID] ~= nil then
            SelectGossipOption(gossipOptions[option.gossipOptionID])
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
            true --defaultValue
        )
        Settings.CreateCheckbox(subCat, setting, moduleDescription)
    end
end);
