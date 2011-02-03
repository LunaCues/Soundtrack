--[[
    Soundtrack addon for World of Warcraft

    Custom events functions.
    Functions that manage misc. and custom events.
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
local ST_AURA_LVL = 6
local ST_STATUS_LVL = 7
local ST_BUFF_LVL = 8
local ST_NPC_LVL = 9
local ST_SFX_LVL = 10

local ST_BATTLE = "Battle"
local ST_BOSS = "Boss"
local ST_ZONE = "Zone"
local ST_DANCE = "Dance"
local ST_MISC = "Misc"
local ST_CUSTOM = "Custom"
local ST_PLAYLISTS = "Playlists"

local arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13, arg14, arg15, arg16, arg17, arg18, arg19, arg20

local function debug(msg)
	Soundtrack.Util.DebugPrint(msg, 0.6, 0.6, 1.0)
end

Soundtrack.CustomEvents = {
    BuffEvents = {}
}

Soundtrack.ActionHouse = false
Soundtrack.Bank = false
Soundtrack.Merchant = false
Soundtrack.Barbershop = false

Soundtrack.CurrentStance = 0;
Soundtrack.TreeForm = false;
Soundtrack.MoonkinForm = false;

local ST_CLASS_STEALTH

function Soundtrack.CustomEvents.RegisterTrigger(self, trigger)
	if trigger ~= nil then
		self:RegisterEvent(trigger);
	end
end

function Soundtrack.CustomEvents.RenameEvent(tableName, oldEventName, newEventName)
    if Soundtrack.IsNullOrEmpty(tableName) then
        Soundtrack.Error("Custom RenameEvent: Nil table")
        return
    end
    if Soundtrack.IsNullOrEmpty(oldEventName) then
        Soundtrack.Error("Custom RenmeEvent: Nil old event")
        return
    end
	if Soundtrack.IsNullOrEmpty(newEventName) then
        Soundtrack.Error("Custom RenameEvent: Nil new event " .. oldEventName)
        return
    end
	
    local eventTable = Soundtrack.Events.GetTable(tableName)
    
    if not eventTable then
        Soundtrack.Error("Custom RenameEvent: Cannot find table : " .. tableName)
        return
    end
	
	if eventTable[oldEventName] == nil then
		return -- old event DNE
	end
	
	Soundtrack.TraceCustom("RenameEvent: " .. tableName .. ": " .. oldEventName .. " to " .. newEventName)
    
    eventTable[newEventName] = eventTable[oldEventName]

	-- Now that we changed the name of the event, delete the old event
	Soundtrack.CustomEvents.DeleteEvent(tableName, oldEventName)
end
function Soundtrack.CustomEvents.DeleteEvent(tableName, eventName)
    
    local eventTable = Soundtrack.Events.GetTable(tableName)
    if eventTable then
        if eventTable[eventName] then
            Soundtrack.TraceCustom("Removing event: "..eventName)
            eventTable[eventName] = nil
        end
    end
end

-- table can be Custom or Misc. 
function Soundtrack.CustomEvents.RegisterUpdateScript(self, name, tableName, _priority, _continuous, _script, _soundEffect)
    if tableName == ST_CUSTOM then
        Soundtrack_CustomEvents[name] = { script = _script, eventtype = "Update Script", priority=_priority, continuous=_continuous, soundEffect=_soundEffect };
    elseif tableName == ST_MISC then
        Soundtrack_MiscEvents[name] = { script = _script, eventtype = "Update Script", priority=_priority, continuous=_continuous, soundEffect=_soundEffect };
    end
    
    if _trigger ~= nil then
        self:RegisterEvent(_trigger);
    end
    
    Soundtrack.AddEvent(tableName, name, _priority, _continuous, _soundEffect)
end

-- table can be Custom or Misc. 
function Soundtrack.CustomEvents.RegisterEventScript(self, name, tableName, _trigger, _priority, _continuous, _script, _soundEffect)
    if tableName == ST_CUSTOM then
        Soundtrack_CustomEvents[name] = { trigger = _trigger, script = _script, eventtype = "Event Script", priority=_priority, continuous=_continuous, soundEffect=_soundEffect };
    elseif tableName == ST_MISC then
        Soundtrack_MiscEvents[name] = { trigger = _trigger, script = _script, eventtype = "Event Script", priority=_priority, continuous=_continuous, soundEffect=_soundEffect }; 
    end
    Soundtrack.CustomEvents.RegisterTrigger(self, _trigger)
    
    Soundtrack.AddEvent(tableName, name, _priority, _continuous, _soundEffect)
end

-- Returns the spellID of the buff, else nil
function Soundtrack.IsBuffActive(buffTexture)
	if buffTexture == nil then
		return nil
	end
    for i=1,40 do
		local n, _, icon, _, _, _, _, _, _, _, spellId = UnitBuff("player", i); 
		if icon == nil then
			return nil  -- all buffs checked, buff not found
		elseif string.lower(icon) == string.lower(buffTexture) then
			--Soundtrack.Trace("Buff: "..string.lower(icon) .. " " .. spellId)
	        return spellId
	    end
	end
	return nil
end
function Soundtrack.IsDebuffActive(buffTexture)
	if buffTexture == nil then
		return nil
	end
    for i=1,40 do
		local n, _, icon, _, _, _, _, _, _, _, spellId = UnitDebuff("player", i); 
	    if icon == nil then
			return nil
		elseif string.lower(icon) == string.lower(buffTexture) then
			--Soundtrack.Trace("Debuff: "..string.lower(icon) .. " " .. spellId)
	        return spellId
	    end
	end
	return nil
end

function Soundtrack.CustomEvents.RegisterBuffEvent(eventName, tableName, _buffTexture, _priority, _continuous, _soundEffect)
    if tableName == ST_CUSTOM then
        Soundtrack_CustomEvents[eventName] = 
        { 
            buffTexture=_buffTexture, 
            stackLevel=_priority, 
            active=false,
            eventtype="Buff",
            priority=_priority, 
            continuous=_continuous,
			soundEffect=_soundEffect
        }    
    elseif tableName == ST_MISC then
        Soundtrack_MiscEvents[eventName] = 
        { 
            buffTexture=_buffTexture, 
            stackLevel=_priority, 
            active=false,
            eventtype="Buff",
            priority=_priority, 
            continuous=_continuous,
			soundEffect = _soundEffect
        }  
    end
    Soundtrack.AddEvent(tableName, eventName, _priority, _continuous, _soundEffect);
end

function Soundtrack_Custom_PlayEvent(tableName, eventName)
	local eventTable = Soundtrack.Events.GetTable(tableName)
	local currentEvent = Soundtrack.Events.Stack[eventTable[eventName].priority].eventName
	if eventName == currentEvent then
		return	 	-- Don't do anything.  Event already playing.
	else
		Soundtrack.PlayEvent(tableName, eventName);
	end
end

function Soundtrack_Custom_StopEvent(tableName, eventName)
	local eventTable = Soundtrack.Events.GetTable(tableName)
	local currentEvent = Soundtrack.Events.Stack[eventTable[eventName].priority].eventName
	
	if eventName ~= currentEvent then 
		return 		-- Don't do anything.  Event not playing.
	else
		Soundtrack.StopEvent(tableName, eventName);
	end
end

local jumpDelayTime = 0;
local jumpUpdateTime = .7

hooksecurefunc("JumpOrAscendStart",
	function()
		if HasFullControl() and not IsFlying() and not IsSwimming() and not UnitInVehicle("player") then 
			local currentTime = GetTime()
			if currentTime >= jumpDelayTime then
				jumpDelayTime = currentTime + jumpUpdateTime;
				if SoundtrackEvents_EventHasTracks(ST_MISC, SOUNDTRACK_JUMP) then
					Soundtrack_Custom_PlayEvent(ST_MISC, SOUNDTRACK_JUMP)
				end
			end
		end
	end
);

function Soundtrack.CustomEvents.Initialize(self)

	Soundtrack.TraceCustom("Initializing misc. events...")
	
	self:RegisterEvent("UNIT_AURA")
    self:RegisterEvent("AUCTION_HOUSE_CLOSED")
    self:RegisterEvent("AUCTION_HOUSE_SHOW")
    self:RegisterEvent("BANKFRAME_CLOSED")
    self:RegisterEvent("BANKFRAME_OPENED")
    self:RegisterEvent("MERCHANT_CLOSED")
    self:RegisterEvent("MERCHANT_SHOW")
    self:RegisterEvent("BARBER_SHOP_OPEN")
    self:RegisterEvent("BARBER_SHOP_CLOSE")

	
    -- Add fixed custom events
	Soundtrack.CustomEvents.RegisterUpdateScript(	-- Jump
		self,
        SOUNDTRACK_JUMP, 
        ST_MISC,
        ST_SFX_LVL,
        false,
        function()
			-- hooksecurefunc for "JumpOrAscendStart"
		end,
		true
	);
    Soundtrack.CustomEvents.RegisterUpdateScript(	-- Swimming
		self,
        SOUNDTRACK_SWIMMING, 
        ST_MISC,
        ST_STATUS_LVL,
        true,
        function()
            if SNDCUSTOM_IsSwimming == nil then 
                SNDCUSTOM_IsSwimming = false 
            end

            if SNDCUSTOM_IsSwimming and not IsSwimming() then
				Soundtrack_Custom_StopEvent(ST_MISC, SOUNDTRACK_SWIMMING)
                SNDCUSTOM_IsSwimming = false
            elseif not SNDCUSTOM_IsSwimming and IsSwimming() then
                Soundtrack_Custom_PlayEvent(ST_MISC, SOUNDTRACK_SWIMMING)
                SNDCUSTOM_IsSwimming = true;
            end
        end,
		false
	);
	Soundtrack.CustomEvents.RegisterUpdateScript(	-- Auction House  
		self,
        SOUNDTRACK_AUCTION_HOUSE, 
        ST_MISC,
        ST_NPC_LVL,
        true,
        function()
            if SNDCUSTOM_AuctionHouse == nil then 
                SNDCUSTOM_AuctionHouse = false 
            end

            if SNDCUSTOM_AuctionHouse and not Soundtrack.AuctionHouse then
                Soundtrack_Custom_StopEvent(ST_MISC, SOUNDTRACK_AUCTION_HOUSE)
                SNDCUSTOM_AuctionHouse = false
            elseif not SNDCUSTOM_AuctionHouse and Soundtrack.AuctionHouse then
                Soundtrack_Custom_PlayEvent(ST_MISC, SOUNDTRACK_AUCTION_HOUSE)
                SNDCUSTOM_AuctionHouse = true;
            end
        end,
		false
	    );
	Soundtrack.CustomEvents.RegisterUpdateScript(	-- Bank  
		self,
        SOUNDTRACK_BANK, 
        ST_MISC,
        ST_NPC_LVL,
        true,
        function()
            if SNDCUSTOM_Bank == nil then 
                SNDCUSTOM_Bank = false 
            end

			-- Soundtrack.* does not deal with localization
            if SNDCUSTOM_Bank and not Soundtrack.Bank then
                Soundtrack_Custom_StopEvent(ST_MISC, SOUNDTRACK_BANK)
                SNDCUSTOM_Bank = false
            elseif not SNDCUSTOM_Bank and Soundtrack.Bank then
                Soundtrack_Custom_PlayEvent(ST_MISC, SOUNDTRACK_BANK)
                SNDCUSTOM_Bank = true;
            end
        end,
		false
	    );
	Soundtrack.CustomEvents.RegisterUpdateScript(	-- Merchant
		self,
        SOUNDTRACK_MERCHANT, 
        ST_MISC,
        ST_NPC_LVL, -- TODO Anthony: This conflicts with battle level, was 6
        true,
        function()
            if SNDCUSTOM_Merchant == nil then 
                SNDCUSTOM_Merchant = false 
            end
			
            if SNDCUSTOM_Merchant and not Soundtrack.Merchant then
                Soundtrack_Custom_StopEvent(ST_MISC, SOUNDTRACK_MERCHANT)
                SNDCUSTOM_Merchant = false
            elseif not SNDCUSTOM_Merchant and Soundtrack.Merchant then
                Soundtrack_Custom_PlayEvent(ST_MISC, SOUNDTRACK_MERCHANT)
                SNDCUSTOM_Merchant = true
            end
        end,
		false
	    );	    
	Soundtrack.CustomEvents.RegisterUpdateScript(	-- Barbershop
		self,
		SOUNDTRACK_BARBERSHOP,
		ST_MISC,
		ST_NPC_LVL,
		true,
		function()
			if SNDCUSTOM_Barbershop == nil then
				SNDCUSTOM_Barbershop = false
			end
			
			if SNDCUSTOM_Barbershop and not Soundtrack.Barbershop then
				Soundtrack_Custom_StopEvent(ST_MISC, SOUNDTRACK_BARBERSHOP)
				SNDCUSTOM_Barbershop = false
			elseif not SNDCUSTOM_Barbershop and Soundtrack.Barbershop then
				Soundtrack_Custom_PlayEvent(ST_MISC, SOUNDTRACK_BARBERSHOP)
				SNDCUSTOM_Barbershop = true
			end
		end,
		false
		);
	Soundtrack.CustomEvents.RegisterUpdateScript(	-- Cinematic
		self,
		SOUNDTRACK_CINEMATIC,
		ST_MISC,
		ST_NPC_LVL,
		true,
		function()
			if SNDCUSTOM_Cinematic == nil then
				SNDCUSTOM_Cinematic = false
			end
			
			if SNDCUSTOM_Cinematic and not Soundtrack.Cinematic then
				Soundtrack_Custom_StopEvent(ST_MISC, SOUNDTRACK_CINEMATIC)
				SNDCUSTOM_Cinematic = false
			elseif not SNDCUSTOM_Cinematic and Soundtrack.Cinematic then
				Soundtrack_Custom_PlayEvent(ST_MISC, SOUNDTRACK_CINEMATIC)
				SNDCUSTOM_Cinematic = true
			end
		end,
		false
		);
	
	Soundtrack.CustomEvents.RegisterEventScript(	-- NPC Emote
		self,
		SOUNDTRACK_NPC_EMOTE,
		ST_MISC,
		"CHAT_MSG_MONSTER_EMOTE",
		ST_SFX_LVL,
		false,
		function()
			Soundtrack_Custom_PlayEvent(ST_MISC, SOUNDTRACK_NPC_EMOTE)
		end,
		true
		);
	Soundtrack.CustomEvents.RegisterEventScript(	-- NPC Say
		self,
		SOUNDTRACK_NPC_SAY,
		ST_MISC,
		"CHAT_MSG_MONSTER_SAY",
		ST_SFX_LVL,
		false,
		function()
			Soundtrack_Custom_PlayEvent(ST_MISC, SOUNDTRACK_NPC_SAY)
		end,
		true
		);
	Soundtrack.CustomEvents.RegisterEventScript(	-- NPC Whisper
		self,
		SOUNDTRACK_NPC_WHISPER,
		ST_MISC,
		"CHAT_MSG_MONSTER_WHISPER",
		ST_SFX_LVL,
		false,
		function()
			Soundtrack_Custom_PlayEvent(ST_MISC, SOUNDTRACK_NPC_WHISPER)
		end,
		true
		);
	Soundtrack.CustomEvents.RegisterEventScript(	-- NPC Yell
		self,
		SOUNDTRACK_NPC_YELL,
		ST_MISC,
		"CHAT_MSG_MONSTER_YELL",
		ST_SFX_LVL,
		false,
		function()
			Soundtrack_Custom_PlayEvent(ST_MISC, SOUNDTRACK_NPC_YELL)
		end,
		true
		);
	
	Soundtrack.CustomEvents.RegisterEventScript(	-- Level Up
		self,
	    SOUNDTRACK_LEVEL_UP,
	    ST_MISC,
	    "PLAYER_LEVEL_UP",
	    ST_SFX_LVL,
	    false,
	    function()
	        Soundtrack_Custom_PlayEvent(ST_MISC, SOUNDTRACK_LEVEL_UP);
	    end,
		true
	    );
	Soundtrack.CustomEvents.RegisterEventScript(	-- Join Party
		self,
	    SOUNDTRACK_JOIN_PARTY,
	    ST_MISC,
	    "PARTY_MEMBERS_CHANGED",
	    ST_SFX_LVL,
	    false,
	    function()
	        if SOUNDTRACK_InParty == nil then 
                SOUNDTRACK_InParty = false 
            end
	        if not SOUNDTRACK_InParty and GetNumRaidMembers() == 0 and GetNumPartyMembers() > 0 then
				Soundtrack_Custom_PlayEvent(ST_MISC, SOUNDTRACK_JOIN_PARTY)
                SOUNDTRACK_InParty = true
	        elseif SOUNDTRACK_InParty and GetNumPartyMembers() == 0 then
                SOUNDTRACK_InParty = false
	        end
	    end,
		true
	    );
	Soundtrack.CustomEvents.RegisterEventScript(	-- Join Raid
		self,
	    SOUNDTRACK_JOIN_RAID,
	    ST_MISC,
	    "PARTY_MEMBERS_CHANGED",
	    ST_SFX_LVL,
	    false,
	    function()
	        if SOUNDTRACK_InRaid == nil then 
                SOUNDTRACK_InRaid = false 
            end
	        if not SOUNDTRACK_InRaid and GetNumRaidMembers() > 0 then
                Soundtrack_Custom_PlayEvent(ST_MISC, SOUNDTRACK_JOIN_RAID)
                SOUNDTRACK_InRaid = true
	        elseif SOUNDTRACK_InRaid and not GetNumRaidMembers() == 0 then
                SOUNDTRACK_InRaid = false
	        end
	    end,
		true
	);

	Soundtrack.CustomEvents.RegisterEventScript(	-- Death Knight Change Presence
		self,
	    SOUNDTRACK_DK_CHANGE,
	    ST_MISC,
	    "UPDATE_SHAPESHIFT_FORM",
	    ST_SFX_LVL,
	    false,
	    function()
	        local class = UnitClass("player")
			local stance = GetShapeshiftForm();
			if class == "Death Knight" and stance ~= 0 and stance ~= Soundtrack.CurrentStance then
				Soundtrack_Custom_PlayEvent(ST_MISC, SOUNDTRACK_DK_CHANGE)
				Soundtrack.CurrentStance = stance;
			end
	    end,
		true
	);

	Soundtrack.CustomEvents.RegisterEventScript(	-- Druid Change Form
		self,
	    SOUNDTRACK_DRUID_CHANGE,
	    "Misc",
	    "UPDATE_SHAPESHIFT_FORM",
	    ST_SFX_LVL,
	    false,
	    function()
	        local class = UnitClass("player")
			local stance = GetShapeshiftForm();
			if class == "Druid" and stance ~= 0 and stance ~= Soundtrack.CurrentStance then
				Soundtrack_Custom_PlayEvent("Misc", SOUNDTRACK_DRUID_CHANGE)
				Soundtrack.CurrentStance = stance;
			elseif class == "Druid" and stance == 0 and stance ~= Soundtrack.CurrentStance then
				Soundtrack.CurrentStance = stance;
			end
	    end,
		true
	);
	Soundtrack.CustomEvents.RegisterUpdateScript(	-- Druid Prowl
		self,
        SOUNDTRACK_DRUID_PROWL, 
        ST_MISC,
        ST_BUFF_LVL,
        true,
        function()
			local class = UnitClass("player")
            if ST_CLASS_STEALTH == nil then 
                ST_CLASS_STEALTH = false 
            end
            if ST_CLASS_STEALTH and not IsStealthed() and class == "Druid" then
					Soundtrack_Custom_StopEvent(ST_MISC, SOUNDTRACK_DRUID_PROWL)
					ST_CLASS_STEALTH = false 
            elseif not ST_CLASS_STEALTH and IsStealthed() and class == "Druid" then
				if Soundtrack.IsBuffActive("Interface\\Icons\\Ability_Druid_CatForm") then
					Soundtrack_Custom_PlayEvent(ST_MISC, SOUNDTRACK_DRUID_PROWL)
					ST_CLASS_STEALTH = true;
				end
            end
        end,
		false
	);

	Soundtrack.CustomEvents.RegisterEventScript(	-- Paladin Change Auras
		self,
	    SOUNDTRACK_PALADIN_CHANGE,
	    ST_MISC,
	    "UPDATE_SHAPESHIFT_FORM",
	    ST_SFX_LVL,
	    false,
	    function()
	        local class = UnitClass("player")
			local stance = GetShapeshiftForm();
			if class == "Paladin" and stance ~= 0 and stance ~= Soundtrack.CurrentStance then
				Soundtrack_Custom_PlayEvent(ST_MISC, SOUNDTRACK_PALADIN_CHANGE)
				Soundtrack.CurrentStance = stance;
			end
	    end,
		true
	);

	Soundtrack.CustomEvents.RegisterEventScript(	-- Priest Change Shadowform
		self,
	    SOUNDTRACK_PRIEST_CHANGE,
	    ST_MISC,
	    "UPDATE_SHAPESHIFT_FORM",
	    ST_SFX_LVL,
	    false,
	    function()
	        local class = UnitClass("player")
			local stance = GetShapeshiftForm();
			if class == "Priest" and stance ~= 0 then
				Soundtrack_Custom_PlayEvent(ST_MISC, SOUNDTRACK_PRIEST_CHANGE)
				Soundtrack.CurrentStance = stance;
			end
	    end,
		true
	);

	Soundtrack.CustomEvents.RegisterEventScript(	-- Rogue Change Stealth
		self,
	    SOUNDTRACK_ROGUE_CHANGE,
	    ST_MISC,
	    "UPDATE_SHAPESHIFT_FORM",
	    ST_SFX_LVL,
	    false,
	    function()
	        local class = UnitClass("player")
			local stance = GetShapeshiftForm();
			if class == "Rogue" and stance ~= 0 and stance ~= 2 and not IsStealthed() then
				Soundtrack_Custom_PlayEvent(ST_MISC, SOUNDTRACK_ROGUE_CHANGE)
				Soundtrack.CurrentStance = stance;
			end
	    end,
		true
	);
	Soundtrack.CustomEvents.RegisterUpdateScript(	-- Rogue Stealth
		self,
        SOUNDTRACK_ROGUE_STEALTH, 
        ST_MISC,
        ST_BUFF_LVL,
        true,
        function()
			local class = UnitClass("player")
            if ST_CLASS_STEALTH == nil then 
                ST_CLASS_STEALTH = false 
            end
            if ST_CLASS_STEALTH and not IsStealthed() and class == "Rogue" then
					Soundtrack_Custom_StopEvent(ST_MISC, SOUNDTRACK_ROGUE_STEALTH)
					ST_CLASS_STEALTH = false 
            elseif not ST_CLASS_STEALTH and IsStealthed() and class == "Rogue" then
				if Soundtrack.IsBuffActive("Interface\\Icons\\ability_stealth") then
					Soundtrack_Custom_PlayEvent(ST_MISC, SOUNDTRACK_ROGUE_STEALTH)
					ST_CLASS_STEALTH = true;
				end
            end
        end,
		false
	);

	Soundtrack.CustomEvents.RegisterEventScript(	-- Shaman Change Ghost Wolf
		self,
	    SOUNDTRACK_SHAMAN_CHANGE,
	    ST_MISC,
	    "UPDATE_SHAPESHIFT_FORM",
	    ST_SFX_LVL,
	    false,
	    function()
	        local class = UnitClass("player")
			local stance = GetShapeshiftForm();
			if class == "Shaman" and stance ~= 0 then
				Soundtrack.CurrentStance = stance;
				Soundtrack_Custom_PlayEvent(ST_MISC, SOUNDTRACK_SHAMAN_CHANGE)
			end
	    end,
		true
	);

	Soundtrack.CustomEvents.RegisterEventScript(	-- Warrior Change Stances
		self,
	    SOUNDTRACK_WARRIOR_CHANGE,
	    ST_MISC,
	    "UPDATE_SHAPESHIFT_FORM",
	    ST_SFX_LVL,
	    false,
	    function()
	        local class = UnitClass("player")
			local stance = GetShapeshiftForm();
			if class == "Warrior" and stance ~= 0 and stance ~= Soundtrack.CurrentStance then
				Soundtrack_Custom_PlayEvent(ST_MISC, SOUNDTRACK_WARRIOR_CHANGE)
				Soundtrack.CurrentStance = stance;
			end
	    end,
		true
	);
	
	Soundtrack.CustomEvents.RegisterEventScript(	-- Duel Requested
		self,
	    SOUNDTRACK_DUEL_REQUESTED,
	    ST_MISC,
	    "DUEL_REQUESTED",
	    ST_SFX_LVL,
	    false,
	    function()
	        Soundtrack_Custom_PlayEvent(ST_MISC, SOUNDTRACK_DUEL_REQUESTED)
	    end,
		true
	    );
	Soundtrack.CustomEvents.RegisterEventScript(	-- Quest Complete
		self,
	    SOUNDTRACK_QUEST_COMPLETE,
	    ST_MISC,
	    "QUEST_COMPLETE",
	    ST_SFX_LVL,
	    false,
	    function()
	        Soundtrack_Custom_PlayEvent(ST_MISC, SOUNDTRACK_QUEST_COMPLETE)
	    end,
		true
	);    

	-- Thanks to zephus67 for the code!
	Soundtrack.CustomEvents.RegisterUpdateScript(	-- Stealthed
		self,
        SOUNDTRACK_STEALTHED, 
        ST_MISC,
        ST_AURA_LVL,
        true,
        function()
            if SNDCUSTOM_IsStealthed == nil then 
                SNDCUSTOM_IsStealthed = false 
            end
            if SNDCUSTOM_IsStealthed and not IsStealthed() then
                Soundtrack_Custom_StopEvent(ST_MISC, SOUNDTRACK_STEALTHED)
                SNDCUSTOM_IsStealthed = false 
            elseif not SNDCUSTOM_IsStealthed and IsStealthed() then
                Soundtrack_Custom_PlayEvent(ST_MISC, SOUNDTRACK_STEALTHED)
                SNDCUSTOM_IsStealthed = true;
            end
        end,
		false
	);
	
	
	-- Thanks to sgtrama!
	Soundtrack.CustomEvents.RegisterEventScript(	-- LFG Complete
		self,
	    SOUNDTRACK_LFG_COMPLETE,
	    ST_MISC,
	    "LFG_COMPLETION_REWARD",
	    ST_SFX_LVL,
	    false,
	    function()
	        Soundtrack_Custom_PlayEvent(ST_MISC, SOUNDTRACK_LFG_COMPLETE)
	    end,
		true
	);

	Soundtrack.CustomEvents.RegisterEventScript(	-- Achievement
		self,
	    SOUNDTRACK_ACHIEVEMENT,
	    ST_MISC,
	    "ACHIEVEMENT_EARNED",
	    ST_SFX_LVL,
	    false,
	    function()
	        Soundtrack_Custom_PlayEvent(ST_MISC, SOUNDTRACK_ACHIEVEMENT)
	    end,
		true
	);
	
	Soundtrack.CustomEvents.RegisterBuffEvent(SOUNDTRACK_DK, ST_MISC, "null", 1, false, false);
	Soundtrack.CustomEvents.RegisterBuffEvent(SOUNDTRACK_DRUID, ST_MISC, "null", 1, false, false);
	Soundtrack.CustomEvents.RegisterBuffEvent(SOUNDTRACK_PALADIN, ST_MISC, "null", 1, false, false);
	Soundtrack.CustomEvents.RegisterBuffEvent(SOUNDTRACK_PRIEST, ST_MISC, "null", 1, false, false);
	Soundtrack.CustomEvents.RegisterBuffEvent(SOUNDTRACK_ROGUE, ST_MISC, "null", 1, false, false);
	Soundtrack.CustomEvents.RegisterBuffEvent(SOUNDTRACK_SHAMAN, ST_MISC, "null", 1, false, false);
	Soundtrack.CustomEvents.RegisterBuffEvent(SOUNDTRACK_WARRIOR, ST_MISC, "null", 1, false, false);
	Soundtrack.CustomEvents.RegisterBuffEvent(SOUNDTRACK_HUNTER, ST_MISC, "null", 1, false, false);
	
	Soundtrack.CustomEvents.RegisterBuffEvent(SOUNDTRACK_COMBAT_EVENTS, ST_MISC, "null", 1, false, false);
	Soundtrack.CustomEvents.RegisterBuffEvent(SOUNDTRACK_GROUP_EVENTS, ST_MISC, "null", 1, false, false);
	Soundtrack.CustomEvents.RegisterBuffEvent(SOUNDTRACK_NPC_EVENTS, ST_MISC, "null", 1, false, false);
	Soundtrack.CustomEvents.RegisterBuffEvent(SOUNDTRACK_STATUS_EVENTS, ST_MISC, "null", 1, false, false);

	Soundtrack.CustomEvents.RegisterBuffEvent(SOUNDTRACK_HUNTER_CAMO, ST_MISC, "Interface\\Icons\\ability_hunter_displacement", ST_BUFF_LVL, true, false)
	
	Soundtrack.CustomEvents.RegisterBuffEvent(SOUNDTRACK_ROGUE_SPRINT, ST_MISC, "Interface\\Icons\\Ability_Rogue_Sprint", ST_BUFF_LVL, true, false)
	
	Soundtrack.CustomEvents.RegisterBuffEvent(SOUNDTRACK_DRUID_DASH, ST_MISC, "Interface\\Icons\\Ability_Druid_Dash", ST_BUFF_LVL, true, false)
	Soundtrack.CustomEvents.RegisterBuffEvent(SOUNDTRACK_DRUID_CAT, ST_MISC, "Interface\\Icons\\Ability_Druid_CatForm", ST_AURA_LVL, true, false)
	Soundtrack.CustomEvents.RegisterBuffEvent(SOUNDTRACK_DRUID_AQUATIC, ST_MISC, "Interface\\Icons\\Ability_Druid_AquaticForm", ST_AURA_LVL, true, false)
	Soundtrack.CustomEvents.RegisterBuffEvent(SOUNDTRACK_DRUID_BEAR, ST_MISC, "Interface\\Icons\\Ability_Racial_BearForm", ST_AURA_LVL, true, false)
	Soundtrack.CustomEvents.RegisterBuffEvent(SOUNDTRACK_DRUID_TRAVEL, ST_MISC, "Interface\\Icons\\Ability_Druid_TravelForm", ST_AURA_LVL, true, false)
	Soundtrack.CustomEvents.RegisterBuffEvent(SOUNDTRACK_DRUID_FLIGHT, ST_MISC, "Interface\\Icons\\Ability_Druid_FlightForm", ST_AURA_LVL, true, false)
 
	Soundtrack.CustomEvents.RegisterUpdateScript(	-- Moonkin Form
	    self, SOUNDTRACK_DRUID_MOONKIN, ST_MISC, ST_AURA_LVL, true,
	    function()
	        local class = UnitClass("player")
			local buff = Soundtrack.IsBuffActive("Interface\\Icons\\Spell_Nature_ForceOfNature")
			if class == "Druid" and buff == 24858 then
				Soundtrack.MoonkinForm = true;
					
				Soundtrack_Custom_PlayEvent(ST_MISC, SOUNDTRACK_DRUID_MOONKIN)
			elseif not Soundtrack.TreeForm then
				Soundtrack.MoonkinForm = false;
				Soundtrack_Custom_StopEvent(ST_MISC, SOUNDTRACK_DRUID_MOONKIN)
			end
	    end,
		false
	); 
	Soundtrack.CustomEvents.RegisterUpdateScript(	-- Tree of Life Form
	    self, SOUNDTRACK_DRUID_TREE, ST_MISC, ST_AURA_LVL, true,
	    function()
	        local class = UnitClass("player")
			local buff = Soundtrack.IsBuffActive("Interface\\Icons\\Ability_Druid_TreeofLife")
			if class == "Druid" and buff == 34123 then
				Soundtrack.TreeForm = true;
				Soundtrack_Custom_PlayEvent(ST_MISC, SOUNDTRACK_DRUID_TREE)
			elseif not Soundtrack.MoonkinForm then
				Soundtrack.TreeForm = false;
				Soundtrack_Custom_StopEvent(ST_MISC, SOUNDTRACK_DRUID_TREE)
			end
	    end,
		false
	);
	
	Soundtrack.CustomEvents.RegisterBuffEvent(SOUNDTRACK_SHAMAN_GHOST_WOLF, ST_MISC, "Interface\\Icons\\Spell_Nature_SpiritWolf", ST_AURA_LVL, true, false)
	
	--[[
	Soundtrack.CustomEvents.RenameEvent(ST_MISC, SOUNDTRACK_FLIGHT_OLD, SOUNDTRACK_FLIGHT)
	Soundtrack.CustomEvents.RenameEvent(ST_MISC, SOUNDTRACK_DEATH_OLD, SOUNDTRACK_DEATH)
	Soundtrack.CustomEvents.RenameEvent(ST_MISC, SOUNDTRACK_GHOST_OLD, SOUNDTRACK_GHOST)
	Soundtrack.CustomEvents.RenameEvent(ST_MISC, SOUNDTRACK_MOUNT_FLYING_OLD, SOUNDTRACK_MOUNT_FLYING)
	Soundtrack.CustomEvents.RenameEvent(ST_MISC, SOUNDTRACK_MOUNT_GROUND_OLD, SOUNDTRACK_MOUNT_GROUND)
	Soundtrack.CustomEvents.RenameEvent(ST_MISC, SOUNDTRACK_STEALTHED_OLD, SOUNDTRACK_STEALTHED)
	Soundtrack.CustomEvents.RenameEvent(ST_MISC, SOUNDTRACK_SWIMMING_OLD, SOUNDTRACK_SWIMMING)
	
	Soundtrack.CustomEvents.RenameEvent(ST_MISC, SOUNDTRACK_ACHIEVEMENT_OLD, SOUNDTRACK_ACHIEVEMENT)
	Soundtrack.CustomEvents.RenameEvent(ST_MISC, SOUNDTRACK_JOIN_PARTY_OLD, SOUNDTRACK_JOIN_PARTY)
	Soundtrack.CustomEvents.RenameEvent(ST_MISC, SOUNDTRACK_JOIN_RAID_OLD, SOUNDTRACK_JOIN_RAID)
	Soundtrack.CustomEvents.RenameEvent(ST_MISC, SOUNDTRACK_JUMP_OLD, SOUNDTRACK_JUMP)
	Soundtrack.CustomEvents.RenameEvent(ST_MISC, SOUNDTRACK_LEVEL_UP_OLD, SOUNDTRACK_LEVEL_UP)
	Soundtrack.CustomEvents.RenameEvent(ST_MISC, SOUNDTRACK_LFG_COMPLETE_OLD, SOUNDTRACK_LFG_COMPLETE)
	Soundtrack.CustomEvents.RenameEvent(ST_MISC, SOUNDTRACK_QUEST_COMPLETE_OLD, SOUNDTRACK_QUEST_COMPLETE)

	Soundtrack.CustomEvents.RenameEvent(ST_MISC, SOUNDTRACK_AUCTION_HOUSE_OLD, SOUNDTRACK_AUCTION_HOUSE)
	Soundtrack.CustomEvents.RenameEvent(ST_MISC, SOUNDTRACK_BANK_OLD, SOUNDTRACK_BANK)
	Soundtrack.CustomEvents.RenameEvent(ST_MISC, SOUNDTRACK_MERCHANT_OLD, SOUNDTRACK_MERCHANT)

	Soundtrack.CustomEvents.RenameEvent(ST_MISC, SOUNDTRACK_RANGE_CRIT_OLD, SOUNDTRACK_RANGE_CRIT)
	Soundtrack.CustomEvents.RenameEvent(ST_MISC, SOUNDTRACK_RANGE_HIT_OLD, SOUNDTRACK_RANGE_HIT)
	Soundtrack.CustomEvents.RenameEvent(ST_MISC, SOUNDTRACK_HEAL_CRIT_OLD, SOUNDTRACK_HEAL_CRIT)
	Soundtrack.CustomEvents.RenameEvent(ST_MISC, SOUNDTRACK_HEAL_HIT_OLD, SOUNDTRACK_HEAL_HIT)
	Soundtrack.CustomEvents.RenameEvent(ST_MISC, SOUNDTRACK_HOT_CRIT_OLD, SOUNDTRACK_HOT_CRIT)
	Soundtrack.CustomEvents.RenameEvent(ST_MISC, SOUNDTRACK_HOT_HIT_OLD, SOUNDTRACK_HOT_HIT)
	Soundtrack.CustomEvents.RenameEvent(ST_MISC, SOUNDTRACK_DOT_CRIT_OLD, SOUNDTRACK_DOT_CRIT)
	Soundtrack.CustomEvents.RenameEvent(ST_MISC, SOUNDTRACK_DOT_HIT_OLD, SOUNDTRACK_DOT_HIT)
	Soundtrack.CustomEvents.RenameEvent(ST_MISC, SOUNDTRACK_SPELL_CRIT_OLD, SOUNDTRACK_SPELL_CRIT)
	Soundtrack.CustomEvents.RenameEvent(ST_MISC, SOUNDTRACK_SPELL_HIT_OLD, SOUNDTRACK_SPELL_HIT)
	Soundtrack.CustomEvents.RenameEvent(ST_MISC, SOUNDTRACK_SWING_CRIT_OLD, SOUNDTRACK_SWING_CRIT)
	Soundtrack.CustomEvents.RenameEvent(ST_MISC, SOUNDTRACK_SWING_HIT_OLD, SOUNDTRACK_SWING_HIT)
	Soundtrack.CustomEvents.RenameEvent(ST_MISC, SOUNDTRACK_VICTORY_OLD, SOUNDTRACK_VICTORY)
	--]]
	
	-- Make sure there are events for each customevent
	for k,v in pairs(Soundtrack_CustomEvents) do
	    --Soundtrack.AddEvent(ST_CUSTOM, k, v.priority, v.continuous, v.soundEffect)
		if v.eventtype == "Event Script" then
			self:RegisterEvent(v.trigger)
		end
	end 
	
    Soundtrack_SortEvents(ST_MISC)
    Soundtrack_SortEvents(ST_CUSTOM)
end

function Soundtrack.CustomEvents.OnLoad(self)
	self:RegisterEvent("VARIABLES_LOADED")
end


-- nil triggers are called at each update.
function Soundtrack.CustomEvents.OnUpdate(self, elapsed)    
       
    if Soundtrack.Settings.EnableCustomMusic then
        for k,v in pairs(Soundtrack_CustomEvents) do
            if v.eventtype == "Update Script" then
				local hasTracks = SoundtrackEvents_EventHasTracks(ST_CUSTOM, k)
				if hasTracks then
					RunScript(v.script);
				end
            end
        end
    end

    if Soundtrack.Settings.EnableMiscMusic then
        for k,v in pairs(Soundtrack_MiscEvents) do
            if v.eventtype == "Update Script" then
				local hasTracks = SoundtrackEvents_EventHasTracks(ST_MISC, k)
				if hasTracks then
					v.script();
				end
            end
        end
    end
end

function Soundtrack.CustomEvents.OnEvent(self, event, ...)
	arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13, arg14, arg15, arg16, arg17, arg18, arg19, arg20 = select(1, ...)
	
	if event == "VARIABLES_LOADED" then	
		Soundtrack.CustomEvents.Initialize(self)
    end
	
	Soundtrack.TraceCustom(event)
	
    if event == "AUCTION_HOUSE_SHOW" then
		debug("AUCTION_HOUSE_SHOW")
        Soundtrack.AuctionHouse = true
    elseif event == "AUCTION_HOUSE_CLOSED" then
        Soundtrack.AuctionHouse = false
    elseif event == "BANKFRAME_OPENED" then
		debug("BANKFRAME_OPENED")
        Soundtrack.Bank = true
    elseif event == "BANKFRAME_CLOSED" then
        Soundtrack.Bank = false
    elseif event == "MERCHANT_SHOW" then
		debug("MERCHANT_SHOW")
        Soundtrack.Merchant = true
    elseif event == "MERCHANT_CLOSED" then
        Soundtrack.Merchant = false
	elseif event == "BARBER_SHOP_OPEN" then
		debug("BARBER_SHOP_OPEN")
		Soundtrack.Barbershop = true
	elseif event == "BARBER_SHOP_CLOSE" then
		Soundtrack.Barbershop = false
    elseif event == "CINEMATIC_START" then
		debug("CINEMATIC_START")
		Soundtrack.Cinematic = true
	elseif event == "CINEMATIC_STOP" then
		Soundtrack.Cinematic = false
		
	
    -- Handle custom buff events
    elseif event == "UNIT_AURA" or event == "UPDATE_SHAPESHIFT_FORM" then 
		if arg1 == "player" then
		--[[
			if Soundtrack.Settings.EnableCustomMusic then
				for k,v in pairs(Soundtrack_CustomEvents) do
					if v.eventtype == "Buff" then
						local buffActive = Soundtrack.IsBuffActive(v.buffTexture)
						local hasTracks = SoundtrackEvents_EventHasTracks(ST_CUSTOM, k)
						if not v.active and buffActive then
							v.active = true
							if hasTracks then
								Soundtrack_Custom_PlayEvent(ST_CUSTOM, k)
							end
						elseif v.active and not buffActive then
							v.active = false
							if hasTracks then
								Soundtrack_Custom_StopEvent(ST_CUSTOM, k)
							end
						end
					end
					if v.eventtype == "Debuff" then
						local debuffActive = Soundtrack.IsDebuffActive(v.debuffTexture)
						local hasTracks = SoundtrackEvents_EventHasTracks(ST_CUSTOM, k)
						if not v.active and debuffActive then
							v.active = true
							if hasTracks then
								Soundtrack_Custom_PlayEvent(ST_CUSTOM, k)
							end
						elseif v.active and not debuffActive then
							v.active = false
							if hasTracks then
								Soundtrack_Custom_StopEvent(ST_CUSTOM, k)
							end
						end
					end
				end
			end
			--]]
			if Soundtrack.Settings.EnableMiscMusic then
				for k,v in pairs(Soundtrack_MiscEvents) do
					if v.eventtype == "Buff" then
						local buffActive = Soundtrack.IsBuffActive(v.buffTexture)
						local hasTracks = SoundtrackEvents_EventHasTracks(ST_MISC, k)
						if not v.active and buffActive then
							v.active = true
							if hasTracks then
								Soundtrack_Custom_PlayEvent(ST_MISC, k)
							end
						elseif v.active and not buffActive then
							v.active = false
							if hasTracks then
								Soundtrack_Custom_StopEvent(ST_MISC, k)
							end
						end
					end
					if v.eventtype == "Debuff" then
						local debuffActive = Soundtrack.IsDebuffActive(v.debuffTexture)
						local hasTracks = SoundtrackEvents_EventHasTracks(ST_MISC, k)
						if not v.active and debuffActive then
							v.active = true
							if hasTracks then
								Soundtrack_Custom_PlayEvent(ST_MISC, k)
							end
						elseif v.active and not debuffActive then
							v.active = false
							if hasTracks then
								Soundtrack_Custom_StopEvent(ST_MISC, k)
							end
						end
					end
				end
			end
		end
    end
    
    -- Handle custom events
	--[[
    if Soundtrack.Settings.EnableCustomMusic then
        for k,v in pairs(Soundtrack_CustomEvents) do
            if v.eventtype == "Event Script" then
                if event == v.trigger then
					local hasTracks = SoundtrackEvents_EventHasTracks(ST_CUSTOM, k)
					if hasTracks then
						RunScript(v.script)
					end
                end
            end
        end
    end
	--]]
    
    if Soundtrack.Settings.EnableMiscMusic then
        for k,v in pairs(Soundtrack_MiscEvents) do
            if v.eventtype == "Event Script" then
                if event == v.trigger then
					local hasTracks = SoundtrackEvents_EventHasTracks(ST_MISC, k) 
					if hasTracks then
						v.script();
					end
                end
            end
        end
    end
end