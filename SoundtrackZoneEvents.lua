--[[
    Soundtrack addon for World of Warcraft

    Zone events functions.
    Functions that manage zone change events.
]]

local ST_BATTLE = "Battle"
local ST_BOSS = "Boss"
local ST_ZONE = "Zone"
local ST_DANCE = "Dance"
local ST_MISC = "Misc"
local ST_CUSTOM = "Custom"
local ST_PLAYLISTS = "Playlists"

-- Finds the continent name, based on the zone name
local function FindContinentByZone(zoneName)
    -- TODO : Search zone list instead of relying on map
	if zoneName == nil then return nil end
	
    local eventTable = Soundtrack.Events.GetTable("Zone");

	inInstance, instanceType = IsInInstance();
	if inInstance then
		if instanceType == "arena" or instanceType == "pvp" then
			return "PvP";
		end
		if instanceType == "party" or instanceType == "raid" then
			return "Instances";
		end
	end
	
    if eventTable then 
        for k, v in pairs(eventTable) do
            -- Find tracks to remove
            if string.find(k, zoneName) then
                local i1, i2  = string.find(k, "[^/]*/");
                if i1 and i2 then
                    return string.sub(k, i1, i2-1);
                end
            end
        end
    end
    return "Instances";  -- Uncategorized stuff, usually is outside part of an instance
end

-- After migration, zone events have no priorities set. We only
-- discover them as we figure out which parent zones exist
local function AssignPriority(tableName, eventName, priority)
    local event = Soundtrack.GetEventByName(tableName, eventName)
    if event then
        event.priority = priority
    end

end

-- IsInInstance()

function Soundtrack_ZoneEvents_AddZones()
	local zoneText = GetRealZoneText();
	if zoneText == nil then return end
	
    local continentText = FindContinentByZone(zoneText);    
    local zoneSubText = GetSubZoneText();
    local minimapZoneText = GetMinimapZoneText();
    
    Soundtrack.TraceZones("continentText: " .. continentText);
    Soundtrack.TraceZones("zoneText: " .. zoneText);
    Soundtrack.TraceZones("zoneSubText: " .. zoneSubText);
    Soundtrack.TraceZones("minimapZoneText:" .. minimapZoneText);
    
    -- Construct full zone path
    
    local zoneText1, zoneText2, zoneText3, zoneText4;
    
    local zonePath;
        
    if not Soundtrack.IsNullOrEmpty(continentText) then
        zoneText1 = continentText;
		Soundtrack.TraceZones("zoneText1: " .. zoneText1);
        zonePath = continentText;
    end
        
    if not Soundtrack.IsNullOrEmpty(zoneText) then
        zoneText2 = continentText .. "/" .. zoneText;
		Soundtrack.TraceZones("zoneText2: " .. zoneText2);
        zonePath = zoneText2;
        Soundtrack.Events.RenameEvent(ST_ZONE, zoneText, zoneText2);
    end
    

    if zoneText ~= zoneSubText and not Soundtrack.IsNullOrEmpty(zoneSubText) then
        zoneText3 = zonePath .. "/" .. zoneSubText;
		Soundtrack.TraceZones("zoneText3: " .. zoneText3);
        zonePath = zoneText3;
        Soundtrack.Events.RenameEvent(ST_ZONE, zoneSubText, zoneText3);
    end
    
    if zoneText ~= minimapZoneText and zoneSubText ~= minimapZoneText and not Soundtrack.IsNullOrEmpty(minimapZoneText) then
        zoneText4 = zonePath .. "/" .. minimapZoneText;
		Soundtrack.TraceZones("zoneText4: " .. zoneText4);
        zonePath = zoneText4;
        Soundtrack.Events.RenameEvent(ST_ZONE, minimapZoneText, zoneText4);
    end
    
    Soundtrack.TraceZones("Zone: " .. zonePath);
    
    if zoneText4 then
		local eventTable = Soundtrack.Events.GetTable(ST_ZONE)
		if eventTable[zoneText4] == nil then
			Soundtrack.AddEvent(ST_ZONE, zoneText4, 4, true)
		end
		AssignPriority(ST_ZONE, zoneText4, 4)
    end
    
    if zoneText3 then
		local eventTable = Soundtrack.Events.GetTable(ST_ZONE)
		if eventTable[zoneText3] == nil then
			Soundtrack.AddEvent(ST_ZONE, zoneText3, 3, true)
		end
		AssignPriority(ST_ZONE, zoneText3, 3)
    end
    
    if zoneText2 then
		local eventTable = Soundtrack.Events.GetTable(ST_ZONE)
		if eventTable[zoneText2] == nil then
			Soundtrack.AddEvent(ST_ZONE, zoneText2, 2, true)
		end
		AssignPriority(ST_ZONE, zoneText2, 2)
    end
    
    if zoneText1 then
		local eventTable = Soundtrack.Events.GetTable(ST_ZONE)
		if eventTable[zoneText1] == nil then
			Soundtrack.AddEvent(ST_ZONE, zoneText1, 1, true)
		end
		AssignPriority(ST_ZONE, zoneText1, 1)
    end
   
end

