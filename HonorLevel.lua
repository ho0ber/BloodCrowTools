local addonName, NS = ...

local HonorLevelFrame = CreateFrame("Frame", nil, TargetFrame.TargetFrameContainer);
HonorLevelFrame.title = HonorLevelFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlightLarge");
local file, size = HonorLevelFrame.title:GetFont()
HonorLevelFrame.title:SetFont(file, size, "THICKOUTLINE")
HonorLevelFrame.title:SetPoint("CENTER", TargetFrame.TargetFrameContent.TargetFrameContentContextual.PrestigePortrait, "CENTER", 0, -1)
HonorLevelFrame.title:SetText("100")

HonorLevelFrame:RegisterEvent("PLAYER_TARGET_CHANGED")
HonorLevelFrame:RegisterEvent("UNIT_TARGET")
HonorLevelFrame:SetScript("OnEvent", function(self, event, ...)
    if not NS.checkSetting("HonorLevel") then
        HonorLevelFrame.title:SetText("")
        return
    end

    local hl = UnitHonorLevel("target")
    if hl ~= null and hl > 0 then
        HonorLevelFrame.title:SetText(hl)
    else
        HonorLevelFrame.title:SetText("")
    end
    
end);
