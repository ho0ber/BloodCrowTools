local addonName, NS = ...

local annoyingSounds = {
    -- MON_Moose_Aggro
    1126365, 1126366, 1126367, 1126368, 1126316, 1126317,
    -- MON_Moose_Attack
    1126318, 1126319, 1126320, 1126321, 1126322, 1126323, 1126324, 1126325, 1126326, 1126327,
    -- MON_Moose_AttackCrit
    1126328, 1126329, 1126330, 1126331, 1126332,
    -- MON_Moose_Death
    1126333, 1126334, 1126335, 1126336, 1126337, 1126338,
    -- MON_Moose_MountSpecial
    1126339, 1126340, 1126341, 1126342, 1126343, 1126344,
    -- MON_Moose_PreAggro
    1126345, 1126346, 1126347, 1126348, 1126349,
    -- MON_Moose_Wound
    1126350, 1126351, 1126352, 1126353, 1126354, 1126355, 1126356, 1126357, 1126358,
    -- MON_Moose_WoundCrit
    1126359, 1126360, 1126361, 1126362, 1126363, 1126364,
    -- I understand your frustration, Geya'rah
    6652259
}

local muteEventFrame = CreateFrame("Frame")
muteEventFrame:RegisterEvent("ADDON_LOADED")
muteEventFrame:SetScript("OnEvent", function(self, event, addon)
    if not NS.checkSetting("MuteAnnoyingSounds") then
        return
    end

    if addon == "BloodCrowTools" then
        for _, soundID in ipairs(annoyingSounds) do
            MuteSoundFile(soundID)
        end
    end
end);
