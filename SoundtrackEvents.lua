--[[
    Soundtrack addon for World of Warcraft

    Soundtrack events functions.
    Functions that handle mapping named events with tracks in the library.
]]

Soundtrack.MaxStackLevel = 16

local function verifyStackLevel(stackLevel)
    if not stackLevel or (not (stackLevel >= 1 and stackLevel <= Soundtrack.MaxStackLevel)) then
        Soundtrack.Error("BAD STACK LEVEL "..stackLevel)
    end
end

-- Returns if event has tracks.
function SoundtrackEvents_EventHasTracks(tableName, eventName)
	local eventTable = Soundtrack.Events.GetTable(tableName)
	if eventTable[eventName] then
		local trackList = eventTable[eventName].tracks
		if trackList then
			local numTracks = table.getn(trackList)
			if numTracks >= 1 then
				return true
			end
		end
	end
	return false
end

local nextTrack -- Hack because of fading issue


-- Attempts to play a random track on a specific event table. Returns true if it found a track to play.
function PlayRandomTrackByTable(tableName, eventName, offset)
    
    Soundtrack.TraceEvents("PlayRandomTrackByTable (" .. tableName .. ", " .. eventName .. ")")
    local eventTable = Soundtrack.Events.GetTable(tableName)
    
    if eventTable[eventName] then
        local trackList = eventTable[eventName].tracks
        
        if trackList then
            local numTracks = table.getn(trackList)
            if numTracks >= 1 then
                local index
                
                if eventTable[eventName].random then
				-- if eventTable[eventName].random and tableName ~= "Playlists" then
                    --Soundtrack.TraceEvents("Random")
                    index = random(1, numTracks)
                    --Soundtrack.TraceEvents("Random index: "..index)
                
                    -- Avoid playing same track twice
                    if index == eventTable[eventName].lastTrackIndex then
                        index = index + 1
                        if index > numTracks then
                            index = 1
                        end
                    end
                    --Soundtrack.TraceEvents("Adjusted Random index: "..index)
                else
                    --Soundtrack.TraceEvents("Non random")
                    -- Non random playback
                    if not eventTable[eventName].lastTrackIndex then
                        index = 1
                    else
                        index = eventTable[eventName].lastTrackIndex + offset
                        if index > numTracks then
                            index = 1
                        elseif index == 0 then
                            index = numTracks
                        end
                    end
                end
                
                local trackName = trackList[index]
                eventTable[eventName].lastTrackIndex = index
                if not Soundtrack.Events.Paused then
					Soundtrack.Library.PlayTrack(trackName, eventTable[eventName].soundEffect)
					nextTrack = trackName
                elseif eventTable[eventName].soundEffect then
					Soundtrack.Library.PlayTrack(trackName, eventTable[eventName].soundEffect)
				else
                    Soundtrack.TraceEvents("Paused")
                end
                return true
            end
        end
    end
    return false
end



function PlayTrackByTable(tableName, eventName, offset)
    
    Soundtrack.TraceEvents("PlayTrackByTable (" .. tableName .. ", " .. eventName .. ")")
    local eventTable = Soundtrack.Events.GetTable(tableName)
    
    if eventTable[eventName] then
        local trackList = eventTable[eventName].tracks
        
        if trackList then
            local numTracks = table.getn(trackList)
            if numTracks >= 1 then
                local index
                index = eventTable[eventName].lastTrackIndex + offset
                if index > numTracks then
					index = 1
                elseif index == 0 then
                    index = numTracks
                end
                
                local trackName = trackList[index]
                eventTable[eventName].lastTrackIndex = index
                if not Soundtrack.Events.Paused then
                    Soundtrack.Library.PlayTrack(trackName, eventTable[eventName].soundEffect)
					nextTrack = trackName
                else
                    Soundtrack.TraceEvents("Paused")
                end
                return true
            end
        end
    end
    return false
end



-- Timer callback function
local cooldown = 0
local fadeOutTime = 1 

local function trackFinished()
    Soundtrack.Events.RestartLastEvent()
