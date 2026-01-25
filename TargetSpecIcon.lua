local addonName, NS = ...

local specIcons = {
    ["Affliction Warlock"] = 136145,
    ["Arcane Mage"] = 135932,
    ["Arms Warrior"] = 132355,
    ["Assassination Rogue"] = 236270,
    ["Augmentation Evoker"] = 5198700,
    ["Balance Druid"] = 136096,
    ["Beast Mastery Hunter"] = 461112,
    ["Blood Death Knight"] = 135770,
    ["Brewmaster Monk"] = 608951,
    ["Demonology Warlock"] = 136172,
    ["Destruction Warlock"] = 136186,
    ["Devastation Evoker"] = 4511811,
    ["Devourer Demon Hunter"] = 7455385,
    ["Discipline Priest"] = 135940,
    ["Elemental Shaman"] = 136048,
    ["Enhancement Shaman"] = 237581,
    ["Feral Druid"] = 132115,
    ["Fire Mage"] = 135810,
    ["Frost Death Knight"] = 135773,
    ["Frost Mage"] = 135846,
    ["Fury Warrior"] = 132347,
    ["Guardian Druid"] = 132276,
    ["Havoc Demon Hunter"] = 1247264,
    ["Holy Paladin"] = 535593,
    ["Holy Priest"] = 237542,
    ["Marksmanship Hunter"] = 236179,
    ["Mistweaver Monk"] = 608952,
    ["Outlaw Rogue"] = 236286,
    ["Preservation Evoker"] = 4511812,
    ["Protection Paladin"] = 236264,
    ["Protection Warrior"] = 132341,
    ["Restoration Druid"] = 136041,
    ["Restoration Shaman"] = 136052,
    ["Retribution Paladin"] = 535595,
    ["Shadow Priest"] = 136207,
    ["Subtlety Rogue"] = 132320,
    ["Survival Hunter"] = 461113,
    ["Unholy Death Knight"] = 135775,
    ["Vengeance Demon Hunter"] = 1247265,
    ["Windwalker Monk"] = 608953,
}

local TargetSpecButton = CreateFrame("Button",nil,TargetFrame.TargetFrameContainer);
TargetSpecButton:SetPoint("RIGHT", TargetFrame.TargetFrameContainer, "LEFT", 20, 0);
TargetSpecButton:SetSize(40,40);
TargetSpecButton:SetHighlightTexture("Interface\\Buttons\\ButtonHilight-Square","ADD");
TargetSpecButton:SetPushedTexture("Interface\\Buttons\\UI-Quickslot-Depress");
 
TargetSpecButton.icon = TargetSpecButton:CreateTexture(nil,"BACKGROUND");
TargetSpecButton.icon:SetAllPoints(TargetSpecButton);
TargetSpecButton.icon:SetTexture(535595); --"Interface\\Icons\\INV_Misc_ArmorKit_17");
 
TargetSpecButton:SetScript("OnClick",function(self,button)
    print("He he he, that tickles!");
end);

TargetSpecButton:RegisterEvent("PLAYER_TARGET_CHANGED")
TargetSpecButton:RegisterEvent("UNIT_TARGET")
TargetSpecButton:SetScript("OnEvent", function(self, event, ...)
    local targetInfo = C_TooltipInfo.GetUnit("target")
    if targetInfo == nil then
        self:Hide()
        return
    end

    local lines = targetInfo.lines;
    if lines == nil then
        self:Hide()
        return
    end

    for _, line in ipairs(lines) do
        if specIcons[line.leftText] then
            self:Show()
            self.icon:SetTexture(specIcons[line.leftText])
            return
        end
    end

    self:Hide()
end);
