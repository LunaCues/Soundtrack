--[[
    Soundtrack addon for World of Warcraft

    Mount events functions.
]]

-- Level 1: Continent
-- Level 2: Region
-- Level 3: Zones
-- Level 4: Interiors
-- Level 5: Mount: Mount, Flight
-- Level 6: Auras: Forms
-- Level 7: Status: Swimming, Stealthed
-- Level 8: Temp. Buffs: Dash, Class Stealth
-- Level 9: NPCs: Merchant, Auction House 
-- Level 10: One-time/SFX: Victory, Dance, Level up, Cinematics
-- Level 11: Battle
-- Level 12: Boss
-- Level 13: Death, Ghost
-- Level 14: Playlists
-- Level 15: Preview

local ST_MOUNT_LVL = 5

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


local function Soundtrack_MountEvents_PlayIfTracksAvailable(tableName, eventName)
	local stackTable = Soundtrack.Events.Stack[ST_MOUNT_LVL].tableName
    local stackEvent = Soundtrack.Events.Stack[ST_MOUNT_LVL].eventName
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
	local stackEvent = Soundtrack.Events.Stack[ST_MOUNT_LVL].eventName
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

function Soundtrack.MountEvents.OnLoad(self)
    self:RegisterEvent("VARIABLES_LOADED")
end

local delayTime = 0
local updateTime = .1

function Soundtrack.MountEvents.OnUpdate(self, deltaT)
    local currentTime = GetTime()
    if currentTime >= delayTime then
	    delayTime = currentTime + updateTime
		if not Soundtrack.Settings.EnableMiscMusic then
			return
		end
		
		--[[
		if IsSwimming() and SoundtrackEvents_EventHasTracks(ST_MISC, SOUNDTRACK_SWIMMING) then
			return
		end
		
		if (Soundtrack.Merchant and SoundtrackEvents_EventHasTracks(ST_MISC, SOUNDTRACK_MERCHANT)) or
		(Soundtrack.Bank and SoundtrackEvents_EventHasTracks(ST_MISC, SOUNDTRACK_BANK)) or 
		(Soundtrack.AuctionHouse and SoundtrackEvents_EventHasTracks(ST_MISC, SOUNDTRACK_AUCTION_HOUSE)) then
			return
		end
		--]]
		
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
			--[[
			if not Soundtrack.MountEvents.IsFlying and isFlying then
				Soundtrack.MountEvents.IsFlying = true
				Soundtrack_MountEvents_PlayIfTracksAvailable(ST_MISC, SOUNDTRACK_MOUNT_FLYING)
			elseif (not Soundtrack.MountEvents.IsMounted or not Soundtrack.MountEvents.IsFlying) and isMounted then
				Soundtrack.MountEvents.IsMounted = true
				Soundtrack_MountEvents_PlayIfTracksAvailable(ST_MISC, SOUNDTRACK_MOUNT_GROUND)
			elseif Soundtrack.MountEvents.IsMounted and not isMounted then
				debugEvents("IsMounted and IsMounted! Stop mount")
				Soundtrack.MountEvents.IsMounted = false
				Soundtrack_MountEvents_StopIfTracksAvailable(ST_MISC, SOUNDTRACK_MOUNT_GROUND)
				--Soundtrack_OnUpdate()
			elseif Soundtrack.MountEvents.IsFlying and not isFlying then
				Soundtrack.MountEvents.IsFlying = false
				Soundtrack_MountEvents_StopIfTracksAvailable(ST_MISC, SOUNDTRACK_MOUNT_FLYING)
			end
			--]]
			
			if isMounted and isFlying then
				Soundtrack_MountEvents_PlayIfTracksAvailable(ST_MISC, SOUNDTRACK_MOUNT_FLYING)
			elseif isMounted and not isFlying then
				Soundtrack_MountEvents_PlayIfTracksAvailable(ST_MISC, SOUNDTRACK_MOUNT_GROUND)
			else
				Soundtrack_MountEvents_StopIfTracksAvailable(ST_MISC, SOUNDTRACK_MOUNT_FLYING)
				Soundtrack_MountEvents_StopIfTracksAvailable(ST_MISC, SOUNDTRACK_MOUNT_GROUND)
			end
				
		end
	end
end

function Soundtrack.MountEvents.OnEvent(self, event, ...)
	if event == "VARIABLES_LOADED" then
		Soundtrack.MountEvents.Initialize()
    end
end

function Soundtrack.MountEvents.Initialize()
    Soundtrack.AddEvent(ST_MISC, SOUNDTRACK_MOUNT_GROUND, ST_MOUNT_LVL, true)
    Soundtrack.AddEvent(ST_MISC, SOUNDTRACK_FLIGHT, ST_MOUNT_LVL, true)
    Soundtrack.AddEvent(ST_MISC, SOUNDTRACK_MOUNT_FLYING, ST_MOUNT_LVL, true)
end