end

local function startEmptyTrack()
    Soundtrack.Library.PauseMusic()
end

local function playOnceTrackFinished()
    Soundtrack.StopEventAtLevel(Soundtrack.Events.GetCurrentStackLevel()) -- TODO Anthony : by name?
end

local function getTrackCount(event)
    if not event then
        return 0
    end
    
    local trackList = event.tracks
    if trackList then
        return table.getn(trackList)
    else
        return 0
    end
end

-- Returns the current stack level on which a valid event is found.
local function getValidStackLevel()
    local validStackLevel = 0
    
    for i = table.getn(Soundtrack.Events.Stack), 1, -1 do
        local event = Soundtrack.GetEvent(Soundtrack.Events.Stack[i].tableName, Soundtrack.Events.Stack[i].eventName)
        if event then
            local trackCount = getTrackCount(event)
            if validStackLevel == 0 and trackCount > 0 then
                validStackLevel = i
            elseif not event.continuous then
                Soundtrack.TraceEvents("Removing obsolete event: "..Soundtrack.Events.Stack[i].eventName)
                Soundtrack.Events.Stack[i].eventName = nil
                Soundtrack.Events.Stack[i].tableName = nil
                Soundtrack.Events.Stack[i].offset = 0
            end
        else
            Soundtrack.Events.Stack[i].eventName = nil
            Soundtrack.Events.Stack[i].tableName = nil
            Soundtrack.Events.Stack[i].offset = 0
        end
    end
    
    return validStackLevel
end




local currentTableName = nil
local currentEventName = nil



function Soundtrack.UnRegisterEvent(eventName)
end

Soundtrack.Events.Stack = 
{ 
	--[[
    { eventName = nil, tableName = nil }, -- Level 1: Continent
    { eventName = nil, tableName = nil }, -- Level 2: Region
    { eventName = nil, tableName = nil }, -- Level 3: Zones
    { eventName = nil, tableName = nil }, -- Level 4: Interiors
    { eventName = nil, tableName = nil }, -- Level 5: Misc. Stealth, Mount, Flight, Dance, Victory
    { eventName = nil, tableName = nil }, -- Level 6: Battle
    { eventName = nil, tableName = nil }, -- Level 7: Boss 
    { eventName = nil, tableName = nil }, -- Level 8: Level up, Death, Ghost
    { eventName = nil, tableName = nil }, -- Level 9: Playlists
    { eventName = nil, tableName = nil }, -- Level 10: Preview
	--]]
	{ eventName = nil, tableName = nil }, -- Level 1: Continent
    { eventName = nil, tableName = nil }, -- Level 2: Region
    { eventName = nil, tableName = nil }, -- Level 3: Zones
    { eventName = nil, tableName = nil }, -- Level 4: Interiors
    { eventName = nil, tableName = nil }, -- Level 5: Mount: Mount, Flight
    { eventName = nil, tableName = nil }, -- Level 6: Auras: Forms
    { eventName = nil, tableName = nil }, -- Level 7: Status: Swimming, Stealthed
    { eventName = nil, tableName = nil }, -- Level 8: Temp. Buffs: Dash, Class Stealth
    { eventName = nil, tableName = nil }, -- Level 9: NPCs: Merchant, Auction House 
    { eventName = nil, tableName = nil }, -- Level 10: One-time: Dance, Cinematics
	{ eventName = nil, tableName = nil }, -- Level 11: Battle
	{ eventName = nil, tableName = nil }, -- Level 12: Boss
	{ eventName = nil, tableName = nil }, -- Level 13: Death, Ghost
	{ eventName = nil, tableName = nil }, -- Level 14: SFX: Victory, Level up, LFG Complete	
	{ eventName = nil, tableName = nil }, -- Level 15: Playlists
	{ eventName = nil, tableName = nil }, -- Level 16: Preview
	
}

function Soundtrack_Events_GetEventAtStackLevel(level)
	local eventName = Soundtrack.Events.Stack[level].eventName
	local tableName = Soundtrack.Events.Stack[level].tableName
	return eventName, tableName
