--[[
    Soundtrack addon for World of Warcraft

    General functions.
]]

Soundtrack_EventTabs = {
    "Battle", 
    "Boss",
    "Zone", 
    "Dance",
    "Misc",
    "Custom", 
    "Playlists"
}

Soundtrack_Events = {}
Soundtrack_CustomEvents = {}
Soundtrack_BattleEvents = {}
Soundtrack_MiscEvents = {}
Soundtrack_FlatEvents = {} -- Event nodes, but with collapsed events removed. used to match scrolling lists
Soundtrack_EventNodes = {} -- Like sorted events, except its in a tree structure
Soundtrack_Profiles = {}

Soundtrack_Tracks = nil
Soundtrack_SortedTracks = {}

local _SuspendSorting = false
local _TracksLoaded = false

function Soundtrack.IsNullOrEmpty(text)
    return not text or text == ""
end

-- Removes obsolete tracks from events.
local function PurgeEventsFromTable(eventTableName)
    local eventTable = Soundtrack.Events.GetTable(eventTableName)
    
    for k, v in pairs(eventTable) do
        local tracksToRemove = {}
        
        -- Find tracks to remove
        for i,trackName in ipairs(v.tracks) do
            if not Soundtrack_Tracks[trackName] then
                Soundtrack.Message("Removed obsolete track "..trackName)
                table.insert(tracksToRemove, trackName)
            end
        end
        
        -- Remove tracks
        for i,trackToRemove in ipairs(tracksToRemove) do
            Soundtrack.Events.Remove(eventTableName, k, trackToRemove)
        end

    end
end

local function CheckForPurgeEvents(eventTableName)
	local eventTable = Soundtrack.Events.GetTable(eventTableName)
    
    for k, v in pairs(eventTable) do
        local tracksToRemove = {}
        
        -- Find tracks to remove
        for i,trackName in ipairs(v.tracks) do
            if not Soundtrack_Tracks[trackName] then
                -- Track found to remove
				return true
            end
        end
    end
	
	return false
end

-- Removes obsolete tracks from event assignments
-- DONE If user forgot MyTracks.lua, this could wipe all assignments. Confirmation box?
local function PurgeEvents()
	local eventsToPurge = false
	for i,event in ipairs(Soundtrack_EventTabs) do
		if CheckForPurgeEvents(event) then
			eventsToPurge = true;
		end
	end
	if eventsToPurge then
		StaticPopup_Show("SOUNDTRACK_PURGE_POPUP");
	end
end
local function PurgeEventsConfirmed()
    for i,event in ipairs(Soundtrack_EventTabs) do
        PurgeEventsFromTable(event)
    end
end
StaticPopupDialogs["SOUNDTRACK_PURGE_POPUP"] = {
    text = SOUNDTRACK_PURGE_EVENTS_QUESTION,
    button1 = TEXT(ACCEPT),
    button2 = TEXT(CANCEL),
    OnAccept = function() 
		PurgeEventsConfirmed()
    end,
	OnCancel = function()
		StaticPopup_Show("SOUNDTRACK_NO_PURGE_POPUP");
	end,
    timeout = 0,
    whileDead = 1
}
StaticPopupDialogs["SOUNDTRACK_NO_PURGE_POPUP"] = {
    text = SOUNDTRACK_GEN_LIBRARY,
    button1 = TEXT(ACCEPT),
    button2 = TEXT(CANCEL),
    OnAccept = function() 
    end,
    timeout = 0,
    whileDead = 1,
    hideOnEscape = 1
}

-- Default values for the Soundtrack.Settings table
local _DefaultSettings = 
{
    MinimapIconPos = 45,
    EnableMinimapButton = true,
    ShowTrackInformation = true,
    ShowDefaultMusic = false,
    ShowEventStack = false,
    ShowPlaybackControls = false,
    EnableBattleMusic = true,
    EnableZoneMusic = true,
    EnableMiscMusic = true,
    EnableCustomMusic = true,
    Debug = false,
    BattleCooldown = 0,
    Silence = 5,
    AutoAddZones = true,
    EscalateBattleMusic = true,
    trackSortingCriteria = "filePath",
	getTime = 0,
	CurrentProfileBattle = "Default",
	CurrentProfileZone = "Default",
	CurrentProfileDance = "Default",
	CurrentProfileMisc = "Default",
	UseDefaultLoadMyTracks = false,
	LockNowPlayingFrame = false,
	LockPlaybackControls = false,
	HideControlButtons = false,
	PlaybackButtonsPosition = "LEFT",
	LowHealthPercent = .25,
	YourEnemyLevelOnly = false;
}


