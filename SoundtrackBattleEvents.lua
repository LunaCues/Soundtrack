--[[
    Soundtrack addon for World of Warcraft

    Battle events functions.
    Functions that manage battle situation changes.
]]

local ST_BATTLE = "Battle"
local ST_BOSS = "Boss"
local ST_ZONE = "Zone"
local ST_DANCE = "Dance"
local ST_MISC = "Misc"
local ST_CUSTOM = "Custom"
local ST_PLAYLISTS = "Playlists"

-- Classifications for mobs
local classifications = 
{
	"Critter",
    "normal",
    "rare",
    "elite",
    "rareelite",
    "worldboss",
}

-- Difficulties for mobs
local difficulties = 
{
    "Unknown", 	-- Attacked
    "1 Trivial", 	-- gray
    "2 Easy",	-- green
    "3 Normal", 	-- yellow
	"4 Tough",	-- orange
    "5 Impossible"	-- red
}

-- Battle event priority for mob types
local battleEvents = {
	SOUNDTRACK_UNKNOWN_BATTLE,

	SOUNDTRACK_CRITTER,
	
	SOUNDTRACK_NORMAL_MOB,
	SOUNDTRACK_NORMAL_MOB .."/1 Trivial", 	-- Gray
	SOUNDTRACK_NORMAL_MOB .."/2 Easy",	 	-- Green
	SOUNDTRACK_NORMAL_MOB .."/3 Normal",  	-- Yellow
	SOUNDTRACK_NORMAL_MOB .."/4 Tough",	 	-- Orange
	SOUNDTRACK_NORMAL_MOB .."/5 Impossible",	-- Red
	
	SOUNDTRACK_ELITE_MOB,
    SOUNDTRACK_ELITE_MOB .."/1 Trivial",		-- Gray
	SOUNDTRACK_ELITE_MOB .."/2 Easy",        -- Green
	SOUNDTRACK_ELITE_MOB .."/3 Normal",      -- Yellow
	SOUNDTRACK_ELITE_MOB .."/4 Tough",       -- Orange
	SOUNDTRACK_ELITE_MOB .."/5 Impossible",  -- Red
	
	SOUNDTRACK_RARE, 
	SOUNDTRACK_BOSS_BATTLE,
    SOUNDTRACK_WORLD_BOSS_BATTLE,
    SOUNDTRACK_PVP_BATTLE
}

-- Figures out mob difficulty from text
local function GetDifficultyFromText(difficultyText)
    -- TODO IndexOf
    for i,d in ipairs(difficulties) do
        if d == difficultyText then
            return i
        end
    end
    Soundtrack.TraceBattle("Cannot find difficulty : "..difficultyText)
    return 0
end

-- Returns a classification number. Used to compare classifications
local function GetClassificationLevel(classificationText)
    -- TODO IndexOf
    for i,c in ipairs(classifications) do
        if c == classificationText then
            return i
        end
    end
    Soundtrack.TraceBattle("Cannot find classification : "..classificationText)
    return 0
end

-- Gets difficulty text from difficulty level
local function GetDifficultyText(difficultyLevel)
    return difficulties[difficultyLevel]
end
-- Gets classification text from clasification level
local function GetClassificationText(classificationLevel)
    return classifications[classificationLevel]
end

-- Returns the difficulty of a target based on the level of the mob, compared
-- to the players level. (also known as the color of the mob).
local function GetDifficulty(target, targetLevel)
    local playerLevel = UnitLevel("player")
    if UnitIsTrivial(target) then 
        return GetDifficultyFromText("1 Trivial")
    elseif playerLevel <= targetLevel-5 then
        return GetDifficultyFromText("5 Impossible")
    elseif playerLevel == targetLevel-4 or playerLevel == targetLevel-3 then
        return GetDifficultyFromText("4 Tough")
    elseif playerLevel >= targetLevel-2 and playerLevel <= targetLevel+2 then
        return GetDifficultyFromText("3 Normal")    
    else
        return GetDifficultyFromText("2 Easy")
    end
end

local function SoundtrackBattle_BossHasTracks(eventName)
	if eventName == nil then
		return false
	end
	local eventTable = Soundtrack.Events.GetTable(ST_BOSS)
	if eventTable[eventName] then
		local trackList = eventTable[eventName].tracks
		if trackList then
			local numTracks = table.getn(trackList)
			if numTracks >= 1 then
				Soundtrack.TraceBattle(eventName.." has tracks.")
				return true
			end
		end
	end
	return false
