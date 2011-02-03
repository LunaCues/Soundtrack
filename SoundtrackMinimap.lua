-- Minimap Button Handling

local function debug(msg)
    Soundtrack.Util.DebugPrint(msg)
end

function SoundtrackMinimap_IconFrame_OnClick(self, button, down)

    debug("Minimap button OnClick")
    
    if not SoundtrackMinimap_IconFrame:IsVisible() then
        return
    end
    
    if button == "RightButton" then
        -- Toggle menu
        local menu = _G["SoundtrackMinimapMenu"]
        menu.point = "TOPRIGHT"
        menu.relativePoint = "CENTER"
        ToggleDropDownMenu(1, nil, menu, "SoundtrackMinimap_IconFrame", -5, -5)
    else
        SoundtrackFrame_Toggle()
    end
end

-- moves the minimap icon to last position in settings or default angle of 45
local function move_icon()
    SoundtrackMinimap_IconFrame:SetPoint("TOPLEFT", "Minimap", "TOPLEFT", 52-(80*cos(Soundtrack.Settings.MinimapIconPos or 45)),(80*sin(Soundtrack.Settings.MinimapIconPos or 45))-52)
end

function SoundtrackMinimap_IconFrame_OnEvent(self, event, ...)
local arg1, arg2 = ...
    if event=="VARIABLES_LOADED" then
        SoundtrackMinimap_RefreshMinimap()
        move_icon() -- Make sure we init the button in the saved positon.
    end
end

function SoundtrackMinimap_RefreshMinimap()
    if Soundtrack.Settings.EnableMinimapButton then
        SoundtrackMinimap_IconFrame:Show()
    else
        SoundtrackMinimap_IconFrame:Hide()
    end
end


function SoundtrackMinimap_IconDraggingFrame_OnUpdate(self,elapsed)

    local xpos,ypos = GetCursorPosition()
    local xmin,ymin = Minimap:GetLeft(), Minimap:GetBottom()

    xpos = xmin-xpos/Minimap:GetEffectiveScale()+70
    ypos = ypos/Minimap:GetEffectiveScale()-ymin-70

    Soundtrack.Settings.MinimapIconPos = math.deg(math.atan2(ypos,xpos))
    move_icon()
end

function SoundtrackMinimapMenu_Initialize()
    Soundtrack.HideTip()
	
	--Title
    local info = {}
    info.text = "Soundtrack"
    info.notClickable = 1
	info.notCheckable = 1
    info.isTitle = 1
    UIDropDownMenu_AddButton(info, 1)
    
	--[[
	local info = {}
	info.text = "Stop Playlist"
	info.func = function() Soundtrack.StopEventAtLevel(9) end
	info.notCheckable = 1
	UIDropDownMenu_AddButton(info, 1)
	--]]
	
    -- Configure
    local info = {}
    info.text = "Configure tracks"
    info.func = function() SoundtrackFrame:Show() end
    info.notCheckable = 1
    UIDropDownMenu_AddButton(info, 1)
    
    local info = {}
    info.text = "Add Current Zone Information"
    info.func = SoundtrackFrameAddZoneButton_OnClick
    info.notCheckable = 1
    UIDropDownMenu_AddButton(info, 1)
    
    local info = {}
    info.text = "Enable Battle Music"
    info.checked = Soundtrack.Settings.EnableBattleMusic
    info.func = function() Soundtrack.Settings.EnableBattleMusic = not Soundtrack.Settings.EnableBattleMusic end
    UIDropDownMenu_AddButton(info, 1)
    
    local info = {}
    info.text = "Enable Zone Music"
    info.checked = Soundtrack.Settings.EnableZoneMusic
    info.func = function() Soundtrack.Settings.EnableZoneMusic = not Soundtrack.Settings.EnableZoneMusic end
    UIDropDownMenu_AddButton(info, 1)
    
    local info = {}
    info.text = "Enable Misc Music"
    info.checked = Soundtrack.Settings.EnableMiscMusic
    info.func = function() Soundtrack.Settings.EnableMiscMusic = not Soundtrack.Settings.EnableMiscMusic end
    UIDropDownMenu_AddButton(info, 1)
    
    local info = {}
    info.text = "Enable Custom Music"
    info.checked = Soundtrack.Settings.EnableCustomMusic
    info.func = function() Soundtrack.Settings.EnableCustomMusic = not Soundtrack.Settings.EnableCustomMusic end
    UIDropDownMenu_AddButton(info, 1)
    
    local info = {}
    info.text = "Playback Controls"
    info.checked = Soundtrack.Settings.ShowPlaybackControls
    info.func = SoundtrackFrame_ToggleShowPlaybackControls
    UIDropDownMenu_AddButton(info, 1)
    

    
    --MobileMinimapButtonsDropDown_Reposition(UIDROPDOWNMENU_MENU_VALUE)
end