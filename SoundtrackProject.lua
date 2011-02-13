--[[
	SoundtrackProject.lua
	
	Loads projects for Soundtrack.
--]]

local SoundtrackProjects = {}

-- Check if the project is loaded
function SoundtrackProject_CheckIfProjectLoaded(projectName)
	for i,project in ipairs(SoundtrackProjects) do
		if SoundtrackProjects[project].name == projectName then
			return true
		end
	end
	return false
end

-- Insert a project an all necessary information into SoundtrackProjects table
-- _projectName = name of your project
-- _projectTable = event table for your project (saved variables from Soundtrack with settings for your project)
-- _locales = locales codes for your project (use GetLocale() return codes)
function SoundtrackProject_InsertProject(_projectName, _projectTable, _locales)
	print(_projectName)
	print(_projectTable)
	print(_locales)
	
	project = 
	{
		name = _projectName, 
		projectTable = _projectTable, 
		locales = _locales,
	};
	
	table.insert(SoundtrackProjects, project)
	
	print(_projectName .. " loaded. "..#(SoundtrackProjects))
end


---------------------
-- Local Functions --
---------------------

-- Loads a project's event-track settings to Soundtrack
local function SoundtrackProject_LoadProject(projectEventsTable)
    for i,ProjectTable in pairs(projectEventsTable) do				-- for every table in project events table
		local SoundtrackTable = Soundtrack.Events.GetTable(i)
		for j, eventName in pairs(ProjectTable) do					-- for every event
			if SoundtrackTable[j] == nil then						-- if event doesn't exist, copy project event
				SoundtrackTable[j] = eventName
			else
				for k, track in pairs(eventName.tracks) do			-- insert tracks into event
					local loaded = false
					print (k," ",track,"    ",l," ",strack)
					for l, strack in pairs(SoundtrackTable[j].tracks) do
						print (k," ",track," == ",l," ",strack)
						if strack == track then loaded = true end
					end
					if not loaded then table.insert(SoundtrackTable[j].tracks, track) end
				end
			end
		end
	end
end


-- Removes a project's event-track settings from Soundtrack
local function SoundtrackProject_RemoveProject(projectEventsTable)
	for i,ProjectTable in pairs(projectEventsTable) do				-- for every table in project events table
		print("ProjectTable: ",i," ",ProjectTable)
		local SoundtrackTable = Soundtrack.Events.GetTable(i)	
		for j, eventName in pairs(ProjectTable) do					-- for all events in table
			print("Event: ",j," ",eventName)
			if SoundtrackTable[j] ~= nil then						
				for k, ptrack in pairs(eventName.tracks) do			-- for all tracks in event
					print("track, project: ",k," ",ptrack)
					for l, strack in pairs(SoundtrackTable[j].tracks) do	
						print("track, soundtrack: ",l," ",strack)
						if ptrack == strack then 					-- remove project tracks from events
						
							table.remove(SoundtrackTable[j].tracks, l)
						end
					end
				end
			end
		end
	end
end



-------------------------------
-- ONLOAD, ONEVENT, ONUPDATE --
-------------------------------

function SoundtrackProject_OnUpdate(frame, elapsed)
	-- Look cute, because there's nothing to do on update.
end

function SoundtrackProject_OnLoad(frame)
	frame:RegisterEvent("VARIABLES_LOADED")
end

function SoundtrackProject_OnEvent(self, event, ...)
	if event == "VARIABLES_LOADED" then								-- VARIABLES_LOADED, time to load stuff!
	
		SLASH_SOUNDTRACKPROJECT1, SLASH_SOUNDTRACKPROJECT2 = '/soundtrackproject', '/stp'
		
		local function SoundtrackProjectSlashCmd(msg)				-- SLASH COMMAND FUNCTION
			local action, spname = msg:match("^(%S*)%s*(.-)$");
			
			if action == "load" or action == "l" then				-- Load a project to Soundtrack
				for i, project in pairs(SoundtrackProjects) do
					if spname == project.name then
						for j, locale in pairs(project.locales) do
							if GetLocale() == locale then
								print("Loading: "..spname)
								SoundtrackProject_LoadProject(project.projectTable)
								return
							end
						end
					end
				end
				print("Soundtrack Project cannot load "..spname)
				return
				
			elseif action == "remove" or action == "r" then			-- Remove a project from Soundtrack
				for i, project in pairs(SoundtrackProjects) do
					if spname == project.name then
						for j, locale in pairs(project.locales) do
							if GetLocale() == locale then
								print("Removing: "..spname)
								SoundtrackProject_RemoveProject(project.projectTable)
								return
							end
						end
					end
				end
				return
			
			elseif action == "list" then							-- List available projects
				print("Soundtrack Projects: "..#(SoundtrackProjects))
				for i, project in pairs(SoundtrackProjects) do
					print("/stp load "..project.name)
				end
				
			else													-- List options
				print ("Soundtrack Project")
				print ("/stp list")
				print ("/stp load <project>")
				print ("/stp remove <project>")
			end
		end
		SlashCmdList["SOUNDTRACKPROJECT"] = SoundtrackProjectSlashCmd
		print ("Soundtrack Project: /stp")
	end
end

-----------------
-- END OF FILE
-----------------