end

Soundtrack.Events.Paused = false

-- Table of custom events defined by the user
Soundtrack.Events.CustomEvents = { }

-- Called anytime the stack has changed. Makes sure the top most event gets played,
-- and avoids playing unnecessary events.
function Soundtrack.Events.OnStackChanged(forceRestart)
    -- Remove any playOnce events that do not have any valid tracks or they will never be removed
    SoundtrackFrame_TouchEvents()
	
    local validStackLevel = getValidStackLevel()
    if validStackLevel == 0 then
        -- Nothing to play.
        -- Stop events if something was already active
        if currentTableName then
            Soundtrack.Timers.Remove("FadeOut")
            Soundtrack.Timers.Remove("TrackFinished")
            Soundtrack.Library.StopTrack()
        end
        currentTableName = nil
        currentEventName = nil
    
    else
        -- There is something valid on the stack.
        local stackItem = Soundtrack.Events.Stack[validStackLevel]
        if not stackItem then
            error("BAD DATA "..validStackLevel)
        end
        local tableName = Soundtrack.Events.Stack[validStackLevel].tableName
        local eventName = Soundtrack.Events.Stack[validStackLevel].eventName
        local event = Soundtrack.GetEvent(tableName, eventName)
        local offset = Soundtrack.Events.Stack[validStackLevel].offset
		local currenttrack = Soundtrack.Library.CurrentlyPlayingTrack
	
        -- Avoid restarting already playing event
        if forceRestart or 
            currentTableName ~= tableName or 
            currentEventName ~= eventName then

			-- Avoid restarting a song that is in both events
			local sametrack = false
			for k,v in ipairs(event.tracks) do 
				if v == currenttrack then 
					sametrack = true
					break;
				end
			end
			if not sametrack or forceRestart then
			
				-- We are starting a new track! 
				-- Remove the playback continuity timers
				Soundtrack.Timers.Remove("FadeOut")
				Soundtrack.Timers.Remove("TrackFinished")
				
				-- After pause, goes to the next song
				--[[
				if Soundtrack.Events.Paused then  -- Edit by Lunaqua
					offset = 0  -- Use to be 1
					Soundtrack.Events.Paused = false
				end
				--]]
				
				nextTrack = null
				local res = PlayRandomTrackByTable(tableName, eventName, offset)
				--local res = PlayTrackByTable(tableName, eventName, offset)
				if not res then
					Soundtrack.TraceEvents("Not supposed to play invalid events.")
				end    
				
				currentTableName = tableName
				currentEventName = eventName
				
				-- A track is now playing, register continuity timers
				if nextTrack then
					local track = Soundtrack_Tracks[nextTrack]
					if track then
						local length = track.length
						if length then 
							if not event.continuous then
								if track.length > 20 then
									Soundtrack.Timers.AddTimer("FadeOut", length - fadeOutTime, playOnceTrackFinished)
								else
									Soundtrack.Timers.AddTimer("FadeOut", length, playOnceTrackFinished)
								end
							else
								local randomSilence = 0
								if Soundtrack.Settings.Silence > 0 then
									randomSilence = random(5, Soundtrack.Settings.Silence)
								end
								Soundtrack.Timers.AddTimer("TrackFinished", length + randomSilence, trackFinished)
								if track.length > 20 then
									Soundtrack.Timers.AddTimer("FadeOut", length - fadeOutTime, startEmptyTrack)
								else
									Soundtrack.Timers.AddTimer("FadeOut", length, startEmptyTrack)
								end
							end
						end        
					end
				end
			end	
			
        end
    
	end

end

-- Returns the event table for a tab name.
function Soundtrack.Events.GetTable(eventTableName)

    if not eventTableName then
        return
    end
    
    local eventTable = Soundtrack_Events[eventTableName]
    if not eventTable then
        Soundtrack.Error("Attempt to access invalid event table ("..eventTableName..")")
        return nil
    end
    
    return eventTable
end

