local addonName, NS = ...
local moduleName = "QuestHelper"
local moduleDescription = "Helps you complete your Kalu'ak rep"

local questNPCs = {
    [25476] = {name="Waltor of Pal'ea",     map=114, x=32.2, y=54.2},
    [25435] = {name="Karuk",                map=114, x=47.0, y=75.4},
    [25450] = {name="Veehja",               map=114, x=43.6, y=80.6},
    [26169] = {name="Ataika",               map=114, x=63.8, y=46.0},
    [26213] = {name="Utaik",                map=114, x=63.8, y=45.8},
    [26218] = {name="Elder Muahit",         map=114, x=67.2, y=54.8},
    [187565] = {name="Elder Atkanok",       map=114, x=54.6, y=35.9},
    [25292] = {name="Etaruk",               map=114, x=54.2, y=36.2},
    [28382] = {name="Hotawa",               map=114, x=67.2, y=54.8},
    [26194] = {name="Elder Ko'nani",        map=115, x=48.0, y=74.8},
    [26228] = {name="Trapper Mau'i",        map=115, x=48.2, y=74.2},
    [26595] = {name="Toalu'u the Mystic",   map=115, x=49.0, y=75.6},
    [188419] = {name="Elder Mana'loa",      map=115, x=36.4, y=64.9},
    [26245] = {name="Tua'kea",              map=115, x=47.6, y=76.6},
    [188364] = {name="Wrecked Crab Trap",   map=115, x=47.7, y=79.9},
    [24755] = {name="Elder Atuik",          map=117, x=25.0, y=57.0},
    [23804] = {name="Orfus of Kamagua",     map=117, x=40.2, y=60.2},
    [24643] = {name="Grezzix Spindlesnap",  map=117, x=23.0, y=62.4},
    [24539] = {name="\"Silvermoon\" Harry", map=117, x=35.0, y=80.8},
}

local quests = {
    -- Karuk
    {id=11655, giver=25476, completer=25476, also=11660},
    {id=11660, giver=25476, completer=25476},
    {id=11656, giver=25476, completer=25476, also=11661},
    {id=11661, giver=25476, completer=25476},
    {id=11662, giver=25476, completer=25435},
    -- Karuk & Veehja
    {id=11613, giver=25435, completer=25435},
    {id=11619, giver=25435, completer=25435},
    {id=11620, giver=25435, completer=25450},
    {id=11625, giver=25450, completer=25450},
    {id=11626, giver=25450, completer=25435},
    -- Ataika
    {id=11949, giver=26169, completer=26169, also=11945},
    {id=11945, giver=26213, completer=26213},
    {id=11950, giver=26169, completer=26218},
    {id=11961, giver=26218, completer=26218},
    {id=11968, giver=26218, completer=26218},
    -- Elder Atkanok & Etaruk
    {id=11605, giver=187565, completer=187565, also=11612},
    {id=11612, giver=25292, completer=25292},
    {id=11607, giver=187565, completer=187565, also=11617},
    {id=11617, giver=25292, completer=25292},
    {id=11609, giver=187565, completer=187565, also=11623},
    {id=11623, giver=25292, completer=25292},
    {id=11610, giver=187565, completer=187565},
    -- Breadcrumb
    {id=12117, giver=28382, completer=26194},
    -- Moa'ki Harbor
    {id=11958, giver=26194, completer=26194, also=11960},
    {id=11960, giver=26228, completer=26228},
    {id=11959, giver=26194, completer=26194},
    -- Elder Toalu'u the Mystic & Elder Mana'loa
    {id=12028, giver=26595, completer=26595},
    {id=12030, giver=26595, completer=188419},
    {id=12031, giver=188419, completer=188419},
    {id=12032, giver=188419, completer=26595},
    -- Tua'kea
    {id=12009, giver=26245, completer=26245, also=12011},
    {id=12011, giver=188364, completer=26245},
    {id=12016, giver=26245, completer=26245},
    {id=12017, giver=26245, completer=26245},

    -- Kamagua - Elder Atuik & Orfus of Kamagua
    {id=11456, giver=24755, completer=24755},
    {id=11457, giver=24755, completer=24755},
    {id=11458, giver=24755, completer=24755},
    {id=11504, giver=23804, completer=23804},
    {id=11507, giver=23804, completer=24755},
    {id=11508, giver=24755, completer=24643},
    {id=11509, giver=24643, completer=24539},
    -- Silvermoon Harry
    {id=11510, giver=24539, completer=24539},
    {id=11511, giver=24539, completer=24539, also=11512},
    {id=11512, giver=24539, completer=23804},
}



