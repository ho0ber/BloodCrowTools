local addonName, NS = ...
local moduleName = "MissingBuffs"
local moduleDescription =  "Watches for missing buffs and reminds you to apply them"

local buffs = {
    [8679]=     {known=8679,      macro="/cast Wound Poison"},
    [3408]=     {known=3408,      macro="/cast Crippling Po}ison"},
    [383648]=   {known=974,       macro="/cast Earth Shield", alt=974},
    [52127]=    {known=52127,     macro="/cast Water Shield"},
    [462854]=   {known=462854,    macro="/cast Skyfury"},
    [57363]=    {known=nil,       macro="/use Blackened Worg Steak"},
}


local BuffButtonFrame = CreateFrame("Frame", nil, UIParent)
BuffButtonFrame:SetPoint("CENTER", UIParent, "TOP", 0, -200);
BuffButtonFrame:RegisterEvent("UNIT_AURA")
BuffButtonFrame:RegisterEvent("PLAYER_IN_COMBAT_CHANGED")

local function createBuffButton(index)
    local BuffButton = CreateFrame("Button", nil, BuffButtonFrame, "SecureActionButtonTemplate")
    BuffButton:SetPoint("CENTER", UIParent, "TOP", (index-1)*140, -200);
    BuffButton:SetSize(120, 120);

    BuffButton.icon = BuffButton:CreateTexture(nil, "BACKGROUND");
    BuffButton.icon:SetAllPoints(BuffButton);
    BuffButton.icon:SetTexture(535595);
    BuffButton:SetAlpha(0.55);
    BuffButton:Hide()

    BuffButton:SetAttribute("type", "macro")
    BuffButton:SetAttribute("type1", "macro")
    BuffButton:SetAttribute("macrotext", "/cast SpellName")
    BuffButton:RegisterForClicks("LeftButtonDown", "LeftButtonUp")
    BuffButton:SetMouseClickEnabled(true)
    return BuffButton
end

local buffButtons = {
    createBuffButton(1),
    createBuffButton(2),
    createBuffButton(3),
}

local function setMissing(id, macro, index)
    if index > #buffButtons then
        return
    end
    local BuffButton = buffButtons[index]
    local spellInfo = C_Spell.GetSpellInfo(id)
    -- print("Buff", spellInfo.name, "is missing")
    BuffButton.icon:SetTexture(spellInfo.iconID)
    BuffButton:SetAttribute("macrotext", macro)
    BuffButton:Show()
end

local function updateBuffButtons()
    if PlayerIsInCombat() then
        return
    end

    local missingCount = 0

    local auras = C_UnitAuras.GetUnitAuras("player", "PLAYER HELPFUL")
    local auraMap = {}
    for _,aura in ipairs(auras) do
        if issecretvalue(aura.spellId) then
            return
        end
        auraMap[aura.spellId] = true
    end
    for buff,info in pairs(buffs) do
        if info.known == nil or C_SpellBook.IsSpellKnown(info.known) then
            if auraMap[buff] == nil then
                if info.alt == nil or auraMap[info.alt] == nil then
                    -- print(buff, "is missing")
                    missingCount = missingCount + 1
                    setMissing(buff, info.macro, missingCount)
                end
            end
        end
    end
    for i = missingCount + 1, #buffButtons, 1 do
        buffButtons[i]:Hide()
    end
end

BuffButtonFrame:SetScript("OnEvent", function(self, event, ...)
    if not NS.checkSetting(moduleName) then
        BuffButtonFrame:Hide()
        return
    end

    if event == "PLAYER_IN_COMBAT_CHANGED" then
        local in_combat = ...
        if in_combat then
            BuffButtonFrame:Hide()
        else
            BuffButtonFrame:Show()
            updateBuffButtons()
        end
    elseif event == "UNIT_AURA" then
        local unit, info = ...
        if unit == "player" then
            updateBuffButtons()
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
            false --defaultValue
        )
        Settings.CreateCheckbox(subCat, setting, moduleDescription)
    end
end);