local function OnZoneChanged()
    
    local zoneText = GetRealZoneText();
	if zoneText == nil then return end
	
    local continentText = FindContinentByZone(zoneText);    
    local zoneSubText = GetSubZoneText();
    local minimapZoneText = GetMinimapZoneText();
    
    Soundtrack.TraceZones("continentText: " .. continentText);
    Soundtrack.TraceZones("zoneText: " .. zoneText);
    Soundtrack.TraceZones("zoneSubText: " .. zoneSubText);
    Soundtrack.TraceZones("minimapZoneText:" .. minimapZoneText);
    
    -- Construct full zone path
    
    local zoneText1, zoneText2, zoneText3, zoneText4;
    
    local zonePath;
        
    if not Soundtrack.IsNullOrEmpty(continentText) then
        zoneText1 = continentText;
		Soundtrack.TraceZones("zoneText1: " .. zoneText1);
        zonePath = continentText;
    end
        
    if not Soundtrack.IsNullOrEmpty(zoneText) then
        zoneText2 = continentText .. "/" .. zoneText;
		Soundtrack.TraceZones("zoneText2: " .. zoneText2);
        zonePath = zoneText2;
        Soundtrack.Events.RenameEvent(ST_ZONE, zoneText, zoneText2);
    end
    

    if zoneText ~= zoneSubText and not Soundtrack.IsNullOrEmpty(zoneSubText) then
        zoneText3 = zonePath .. "/" .. zoneSubText;
		Soundtrack.TraceZones("zoneText3: " .. zoneText3);
        zonePath = zoneText3;
        Soundtrack.Events.RenameEvent(ST_ZONE, zoneSubText, zoneText3);
    end
    
    if zoneText ~= minimapZoneText and zoneSubText ~= minimapZoneText and not Soundtrack.IsNullOrEmpty(minimapZoneText) then
        zoneText4 = zonePath .. "/" .. minimapZoneText;
		Soundtrack.TraceZones("zoneText4: " .. zoneText4);
        zonePath = zoneText4;
        Soundtrack.Events.RenameEvent(ST_ZONE, minimapZoneText, zoneText4);
    end
    
    Soundtrack.TraceZones("Zone: " .. zonePath);
    
    if zoneText4 then
        if Soundtrack.Settings.AutoAddZones then
			local eventTable = Soundtrack.Events.GetTable(ST_ZONE)
			if eventTable[zoneText4] == nil then
				Soundtrack.AddEvent(ST_ZONE, zoneText4, 4, true)
			end
        end
		AssignPriority(ST_ZONE, zoneText4, 4)
        Soundtrack.PlayEvent(ST_ZONE, zoneText4);
    else
        Soundtrack.StopEventAtLevel(4);
    end
    
    if zoneText3 then
        if Soundtrack.Settings.AutoAddZones then
			local eventTable = Soundtrack.Events.GetTable(ST_ZONE)
			if eventTable[zoneText3] == nil then
				Soundtrack.AddEvent(ST_ZONE, zoneText3, 3, true)
			end
        end
		AssignPriority(ST_ZONE, zoneText3, 3)
        Soundtrack.PlayEvent(ST_ZONE, zoneText3);
    else
        Soundtrack.StopEventAtLevel(3);
    end
    
    if zoneText2 then
        if Soundtrack.Settings.AutoAddZones then
			local eventTable = Soundtrack.Events.GetTable(ST_ZONE)
			if eventTable[zoneText2] == nil then
				Soundtrack.AddEvent(ST_ZONE, zoneText2, 2, true)
			end
        end
		AssignPriority(ST_ZONE, zoneText2, 2)
        Soundtrack.PlayEvent(ST_ZONE, zoneText2);
    else        
        Soundtrack.StopEventAtLevel(2);
    end
    
    if zoneText1 then
        if Soundtrack.Settings.AutoAddZones then
			local eventTable = Soundtrack.Events.GetTable(ST_ZONE)
			if eventTable[zoneText1] == nil then
				Soundtrack.AddEvent(ST_ZONE, zoneText1, 1, true)
			end
        end
		AssignPriority(ST_ZONE, zoneText1, 1)
        Soundtrack.PlayEvent(ST_ZONE, zoneText1);
    else        
        Soundtrack.StopEventAtLevel(1);
    end
   
end



Soundtrack.ZoneEvents = 
{
}

function Soundtrack.ZoneEvents.OnLoad(self)
    self:RegisterEvent("ZONE_CHANGED_NEW_AREA")
    self:RegisterEvent("ZONE_CHANGED")
    self:RegisterEvent("ZONE_CHANGED_INDOORS")
    self:RegisterEvent("PLAYER_REGEN_ENABLED")
    self:RegisterEvent("MINIMAP_ZONE_CHANGED")
    self:RegisterEvent("VARIABLES_LOADED")
end
    
function Soundtrack.ZoneEvents.OnEvent(self, event, ...)
    if not Soundtrack.Settings.EnableZoneMusic then
        return
    end
	
	Soundtrack.Trace(event);
	
    if event == "ZONE_CHANGED" or 
       event == "ZONE_CHANGED_INDOORS" or
	   event == "ZONE_CHANGED_NEW_AREA" or
       event == "MINIMAP_ZONE_CHANGED" or
       event == "VARIABLES_LOADED" then
		Soundtrack.TraceZones("Event: "..event);
        OnZoneChanged()
    end
end    

function Soundtrack.ZoneEvents.Initialize()
    -- Add default zones
    local continentNames = { GetMapContinents() }
    
    local tableName = Soundtrack.Events.GetTable(ST_ZONE);
    
    Soundtrack.AddEvent(ST_ZONE, "Instances", 1, true);
	Soundtrack.AddEvent(ST_ZONE, "PvP", 1, true);
	Soundtrack.AddEvent(ST_ZONE, "Uncategorized", 1, true);
    
    for i,continentName in ipairs(continentNames) do      
        Soundtrack.AddEvent(ST_ZONE, continentName, 1, true);
        local zoneNames = { GetMapZones(i) };
        for j,zoneName in ipairs(zoneNames) do
            local newName = continentName .. "/" .. zoneName;
            Soundtrack.AddEvent(ST_ZONE, newName, 2, true);
        end
    end 
       
end