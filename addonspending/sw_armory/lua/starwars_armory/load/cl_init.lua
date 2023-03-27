if not CLIENT then return end
//
/*
	This file is not needed to be touched.
	
	For configuration
	server/sv_armory_config.lua
	client/cl_armory_config.lua
	
	Thanks for purchasing -Nykez
*/

SArmory = SArmory or {}
SArmory.Config = SArmory.Config or {}
SArmory.Action = SArmory.Action or {}
SArmory.Database = SArmory.Database or {}
local folder = "starwars_armory"

function SArmory.Action.loadWeapons()
	local foundFiles = file.Find(folder .. "/weapons/*.lua", "LUA")

	for k, v in pairs(foundFiles) do
        local fileName = folder.. "/weapons/".. v

    	if SERVER then
			AddCSLuaFile(fileName)
		end

		include(fileName)
	end
end

function SArmory.Action.registerWeapon(tblWeapon)
	SArmory.Database[tblWeapon.ID] = tblWeapon
end

function SArmory.Action.loadFiles()
	for k, v in pairs(file.Find(folder.."/client/*.lua", "LUA")) do
		include(folder.."/client/"..v)
		print("Loading: ",v)
	end
	for k, v in pairs(file.Find(folder.."/client/vgui/*.lua", "LUA")) do
		include(folder.."/client/vgui/"..v)
	end
	
	SArmory.Action.loadWeapons()
end
hook.Add("Initialize", "SArmory.Action.loadFiles1", SArmory.Action.loadFiles)

function SArmory.Action.start()
	SArmory.Action.loadWeapons()
	SArmory.Action.loadFiles()
	SArmory.Action.loadWeapons()
end
hook.Add("Initialize", "SArmory.Action.start2_cl", SArmory.Action.start)
hook.Add("DConfigDataLoaded", "SArmory.Action.start2_cl", SArmory.Action.start)

function SArmory.Action.onReload()
	SArmory.Action.loadFiles()
	SArmory.Action.loadWeapons()
end
hook.Add("OnReloaded", "SArmory.Action.onReload", SArmory.Action.onReload)
surface.CreateFont( "AurebeshUnreadable", {
	font = "Aurebesh", --  Use the font-name which is shown to you by your operating system Font Viewer, not the file name
	extended = false,
	size = 13,
	weight = 500,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
})
surface.CreateFont( "AurebeshReadable", {
	font = "Aurebesh_english", --  Use the font-name which is shown to you by your operating system Font Viewer, not the file name
	extended = false,
	size = 13,
	weight = 500,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
})