-- Transfers default settings from _DefaultSettings to Soundtrack.Settings 
-- if the options are missing.
local function InitDefaultSettings()
    -- Add missing values
    for k,v in pairs(_DefaultSettings) do
        if Soundtrack.Settings[k] == nil then 
			Soundtrack.Settings[k] = v 
		end
    end
	Soundtrack.Settings.getTime = GetTime();
end

local function GetPathFileNameRecursive(filePath)
    local index1 = string.find(filePath, "/")
    if not index1 then
        return filePath
    else
        return Soundtrack.GetPathFileName(string.sub(filePath, index1 + 1))
    end
end


-- Strips a path string from the path and returns the file name at the end.
-- Used to strip parent events or parent folders from event and track names.
function Soundtrack.GetPathFileName(filePath)
    local temp = string.gsub(filePath, "\\", "/") 
    return GetPathFileNameRecursive(temp)
end

function Soundtrack.AddEvent(tableName, eventName, _priority, _continuous, _soundEffect)
    if Soundtrack.IsNullOrEmpty(tableName) then
        Soundtrack.Error("AddEvent: Nil table")
        return
    end
    if Soundtrack.IsNullOrEmpty(eventName) then
        Soundtrack.Error("AddEvent: Nil event")
        return
    end
    
    local eventTable = Soundtrack.Events.GetTable(tableName)
    
    if not eventTable then
        Soundtrack.Error("AddEvent: Cannot find table : " .. tableName)
        return
    end
    
    local event = eventTable[eventName]
    if event then
		event.priority = _priority
		if event.continuous == nil then
			event.continuous = _continuous
		end
		if event.soundEffect == nil then
			event.soundEffect = _soundEffect
		end
        return -- event is already registered
    end
    
    Soundtrack.TraceEvents("AddEvent: " .. tableName .. ": " .. eventName)
    
    eventTable[eventName] = 
    { 
        tracks = {}, 
        lastTrackIndex = 0, 
        random = true, 
        priority = _priority, 
        continuous = _continuous,
		soundEffect = _soundEffect
    }  
	
	Soundtrack_SortEvents(tableName)
end

-- Added by Lunaqua
function Soundtrack.RenameEvent(tableName, oldEventName, newEventName, _priority, _continuous, _soundEffect)
  
    if Soundtrack.IsNullOrEmpty(tableName) then
        Soundtrack.Error("RenameEvent: Nil table")
        return
    end
    if Soundtrack.IsNullOrEmpty(oldEventName) then
        Soundtrack.Error("RenmeEvent: Nil old event")
        return
    end
	if Soundtrack.IsNullOrEmpty(newEventName) then
        Soundtrack.Error("RenameEvent: Nil new event " .. oldEventName)
        return
    end
	
    local eventTable = Soundtrack.Events.GetTable(tableName)
    
    if not eventTable then
        Soundtrack.Error("RenameEvent: Cannot find table : " .. tableName)
        return
    end
	
    local event = eventTable[newEventName]
	if event then
        if event.priority == nil then
			event.priority = _priority
		end
		if event.continuous == nil then
			event.continuous = _continuous
		end
		event.soundEffect = _soundEffect
        return -- event is already registered
    end
    
	Soundtrack.TraceEvents("RenameEvent: " .. tableName .. ": " .. oldEventName .. " to " .. newEventName)
    
    eventTable[newEventName] = eventTable[oldEventName]

	-- Now that we changed the name of the event, delete the old event
	Soundtrack.Events.DeleteEvent(tableName, oldEventName)
	
    -- Because I cant figure out how to sort the hashtable...
    Soundtrack_SortEvents(tableName)
end

function Soundtrack.AssignTrack(eventName, trackName)
    if Soundtrack.IsNullOrEmpty(eventName) or Soundtrack.IsNullOrEmpty(trackName) then
        debugEvents("AddEvent: Invalid table or event name")
        return
    end

    local tableName = Soundtrack.GetTableFromEvent(eventName)
    local eventTable = Soundtrack.Events.GetTable(tableName)
    
    if not eventTable then
        debugEvents("Cannot find table : " .. tableName)
        return
    end
    
    table.insert(eventTable[eventName].tracks, trackName)
