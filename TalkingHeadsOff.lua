local addonName, NS = ...
local moduleName = "TalkingHeadsOff"
local moduleDescription = "Hides talking heads when they pop up"

local hideNextHead = true

local TalkingHeadEvents = CreateFrame("Frame")
TalkingHeadEvents:RegisterEvent("TALKINGHEAD_REQUESTED")
TalkingHeadEvents:RegisterEvent("CHAT_MSG_MONSTER_SAY")
TalkingHeadEvents:SetScript("OnEvent", function(self, event, ...)
    if not NS.checkSetting(moduleName) then
        return
    end

    if event == "CHAT_MSG_MONSTER_SAY" then
        local message, npc = ...
        if npc == "Ruffious" and BloodCrowToolsSettings["letRuffiousTalk"] then
            hideNextHead = false
        end
    elseif event == "TALKINGHEAD_REQUESTED" then
        if hideNextHead then
            TalkingHeadFrame.MainFrame.CloseButton:Click()
        else
            hideNextHead = true
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
    do 
        local setting = Settings.RegisterAddOnSetting(
            subCat, --category
            "letRuffiousTalk", --variable
            "letRuffiousTalk", --variableKey
            BloodCrowToolsSettings, --variableTbl
            type(true), --type
            "Let Ruffious Talk", --label?
            true --defaultValue
        )
        Settings.CreateCheckbox(subCat, setting, "Let Ruffious' talking head still pop up")
    end
end);