QuestHelperFrame = CreateFrame("Frame", "QuestHelper", UIParent, "TooltipBorderedFrameTemplate")--, "BasicFrameTemplateWithInset")
QuestHelperFrame:SetSize(400, 150)

QuestHelperFrame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
QuestHelperFrame:EnableMouse(true)
QuestHelperFrame:SetMovable(true)
QuestHelperFrame:RegisterForDrag("LeftButton")
QuestHelperFrame:SetScript("OnDragStart", function(self)
	self:StartMoving()
end)
QuestHelperFrame:SetScript("OnDragStop", function(self)
	self:StopMovingOrSizing()
    local point, relativeTo, relativePoint, xOfs, yOfs = QuestHelperFrame:GetPoint(1)
    BloodCrowToolsSettings["QuestHelperX"] = xOfs
    BloodCrowToolsSettings["QuestHelperY"] = yOfs
end)

QuestHelperFrame.text = QuestHelperFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
QuestHelperFrame.text:SetPoint("TOPLEFT", QuestHelperFrame, "TOPLEFT", 15, -15)
QuestHelperFrame.text:SetText("Testing")
QuestHelperFrame.text:SetJustifyH("LEFT")

local function updateWindow(text)
    QuestHelperFrame.text:SetText(text)
    local w = QuestHelperFrame.text:GetStringWidth()
    local h = QuestHelperFrame.text:GetStringHeight()
    QuestHelperFrame:SetSize(w+30, h+30)
    QuestHelperFrame:Show()
end

local function setWaypoint(target)
   local mapPoint = UiMapPoint.CreateFromVector2D(target.map, CreateVector2D(target.x/100, target.y/100))
   C_Map.SetUserWaypoint(mapPoint)
   C_SuperTrack.SetSuperTrackedUserWaypoint(true)
end

local function criteriaComplete(questID)
    local ob = C_QuestLog.GetQuestObjectives(questID)
    if objectives == nil then
        return true
    end
    for _, criteria in ipairs(ob) do
        if not criteria.finished then
            return false
        end
    end
    return true
end

local function getQuest(id)
    for _, q in ipairs(quests) do
        if q.id == id then
            return q
        end
    end
end

local function getTarget(q, active)
    if not q then
        return
    end
    local tar = nil
    if active then
        tar = q.completer
    else
        tar = q.giver
    end
    local npc = questNPCs[tar]
    if not npc then
        return
    end
    return npc
end

local function findCurrentQuest()
    for _, quest in ipairs(quests) do
        if not C_QuestLog.IsQuestFlaggedCompleted(quest.id) then
            return quest
        end
    end
end


local function trackQuest(questID)
    C_SuperTrack.SetSuperTrackedQuestID(questID)
    C_Map.ClearUserWaypoint()
end