end

local function Soundtrack_SetFrameLocks()
	-- If option true, then disable mouse.
	local enableMouse = not Soundtrack.Settings.LockNowPlayingFrame
	NowPlayingTextFrame:EnableMouse(enableMouse)
	
	enableMouse = not Soundtrack.Settings.LockPlaybackControls
	SoundtrackControlFrame:EnableMouse(enableMouse)
end

function Soundtrack_MyTracksExist()
	if SoundtrackMusic_LoadMyTracks then
		return true;
	else
		return false;
	end
end



local function SetUserEventsToCorrectLevel()
		local tableName = Soundtrack.Events.GetTable("Boss")
		for j, eventName in pairs(tableName) do		
			tableName[j].priority = ST_BOSS_LVL
			Soundtrack.Trace(j .. " set to " .. ST_BOSS_LVL)
		end

		tableName = Soundtrack.Events.GetTable("Playlists")
		for j, eventName in pairs(tableName) do		
			tableName[j].priority = ST_PLAYLIST_LVL
			Soundtrack.Trace(j .. " set to " .. ST_PLAYLIST_LVL)
		end
end

local function OnVariablesLoaded(self)

    if not Soundtrack_Settings then
        Soundtrack_Settings = {}
    end
    
    Soundtrack.Settings = Soundtrack_Settings
	Soundtrack.Util.InitDebugChatFrame()
	Soundtrack.Timers.AddTimer("InitDebugChatFrame", 1, Soundtrack.Util.InitDebugChatFrame)
	Soundtrack.Timers.AddTimer("InitDebugChatFrame", 2, Soundtrack.Util.InitDebugChatFrame)
	Soundtrack.Timers.AddTimer("InitDebugChatFrame", 3, Soundtrack.Util.InitDebugChatFrame)
	
    InitDefaultSettings()

    Soundtrack_Tracks = {}
    
    -- Load tracks in generated script if available
    Soundtrack_LoadDefaultTracks()

	if Soundtrack_LoadMyTracks and not _TracksLoaded then
        Soundtrack_LoadMyTracks()
		Soundtrack.Settings.UseDefaultLoadMyTracks = false;
		_TracksLoaded = true
	elseif not Soundtrack_LoadMyTracks and not Soundtrack.Settings.UseDefaultLoadMyTracks then 
		StaticPopup_Show("ST_NO_LOADMYTRACKS_POPUP");
		error(SOUNDTRACK_ERROR_LOADING) 
	elseif not Soundtrack_LoadMyTracks and Soundtrack.Settings.UseDefaultLoadMyTracks then
	    -- User has no tracks to load, and is intentional
	end   

    -- Create events table
    for i,eventTabName in ipairs(Soundtrack_EventTabs) do
        if not Soundtrack_Events[eventTabName] then
            Soundtrack.TraceEvents("Creating table "..eventTabName)
            Soundtrack_Events[eventTabName] = {}
        end
    end
    
    _SuspendSorting = true
	Soundtrack_SetFrameLocks()
	--[[
    Soundtrack.DanceEvents.Initialize()
    Soundtrack.ZoneEvents.Initialize()
    Soundtrack.BattleEvents.Initialize()
    Soundtrack.MountEvents.Initalize()
    Soundtrack.CustomEvents.Initialize(self)
	--]]
    _SuspendSorting = false
        
    -- Remove obsolete predefined events
	--PurgeEvents()
	Soundtrack.Timers.AddTimer("PurgeEvents", 5, PurgeEvents)
    

    -- sort all the tables
    for i,eventTabName in ipairs(Soundtrack_EventTabs) do
        Soundtrack_SortEvents(eventTabName)
    end
    
    Soundtrack.SortTracks()
    SetUserEventsToCorrectLevel()
	
    local numTracks = getn(Soundtrack_SortedTracks)
    DEFAULT_CHAT_FRAME:AddMessage("Soundtrack: Loaded with " .. numTracks.." track(s) in library.", 0.0, 1.0, 0.25)
    --[[
	Soundtrack.Trace("Num battle events "..getn(Soundtrack_SortedEvents["Battle"]))
    Soundtrack.Trace("Num zone events "..getn(Soundtrack_SortedEvents["Zone"]))
    Soundtrack.Trace("Num dance events "..getn(Soundtrack_SortedEvents["Dance"]))
    Soundtrack.Trace("Num misc events "..getn(Soundtrack_SortedEvents["Misc"]))
    Soundtrack.Trace("Num custom eventcustom events "..getn(Soundtrack_SortedEvents["Custom"]))
    Soundtrack.Trace("Num playlists "..getn(Soundtrack_SortedEvents["Playlists"]))
    --]]
	
    SoundtrackFrame_RefreshPlaybackControls()
