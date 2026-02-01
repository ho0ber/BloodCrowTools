local addonName, NS = ...
local moduleName = "ShardInfo"
local moduleDescription = "Shows the shardID of the target"

local diamond = "\124TInterface\\TargetingFrame\\UI-RaidTargetingIcon_3:0\124t"

local ShardInfoFrame = CreateFrame("Frame", nil, TargetFrame.TargetFrameContainer);
ShardInfoFrame.title = ShardInfoFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlight");
ShardInfoFrame.title:SetPoint("BOTTOM", TargetFrame.TargetFrameContent.TargetFrameContentMain.Name, "TOP", 0, 0)
ShardInfoFrame.title:SetText("")

ShardInfoFrame:RegisterEvent("PLAYER_TARGET_CHANGED")
ShardInfoFrame:RegisterEvent("UNIT_TARGET")
ShardInfoFrame:SetScript("OnEvent", function(self, event, ...)
    if not NS.checkSetting(moduleName) then
        ShardInfoFrame.title:SetText("")
        return
    end

    local guid = UnitGUID("target")
    if guid ~= nil and not issecretvalue(guid) then
        local type, _ = strsplit("-", guid, 2)
        if type == "Creature" then
            local _, _, _, _, shardID = strsplit("-", guid, 6)
            ShardInfoFrame.title:SetText(diamond .. shardID)
            return
        end
    end
    ShardInfoFrame.title:SetText("")
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
