--[[
    Soundtrack addon for World of Warcraft

    Battle events functions.
    Functions that manage battle situation changes.
]]

local arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13, arg14, arg15, arg16, arg17, arg18, arg19, arg20, arg21

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
	SOUNDTRACK_ELITE_MOB,
	SOUNDTRACK_NORMAL_MOB .."/1 Trivial", 	-- Gray
    SOUNDTRACK_ELITE_MOB .."/1 Trivial",	-- Gray
	SOUNDTRACK_NORMAL_MOB .."/2 Easy",	 	-- Green
	SOUNDTRACK_ELITE_MOB .."/2 Easy",       -- Green
	SOUNDTRACK_NORMAL_MOB .."/3 Normal",  	-- Yellow
	SOUNDTRACK_ELITE_MOB .."/3 Normal",     -- Yellow
	SOUNDTRACK_NORMAL_MOB .."/4 Tough",	 	-- Orange
	SOUNDTRACK_ELITE_MOB .."/4 Tough",      -- Orange
	SOUNDTRACK_NORMAL_MOB .."/5 Impossible",-- Red
	SOUNDTRACK_ELITE_MOB .."/5 Impossible", -- Red
	
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

-- Returns the difficulty of a target based on the level of the mob, 
-- compared to the players level. (also known as the color of the mob).
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
				return true
			end
		end
	end
	return false
end

local function SoundtrackBattle_BattleHasTracks(eventName)
	if eventName == nil then
		return false
	end
	local eventTable = Soundtrack.Events.GetTable(ST_BATTLE)
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

local function SoundtrackBattle_MiscHasTracks(eventName)
	if eventName == nil then
		return false
	end
	local eventTable = Soundtrack.Events.GetTable(ST_MISC)
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
    
    -- create table of units
    local units = {} 
	
	-- add you!
    table.insert(units, "player")
    
	-- add your party/raid members
	if not Soundtrack.Settings.YourEnemyLevelOnly then
		if total > 0 then
			local index
			for index = 1, total do 
				table.insert(units, prefix..index) 
			end
		end
	end
    
    -- add your pet
    if UnitExists("pet") then
        table.insert(units, "pet")
    end
    
    -- add your party/raid pets
	if not Soundtrack.Settings.YourEnemyLevelOnly then
		local index
		for index = 0, total do
			if UnitExists(prefix.."pet"..index) then 
				table.insert(units, prefix.."pet"..index) 
			end
		end
	end
    
    local unit
    local highestlevel = 1
    local highestDifficulty = 1
    local highestClassification = 1
    local pvpEnabled = false
	local isBoss = false
	local bossName = nil
	local hasLowHealth = false
    
    local bossTable = nil
	local bossEventName = Soundtrack.Events.Stack[ST_BOSS_LVL].eventName
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
            local unitName = UnitName(target)
			local bossEvent = bossTable[unitName]
			local unitHealthPercent = UnitHealth(target)/UnitHealthMax(target)
			local unitIsPlayer = UnitIsPlayer(target)
			local unitCanAttack = UnitCanAttack("player", target)
			local targetlevel = UnitLevel(target)
			local unitIsCritter = UnitCreatureType(target)
			local unitClass = UnitClassification(target)
            local classificationLevel = GetClassificationLevel(unitClass)
            local difficultyLevel = GetDifficulty(target, targetlevel)
			
			
            -- Check for pvp
            if not pvpEnabled then
                pvpEnabled = unitIsPlayer and unitCanAttack
            end
            
            -- Get the target level
            if targetlevel then
                if targetlevel == -1 then 
                    targetlevel = UnitLevel("player") + 10 -- at least 10 levels higher
                end
                if targetlevel > highestlevel then
                    highestlevel = targetlevel -- this unit has the highest living hostile target so far
                end
            end
            
            -- Get the target classification
			if unitIsCritter ~= "Critter" then
				if unitClass == "worldboss" and unitHealthPercent < Soundtrack.Settings.LowHealthPercent then
					hasLowHealth = true
				end
			else
				unitClass = unitIsCritter
			end
			
            if classificationLevel > highestClassification then
                highestClassification = classificationLevel
            end
            
			-- Get target difficulty
            if difficultyLevel > highestDifficulty then
                highestDifficulty = difficultyLevel
            end
			
			-- Check if in the boss table
            if bossTable then
                if bossEvent then
					Soundtrack.TraceBattle(unitName.." is a boss.")
					isBoss = true
					if SoundtrackEvents_EventHasTracks(ST_BOSS, unitName) then
						bossName = unitName
					end
					if unitHealthPercent < Soundtrack.Settings.LowHealthPercent then
						hasLowHealth = true
					end
					if bossEvent.worldboss then
						unitClass = "worldboss"
					end
				end
            end
        end
    end
    
    local classificationText = GetClassificationText(highestClassification)
    local difficultyText = GetDifficultyText(highestDifficulty)
    Soundtrack.TraceBattle("Difficulty: "..difficultyText..", "..highestClassification.." "..classificationText)
    return classificationText, difficultyText, pvpEnabled, isBoss, bossName, hasLowHealth