end
StaticPopupDialogs["ST_NO_LOADMYTRACKS_POPUP"] = {
    text = SOUNDTRACK_NO_MYTRACKS,
    button1 = TEXT(ACCEPT),
    button2 = TEXT(CANCEL),
    OnAccept = function() 
		Soundtrack.Settings.UseDefaultLoadMyTracks = true;
		OnVariablesLoaded()
    end,
	OnCancel = function()
		Soundtrack.Settings.UseDefaultLoadMyTracks = false;
	end,
    timeout = 0,
    whileDead = 1,
}



function Soundtrack.GetTableFromEvent(eventName)
    for i,eventTabName in ipairs(Soundtrack_EventTabs) do
        local eventTable = Soundtrack.Events.GetTable(eventTabName)
        if eventTable and eventTable[eventName] then
            return eventTabName
        end
    end
    
    return nil
end

function Soundtrack.GetEvent(tableName, eventName)
    if not tableName or not eventName then
        return nil
    end

    local eventTable = Soundtrack.Events.GetTable(tableName)
    return eventTable[eventName]
end

function Soundtrack.GetEventByName(eventName)
    if not eventName then return nil end

    local tableName = Soundtrack.GetTableFromEvent(eventName)
        
    if not tableName then return nil end

    local eventTable = Soundtrack.Events.GetTable(tableName)
    return eventTable[eventName]
end


-- Todo Replace force restart with another method to "reset" an event or clear its history
function Soundtrack.PlayEvent(tableName, eventName, forceRestart)

    if not tableName then Soundtrack.Error("PlayEvent: Invalid table name") return end
    if not eventName then Soundtrack.Error("PlayEvent: Invalid event name") return end
	
    local eventTable = Soundtrack.Events.GetTable(tableName)
    if not eventTable then return end
    
    local event = eventTable[eventName]
    
    if not event then return end
    
    local playOnceText
    if event.continuous then
        playOnceText = "Loop"
    else 
        playOnceText = "Once"
    end
    
    local priorityText = "Priority: " .. event.priority or "Unset"
    
    local sfxText = ""
    if event.soundEffect then
        sfxText = " (SFX)"
    end
    
    Soundtrack.TraceEvents("PlayEvent("..tableName..", ".. Soundtrack.GetPathFileName(eventName) ..", ".. priorityText ..") "..playOnceText .. sfxText)    

    if not offset then 
        offset = 1 
    end

    -- Add event on the stack    
    if not event.priority then
        Soundtrack.Error("Cannot play event " .. eventName .. ". It has no priority!")
    elseif event.soundEffect then
        -- Sound effects are never added to the stack
        PlayRandomTrackByTable(tableName, eventName, offset)
    else
        Soundtrack.Events.Stack[event.priority].tableName = tableName
        Soundtrack.Events.Stack[event.priority].eventName = eventName
        Soundtrack.Events.Stack[event.priority].offset = offset
        Soundtrack.Events.OnStackChanged(forceRestart)
    end
end

-- Call this to stop music. Makes sure it only stops music Soundtrack has started.
function Soundtrack.StopEventAtLevel(stackLevel)    
    --verifyStackLevel(stackLevel)

	if stackLevel == 0 or
       not stackLevel then
        return
    else
		if Soundtrack.Events.Stack[stackLevel].eventName ~= nil then
			Soundtrack.TraceEvents("StopEvent("..stackLevel..")")
			-- Remove the event from the stack.
			Soundtrack.Events.Stack[stackLevel].eventName = nil
			Soundtrack.Events.Stack[stackLevel].tableName = nil
			Soundtrack.Events.Stack[stackLevel].offset = 0
			Soundtrack.Events.OnStackChanged()
		end
	end
end

