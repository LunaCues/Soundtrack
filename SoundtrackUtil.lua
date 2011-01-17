--[[
    Soundtrack addon for World of Warcraft

    Soundtrack utility functions.
    Various helper methods for debugging or generic stuff.
]]

local debugChatFrameIndex = 1

local function FindChatFrameIndex()

    for i=1,10 do
        local name = GetChatWindowInfo(i)
        if name == "Soundtrack" then
            debugChatFrameIndex = i
            return
        end
    end
    
end


-- Returns the number of seconds in "mm.ss" format
function Soundtrack.Util.FormatDuration(seconds)
    if not seconds then
        return ""
    else
        return string.format("%i:%02i", math.floor(seconds/60), seconds % 60)
    end
end

-- Finds the frame to dump the debug info. Call at startup
function Soundtrack.Util.InitDebugChatFrame()
    FindChatFrameIndex()
end

function Soundtrack.Util.ChatPrint(text, cRed, cGreen, cBlue, cAlpha, holdTime)

    if cRed and cGreen and cBlue then
		local frame = _G["ChatFrame"..debugChatFrameIndex]
        if frame then
            frame:AddMessage(text, cRed, cGreen, cBlue)
        elseif DEFAULT_CHAT_FRAME then
            DEFAULT_CHAT_FRAME:AddMessage(text, cRed, cGreen, cBlue)
        end

    else
		local frame = _G["ChatFrame"..debugChatFrameIndex]
        if frame then
			frame:AddMessage(text, 0.0, 1.0, 0.25)
        elseif DEFAULT_CHAT_FRAME then
            DEFAULT_CHAT_FRAME:AddMessage(text, 0.0, 1.0, 0.25)
        end
    end
end

function Soundtrack.Util.DebugPrint(text, cRed, cGreen, cBlue)
    if Soundtrack.Settings.Debug then
        Soundtrack.Util.ChatPrint(text, cRed, cGreen, cBlue)
    end
end

-- Removes string.find offenders from a string
function Soundtrack.Util.CleanString(str)
	local cleanstr = string.gsub(str, "{", "")
	cleanstr = string.gsub(cleanstr, "\"", "")
	cleanstr = string.gsub(cleanstr, "'", "")
	cleanstr = string.gsub(cleanstr, "\\", "")
	return cleanstr;
end