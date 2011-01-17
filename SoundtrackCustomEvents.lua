
local function debug(msg)
	Soundtrack.Util.DebugPrint(msg, 0.6, 0.6, 1.0)
end

Soundtrack.CustomEvents = {
    BuffEvents = {}
}

local ST_BATTLE = "Battle"
local ST_BOSS = "Boss"
local ST_ZONE = "Zone"
local ST_DANCE = "Dance"
local ST_MISC = "Misc"
local ST_CUSTOM = "Custom"
local ST_PLAYLISTS = "Playlists"

local arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13, arg14, arg15, arg16, arg17, arg18, arg19, arg20

Soundtrack.CombatLogDelayTime = 0
Soundtrack.CombatLogUpdateTime = .1
Soundtrack.ActionHouse = false
Soundtrack.Bank = false
Soundtrack.Merchant = false
Soundtrack.Barbershop = false

Soundtrack.CurrentStance = 0;
Soundtrack.TreeForm = false;
Soundtrack.MoonkinForm = false;

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
	if eventName == currentEvent then return end -- Don't do anything.  Event already playing.
	
	if eventTable[eventName].trigger == "COMBAT_LOG_EVENT_UNFILTERED" then
		local currentTime = GetTime()
		if currentTime >= Soundtrack.CombatLogDelayTime then
			Soundtrack.CombatLogDelayTime = currentTime + Soundtrack.CombatLogUpdateTime
			Soundtrack.PlayEvent(tableName, eventName);
		end
	else
		Soundtrack.PlayEvent(tableName, eventName);
	end