function Soundtrack.StopEvent(tableName, eventName)    
    local event = Soundtrack.GetEvent(tableName, eventName)
    if event then
		Soundtrack.TraceEvents("StopEvent("..tableName..", "..eventName..")")
        Soundtrack.StopEventAtLevel(event.priority)
    end
end

-- Editing by Lunaqua
Soundtrack_Tooltip = CreateFrame( "GameTooltip", "SoundtrackTooltip", UIParent, "GameTooltipTemplate")
function Soundtrack.ShowTip(self, tipTitle, tipText, tipTextAuthor, tipTextAlbum)
	Soundtrack_Tooltip:SetOwner(self or UIParent, "ANCHOR_TOPRIGHT" )
	Soundtrack_Tooltip:ClearLines()
	Soundtrack_Tooltip:AddLine(tipTitle, 1, 1, 1, 1)
	if tipText ~= nil then
		Soundtrack_Tooltip:AddLine(tipText, nil, nil, nil, 1)
	end
	if tipTextAuthor ~= nil then
		Soundtrack_Tooltip:AddLine(tipTextAuthor, 1, .9, 0, 1)
	end
	if tipTextAlbum ~= nil then
		Soundtrack_Tooltip:AddLine(tipTextAlbum, 1, .5, 0, 1)
	end
	Soundtrack_Tooltip:Show()
end
function Soundtrack.HideTip()
	Soundtrack_Tooltip:Hide()
end

function StringSplit(text, delimiter)
  local list = {}
  local pos = 1
  if strfind("", delimiter, 1) then -- this would result in endless loops
    error("delimiter matches empty string!")
  end
  while 1 do
    local first, last = strfind(text, delimiter, pos)
    if first then -- found?
      tinsert(list, strsub(text, pos, first-1))
      pos = last+1
    else
      tinsert(list, strsub(text, pos))
      break
    end
  end
  return list
end

local function StringSplit(str, delim, maxNb)
    -- Eliminate bad cases...
    if string.find(str, delim) == nil then
        return { str }
    end
    if maxNb == nil or maxNb < 1 then
        maxNb = 0    -- No limit
    end
    local result = {}
    local pat = "(.-)" .. delim .. "()"
    local nb = 0
    local lastPos
    for part, pos in string.gmatch(str, pat) do
        nb = nb + 1
        result[nb] = part
        lastPos = pos
        if nb == maxNb then break end
    end
    -- Handle the last field
    if nb ~= maxNb then
        result[nb + 1] = string.sub(str, lastPos)
    end
    return result
end

-- event node : name, tag, nodes

-- Returns a child node if the name matches
local function GetChildNode(rootNode, childNodeName)
    
    if not rootNode then return nil end

    for i,n in ipairs(rootNode.nodes) do
        if childNodeName == n.name then
            return n
        end
    end 
    
    return nil
end

local function AddEventNode(rootNode, eventPath)
    if not rootNode then
        error("rootNode is nil")
    end

    local currentRootNode = rootNode

    local parts = StringSplit(eventPath, "/")
    for i,part in ipairs(parts) do
        
        local childNode = GetChildNode(currentRootNode, part)
        if not childNode then
            -- Add a new node if its missing
            local newNode = { name = part, nodes = {}, tag = eventPath }
            table.insert(currentRootNode.nodes, newNode)
            currentRootNode = newNode
        else
            currentRootNode = childNode
        end
    end
end

local function PrintEventNode(node)
    Soundtrack.TraceFrame("Node: " .. node.name)
    
    for i, n in ipairs(node.nodes) do
        PrintEventNode(n)
    end
end

-- Returns a flat list of tree nodes, based on whether each level is expanded or not
local function GetFlattenedEventNodes(eventTableName, rootNode, list)

    table.insert(list, rootNode)
    
    -- if expandable
    if table.getn(rootNode.nodes) >= 1 then    
        local event = Soundtrack_Events[eventTableName][rootNode.tag] or error("Cannot locate event " .. rootNode.name)
        if not event then return end
        
        -- By default every event is expanded
        if event.expanded == nil then event.expanded = true end
        
        -- TODO Have a method dump an object to the console regardless of type and nil
        if event.expanded then
            for i, n in ipairs(rootNode.nodes) do
                GetFlattenedEventNodes(eventTableName, n, list)
            end
        end
    end
end