end

-- Calculates the highest enemy level amongs all the party members and pet
-- targets. Thanks to Athame!
-- Returns classification, difficulty, pvpEnabled
function GetGroupEnemyLevel()

    local prefix
    local total
    if GetNumRaidMembers() > 0 then
        prefix = "raid"
        total = GetNumRaidMembers()
    else
        prefix = "party"
        total = GetNumPartyMembers()
    end
    
    -- add your party/raid members
    local units = {} 
    table.insert(units, "player") -- you
    if total > 0 then
        local index
        for index = 1, total do 
            table.insert(units, prefix..index) 
        end
    end
    
    -- add your party/raid pets
    if UnitExists("pet") then
        table.insert(units, "pet")
    end
    
    local index
    for index = 0, total do
        if UnitExists(prefix.."pet"..index) then 
            table.insert(units, prefix.."pet"..index) 
        end
    end
    
    local unit
    local highestlevel = 1
    local highestDifficulty = 1
    local highestClassification = 1
    local pvpEnabled = false
    
    local bossTable = nil
	local bossEventName = Soundtrack.Events.Stack[7].eventName
	local bossHasTracks = SoundtrackEvents_EventHasTracks(ST_BOSS, bossEventName)
	
	if bossEventName == nil or (bossEventName and not bossHasTracks) then
        bossTable = Soundtrack.Events.GetTable(ST_BOSS)
    end
    
    for index,unit in ipairs(units) do
        local target = unit .. "target"
        local unitExists = UnitExists(target)
        local unitIsEnemy = not UnitIsFriend("player", target)
        local unitIsAlive = not UnitIsDeadOrGhost(target)
        
        if unitExists and unitIsEnemy and unitIsAlive then
            
            if bossTable then
                local unitName = UnitName(target)
                local bossEvent = bossTable[unitName]
                if bossEvent then
					if SoundtrackEvents_EventHasTracks(ST_BOSS, unitName) then
						Soundtrack.PlayEvent(ST_BOSS, unitName)
					else
						Soundtrack.PlayEvent(ST_BATTLE, SOUNDTRACK_BOSS_BATTLE)
					end
				end
            end
            
            -- If we find at least one target, we set the minimum to trivial instead of unknown.
			-- 1.29: This would set it to Critter, so we'll leave as unknown
            --[[ if highestDifficulty == 1 then
                highestDifficulty = 3
            end	--]]
            
            -- Check for pvp
            if not pvpEnabled then
                pvpEnabled = UnitIsPlayer("target") and UnitCanAttack("player", "target")
            end
            
            -- Get the target level
            local targetlevel = UnitLevel(target)
            if targetlevel then
                if targetlevel == -1 then 
                    targetlevel = UnitLevel("player") + 10 -- at least 10 levels higher
                end
                if targetlevel > highestlevel then
                    highestlevel = targetlevel -- this unit has the highest living hostile target so far
                end
            end
            
            -- Get the target classification
			local unitClass = UnitCreatureType(target)
			if unitClass ~= "Critter" then
				unitClass = UnitClassification(target)
			end
            local classificationLevel = GetClassificationLevel(unitClass)
            if classificationLevel > highestClassification then
                highestClassification = classificationLevel
            end
            
			-- Get target difficulty
            difficultyLevel = GetDifficulty(target, targetlevel)
            if difficultyLevel > highestDifficulty then
                highestDifficulty = difficultyLevel
            end
        end
    end
    
    local classificationText = GetClassificationText(highestClassification)
    local difficultyText = GetDifficultyText(highestDifficulty)
    Soundtrack.TraceBattle("Mob detected: Difficulty: "..difficultyText..", Classification: "..classificationText)
    return classificationText, difficultyText, pvpEnabled
end