end
function Soundtrack_Custom_StopEvent(tableName, eventName)
	local eventTable = Soundtrack.Events.GetTable(tableName)
	local currentEvent = Soundtrack.Events.Stack[eventTable[eventName].priority].eventName
	if eventName ~= currentEvent then return end -- Don't do anything.  Event not playing.
	
	Soundtrack.StopEvent(tableName, eventName);
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

	
    -- Add fixed custom events 

	Soundtrack.CustomEvents.RegisterUpdateScript(	-- Jump
		self,
        SOUNDTRACK_JUMP, 
        ST_MISC,
        8,
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
        5,
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
        5,
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
        5,
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
        5, -- TODO Anthony: This conflicts with battle level, was 6
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
		5,
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
		5,
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
	
	Soundtrack.CustomEvents.RegisterEventScript(	-- NPC Dungeon Emote
		self,
		SOUNDTRACK_NPC_EMOTE,
		ST_MISC,
		"CHAT_MSG_MONSTER_EMOTE",
		8,
		false,
		function()
			Soundtrack_Custom_PlayEvent(ST_MISC, SOUNDTRACK_NPC_EMOTE)
		end,
		true
		);
	Soundtrack.CustomEvents.RegisterEventScript(	-- NPC Dungeon Say
		self,
		SOUNDTRACK_NPC_SAY,
		ST_MISC,
		"CHAT_MSG_MONSTER_SAY",
		8,
		false,
		function()
			Soundtrack_Custom_PlayEvent(ST_MISC, SOUNDTRACK_NPC_SAY)
		end,
		true
		);
	Soundtrack.CustomEvents.RegisterEventScript(	-- NPC Dungeon Whisper
		self,
		SOUNDTRACK_NPC_WHISPER,
		ST_MISC,
		"CHAT_MSG_MONSTER_WHISPER",
		8,
		false,
		function()
			Soundtrack_Custom_PlayEvent(ST_MISC, SOUNDTRACK_NPC_WHISPER)
		end,
		true
		);
	Soundtrack.CustomEvents.RegisterEventScript(	-- NPC Dungeon Yell
		self,
		SOUNDTRACK_NPC_YELL,
		ST_MISC,
		"CHAT_MSG_MONSTER_YELL",
		8,
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
	    8,
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
	    6,
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
	    6,
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
	    8,
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
	    8,
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
        5,
        true,
        function()
			local class = UnitClass("player")
            if SNDCUSTOM_IsStealthed == nil then 
                SNDCUSTOM_IsStealthed = false 
            end
            if SNDCUSTOM_IsStealthed and not IsStealthed() and class == "Druid" then
                Soundtrack_Custom_StopEvent(ST_MISC, SOUNDTRACK_DRUID_PROWL)
                SNDCUSTOM_IsStealthed = false 
            elseif not SNDCUSTOM_IsStealthed and IsStealthed() and class == "Druid" then
                Soundtrack_Custom_PlayEvent(ST_MISC, SOUNDTRACK_DRUID_PROWL)
                SNDCUSTOM_IsStealthed = true;
            end
        end,
		false
	);

	Soundtrack.CustomEvents.RegisterEventScript(	-- Paladin Change Auras
		self,
	    SOUNDTRACK_PALADIN_CHANGE,
	    ST_MISC,
	    "UPDATE_SHAPESHIFT_FORM",
	    8,
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
	    8,
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
	    8,
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
        5,
        true,
        function()
			local class = UnitClass("player")
            if SNDCUSTOM_IsStealthed == nil then 
                SNDCUSTOM_IsStealthed = false 
            end
            if SNDCUSTOM_IsStealthed and not IsStealthed() and class == "Rogue" then
                Soundtrack_Custom_StopEvent(ST_MISC, SOUNDTRACK_ROGUE_STEALTH)
                SNDCUSTOM_IsStealthed = false 
            elseif not SNDCUSTOM_IsStealthed and IsStealthed() and class == "Rogue" then
                Soundtrack_Custom_PlayEvent(ST_MISC, SOUNDTRACK_ROGUE_STEALTH)
                SNDCUSTOM_IsStealthed = true;
            end
        end,
		false
	);

	Soundtrack.CustomEvents.RegisterEventScript(	-- Shaman Change Ghost Wolf
		self,
	    SOUNDTRACK_SHAMAN_CHANGE,
	    ST_MISC,
	    "UPDATE_SHAPESHIFT_FORM",
	    8,
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
	    8,
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
	    5,
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
	    6,
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
        5,
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
	--[[
	Soundtrack.CustomEvents.RegisterUpdateScript(
	"Stealthed",
	"Misc",
	4,
	true,
	function()
		if SNDCUSTOM_IsStealthed == nil then
			SNDCUSTOM_IsStealthed = false
		end
		if SNDCUSTOM_IsStealthed and not IsStealthed() then
			Soundtrack.StopEvent("Misc", "Stealthed");
			SNDCUSTOM_IsStealthed = false
		elseif not SNDCUSTOM_IsStealthed andIsStealthed () then
			Soundtrack.PlayEvent("Misc", "Stealthed");
			SNDCUSTOM_IsStealthed = true;
		end
	end
);

--]]
	

	-- Thanks to sgtrama!
	Soundtrack.CustomEvents.RegisterEventScript(	-- LFG Complete
		self,
	    SOUNDTRACK_LFG_COMPLETE,
	    ST_MISC,
	    "LFG_COMPLETION_REWARD",
	    6,
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
	    6,
	    false,
	    function()
	        Soundtrack_Custom_PlayEvent(ST_MISC, SOUNDTRACK_ACHIEVEMENT)
	    end,
		true
	);
	
	
	Soundtrack.CustomEvents.RegisterEventScript(	-- Swing Crit
		self,
	    SOUNDTRACK_SWING_CRIT,
	    ST_MISC,
	    "COMBAT_LOG_EVENT_UNFILTERED",
	    8,
	    false,
	    function()
	        if arg2 == "SWING_DAMAGE" and arg4 == UnitName("player") and arg15 == 1 then
				Soundtrack_Custom_PlayEvent(ST_MISC, SOUNDTRACK_SWING_CRIT)
			end
	    end,
		true
	);
	Soundtrack.CustomEvents.RegisterEventScript(	-- Swing
		self,
	    SOUNDTRACK_SWING_HIT,
	    ST_MISC,
	    "COMBAT_LOG_EVENT_UNFILTERED",
	    8,
	    false,
	    function()
	        if arg2 == "SWING_DAMAGE" and arg4 == UnitName("player") then
				if arg15 == nil then
					Soundtrack_Custom_PlayEvent(ST_MISC, SOUNDTRACK_SWING_HIT)
				else 
					local eventTable = Soundtrack.Events.GetTable(ST_MISC) 
					local numTracks = table.getn(eventTable[SOUNDTRACK_SWING_CRIT].tracks)
					if numTracks == 0 then
						Soundtrack_Custom_PlayEvent(ST_MISC, SOUNDTRACK_SWING_HIT)
					end
				end
			end
	    end,
		true
	);

	Soundtrack.CustomEvents.RegisterEventScript(	-- Damage Spells Crit
		self,
	    SOUNDTRACK_SPELL_CRIT,
	    ST_MISC,
	    "COMBAT_LOG_EVENT_UNFILTERED",
	    8,
	    false,
	    function()
	        if arg2 == "SPELL_DAMAGE" and arg4 == UnitName("player") and arg18 == 1 then
				Soundtrack_Custom_PlayEvent(ST_MISC, SOUNDTRACK_SPELL_CRIT)
			end
	    end,
		true
	);
	Soundtrack.CustomEvents.RegisterEventScript(	-- Damage Spells
		self,
	    SOUNDTRACK_SPELL_HIT,
	    ST_MISC,
	    "COMBAT_LOG_EVENT_UNFILTERED",
	    8,
	    false,
	    function()
	        if arg2 == "SPELL_DAMAGE" and arg4 == UnitName("player") then
				if arg18 == nil then
					Soundtrack_Custom_PlayEvent(ST_MISC, SOUNDTRACK_SPELL_HIT)
				else
					local eventTable = Soundtrack.Events.GetTable(ST_MISC) 
					local numTracks = table.getn(eventTable[SOUNDTRACK_SPELL_CRIT].tracks)
					if numTracks == 0 then
						Soundtrack_Custom_PlayEvent(ST_MISC, SOUNDTRACK_SPELL_HIT)
					end
				end
			end
	    end,
		true
	);
	
	Soundtrack.CustomEvents.RegisterEventScript(	-- DoTs Crit
		self,
	    SOUNDTRACK_DOT_CRIT,
	    ST_MISC,
	    "COMBAT_LOG_EVENT_UNFILTERED",
	    8,
	    false,
	    function()
	        if arg2 == "SPELL_PERIODIC_DAMAGE" and arg4 == UnitName("player") and arg18 == 1 then
				Soundtrack_Custom_PlayEvent(ST_MISC, SOUNDTRACK_DOT_CRIT)
			end
	    end,
		true
	);
	Soundtrack.CustomEvents.RegisterEventScript(	-- DoTs
		self,
	    SOUNDTRACK_DOT_HIT,
	    ST_MISC,
	    "COMBAT_LOG_EVENT_UNFILTERED",
	    8,
	    false,
	    function()
	        if arg2 == "SPELL_PERIODIC_DAMAGE" and arg4 == UnitName("player") then
				if arg18 == nil then
					Soundtrack_Custom_PlayEvent(ST_MISC, SOUNDTRACK_DOT_HIT)
				else
					local eventTable = Soundtrack.Events.GetTable(ST_MISC) 
					local numTracks = table.getn(eventTable[SOUNDTRACK_DOT_CRIT].tracks)
					if numTracks == 0 then
						Soundtrack_Custom_PlayEvent(ST_MISC, SOUNDTRACK_DOT_HIT)
					end
				end
			end
	    end,
		true
	);
	
	Soundtrack.CustomEvents.RegisterEventScript(	-- Healing Spells Crit
		self,
	    SOUNDTRACK_HEAL_CRIT,
	    ST_MISC,
	    "COMBAT_LOG_EVENT_UNFILTERED",
	    8,
	    false,
	    function()
	        if arg2 == "SPELL_HEAL" and arg4 == UnitName("player") and arg15 == 1 then 
					Soundtrack_Custom_PlayEvent(ST_MISC, SOUNDTRACK_HEAL_CRIT)
			end
	    end,
		true
	);
	Soundtrack.CustomEvents.RegisterEventScript(	-- Healing Spells
		self,
	    SOUNDTRACK_HEAL_HIT,
	    ST_MISC,
	    "COMBAT_LOG_EVENT_UNFILTERED",
	    8,
	    false,
	    function()
	        if arg2 == "SPELL_HEAL" and arg4 == UnitName("player") then 
				if arg15 == nil then 
					Soundtrack_Custom_PlayEvent(ST_MISC, SOUNDTRACK_HEAL_HIT)
				else
					local eventTable = Soundtrack.Events.GetTable(ST_MISC) 
					local numTracks = table.getn(eventTable[SOUNDTRACK_HEAL_CRIT].tracks)
					if numTracks == 0 then
						Soundtrack_Custom_PlayEvent(ST_MISC, SOUNDTRACK_HEAL_HIT)
					end
				end
			end
	    end,
		true
	); 
    
	Soundtrack.CustomEvents.RegisterEventScript(	-- HoTs Crit
		self,
	    SOUNDTRACK_HOT_CRIT,
	    ST_MISC,
	    "COMBAT_LOG_EVENT_UNFILTERED",
	    8,
	    false,
	    function()
	        if arg2 == "SPELL_PERIODIC_HEAL" and arg4 == UnitName("player") and arg15 == 1 then 
					Soundtrack_Custom_PlayEvent(ST_MISC, SOUNDTRACK_HOT_CRIT)
			end
	    end,
		true
	); 
	Soundtrack.CustomEvents.RegisterEventScript(	-- HoTs
		self,
	    SOUNDTRACK_HOT_HIT,
	    ST_MISC,
	    "COMBAT_LOG_EVENT_UNFILTERED",
	    8,
	    false,
	    function()
	        if arg2 == "SPELL_PERIODIC_HEAL" and arg4 == UnitName("player") then 
				if arg15 == nil then 
					Soundtrack_Custom_PlayEvent(ST_MISC, SOUNDTRACK_HOT_HIT)
				else
					local eventTable = Soundtrack.Events.GetTable(ST_MISC) 
					local numTracks = table.getn(eventTable[SOUNDTRACK_HOT_CRIT].tracks)
					if numTracks == 0 then
						Soundtrack_Custom_PlayEvent(ST_MISC, SOUNDTRACK_HOT_HIT)
					end
				end
			end
	    end,
		true
	); 
    
	Soundtrack.CustomEvents.RegisterEventScript(	-- Range Crit
		self,
	    SOUNDTRACK_RANGE_CRIT,
	    ST_MISC,
	    "COMBAT_LOG_EVENT_UNFILTERED",
	    8,
	    false,
	    function()
	        if arg2 == "SWING_DAMAGE" and arg4 == UnitName("player") and arg18 == 1 then
				Soundtrack_Custom_PlayEvent(ST_MISC, SOUNDTRACK_RANGE_CRIT)
			end
	    end,
		true
	);
	Soundtrack.CustomEvents.RegisterEventScript(	-- Range
		self,
	    SOUNDTRACK_RANGE_HIT,
	    ST_MISC,
	    "COMBAT_LOG_EVENT_UNFILTERED",
	    8,
	    false,
	    function()
	        if arg2 == "SWING_DAMAGE" and arg4 == UnitName("player") then
				if arg18 == nil then
					Soundtrack_Custom_PlayEvent(ST_MISC, SOUNDTRACK_RANGE_HIT)
				else 
					local eventTable = Soundtrack.Events.GetTable(ST_MISC) 
					local numTracks = table.getn(eventTable[SOUNDTRACK_RANGE_CRIT].tracks)
					if numTracks == 0 then
						Soundtrack_Custom_PlayEvent(ST_MISC, SOUNDTRACK_RANGE_HIT)
					end
				end
			end
	    end,
		true
	);
	
	Soundtrack.CustomEvents.RegisterBuffEvent(SOUNDTRACK_DK, ST_MISC, "null", 8, false, false);
	Soundtrack.CustomEvents.RegisterBuffEvent(SOUNDTRACK_DRUID, ST_MISC, "null", 8, false, false);
	Soundtrack.CustomEvents.RegisterBuffEvent(SOUNDTRACK_PALADIN, ST_MISC, "null", 8, false, false);
	Soundtrack.CustomEvents.RegisterBuffEvent(SOUNDTRACK_PRIEST, ST_MISC, "null", 8, false, false);
	Soundtrack.CustomEvents.RegisterBuffEvent(SOUNDTRACK_ROGUE, ST_MISC, "null", 8, false, false);
	Soundtrack.CustomEvents.RegisterBuffEvent(SOUNDTRACK_SHAMAN, ST_MISC, "null", 8, false, false);
	Soundtrack.CustomEvents.RegisterBuffEvent(SOUNDTRACK_WARRIOR, ST_MISC, "null", 8, false, false);
	
	Soundtrack.CustomEvents.RegisterBuffEvent(SOUNDTRACK_COMBAT_EVENTS, ST_MISC, "null", 8, false, false);
	Soundtrack.CustomEvents.RegisterBuffEvent(SOUNDTRACK_GROUP_EVENTS, ST_MISC, "null", 8, false, false);
	Soundtrack.CustomEvents.RegisterBuffEvent(SOUNDTRACK_NPC_EVENTS, ST_MISC, "null", 8, false, false);
	Soundtrack.CustomEvents.RegisterBuffEvent(SOUNDTRACK_STATUS_EVENTS, ST_MISC, "null", 8, false, false);

    -- Ability_Rogue_Sprint
	Soundtrack.CustomEvents.RegisterBuffEvent(SOUNDTRACK_ROGUE_SPRINT, ST_MISC, "Interface\\Icons\\Ability_Rogue_Sprint", 8, true, false)
	
	Soundtrack.CustomEvents.RegisterBuffEvent(SOUNDTRACK_DRUID_DASH, ST_MISC, "Interface\\Icons\\Ability_Druid_Dash", 8, true, false)
	Soundtrack.CustomEvents.RegisterBuffEvent(SOUNDTRACK_DRUID_CAT, ST_MISC, "Interface\\Icons\\Ability_Druid_CatForm", 8, true, false)
	Soundtrack.CustomEvents.RegisterBuffEvent(SOUNDTRACK_DRUID_AQUATIC, ST_MISC, "Interface\\Icons\\Ability_Druid_AquaticForm", 8, true, false)
	Soundtrack.CustomEvents.RegisterBuffEvent(SOUNDTRACK_DRUID_BEAR, ST_MISC, "Interface\\Icons\\Ability_Racial_BearForm", 8, true, false)
	Soundtrack.CustomEvents.RegisterBuffEvent(SOUNDTRACK_DRUID_TRAVEL, ST_MISC, "Interface\\Icons\\Ability_Druid_TravelForm", 8, true, false)
	Soundtrack.CustomEvents.RegisterBuffEvent(SOUNDTRACK_DRUID_FLIGHT, ST_MISC, "Interface\\Icons\\Ability_Druid_FlightForm", 8, true, false)

	Soundtrack.CustomEvents.RegisterUpdateScript(	-- Moonkin Form
	    self, SOUNDTRACK_DRUID_MOONKIN, ST_MISC, 8, true,
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
	    self, SOUNDTRACK_DRUID_TREE, ST_MISC, 8, true,
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
	
	Soundtrack.CustomEvents.RegisterBuffEvent(SOUNDTRACK_SHAMAN_GHOST_WOLF, ST_MISC, "Interface\\Icons\\Spell_Nature_SpiritWolf", 8, true, false)
	
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
	
	-- All arguments are for Combat events, which can take up to 20 args.
    if event == "AUCTION_HOUSE_SHOW" then
        Soundtrack.AuctionHouse = true
    elseif event == "AUCTION_HOUSE_CLOSED" then
        Soundtrack.AuctionHouse = false
    elseif event == "BANKFRAME_OPENED" then
        Soundtrack.Bank = true
    elseif event == "BANKFRAME_CLOSED" then
        Soundtrack.Bank = false
    elseif event == "MERCHANT_SHOW" then
        Soundtrack.Merchant = true
    elseif event == "MERCHANT_CLOSED" then
        Soundtrack.Merchant = false
	elseif event == "BARBERSHOP_SHOW" then
		Soundtrack.Barbershop = true
	elseif event == "BARBERSHOP_CLOSED" then
		Soundtrack.Barbershop = false
    elseif event == "CINEMATIC_START" then
		Soundtrack.Cinematic = true
	elseif event == "CINEMATIC_STOP" then
		Soundtrack.Cinematic = false
		
	
    -- Handle custom buff events
    elseif event == "UNIT_AURA" then 
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