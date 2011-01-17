--[[
    Soundtrack addon for World of Warcraft

    Soundtrack utility functions.
    Various helper methods for debugging or generic stuff.
]]

local timerList = {}

local function debug(msg)
    Soundtrack.Util.DebugPrint(msg, 0.75, 0.75, 0.75)
end

Soundtrack.Timers.CooldownTime = 0 -- time (in seconds) since cooldowns last updated
Soundtrack.Timers.CooldownLimit = 1 -- time (in seconds) before cooldowns are updated
Soundtrack.Timers.CurrentTime = GetTime()

-- Will trigger the callback in a specified amount of time (in seconds)
-- The timer gets removed from the list when it is triggered
function Soundtrack.Timers.AddTimer(name, duration, callback)

    table.insert(timerList, 
        { 
            Name = name, 
            Start = GetTime(), 
            When = duration + GetTime(), 
            Callback = callback 
        } )
    
    --local numTimers = #(timerList)
    --local durationText = Soundtrack.Util.FormatDuration(duration)
    --debug("Soundtrack: AddTimer("..name..", "..durationText..") - (Timer count: "..numTimers..")")
end

function Soundtrack.Timers.Get(name)
    for i = 1, #(timerList), 1 do
        if timerList[i].Name == name then
            return timerList[i]
        end
    end
    return nil
end

function Soundtrack.Timers.Remove(name)
    for i = 1, #(timerList), 1 do
        if timerList[i].Name == name then
            table.remove(timerList, i)
            local numTimers = #(timerList)
            --debug("Timer '"..name.."' removed. (Timer count: "..numTimers..")")
            return
        end
    end 
end


function Soundtrack.Timers.OnUpdate(self, deltaT)    
    
    local now = GetTime()
    local i
        
    -- Check the timers in reverse order as some timers 
    -- can be removed during the traversal
    local i
    local callbacks = {}
    for i = #(timerList), 1, -1 do
        if timerList[i].When <= now then
            -- Trigger event
            local name = timerList[i].Name
            table.insert(callbacks, timerList[i])
            table.remove(timerList, i)
            local numTimers = #(timerList)
            --debug("Timer '"..name.."' elapsed! (Timer count: "..numTimers..")")
        end
    end
    
    -- Call the callbacks, this must be done outside the loop, because the callbacks
    -- can add their own timers!
    for i, callback in ipairs(callbacks) do
        callback.Callback()  
    end
end