-- When the player is engaged in battle, this determines 
-- the type of battle.
local function GetBattleType()
    local classification, difficulty, pvpEnabled = GetGroupEnemyLevel()

    if pvpEnabled then
        return SOUNDTRACK_PVP_BATTLE
    else
		if difficulty == "Unknown" then
			return SOUNDTRACK_UNKNOWN_BATTLE
		end
        local eventName = classification
        if classification == "worldboss" then
            return SOUNDTRACK_WORLD_BOSS_BATTLE  -- "World Boss Battle"
        elseif classification == "rareelite" or
               classification == "rare" then
            return SOUNDTRACK_RARE  -- "Rare"
        elseif classification == "elite" then
			local EliteMobDifficulty = "Elite Mob/"..difficulty
			local eventTable = Soundtrack.Events.GetTable(ST_BATTLE)
			if table.getn(eventTable[EliteMobDifficulty].tracks) ~= 0 then
				return EliteMobDifficulty
			else
				return SOUNDTRACK_ELITE_MOB		-- "Elite Battle"
			end
        elseif classification == "normal" then
			local NormalMobDifficulty = "Normal Mob/"..difficulty
			local eventTable = Soundtrack.Events.GetTable(ST_BATTLE)
			if table.getn(eventTable[NormalMobDifficulty].tracks) ~= 0 then
				return NormalMobDifficulty
			else
				return SOUNDTRACK_NORMAL_MOB
			end
		elseif classification == "Critter" then
			return SOUNDTRACK_CRITTER
        end
    end
    
    return "InvalidBattle"
end

local victoryPlaying = false -- To differentiate between active battle because of victory or not.

local hostileDeathCount = 0
local currentBattleTypeIndex = 0 -- Used to determine battle priorities and escalations

local function StartVictoryMusic()
    Soundtrack.StopEventAtLevel(7)
    if hostileDeathCount > 0 then
        -- Attempt to start victory music
        Soundtrack.PlayEvent(ST_MISC, SOUNDTRACK_VICTORY)
		local victoryEvent = Soundtrack.GetEvent(ST_MISC, SOUNDTRACK_VICTORY)
		if victoryEvent.soundEffect == true then
			Soundtrack.TraceBattle("Victory = sound effect")
			Soundtrack.StopEventAtLevel(6)
		end
        hostileDeathCount = 0
    else
        Soundtrack.StopEvent(ST_MISC, SOUNDTRACK_VICTORY)
    end
end

local function StopCombatMusic()
    Soundtrack.TraceBattle("Stop Combat Music")
    currentBattleTypeIndex = 0 -- we are out of battle
    StartVictoryMusic()
end


local function IsPlayerReallyDead()
    local dead = UnitIsDeadOrGhost("player")
	
    local _,class = UnitClass("player")
    if class ~= "HUNTER" then
        return dead
    end
	
	local FDbuff = "Interface\\Icons\\Ability_Rogue_FeignDeath"
	if Soundtrack.IsBuffActive(FDbuff) then
		dead = nil
	end
	
    return dead
end

local function AnalyzeBattleSituation() 

    local battleType = GetBattleType()
    local battleTypeIndex = Soundtrack.IndexOf(battleEvents, battleType)
    -- If we're in cooldown, but a higher battle is already playing, keep that one, 
    -- otherwise we can escalate the battle music.
    --Soundtrack.TraceEvents("CurrentBattleTypeIndex: " .. currentBattleTypeIndex)
    --Soundtrack.TraceEvents("BattleTypeIndex: " .. battleTypeIndex)
    
    -- If we are out of combat, we play the battle event.
    -- If we are in combat, we only escalate if option is turned on
    if currentBattleTypeIndex == 0 or 
       (Soundtrack.Settings.EscalateBattleMusic and battleTypeIndex > currentBattleTypeIndex) then
        Soundtrack.PlayEvent(ST_BATTLE, battleType)
        currentBattleTypeIndex = battleTypeIndex
    end
end

-- True when a battle event is currently playing
Soundtrack.BattleEvents.Stealthed = false

function Soundtrack.BattleEvents.OnLoad(self)
    self:RegisterEvent("PLAYER_REGEN_DISABLED")
    self:RegisterEvent("PLAYER_REGEN_ENABLED")
    self:RegisterEvent("PLAYER_UNGHOST")
    self:RegisterEvent("PLAYER_ALIVE")
    self:RegisterEvent("PLAYER_DEAD")
    self:RegisterEvent("UNIT_AURA")
    self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	self:RegisterEvent("VARIABLES_LOADED")
end

local delayTime = 0
local updateTime = .2

