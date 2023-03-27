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

	SArmory.Action.finish()
end

function SArmory.Action.registerWeapon(tblWeapon)
	SArmory.Database[tblWeapon.ID] = tblWeapon
end

function SArmory.Action.reloadWeapons()
	if SArmory.Loaded != true then return end
	SArmory.Action.loadWeapons()
end
hook.Add( "OnReloaded", "SArmory.Action.reloadWeapons", SArmory.Action.reloadWeapons )

function SArmory.Action.loadFiles()
	SArmory.Action.loadCLFiles()
	for k, v in pairs(file.Find(folder.."/server/*.lua", "LUA")) do
		include(folder.."/server/" .. v)
	end
end

function SArmory.Action.loadCLFiles()
	for k, v in pairs(file.Find(folder.."/client/*.lua", "LUA")) do
		AddCSLuaFile(folder.."/client/"..v)
	end
	for k, v in pairs(file.Find(folder.."/client/vgui/*.lua", "LUA")) do
		AddCSLuaFile(folder.."/client/vgui/"..v)
	end
end

function SArmory.Action.start()
	SArmory.Action.loadWeapons()
	SArmory.Action.loadFiles()
	SArmory.Action.loadWeapons()
end
hook.Add("DarkRPFinishedLoading", "SArmory.Action.start", SArmory.Action.start )
hook.Add("loadCustomDarkRPItems", "SArmory.Action.start", SArmory.Action.start)
hook.Add("PostGamemodeLoaded", "SArmory.Action.start", SArmory.Action.start)
hook.Add("DConfigDataLoaded", "SArmory.Action.start", SArmory.Action.start)

function SArmory.Action.finish()
	SArmory.Loaded = true
	hook.Call("SArmory.Action.finished")
end

function SArmory.Action.notify(player, msg)
	if SArmory.Config.MsgType == true then
		DarkRP.notify(player, 1, 5, msg)
	else
		player:PrintMessage(HUD_PRINTTALK, msg)
	end
end

resource.AddWorkshop("1090238033")

MsgC(Color(0, 255, 0), "[Armory] Loaded Sci-Fi Armory!\n")
