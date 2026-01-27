local addonName, NS = ...
local moduleName = "DebuffWatch"
local moduleDescription =  "Watches for major self-debuffs and warns when they appear"

local lastCounter = nil
local debuffTimer = nil
local DebuffButton = CreateFrame("Frame", nil, UIParent);
DebuffButton:SetPoint("CENTER", UIParent, "TOP", 0, -200);
DebuffButton:SetSize(120, 120);

DebuffButton.icon = DebuffButton:CreateTexture(nil, "BACKGROUND");
DebuffButton.icon:SetAllPoints(DebuffButton);
DebuffButton.icon:SetTexture(535595);
DebuffButton:SetAlpha(0.55);
DebuffButton:Hide()

DebuffButton:RegisterEvent("UNIT_AURA")
DebuffButton:SetScript("OnEvent", function(self, event, unit, info)
    if not NS.checkSetting(moduleName) then
        DebuffButton:Hide()
        return
    end

    if unit == "player" then
        local auras = C_UnitAuras.GetUnitAuras("player", "PLAYER HARMFUL NOT_CANCELABLE INCLUDE_NAME_PLATE_ONLY")
        for _, aura in ipairs(auras) do
            DebuffButton.icon:SetTexture(aura.icon)
        end

        local debuff_count = #auras
        if lastCounter ~= nil and debuff_count > lastCounter then
            DebuffButton:Show()
            if debuffTimer ~= nil then
                debuffTimer.Cancel()
            end
            PlaySoundFile("Interface\\Addons\\BloodCrowTools\\PowerAurasMedia\\Sounds\\Gasp.ogg", "Master")
            debuffTimer = C_Timer.After(10, function()
                DebuffButton:Hide()
            end);
        end
        lastCounter = debuff_count
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