function Soundtrack.BattleEvents.OnUpdate(self, elapsed)
	local currentTime = GetTime()
	
	if currentTime > delayTime then
		delayTime = currentTime + updateTime
		if currentBattleTypeIndex > 0 then
			AnalyzeBattleSituation()
		end
	end
end
    
 function Soundtrack.BattleEvents.OnEvent(self, event, ...)
	arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13, arg14, arg15, arg16, arg17, arg18, arg19, arg20 = select(1, ...)
	
	if event == "VARIABLES_LOADED" then
        Soundtrack.BattleEvents.Initialize(self)
    end
	
	Soundtrack.TraceBattle(event)
	
    if event == "PLAYER_REGEN_DISABLED" then
        if not Soundtrack.Settings.EnableBattleMusic then
            return
        end

        -- If we re-enter combat after cooldown, clear timers.
        Soundtrack.Timers.Remove("BattleCooldown")
        AnalyzeBattleSituation()
    elseif event == "PLAYER_REGEN_ENABLED" and 
           not UnitIsCorpse("player") and 
           not UnitIsDead("player") then
        if Soundtrack.Settings.BattleCooldown > 0 then
            Soundtrack.Timers.AddTimer("BattleCooldown", Soundtrack.Settings.BattleCooldown, StopCombatMusic)
        else
            StopCombatMusic()            
        end
    elseif event == "COMBAT_LOG_EVENT_UNFILTERED" then
		if arg2 == "PARTY_KILL" then
			hostileDeathCount = hostileDeathCount + 1
			Soundtrack.TraceBattle("Death count: "..hostileDeathCount)
		else
			if Soundtrack.Settings.EnableMiscMusic then
				for k,v in pairs(Soundtrack_BattleEvents) do
					RunScript(v.script)
					v.script()
				end
			end
		end
    elseif event == "PLAYER_UNGHOST" then
        Soundtrack.StopEvent(ST_MISC, SOUNDTRACK_GHOST)
    elseif event == "PLAYER_ALIVE" then
        Soundtrack.TraceBattle("PLAYER_ALIVE")
        if UnitIsDeadOrGhost("player") then
            Soundtrack.PlayEvent(ST_MISC, SOUNDTRACK_GHOST)
			currentBattleTypeIndex = 0
        else
            Soundtrack.StopEvent(ST_MISC, SOUNDTRACK_GHOST)
        end
    elseif event == "UNIT_AURA" then
        if UnitIsFeignDeath("player") then
            -- Stop the battle music
            Soundtrack.TraceBattle("Feign death: Stopping battle music")
            Soundtrack.StopEventAtLevel(6)
            Soundtrack.StopEventAtLevel(7)
        end
    elseif event == "PLAYER_DEAD" then
        Soundtrack.TraceBattle("PLAYER_DEAD")
        if IsPlayerReallyDead() then
			Soundtrack.StopEventAtLevel(6)
			Soundtrack.StopEventAtLevel(7)
            Soundtrack.PlayEvent(ST_MISC, SOUNDTRACK_DEATH)
        end
		currentBattleTypeIndex = 0 -- out of combat
    end
end

function Soundtrack.BattleEvents.RegisterEventScript(self, name, tableName, _trigger, _priority, _continuous, _script, _soundEffect)
    Soundtrack_MiscEvents[name] = { trigger = _trigger, script = _script, eventtype = "Event Script", priority=_priority, continuous=_continuous, soundEffect=_soundEffect };
	Soundtrack_BattleEvents[name] = {script = _script}
	
    self:RegisterEvent(_trigger);
    
    Soundtrack.AddEvent(tableName, name, _priority, _continuous, _soundEffect)
end


