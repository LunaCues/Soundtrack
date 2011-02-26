--[[
    Soundtrack addon for World of Warcraft

    Dance events functions.
]]

local function debugDance(msg)
    Soundtrack.Util.DebugPrint(msg, 0.0, 1.0, 1.0)
end

function Soundtrack.DanceEvents.OnLoad(self)
    self:RegisterEvent("CHAT_MSG_TEXT_EMOTE")
	self:RegisterEvent("VARIABLES_LOADED")
end


function Soundtrack.DanceEvents.OnEvent(self, event, ...)
	local arg1, arg2 = ...
    
	if event == "VARIABLES_LOADED" then
		Soundtrack.DanceEvents.Initialize()
    end
	
	Soundtrack.TraceCustom(event)
	
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
    Soundtrack.AddEvent(ST_DANCE, "Human male", ST_ONCE_LVL, false)
    Soundtrack.AddEvent(ST_DANCE, "Human male", ST_ONCE_LVL, false)
    Soundtrack.AddEvent(ST_DANCE, "Human female", ST_ONCE_LVL, false)
    Soundtrack.AddEvent(ST_DANCE, "Dwarf male", ST_ONCE_LVL, false)
    Soundtrack.AddEvent(ST_DANCE, "Dwarf female", ST_ONCE_LVL, false)
    Soundtrack.AddEvent(ST_DANCE, "Gnome male", ST_ONCE_LVL, false)
    Soundtrack.AddEvent(ST_DANCE, "Gnome female", ST_ONCE_LVL, false)
    Soundtrack.AddEvent(ST_DANCE, "Night Elf male", ST_ONCE_LVL, false)
    Soundtrack.AddEvent(ST_DANCE, "Night Elf female", ST_ONCE_LVL, false)
    Soundtrack.AddEvent(ST_DANCE, "Undead male", ST_ONCE_LVL, false)
    Soundtrack.AddEvent(ST_DANCE, "Undead female", ST_ONCE_LVL, false)
    Soundtrack.AddEvent(ST_DANCE, "Orc male", ST_ONCE_LVL, false)
    Soundtrack.AddEvent(ST_DANCE, "Orc female", ST_ONCE_LVL, false)
    Soundtrack.AddEvent(ST_DANCE, "Tauren male", ST_ONCE_LVL, false)
    Soundtrack.AddEvent(ST_DANCE, "Tauren female", ST_ONCE_LVL, false)
    Soundtrack.AddEvent(ST_DANCE, "Troll male", ST_ONCE_LVL, false)
    Soundtrack.AddEvent(ST_DANCE, "Troll female", ST_ONCE_LVL, false)
    Soundtrack.AddEvent(ST_DANCE, "Blood Elf male", ST_ONCE_LVL, false)
    Soundtrack.AddEvent(ST_DANCE, "Blood Elf female", ST_ONCE_LVL, false)
    Soundtrack.AddEvent(ST_DANCE, "Draenei male", ST_ONCE_LVL, false)
    Soundtrack.AddEvent(ST_DANCE, "Draenei female", ST_ONCE_LVL, false)
	Soundtrack.AddEvent(ST_DANCE, "Worgen male", ST_ONCE_LVL, false)
	Soundtrack.AddEvent(ST_DANCE, "Worgen female", ST_ONCE_LVL, false)
	Soundtrack.AddEvent(ST_DANCE, "Goblin male", ST_ONCE_LVL, false)
	Soundtrack.AddEvent(ST_DANCE, "Goblin female", ST_ONCE_LVL, false)
end