end


-- When the player is engaged in battle, this determines 
-- the type of battle.
local function GetBattleType()
    local classification, difficulty, pvpEnabled, isBoss, bossName, hasLowHealth = GetGroupEnemyLevel()

    if pvpEnabled then
        return SOUNDTRACK_PVP_BATTLE
    else
		if difficulty == "Unknown" then
			return SOUNDTRACK_UNKNOWN_BATTLE
		end
        local eventName = classification
		if isBoss and classification ~= "worldboss" then
			return SOUNDTRACK_BOSS_BATTLE, bossName, hasLowHealth
        elseif classification == "worldboss" then
			return SOUNDTRACK_WORLD_BOSS_BATTLE, bossName, hasLowHealth  -- "World Boss Battle"
        elseif classification == "rareelite" or
               classification == "rare" then
            return SOUNDTRACK_RARE  -- "Rare"
        elseif classification == "elite" then
			local EliteMobDifficulty = SOUNDTRACK_ELITE_MOB.."/"..difficulty
			local eventTable = Soundtrack.Events.GetTable(ST_BATTLE)
			if #(eventTable[EliteMobDifficulty].tracks) ~= 0 then
				return EliteMobDifficulty
			else
				return SOUNDTRACK_ELITE_MOB		-- "Elite Battle"
			end
        elseif classification == "normal" then
			local NormalMobDifficulty = SOUNDTRACK_NORMAL_MOB.."/"..difficulty
			local eventTable = Soundtrack.Events.GetTable(ST_BATTLE)
			if #(eventTable[NormalMobDifficulty].tracks) ~= 0 then
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
    if hostileDeathCount > 0 then
		local battleEventName = Soundtrack.Events.Stack[ST_BATTLE_LVL].eventName
		local bossEventName = Soundtrack.Events.Stack[ST_BOSS_LVL].eventName
		if bossEventName ~= nil then
			local victoryEvent = Soundtrack.GetEvent(ST_MISC, SOUNDTRACK_VICTORY_BOSS)
			if victoryEvent.soundEffect == true then
				Soundtrack.PlayEvent(ST_MISC, SOUNDTRACK_VICTORY_BOSS)
				Soundtrack.StopEventAtLevel(ST_BATTLE_LVL)
				Soundtrack.StopEventAtLevel(ST_BOSS_LVL)
			else
				Soundtrack.StopEventAtLevel(ST_BATTLE_LVL)
				Soundtrack.StopEventAtLevel(ST_BOSS_LVL)
				Soundtrack.PlayEvent(ST_MISC, SOUNDTRACK_VICTORY_BOSS)
			end
		elseif battleEventName ~= SOUNDTRACK_CRITTER and battleEventName ~= SOUNDTRACK_UNKNOWN_BATTLE then
			local victoryEvent = Soundtrack.GetEvent(ST_MISC, SOUNDTRACK_VICTORY)
			if victoryEvent.soundEffect == true then
				Soundtrack.PlayEvent(ST_MISC, SOUNDTRACK_VICTORY)
				Soundtrack.StopEventAtLevel(ST_BATTLE_LVL)
				Soundtrack.StopEventAtLevel(ST_BOSS_LVL)
			else
				Soundtrack.StopEventAtLevel(ST_BATTLE_LVL)
				Soundtrack.StopEventAtLevel(ST_BOSS_LVL)
				Soundtrack.PlayEvent(ST_MISC, SOUNDTRACK_VICTORY)
			end
		else
			Soundtrack.StopEventAtLevel(ST_BATTLE_LVL)
			Soundtrack.StopEventAtLevel(ST_BOSS_LVL)
		end
	else
		Soundtrack.StopEventAtLevel(ST_BATTLE_LVL)
		Soundtrack.StopEventAtLevel(ST_BOSS_LVL)
	end
	hostileDeathCount = 0