function Soundtrack.BattleEvents.Initialize(self)
    Soundtrack.AddEvent(ST_BATTLE, SOUNDTRACK_UNKNOWN_BATTLE, 6, true)

	Soundtrack.AddEvent(ST_BATTLE, SOUNDTRACK_CRITTER, 6, true)
	
	Soundtrack.AddEvent(ST_BATTLE, SOUNDTRACK_NORMAL_MOB, 6, true)
	Soundtrack.AddEvent(ST_BATTLE, SOUNDTRACK_NORMAL_MOB .."/1 Trivial", 6, true)
	Soundtrack.AddEvent(ST_BATTLE, SOUNDTRACK_NORMAL_MOB .."/2 Easy", 6, true)
	Soundtrack.AddEvent(ST_BATTLE, SOUNDTRACK_NORMAL_MOB .."/3 Normal", 6, true)
	Soundtrack.AddEvent(ST_BATTLE, SOUNDTRACK_NORMAL_MOB .."/4 Tough", 6, true)
	Soundtrack.AddEvent(ST_BATTLE, SOUNDTRACK_NORMAL_MOB .."/5 Impossible", 6, true)
	
	Soundtrack.AddEvent(ST_BATTLE, SOUNDTRACK_ELITE_MOB, 6, true)
    Soundtrack.AddEvent(ST_BATTLE, SOUNDTRACK_ELITE_MOB .."/1 Trivial", 6, true)
	Soundtrack.AddEvent(ST_BATTLE, SOUNDTRACK_ELITE_MOB .."/2 Easy", 6, true)
	Soundtrack.AddEvent(ST_BATTLE, SOUNDTRACK_ELITE_MOB .."/3 Normal", 6, true)
	Soundtrack.AddEvent(ST_BATTLE, SOUNDTRACK_ELITE_MOB .."/4 Tough", 6, true)
	Soundtrack.AddEvent(ST_BATTLE, SOUNDTRACK_ELITE_MOB .."/5 Impossible", 6, true)
	
	Soundtrack.AddEvent(ST_BATTLE, SOUNDTRACK_BOSS_BATTLE, 6, true)
    Soundtrack.AddEvent(ST_BATTLE, SOUNDTRACK_WORLD_BOSS_BATTLE, 6, true)
    Soundtrack.AddEvent(ST_BATTLE, SOUNDTRACK_PVP_BATTLE, 6, true)

	Soundtrack.AddEvent(ST_BATTLE, SOUNDTRACK_RARE, 6, true)
	
    Soundtrack.AddEvent(ST_MISC, SOUNDTRACK_VICTORY, 6, false, true)
    Soundtrack.AddEvent(ST_MISC, SOUNDTRACK_DEATH, 6, true, false)
    Soundtrack.AddEvent(ST_MISC, SOUNDTRACK_GHOST, 6, true, false)
	
	
	--[[
	==========================================================
		MISC EVENTS with COMBAT_LOG_EVENT_UNFILTERED event
		
		This allows them to register with the same frame
			so that only one frame handles all
			COMBAT_LOG_EVENT_UNFILTERED events
	==========================================================
	--]]
	
	Soundtrack.BattleEvents.RegisterEventScript(	-- Swing Crit
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
	Soundtrack.BattleEvents.RegisterEventScript(	-- Swing
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

	Soundtrack.BattleEvents.RegisterEventScript(	-- Damage Spells Crit
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
	Soundtrack.BattleEvents.RegisterEventScript(	-- Damage Spells
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
	
	Soundtrack.BattleEvents.RegisterEventScript(	-- DoTs Crit
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
	Soundtrack.BattleEvents.RegisterEventScript(	-- DoTs
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
	
	Soundtrack.BattleEvents.RegisterEventScript(	-- Healing Spells Crit
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
	Soundtrack.BattleEvents.RegisterEventScript(	-- Healing Spells
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
    
	Soundtrack.BattleEvents.RegisterEventScript(	-- HoTs Crit
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
	Soundtrack.BattleEvents.RegisterEventScript(	-- HoTs
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
    
	Soundtrack.BattleEvents.RegisterEventScript(	-- Range Crit
		self,
	    SOUNDTRACK_RANGE_CRIT,
	    ST_MISC,
	    "COMBAT_LOG_EVENT_UNFILTERED",
	    8,
	    false,
	    function()
	        if arg2 == "RANGE_DAMAGE" and arg4 == UnitName("player") and arg18 == 1 then
				Soundtrack_Custom_PlayEvent(ST_MISC, SOUNDTRACK_RANGE_CRIT)
			end
	    end,
		true
	);
	Soundtrack.BattleEvents.RegisterEventScript(	-- Range
		self,
	    SOUNDTRACK_RANGE_HIT,
	    ST_MISC,
	    "COMBAT_LOG_EVENT_UNFILTERED",
	    8,
	    false,
	    function()
	        if arg2 == "RANGE_DAMAGE" and arg4 == UnitName("player") then
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
	

end