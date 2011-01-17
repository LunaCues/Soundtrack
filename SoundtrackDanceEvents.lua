--[[
    Soundtrack addon for World of Warcraft

    Dance events functions.
]]

local ST_BATTLE = "Battle"
local ST_BOSS = "Boss"
local ST_ZONE = "Zone"
local ST_DANCE = "Dance"
local ST_MISC = "Misc"
local ST_CUSTOM = "Custom"
local ST_PLAYLISTS = "Playlists"

local function debugDance(msg)
    Soundtrack.Util.DebugPrint(msg, 0.0, 1.0, 1.0)
end

function Soundtrack.DanceEvents.OnLoad(self)
    self:RegisterEvent("CHAT_MSG_TEXT_EMOTE")
end

hooksecurefunc("JumpOrAscendStart",
	function()	
		Soundtrack.StopEventAtLevel(5)
	end
);


function Soundtrack.DanceEvents.OnEvent(self, event, ...)
	local arg1, arg2 = ...
    
	if not Soundtrack.Settings.EnableMiscMusic then
        return
    end
    
    if event == "CHAT_MSG_TEXT_EMOTE" then
        for i,emote in ipairs(SOUNDTRACK_DANCE_EMOTES) do
            if string.find(arg1, emote) then
                -- Check if the dance is initated by the player
                if UnitName("player") == arg2 then
                    local raceName = UnitRace("player")
                    local sex = UnitSex("player")
                    if sex == 2 then 
                        Soundtrack.PlayEvent(ST_DANCE, raceName .. " male")
                    elseif sex == 3 then
                        Soundtrack.PlayEvent(ST_DANCE, raceName .. " female")
                    end
                end
                break
            end
        end
    end
end


function Soundtrack.DanceEvents.Initialize()
    Soundtrack.AddEvent(ST_DANCE, "Human male", 5, false)
    Soundtrack.AddEvent(ST_DANCE, "Human male", 5, false)
    Soundtrack.AddEvent(ST_DANCE, "Human female", 5, false)
    Soundtrack.AddEvent(ST_DANCE, "Dwarf male", 5, false)
    Soundtrack.AddEvent(ST_DANCE, "Dwarf female", 5, false)
    Soundtrack.AddEvent(ST_DANCE, "Gnome male", 5, false)
    Soundtrack.AddEvent(ST_DANCE, "Gnome female", 5, false)
    Soundtrack.AddEvent(ST_DANCE, "Night Elf male", 5, false)
    Soundtrack.AddEvent(ST_DANCE, "Night Elf female", 5, false)
    Soundtrack.AddEvent(ST_DANCE, "Undead male", 5, false)
    Soundtrack.AddEvent(ST_DANCE, "Undead female", 5, false)
    Soundtrack.AddEvent(ST_DANCE, "Orc male", 5, false)
    Soundtrack.AddEvent(ST_DANCE, "Orc female", 5, false)
    Soundtrack.AddEvent(ST_DANCE, "Tauren male", 5, false)
    Soundtrack.AddEvent(ST_DANCE, "Tauren female", 5, false)
    Soundtrack.AddEvent(ST_DANCE, "Troll male", 5, false)
    Soundtrack.AddEvent(ST_DANCE, "Troll female", 5, false)
    Soundtrack.AddEvent(ST_DANCE, "Blood Elf male", 5, false)
    Soundtrack.AddEvent(ST_DANCE, "Blood Elf female", 5, false)
    Soundtrack.AddEvent(ST_DANCE, "Draenei male", 5, false)
    Soundtrack.AddEvent(ST_DANCE, "Draenei female", 5, false)
	Soundtrack.AddEvent(ST_DANCE, "Worgen male", 5, false)
	Soundtrack.AddEvent(ST_DANCE, "Worgen female", 5, false)
	Soundtrack.AddEvent(ST_DANCE, "Goblin male", 5, false)
	Soundtrack.AddEvent(ST_DANCE, "Goblin female", 5, false)
end