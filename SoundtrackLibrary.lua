--[[
    Soundtrack addon for World of Warcraft

    Soundtrack library functions.
    Functions that manage the users list of available music tracks.
]]

Soundtrack.Library.CurrentlyPlayingTrack = nil
local fadeOut = false

local function debug(msg)
    Soundtrack.Util.DebugPrint("[Library]: " .. msg, 0.25, 0.25, 1.0)
end

function Soundtrack.Library.AddTrack(trackName, _length, _title, _artist, _album)
    Soundtrack_Tracks[trackName] = { length = _length, title = _title, artist = _artist, album = _album }
    --Soundtrack.SortTracks()
end

function Soundtrack.Library.AddDefaultTrack(trackName, _length, _title, _artist, _album)             
    Soundtrack_Tracks[trackName] = { length = _length, title = _title, artist = _artist, album = _album, defaultTrack = true }
    --Soundtrack.SortTracks()
end

function Soundtrack.Library.AddProjectTrack(trackName, _length, _title, _artist, _album)
	Soundtrack_Tracks[trackName] = { length = _length, title = _title, artist = _artist, album = _album, projectTrack = true}
end


function Soundtrack.Library.StopMusic()
	-- Remove the playback continuity timers
	-- because we're stopping!
	Soundtrack.Timers.Remove("FadeOut")
	Soundtrack.Timers.Remove("TrackFinished")
	
	-- Play EmptyTrack
    Soundtrack.Library.CurrentlyPlayingTrack = "None"
    debug("Playing empty track.")
    debug("PlayMusic('Interface\\AddOns\\Soundtrack\\EmptyTrack.mp3')")
    PlayMusic("Interface\\AddOns\\Soundtrack\\EmptyTrack.mp3") 
    SoundtrackFrame_TouchTracks()
end

function Soundtrack.Library.PauseMusic()
	-- Play EmptyTrack
    Soundtrack.Library.CurrentlyPlayingTrack = "None"
    debug("Playing empty track.")
    debug("PlayMusic('Interface\\AddOns\\Soundtrack\\EmptyTrack.mp3')")
    PlayMusic("Interface\\AddOns\\Soundtrack\\EmptyTrack.mp3") 
    SoundtrackFrame_TouchTracks()
end

function Soundtrack.Library.StopTrack()
    debug("StopTrack()")
    fadeOut = true
    nextTrackInfo = nil
end    

local nextTrackInfo;
local nextFileName;
local nextTrackName;
    
local function DelayedPlayMusic()
   Soundtrack.Library.CurrentlyPlayingTrack = nextTrackName
   SetNowPlayingText(nextTrackInfo.title, nextTrackInfo.artist, nextTrackInfo.album)
   debug("PlayMusic(".. nextFileName ..")")
   -- Soundtrack.Library.StopTrack()
   PlayMusic(nextFileName)
   SoundtrackFrame_TouchTracks()
end


local originalVolume
local currentVolume

function Soundtrack.Library.OnUpdate(self, deltaT) 
	local stackLevel = Soundtrack.Events.GetCurrentStackLevel()
	local currentTrack = Soundtrack.Library.CurrentlyPlayingTrack
	local frameText = SoundtrackFrame_StatusBarEventText1:GetText()
	
	if fadeOut == true or (stackLevel == 0 and frameText == SOUNDTRACK_NO_EVENT_PLAYING and currentTrack ~= nil) then 
		StopMusic() 
		Soundtrack.Library.CurrentlyPlayingTrack = nil
	
		if nextTrackInfo ~= nil then 
			DelayedPlayMusic() 
			nextTrackInfo = nil 
		end 

		--SoundtrackFrame_TouchTracks() 
		SoundtrackFrame_TouchTracks() 
		fadeOut = false 
	end 
end 

function Soundtrack.Library.PlayTrack(trackName, soundEffect)

    if soundEffect == nil then soundEffect = false end

    debug("PlayTrack(".. Soundtrack.GetPathFileName(trackName) ..")")
    
    -- Check if the track is valid
    if not Soundtrack_Tracks[trackName] then
        return
    end
    
    -- Check if that track is already playing
    if trackName == Soundtrack.Library.CurrentlyPlayingTrack then
        return
    end
    
    nextTrackInfo = Soundtrack_Tracks[trackName]
    
    -- TODO : Change DefaultScore name
    if nextTrackInfo.defaultTrack then
        nextFileName = "Sound\\Music\\" .. trackName .. ".mp3"
    elseif nextTrackInfo.projectTrack then
		nextFileName = "Interface\\Addons\\"..trackName..".mp3"
	else
        --nextFileName = "Interface\\AddOns\\Soundtrack\\Music\\"..trackName..".mp3"
		nextFileName = "Interface\\AddOns\\SoundtrackMusic\\"..trackName..".mp3"
    end        
    
    -- Everything ok, play the track
    if not soundEffect then
        nextTrackName = trackName
        -- HACK because of Blizzard broke cross fading
        -- Start fading out current song
		if fadeOut == false then -- Only record current volume if we aren't already fading out
			originalVolume = tonumber(GetCVar("Sound_MusicVolume"))
			currentVolume = originalVolume    
		end
	fadeOut = true
	else
		debug("PlaySoundFile(".. nextFileName ..")")  -- EDITED, replaced fileName with nextFileName
		PlaySoundFile(nextFileName) -- sound effect. play the music overlapping other music
		nextTrackInfo = nil
    end
    
    -- Update the UI if its opened
    SoundtrackFrame_TouchTracks()
end



-- Removes a track from the library.
function Soundtrack.Library.RemoveTrackWithConfirmation()
    -- Confirmation
    StaticPopup_Show("SOUNDTRACK_REMOVETRACK")
end
-- Remove track popup
StaticPopupDialogs["SOUNDTRACK_REMOVETRACK"] = {
    text = [[Do you want to remove this track from your library?]],
    button1 = "OK",
    button2 = "Cancel",
    OnAccept = function() 
        Soundtrack.Library.RemoveTrack(SoundtrackFrame_SelectedTrack) 
    end,
    timeout = 0,
    whileDead = 1,
    hideOnEscape = 1
}
    
function Soundtrack.Library.RemoveTrack(trackName)
    if trackName then
        Soundtrack_Tracks[trackName] = nil
        Soundtrack.SortTracks()
        
        -- Remove the track from any event that assigns it
        for _,eventTab in ipairs(Soundtrack_EventTabs) do
            for k,v in Soundtrack_Events[eventTab] do 
                for i,tn in ipairs(v.tracks) do
                    if tn == trackName then
                        debug("Removed assigned track "..trackName)
                        table.remove(v.tracks, i)
                        break
                    end
                end
            end
        end
        
        -- Refresh assigned counts
        SoundtrackFrame_RefreshEvents()
    end
end