-- Adds an event to the events table. If no trackName is passed, the event is created empty.
-- If a trackName is passed it is added to that events track list.
function Soundtrack.Events.Add(eventTableName, eventName, trackName)
    if not eventName then
        return
    end

    local eventTable = Soundtrack.Events.GetTable(eventTableName)
    
    if not eventTable then
        Soundtrack.TraceEvents("Cannot find table : " .. eventTableName)
        return
    end
    
    if not eventTable[eventName] then 
        if not trackName then
            Soundtrack.TraceEvents("Add Event: " .. eventTableName .. ": " .. eventName)
        end
        
		-- Create event
        eventTable[eventName] = { tracks = {}, lastTrackIndex = 0, random = true }  
        
        -- Because I cant figure out how to sort the hashtable...
        Soundtrack_SortEvents(eventTableName)
    end
    
    if trackName then
		trackNotListed = true
		for i=0, #(eventTable[eventName].tracks) do
			if trackName == eventTable[eventName].tracks[i] then 
				trackNotListed = false 
				break
			end
		end
		if trackNotListed then
			table.insert(eventTable[eventName].tracks, trackName)
		end
    end
end

-- Removes an event from the events table. 
function Soundtrack.Events.Remove(eventTableName, eventName, trackName)
    
    local eventTable = Soundtrack.Events.GetTable(eventTableName)
    local tracks = eventTable[eventName].tracks
    for i,tn in ipairs(tracks) do
        if tn == trackName then 
            table.remove(tracks, i)
            return
        end
    end
end

function Soundtrack.Events.DeleteEvent(tableName, eventName)
    
    local eventTable = Soundtrack.Events.GetTable(tableName)
    if eventTable then
        if eventTable[eventName] then
            Soundtrack.TraceEvents("Removing event: "..eventName)
            eventTable[eventName] = nil
        end
        Soundtrack_SortEvents(tableName)
    end
end



-- TODO: Needs to be fixed, does not function
-- Look at EditEvent, possibly same function.
function Soundtrack.Events.RenameEvent(tableName, oldName, newName)
    if oldName == newName then
        return
    end

    local eventTable = Soundtrack_Events[tableName]
    if eventTable and eventTable[oldName] then
        Soundtrack.TraceEvents("Renaming event: " .. oldName .. " => " .. newName)
        local event = eventTable[oldName]
        eventTable[newName] = event
        eventTable[oldName] = nil
        Soundtrack_SortEvents(tableName)
    end     
    
    -- Also rename event in CustomEvents
    if Soundtrack_CustomEvents[oldName] then
        local event = Soundtrack_CustomEvents[oldName]
        Soundtrack_CustomEvents[newName] = event
        Soundtrack_CustomEvents[oldName] = nil
    end
    
    if Soundtrack_MiscEvents[oldName] then
        local event = Soundtrack_MiscEvents[oldName]
        Soundtrack_MiscEvents[newName] = event
        Soundtrack_MiscEvents[oldName] = nil
    end
end

function Soundtrack.Events.ClearEvent(eventTableName, eventName)
    Soundtrack.TraceEvents("ClearEvent("..eventTableName..", "..eventName)
    local eventTable = Soundtrack.Events.GetTable(eventTableName)
    
    eventTable[eventName].tracks = {}
end