-- Call after events have changed or been expanded/collapsed
function Soundtrack_OnTreeChanged(eventTableName)

    -- Remove collapsed portions from Sorted events
    Soundtrack_FlatEvents[eventTableName] = {}
    local flatEventList = {}
    local rootEventNode = Soundtrack_EventNodes[eventTableName]
    
    for i,n in ipairs(rootEventNode.nodes) do
       GetFlattenedEventNodes(eventTableName, n, Soundtrack_FlatEvents[eventTableName])
    end
    
end

function Soundtrack_SortEvents(eventTableName)
    if _SuspendSorting then return end

    Soundtrack_FlatEvents[eventTableName] = {}

    for k,v in pairs(Soundtrack_Events[eventTableName]) do
        if k ~= "Preview" then -- Hide internal events
            table.insert(Soundtrack_FlatEvents[eventTableName], k)
        end
    end
    
    -- Only sort is user do not wish to bypass
    table.sort(Soundtrack_FlatEvents[eventTableName])
    
    -- Construct the event node tree, after events have been sorted
    local rootNode = {name = eventTableName, nodes = {}, tag = nil }
    for i,e in ipairs(Soundtrack_FlatEvents[eventTableName]) do
       AddEventNode(rootNode, e)
    end
    Soundtrack_EventNodes[eventTableName] = rootNode
    
    -- Print tree
    Soundtrack.TraceFrame("SortEvents")
    
    Soundtrack_OnTreeChanged(eventTableName)
    
    SoundtrackFrame_RefreshEvents()
end


-- Chat print functions
function Soundtrack.Message(text)
    Soundtrack.Util.ChatPrint("Soundtrack: " .. text)
end
function Soundtrack.Error(text)
    Soundtrack.Util.ChatPrint("Soundtrack: Error: " .. text, 1, 0.25, 0.0)
end

-- Debug functions
function Soundtrack.Warning(text)
    Soundtrack.Util.DebugPrint("Soundtrack: Warning: " .. text, 0.75, 0.75, 0.0)
end
function Soundtrack.Trace(text)
    Soundtrack.Util.DebugPrint("[Trace]: " .. text, 0.75, 0.75, 0.75)
end
function Soundtrack.TraceLibrary(text)
    Soundtrack.Util.DebugPrint("[Library]: " .. text, 0.25, 0.25, 1.0)
end
function Soundtrack.TraceBattle(text)
    Soundtrack.Util.DebugPrint("[Battle]: " .. text, 1.0, 0.0, 0.0)
end
function Soundtrack.TraceZones(text)
    Soundtrack.Util.DebugPrint("[Zones]: " .. text, 0.0, 0.50, 0.0)
end
function Soundtrack.TraceFrame(text)
    Soundtrack.Util.DebugPrint("[Frame]: " .. text, 0.75, 0.75, 0.0)
end
function Soundtrack.TraceEvents(text)
    Soundtrack.Util.DebugPrint("[Events]: " .. text, 0.0, 1.0, 1.0)
end
function Soundtrack.TraceCustom(text)
	Soundtrack.Util.DebugPrint("[Custom]: " .. text, 1.0, 0.0, 0.5)
end

-- Sort functions
local function CompareTracksByAlbum(i1, i2)
    return Soundtrack_Tracks[i1].album < Soundtrack_Tracks[i2].album
end
local function CompareTracksByArtist(i1, i2)
    return Soundtrack_Tracks[i1].artist < Soundtrack_Tracks[i2].artist
end
local function CompareTracksByTitle(i1, i2)
    return Soundtrack_Tracks[i1].title < Soundtrack_Tracks[i2].title
end
local function CompareTracksByFileName(i1, i2)
    return Soundtrack.GetPathFileName(i1) < Soundtrack.GetPathFileName(i2)
end
local function MatchTrack(trackName, track, filter)
    local lowerFilter = string.lower(filter)
    local index = string.find(string.lower(trackName), lowerFilter)
    if index then return true end
    index = string.find(string.lower(track.artist), lowerFilter)
    if index then return true end
    index = string.find(string.lower(track.album), lowerFilter)
    if index then return true end
    index = string.find(string.lower(track.title), lowerFilter)
    if index then return true end
    
    return nil
end