end

local function StopCombatMusic()
    Soundtrack.TraceBattle("Stop Combat Music")
    StartVictoryMusic()
    currentBattleTypeIndex = 0 -- we are out of battle
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
    local battleType, bossName, hasLowHealth = GetBattleType()
    local battleTypeIndex = Soundtrack.IndexOf(battleEvents, battleType)
    -- If we're in cooldown, but a higher battle is already playing, keep that one, 
    -- otherwise we can escalate the battle music.
    Soundtrack.TraceBattle("CurrentBattleTypeIndex: "..currentBattleTypeIndex.."  BattleType: "..battleType)
    if Soundtrack.Settings.EscalateBattleMusic then Soundtrack.TraceBattle("EscalateBattleMusic enabled") end
	
    -- If we are out of combat, we play the battle event.
    -- If we are in combat, we only escalate if option is turned on
    if currentBattleTypeIndex == 0 or battleType == SOUNDTRACK_BOSS_BATTLE or
		(Soundtrack.Settings.EscalateBattleMusic and battleTypeIndex > currentBattleTypeIndex) then
		if battleType == SOUNDTRACK_BOSS_BATTLE or battleType == SOUNDTRACK_WORLD_BOSS then
			if hasLowHealth and SoundtrackBattle_BattleHasTracks(SOUNDTRACK_BOSS_LOW_HEALTH) then 
				Soundtrack.PlayEvent(ST_BATTLE, SOUNDTRACK_BOSS_LOW_HEALTH) 
			elseif bossName ~= nil then
				Soundtrack.PlayEvent(ST_BOSS, bossName)
			else
				Soundtrack.PlayEvent(ST_BATTLE, battleType)
			end
		else
			Soundtrack.PlayEvent(ST_BATTLE, battleType)
		end
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
    --self:RegisterEvent("UNIT_AURA")  -- Used for FeignDeath check
    self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	self:RegisterEvent("ZONE_CHANGED_NEW_AREA")
	self:RegisterEvent("VARIABLES_LOADED")
end

local delayTime = 0
local updateTime = .2

function Soundtrack.BattleEvents.OnUpdate(self, elapsed)
	local currentTime = GetTime()
	
	-- Feign death moved here to remove UNIT_AURA event
	-- if UnitIsFeignDeath("player") then	-- UnitIsFeignDeath broken?
	--[[
	if UnitAura("player", "Feign Death") == "Feign Death" then
        -- Stop the battle music
        Soundtrack.TraceBattle("Feign death: Stopping battle music")
        Soundtrack.StopEventAtLevel(6)
        Soundtrack.StopEventAtLevel(7)
    end
	--]]
	
	
	if currentBattleTypeIndex > 0 then
		if currentTime > delayTime then
			delayTime = currentTime + updateTime
			AnalyzeBattleSituation()
		end
	end
end
    
function Soundtrack.BattleEvents.OnEvent(self, event, ...)
	arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13, arg14, arg15, arg16, arg17, arg18, arg19, arg20, arg21 = select(1, ...)
	
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
    --[[
	elseif event == "UNIT_AURA" then
        if UnitIsFeignDeath("player") then
            -- Stop the battle music
            Soundtrack.TraceBattle("Feign death: Stopping battle music")
            Soundtrack.StopEventAtLevel(6)
            Soundtrack.StopEventAtLevel(7)
        end
	--]]
    elseif event == "PLAYER_DEAD" then
        Soundtrack.TraceBattle("PLAYER_DEAD")
        if IsPlayerReallyDead() then
			Soundtrack.StopEventAtLevel(ST_BATTLE_LVL)
			Soundtrack.StopEventAtLevel(ST_BOSS_LVL)
            Soundtrack.PlayEvent(ST_MISC, SOUNDTRACK_DEATH)
        end
		currentBattleTypeIndex = 0 -- out of combat
    elseif event == "ZONE_CHANGED_NEW_AREA" then
		Soundtrack.TraceBattle("ZONE_CHANGED_NEW_AREA")
		local inInstance, instanceType = IsInInstance();
		if inInstance and (instanceType == "party" or instanceType == "raid") then
			local _, _, encountersTotal, _ = GetInstanceLockTimeRemaining()
			for i=1, encountersTotal, 1 do
				local bossName, _, _ = GetInstanceLockTimeRemainingEncounter(i)
				Soundtrack.AddEvent(ST_BOSS, bossName, ST_BOSS_LVL, true)
				local bossTable = Soundtrack.Events.GetTable(ST_BOSS)
				local bossEvent = bossTable[bossName]
				if instanceType == "raid" then
					bossEvent.worldboss = true
				end
			end
		end
	end 