local function update()
    local quest = findCurrentQuest()
    if not quest then
        updateWindow("All done!")
        return
    end

    local questName = QuestUtils_GetQuestName(quest.id)
    local questActive = C_QuestLog.IsOnQuest(quest.id)
    local questDone = criteriaComplete(quest.id)
    local questTarget = getTarget(quest, questActive)

    local alsoQuest, alsoQuestName, alsoQuestActive, alsoQuestDone, alsoQuestTarget = nil, nil, nil, nil, nil
    local alsoQuestValid = quest.also ~= nil and not C_QuestLog.IsQuestFlaggedCompleted(quest.also)
    
    if alsoQuestValid then
        alsoQuest = getQuest(quest.also)
        alsoQuestName = QuestUtils_GetQuestName(quest.also)
        alsoQuestActive = C_QuestLog.IsOnQuest(quest.also)
        alsoQuestDone = criteriaComplete(quest.also)
        alsoQuestTarget = getTarget(alsoQuest, alsoQuestActive)
    end

    local windowText = ""
    local waypointTarget = nil

    if questActive then
        if questDone then
            windowText = "• Turn In " .. questName
        else
            windowText = "• Complete " .. questName
        end
        waypointTarget = quest.id
    else
        windowText = "• Go to " .. questTarget.name .. " and pick up " .. questName
        waypointTarget = questTarget
    end

    if alsoQuestValid then
        if alsoQuestActive then
            if alsoQuestDone then
                windowText = windowText .. "\n• Turn In " .. alsoQuestName
            else
                if questDone then
                    waypointTarget = quest.also
                    windowText =  "• Complete " .. alsoQuestName .. "\n" .. windowText
                else
                    windowText = windowText .. "\n• Complete " .. alsoQuestName
                end
            end
        else
            windowText = "• Go to " .. alsoQuestTarget.name .. " and pick up " .. alsoQuestName .. "\n" .. windowText
            if questActive then
                waypointTarget = alsoQuestTarget
            end
        end
    end

    if type(waypointTarget) == "number" then
        trackQuest(waypointTarget)
    else
        setWaypoint(waypointTarget)
    end

    updateWindow(windowText)
end

local events = {
    "ADDON_LOADED",
    "CVAR_UPDATE",
    "QUEST_LOG_UPDATE",
    "UNIT_SPELLCAST_SENT",
    "QUEST_GREETING",
    "GOSSIP_SHOW",
    "QUEST_COMPLETE",
    "QUEST_DETAIL",
}

NS.registerEvents(events, true)
QuestHelperFrame:SetScript("OnEvent", function(self, event, ...)
    if not NS.checkSetting(moduleName) then
        NS.registerEvents(events, false)
        QuestHelperFrame:Hide()
        return
    end
    if event == "QUEST_DETAIL" then
        if getQuest(GetQuestID()) ~= nil then
            AcceptQuest()
        end
    elseif event == "QUEST_COMPLETE" then
        local qid = GetQuestID()
        if getQuest(qid) ~= nil and criteriaComplete(qid) then
            if GetNumQuestRewards() < 2 then
                GetQuestReward(1)
            end
        end
    elseif event == "GOSSIP_SHOW" then
        for _,q in pairs(C_GossipInfo.GetAvailableQuests()) do
            if getQuest(q.questID) ~= nil then
                C_GossipInfo.SelectAvailableQuest(q.questID)
            end
        end
        for _,q in pairs(C_GossipInfo.GetActiveQuests()) do
            if getQuest(q.questID) ~= nil and criteriaComplete(q.questID) then
                C_GossipInfo.SelectActiveQuest(q.questID)
                CompleteQuest()
            end
        end
    elseif event == "ADDON_LOADED" then
        local addon, _ = ...
        if addon == "BloodCrowTools" then
            if BloodCrowToolsSettings["QuestHelperX"] ~= nil and BloodCrowToolsSettings["QuestHelperY"] ~= nil then
                QuestHelperFrame:SetPoint("CENTER", UIParent, "CENTER", BloodCrowToolsSettings["QuestHelperX"], BloodCrowToolsSettings["QuestHelperY"])
            end
        end
    else
        update()
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
            type(false), --type
            "Enable " .. moduleName, --label?
            false --defaultValue
        )
        setting:SetValueChangedCallback(function()
            if NS.checkSetting(moduleName) then
                QuestHelperFrame:Show()
                NS.registerEvents(events, true)
            else
                QuestHelperFrame:Hide()
                NS.registerEvents(events, false)
            end
        end);
        Settings.CreateCheckbox(subCat, setting, moduleDescription)
    end
end);