-- Sorts the list of tracks using the passed criteria, or uses
-- the last used sorting criteria
function Soundtrack.SortTracks(sortCriteria)
    if sortCriteria then
        Soundtrack.lastSortCriteria = sortCriteria
    else
		if Soundtrack.lastSortCriteria == nil then
			Soundtrack.lastSortCriteria = "filePath"	
			sortCriteria = "filePath"
		else
			sortCriteria = Soundtrack.lastSortCriteria
		end
    end
    
    Soundtrack_SortedTracks = {}
    for k,v in pairs(Soundtrack_Tracks) do
        if not v.defaultTrack or Soundtrack.Settings.ShowDefaultMusic then
            if not Soundtrack.trackFilter then 
                table.insert(Soundtrack_SortedTracks, k)
            elseif MatchTrack(k, v, Soundtrack.trackFilter) then
                table.insert(Soundtrack_SortedTracks, k)
            end
        end
    end
    
    if sortCriteria == "album" then
        table.sort(Soundtrack_SortedTracks, CompareTracksByAlbum)
    elseif sortCriteria == "artist" then
        table.sort(Soundtrack_SortedTracks, CompareTracksByArtist)
    elseif sortCriteria == "filePath" then
        table.sort(Soundtrack_SortedTracks)
    elseif sortCriteria == "fileName" then
        table.sort(Soundtrack_SortedTracks, CompareTracksByFileName)
    elseif sortCriteria == "title" then
        table.sort(Soundtrack_SortedTracks, CompareTracksByTitle)
    end
    
    SoundtrackFrame_RefreshTracks()
end

local delayTime = 0
local updateTime = .1

-- Helps keep open sound ports by playing an empty sound.
-- Thanks to Yarko's addon RangeColors for the idea!
--[[
function Soundtrack_OpenSoundPorts()
	PlaySound("GAMEHIGHLIGHTFRIENDLYUNIT")
	PlaySound("GAMEHIGHLIGHTFRIENDLYUNIT")
	PlaySound("GAMEHIGHLIGHTFRIENDLYUNIT")
end
--]]

function Soundtrack_OnUpdate(self, deltaT)
    local currentTime = GetTime()
	--Soundtrack_OpenSoundPorts()
	
    Soundtrack.Library.OnUpdate(deltaT)
	SoundtrackFrame_MovingTitle()
	--Soundtrack.CustomEvents.OnUpdate(deltaT)
	
    if currentTime >= delayTime then
	    delayTime = currentTime + updateTime
		Soundtrack.Timers.OnUpdate(deltaT)
	    --Soundtrack.MountEvents.OnUpdate(deltaT)
	    --Soundtrack.BattleEvents.OnUpdate()
		SoundtrackFrame_RefreshTrackProgress()
    end
end


function Soundtrack_OnLoad(self)
	SLASH_SOUNDTRACK1, SLASH_SOUNDTRACK2 = '/soundtrack', '/st'
	local function SoundtrackSlashCmd(msg)
		if msg == 'debug' then
			Soundtrack.Settings.Debug = not Soundtrack.Settings.Debug
			Soundtrack.Util.InitDebugChatFrame()
		elseif msg == 'reset' then
			SoundtrackFrame:ClearAllPoints()
			SoundtrackFrame:SetPoint("CENTER",UIParent,"CENTER",0,0)
		elseif msg == 'report' then
			SoundtrackReportFrame:SetPoint("CENTER",UIParent,"CENTER",0,0)
			SoundtrackReportFrame:Show()
		else
			SoundtrackFrame:Show()
		end
	end
    SlashCmdList["SOUNDTRACK"] = SoundtrackSlashCmd
		
		
		
    -- Register events
    self:RegisterEvent("VARIABLES_LOADED")

    --Soundtrack.BattleEvents.OnLoad(self)
    --Soundtrack.ZoneEvents.OnLoad(self)
    --Soundtrack.DanceEvents.OnLoad(self)
	Soundtrack.Events.OnLoad(self)
end


function Soundtrack_OnEvent(self, event, ...)

    if event == "VARIABLES_LOADED" then
        OnVariablesLoaded(self)
    end
	
    --Soundtrack.ZoneEvents.OnEvent(self, event, ...)
    --Soundtrack.BattleEvents.OnEvent(self, event, ...)
    --Soundtrack.DanceEvents.OnEvent(self, event, ...)
    --Soundtrack.CustomEvents.OnEvent(self, event, ...)
	Soundtrack.Events.OnEvent(self, event, ...)
end