local AddonName, NS = ...
local ModuleName = "DisconnectAlert"
local ModuleDescription = "Shows an icon and plays a loud alert when a party member becomes disconnected"
local SoundChannels = {"Master", "SFX"}

--
-- Global variable for /dump debugging only.
--

DisconnectAlert_PartyTable = {}

--
-- Global variable for /run DisconnectAlert_DebugEnabled = true only.
--

DisconnectAlert_DebugEnabled = false

local AlertIcon = CreateFrame("Frame", nil, UIParent);
AlertIcon:SetPoint("CENTER", UIParent, "TOP", 0, -200);
AlertIcon:SetSize(120, 120);

AlertIcon.icon = AlertIcon:CreateTexture(nil, "BACKGROUND");
AlertIcon.icon:SetAllPoints(AlertIcon);
AlertIcon.icon:SetTexture(132161);
AlertIcon:SetAlpha(0.55);
AlertIcon:Hide()

EventRegistry:RegisterFrameEventAndCallback("PARTY_LEADER_CHANGED",
function(...)
    DisconnectAlert_OnPartyLeaderChanged()
end);

local function DisconnectAlert_DbgPrint(...)
    if not DisconnectAlert_DebugEnabled then
        return
    end

    print(...)
end

function DisconnectAlert_OnPartyLeaderChanged()

    --
    -- When the party leader changes, partyN unit tokens may shift which unit
    -- they refer to.  Remove the party table state in this case so that it may
    -- be rebuilt.  If the party table state were able to use a unique identity
    -- this would not be necessary, however the unique identities are secret
    -- values while in combat.
    --

    DisconnectAlert_DbgPrint("DisconnectAlert: Party leader changed, resetting party table.")
    DisconnectAlert_PartyTable = {}

    --
    -- Pick up the current state next frame.
    --

    C_Timer.After(0, function() DisconnectAlert_ProcessPartyChanges() end)
end

local function DisconnectAlert_ProcessUnitToken(Token)
    local Connected = UnitIsConnected(Token)

    --
    -- Skip non-existent tokens.
    --

    if not UnitExists(Token) then
        return
    end

    DisconnectAlert_DbgPrint("DisconnectAlert: Checking unit token: " .. Token)

    --
    -- We'd like to use UnitName but it might be a secret value.  So, just use
    -- the unit token.  Unfortunately, this means that we must erase our state
    -- when the group size changes, as the unit token mappings might shift.  It
    -- is hoped to be unlikely that disconnect transitions coinciding with a
    -- group size change are a rare case.
    --

--  local Name = UnitName(Token)
    local Name = Token

    --
    -- Unit name might not be available when first joining a party.
    --

    if Name == nil then
        return
    end

    local Entry = DisconnectAlert_PartyTable[Name]

    --
    -- Create a table entry for first detected party members up front.  In this
    -- case, the previous state becomes the current state, so no alert will be
    -- generated when joining a party with disconnected party members.
    --

    if Entry == nil then
        DisconnectAlert_PartyTable[Name] = Connected
        Entry = DisconnectAlert_PartyTable[Name]
        DisconnectAlert_DbgPrint("DisconnectAlert: Initial state for " .. Name .. ": " .. tostring(Connected))
    end

    if Entry ~= Connected then
        DisconnectAlert_DbgPrint("DisconnectAlert: New state for " .. Name .. ": " .. tostring(Connected))
    end

    --
    -- If the previous state was connected and the new state is not connected
    -- then fire the alert.
    --

    if Entry ~= false and Connected == false then
        local Channel = SoundChannels[BloodCrowToolsSettings.disconnectAlertSoundChannel]

        if Channel ~= 3 then
            PlaySound(97225, Channel) -- Stampwhistle_Cast
        end

        RaidNotice_AddMessage(RaidWarningFrame, string.concat(UnitName(Token), " disconnected."), ChatTypeInfo["RAID_WARNING"])
        AlertIcon:Show()
        C_Timer.After(10, function()
            AlertIcon:Hide()
        end);
    end

    DisconnectAlert_PartyTable[Name] = Connected
end

local function DisconnectAlert_ScheduleTimer()
    C_Timer.After(0.1, function() DisconnectAlert_OnTimer() end)
end

function DisconnectAlert_ProcessPartyChanges()
    local Removed = true
    local Count = 0
    local GroupCount = GetNumGroupMembers()

    for _, _ in pairs(DisconnectAlert_PartyTable) do
        Count = Count + 1
    end

    --
    -- Self is not included in the count of party members, but is in the count
    -- of raid members.
    --

    if not IsInRaid() then
        GroupCount = GroupCount - 1
    end

    if GroupCount ~= Count then
        DisconnectAlert_DbgPrint("DisconnectAlert: Clearing party table due to size change (" .. tostring(GroupCount) .. ", " .. tostring(Count) .. ").")
        DisconnectAlert_PartyTable = {}
    end

    --
    -- Remove stale party members.
    --

    while Removed do
        Removed = false
        for Name, State in pairs(DisconnectAlert_PartyTable) do
            if not UnitInParty(Name) and not UnitInRaid(Name) then
                DisconnectAlert_PartyTable[Name] = nil
                Removed = true
                break
            end
        end
    end

    --
    -- Monitor for connected/disconnected state changes.
    --

    if IsInRaid() then
        for i = 1, 40 do
            DisconnectAlert_ProcessUnitToken("raid"..i)
        end
    elseif GetNumGroupMembers() > 0 then
        for i = 1, 5 do
            DisconnectAlert_ProcessUnitToken("party"..i)
        end
    else
        DisconnectAlert_DbgPrint("DisconnectAlert: Clearing party table as the player is not in a group.")
        DisconnectAlert_PartyTable = {}
    end
end

function DisconnectAlert_OnTimer()
    if not NS.checkSetting(ModuleName) then
        AlertIcon:Hide()
        DisconnectAlert_ScheduleTimer()
        return
    end

    --
    -- Scan for party changes.
    --

    DisconnectAlert_ProcessPartyChanges()

    --
    -- Continue polling.
    --

    DisconnectAlert_ScheduleTimer()
end

--
-- We'd like to just call DisconnectAlert_OnTimer directly, but the settings
-- table may not exist yet.
--

C_Timer.After(0.1, DisconnectAlert_OnTimer)

--
-- Settings
--
table.insert(NS.settingsSubcategories, function()
    local subCat = Settings.RegisterVerticalLayoutSubcategory(NS.settingsCategory, ModuleName)
    do 
        local setting = Settings.RegisterAddOnSetting(
            subCat, --category
            "enable" .. ModuleName, --variable
            "enable" .. ModuleName, --variableKey
            BloodCrowToolsSettings, --variableTbl
            type(true), --type
            "Enable " .. ModuleName, --label?
            true --defaultValue
        )
        Settings.CreateCheckbox(subCat, setting, ModuleDescription)
    end

    do
        local variable = "disconnectAlertSoundChannel"
        local defaultValue = 1
        local name = "Sound Channel"
        local tooltip = "Which sound channel for group member disconnect alerts"
        local variableKey = "disconnectAlertSoundChannel"
        local variableTbl = BloodCrowToolsSettings
    
        local function GetOptions()
            local container = Settings.CreateControlTextContainer()
            container:Add(1, "Master")
            container:Add(2, "SFX")
            container:Add(3, "Disabled")
            return container:GetData()
        end
    
        local setting = Settings.RegisterAddOnSetting(subCat, variable, variableKey, variableTbl, type(defaultValue), name, defaultValue)
        Settings.CreateDropdown(subCat, setting, GetOptions, tooltip)
    end
end);
