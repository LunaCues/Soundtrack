--[[
    Soundtrack addon for World of Warcraft

    Mount events functions.
]]

local ST_BATTLE = "Battle"
local ST_BOSS = "Boss"
local ST_ZONE = "Zone"
local ST_DANCE = "Dance"
local ST_MISC = "Misc"
local ST_CUSTOM = "Custom"
local ST_PLAYLISTS = "Playlists"

local function debugEvents(msg)
    Soundtrack.Trace(msg, 0.25, 0.25, 0.25)
end


Soundtrack.MountEvents.InFlight = false
Soundtrack.MountEvents.IsMounted = false

function Soundtrack.MountEvents.OnLoad(self)
end

local function Soundtrack_MountEvents_PlayIfTracksAvailable(tableName, eventName)
	local stackTable = Soundtrack.Events.Stack[5].tableName
    local stackEvent = Soundtrack.Events.Stack[5].eventName
	if tableName == stackTable and eventName == stackEvent then
		return
	end
	local eventTable = Soundtrack.Events.GetTable(tableName)
	if eventTable[eventName] then
		local trackList = eventTable[eventName].tracks
		if trackList then
			local numTracks = table.getn(trackList)
			if numTracks >= 1 then
				Soundtrack.PlayEvent(tableName, eventName);
			end
		end
	end
end
local function Soundtrack_MountEvents_StopIfTracksAvailable(tableName, eventName)
	local eventTable = Soundtrack.Events.GetTable(tableName)
	local stackEvent = Soundtrack.Events.Stack[5].eventName
	if eventTable[eventName] and eventName == stackEvent then
		local trackList = eventTable[eventName].tracks
		if trackList then
			local numTracks = table.getn(trackList)
			if numTracks >= 1 then
				Soundtrack.StopEvent(tableName, eventName);
			end
		end
	end
end


function Soundtrack.MountEvents.OnUpdate(self, deltaT)

    if not Soundtrack.Settings.EnableMiscMusic then
        return
    end
	
	if IsSwimming() and SoundtrackEvents_EventHasTracks(ST_MISC, SOUNDTRACK_SWIMMING) then
		return
	end
	
	if (Soundtrack.Merchant and SoundtrackEvents_EventHasTracks(ST_MISC, SOUNDTRACK_MERCHANT)) or
	   (Soundtrack.Bank and SoundtrackEvents_EventHasTracks(ST_MISC, SOUNDTRACK_BANK)) or 
	   (Soundtrack.AuctionHouse and SoundtrackEvents_EventHasTracks(ST_MISC, SOUNDTRACK_AUCTION_HOUSE)) then
		return
	end
	
	
    -- Really inefficient way to detect taxis...
    local unitOnTaxi = UnitOnTaxi("player")
    
    if Soundtrack.MountEvents.InFlight and unitOnTaxi == nil then
        Soundtrack.MountEvents.InFlight = false
        debugEvents("UnitOnTaxi and in Flight! Stop flight")
        Soundtrack_MountEvents_StopIfTracksAvailable(ST_MISC, SOUNDTRACK_FLIGHT)
    elseif not Soundtrack.MountEvents.InFlight and unitOnTaxi == 1 then 
        debugEvents("UnitOnTaxi and not in Flight! Start flight")
        Soundtrack.MountEvents.InFlight = true
        Soundtrack_MountEvents_PlayIfTracksAvailable(ST_MISC, SOUNDTRACK_FLIGHT)
    end
    
    if not unitOnTaxi then
        local isFlying = IsFlying()
        local isMounted = IsMounted()
		
        -- TODO would be nicer to deal with each mount event separately and just use the priorities to avoid 
        -- these complicated conditions:
        if not Soundtrack.MountEvents.IsFlying and isFlying then
            Soundtrack.MountEvents.IsFlying = true
			Soundtrack_MountEvents_PlayIfTracksAvailable(ST_MISC, SOUNDTRACK_MOUNT_FLYING)
        elseif (not Soundtrack.MountEvents.IsMounted or not Soundtrack.MountEvents.IsFlying) and isMounted then
            Soundtrack.MountEvents.IsMounted = true
			Soundtrack_MountEvents_PlayIfTracksAvailable(ST_MISC, SOUNDTRACK_MOUNT_GROUND)
        elseif Soundtrack.MountEvents.IsMounted and not isMounted then
            debugEvents("IsMounted and and IsMounted! Stop mount")
            Soundtrack.MountEvents.IsMounted = false
            Soundtrack_MountEvents_StopIfTracksAvailable(ST_MISC, SOUNDTRACK_MOUNT_GROUND)
			Soundtrack_OnUpdate()
        elseif Soundtrack.MountEvents.IsFlying and not isFlying then
            Soundtrack.MountEvents.IsFlying = false
            Soundtrack_MountEvents_StopIfTracksAvailable(ST_MISC, SOUNDTRACK_MOUNT_FLYING)
        end
    end
end

function Soundtrack.MountEvents.Initalize()
    Soundtrack.AddEvent(ST_MISC, SOUNDTRACK_MOUNT_GROUND, 5, true)
    Soundtrack.AddEvent(ST_MISC, SOUNDTRACK_FLIGHT, 5, true)
    Soundtrack.AddEvent(ST_MISC, SOUNDTRACK_MOUNT_FLYING, 5, true)
end