end

function Soundtrack.BattleEvents.RegisterEventScript(self, name, tableName, _trigger, _priority, _continuous, _script, _soundEffect)
    Soundtrack_MiscEvents[name] = { trigger = _trigger, script = _script, eventtype = "Event Script", priority=_priority, continuous=_continuous, soundEffect=_soundEffect };
	Soundtrack_BattleEvents[name] = {script = _script}
	
    self:RegisterEvent(_trigger);
    
    Soundtrack.AddEvent(tableName, name, _priority, _continuous, _soundEffect)
end


function Soundtrack.BattleEvents.Initialize(self)
    Soundtrack.AddEvent(ST_BATTLE, SOUNDTRACK_UNKNOWN_BATTLE, ST_BATTLE_LVL, true)

	Soundtrack.AddEvent(ST_BATTLE, SOUNDTRACK_CRITTER, ST_BATTLE_LVL, true)
	
	Soundtrack.AddEvent(ST_BATTLE, SOUNDTRACK_NORMAL_MOB, ST_BATTLE_LVL, true)
	Soundtrack.AddEvent(ST_BATTLE, SOUNDTRACK_NORMAL_MOB .."/1 Trivial", ST_BATTLE_LVL, true)
	Soundtrack.AddEvent(ST_BATTLE, SOUNDTRACK_NORMAL_MOB .."/2 Easy", ST_BATTLE_LVL, true)
	Soundtrack.AddEvent(ST_BATTLE, SOUNDTRACK_NORMAL_MOB .."/3 Normal", ST_BATTLE_LVL, true)
	Soundtrack.AddEvent(ST_BATTLE, SOUNDTRACK_NORMAL_MOB .."/4 Tough", ST_BATTLE_LVL, true)
	Soundtrack.AddEvent(ST_BATTLE, SOUNDTRACK_NORMAL_MOB .."/5 Impossible", ST_BATTLE_LVL, true)
	
	Soundtrack.AddEvent(ST_BATTLE, SOUNDTRACK_ELITE_MOB, ST_BATTLE_LVL, true)
    Soundtrack.AddEvent(ST_BATTLE, SOUNDTRACK_ELITE_MOB .."/1 Trivial", ST_BATTLE_LVL, true)
	Soundtrack.AddEvent(ST_BATTLE, SOUNDTRACK_ELITE_MOB .."/2 Easy", ST_BATTLE_LVL, true)
	Soundtrack.AddEvent(ST_BATTLE, SOUNDTRACK_ELITE_MOB .."/3 Normal", ST_BATTLE_LVL, true)
	Soundtrack.AddEvent(ST_BATTLE, SOUNDTRACK_ELITE_MOB .."/4 Tough", ST_BATTLE_LVL, true)
	Soundtrack.AddEvent(ST_BATTLE, SOUNDTRACK_ELITE_MOB .."/5 Impossible", ST_BATTLE_LVL, true)
	
	Soundtrack.AddEvent(ST_BATTLE, SOUNDTRACK_BOSS_BATTLE, ST_BOSS_LVL, true)
	Soundtrack.AddEvent(ST_BATTLE, SOUNDTRACK_BOSS_LOW_HEALTH, ST_BOSS_LVL, true)
    Soundtrack.AddEvent(ST_BATTLE, SOUNDTRACK_WORLD_BOSS_BATTLE, ST_BOSS_LVL, true)
    Soundtrack.AddEvent(ST_BATTLE, SOUNDTRACK_PVP_BATTLE, ST_BOSS_LVL, true)
	
	Soundtrack.AddEvent(ST_BATTLE, SOUNDTRACK_RARE, ST_BOSS_LVL, true)
	
    Soundtrack.AddEvent(ST_MISC, SOUNDTRACK_VICTORY, ST_BATTLE_LVL, false, true)
	Soundtrack.AddEvent(ST_MISC, SOUNDTRACK_VICTORY_BOSS, ST_BOSS_LVL, false, true)
    Soundtrack.AddEvent(ST_MISC, SOUNDTRACK_DEATH, ST_DEATH_LVL, true, false)
    Soundtrack.AddEvent(ST_MISC, SOUNDTRACK_GHOST, ST_DEATH_LVL, true, false)
	
	
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
	    ST_SFX_LVL,
	    false,
	    function()
	        if arg2 == "SWING_DAMAGE" and arg5 == UnitName("player") and arg16 == 1 then
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
	    ST_SFX_LVL,
	    false,
	    function()
	        if arg2 == "SWING_DAMAGE" and arg5 == UnitName("player") then	
				if arg16 == nil then
					Soundtrack_Custom_PlayEvent(ST_MISC, SOUNDTRACK_SWING_HIT)
				elseif arg16 == 1 and SoundtrackBattle_MiscHasTracks(SOUNDTRACK_SWING_CRIT) == false then
					Soundtrack_Custom_PlayEvent(ST_MISC, SOUNDTRACK_SWING_HIT)
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
	    ST_SFX_LVL,
	    false,
	    function()
	        if arg2 == "SPELL_DAMAGE" and arg5 == UnitName("player") and arg19 == 1 then
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
	    ST_SFX_LVL,
	    false,
	    function()
	        if arg2 == "SPELL_DAMAGE" and arg5 == UnitName("player") then
				if arg19 == nil then
					Soundtrack_Custom_PlayEvent(ST_MISC, SOUNDTRACK_SPELL_HIT)
				elseif arg19 == 1 and SoundtrackBattle_MiscHasTracks(SOUNDTRACK_SPELL_CRIT) == false then
					Soundtrack_Custom_PlayEvent(ST_MISC, SOUNDTRACK_SPELL_HIT)
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
	    ST_SFX_LVL,
	    false,
	    function()
	        if arg2 == "SPELL_PERIODIC_DAMAGE" and arg5 == UnitName("player") and arg19 == 1 then
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
	    ST_SFX_LVL,
	    false,
	    function()
	        if arg2 == "SPELL_PERIODIC_DAMAGE" and arg5 == UnitName("player") then
				if arg19 == nil then
					Soundtrack_Custom_PlayEvent(ST_MISC, SOUNDTRACK_DOT_HIT)
				elseif arg19 == 1 and SoundtrackBattle_MiscHasTracks(SOUNDTRACK_DOT_CRIT) == false then
					Soundtrack_Custom_PlayEvent(ST_MISC, SOUNDTRACK_DOT_HIT)
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
	    ST_SFX_LVL,
	    false,
	    function()
	        if arg2 == "SPELL_HEAL" and arg5 == UnitName("player") and arg16 == 1 then 
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
	    ST_SFX_LVL,
	    false,
	    function()
	        if arg2 == "SPELL_HEAL" and arg5 == UnitName("player") then 
				if arg16 == nil then 
					Soundtrack_Custom_PlayEvent(ST_MISC, SOUNDTRACK_HEAL_HIT)
				elseif arg16 == 1 and SoundtrackBattle_MiscHasTracks(SOUNDTRACK_HEAL_CRIT) == false then
					Soundtrack_Custom_PlayEvent(ST_MISC, SOUNDTRACK_HEAL_HIT)
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
	    ST_SFX_LVL,
	    false,
	    function()
	        if arg2 == "SPELL_PERIODIC_HEAL" and arg5 == UnitName("player") and arg16 == 1 then 
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
	    ST_SFX_LVL,
	    false,
	    function()
	        if arg2 == "SPELL_PERIODIC_HEAL" and arg5 == UnitName("player") then 
				if arg16 == nil then 
					Soundtrack_Custom_PlayEvent(ST_MISC, SOUNDTRACK_HOT_HIT)
				elseif arg16 == 1 and SoundtrackBattle_MiscHasTracks(SOUNDTRACK_HOT_CRIT) == false then
					Soundtrack_Custom_PlayEvent(ST_MISC, SOUNDTRACK_HOT_HIT)
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
	    ST_SFX_LVL,
	    false,
	    function()
	        if arg2 == "RANGE_DAMAGE" and arg5 == UnitName("player") and arg19 == 1 then
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
	    ST_SFX_LVL,
	    false,
	    function()
	        if arg2 == "RANGE_DAMAGE" and arg5 == UnitName("player") then
				if arg19 == nil then
					Soundtrack_Custom_PlayEvent(ST_MISC, SOUNDTRACK_RANGE_HIT)
				elseif arg19 == 1 and SoundtrackBattle_MiscHasTracks(SOUNDTRACK_RANGE_CRIT) == false then
					Soundtrack_Custom_PlayEvent(ST_MISC, SOUNDTRACK_RANGE_HIT)
				end
			end
	    end,
		true
	);
	

end