-- Adds an event on the stack and refreshes active track
function Soundtrack.Events.PlayEvent(tableName, eventName, stackLevel, forceRestart, playOnce, offset)
    if eventName == nil then
        Soundtrack.TraceEvents("Attempting to PlayEvent with a nil name!")
        return
    end
    if not stackLevel then
        Soundtrack.TraceEvents("Cannot PlayEvent(" .. eventName .. "). It has no priority level.")
        return
    end
    verifyStackLevel(stackLevel)
    
    if not tableName then
        Soundtrack.TraceEvents("PlayEvent: Invalid table name")
        return
    end
    if not eventName then
        Soundtrack.TraceEvents("PlayEvent: Invalid event name")
        return
    end
	-- Check if event exists
    local event = Soundtrack.GetEvent(tableName, eventName)
    if not event then
        return
    end
	-- Check if event has assigned tracks
	local eventHasTracks = false
	local eventTable = Soundtrack.Events.GetTable(tableName)
	if eventTable[eventName] then
		local trackList = eventTable[eventName].tracks
		if trackList then
			local numTracks = table.getn(trackList)
			if numTracks >= 1 then
				eventHasTracks = true
			end
		end
	end
	
    local playOnceText
    if event.continuous then
        playOnceText = "Loop"
    else 
        playOnceText = "Once"
    end
    Soundtrack.TraceEvents("PlayEvent("..tableName..", "..eventName..", "..stackLevel..") "..playOnceText)    

    if not offset then 
        offset = 0
    end

    -- Add event on the stack    
    if event.soundEffect then
		if eventHasTracks then
			-- Sound effects are never added to the stack
			PlayRandomTrackByTable(tableName, eventName, offset)
		end
    else
		if eventHasTracks then 
			Soundtrack.Events.Stack[stackLevel].tableName = tableName
			Soundtrack.Events.Stack[stackLevel].eventName = eventName
			Soundtrack.Events.Stack[stackLevel].offset = offset
			Soundtrack.Events.OnStackChanged(forceRestart)
		end
    end
end


function Soundtrack.Events.RestartLastEvent(offset)
    local stackLevel = getValidStackLevel()
    if stackLevel > 0 then
        Soundtrack.Events.PlayEvent(Soundtrack.Events.Stack[stackLevel].tableName, 
                                    Soundtrack.Events.Stack[stackLevel].eventName, 
                                    stackLevel, true, nil, offset) -- Edit by Lunaqua, missing variable in function call, changed to nil
    end
end

function Soundtrack.Events.GetCurrentStackLevel()
    return getValidStackLevel()
end

function Soundtrack.Events.PlaybackNext()
    Soundtrack.Events.RestartLastEvent(1)
end

function Soundtrack.Events.PlaybackPrevious()
    Soundtrack.Events.RestartLastEvent(-1)
end

function Soundtrack.Events.PlaybackPlayStop()
	local stackLevel = Soundtrack.Events.GetCurrentStackLevel()
    local currentEvent = "None"
    if stackLevel ~= 0 then
        currentEvent = Soundtrack.Events.Stack[stackLevel].eventName
    end
    if Soundtrack.Events.Paused and currentEvent ~= SOUNDTRACK_NO_EVENT_PLAYING then
        Soundtrack.TraceEvents("All music unpaused")
        --Soundtrack.Events.Paused = false 
        --Soundtrack.Events.OnStackChanged(true)
		Soundtrack.Events.Paused = false
		Soundtrack.Events.RestartLastEvent(0)
    else
        Soundtrack.TraceEvents("All music paused")
        Soundtrack.Events.Paused = true
        Soundtrack.Library.StopMusic()
    end
    SoundtrackFrame_RefreshPlaybackControls()
end

function Soundtrack.Events.PlaybackTrueStop()
    Soundtrack.TraceEvents("All music stopped")
	Soundtrack.StopEventAtLevel(Soundtrack.Events.GetCurrentStackLevel());
    --Soundtrack.Events.Paused = true
    Soundtrack.Library.StopMusic()
    SoundtrackFrame_RefreshPlaybackControls()
end 

function Soundtrack.Events.Pause(enable)
    Soundtrack.Events.Paused = enable
    SoundtrackFrame_RefreshPlaybackControls()
end

function Soundtrack.Events.OnLoad(self)
	self:RegisterEvent("PLAYER_ENTERING_WORLD");
	self:RegisterEvent("PLAYER_ENTERING_BATTLEGROUND");
end

function Soundtrack.Events.OnEvent(self, event, ...) 
    if event == "PLAYER_ENTERING_WORLD" or
	   event == "PLAYER_ENTERING_BATTLEGROUND" then
		if Soundtrack.Events.Paused == false then
			Soundtrack.Events.RestartLastEvent(1)
		end
    end
end