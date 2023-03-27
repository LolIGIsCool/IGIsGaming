if not CLIENT then return end

SArmory = SArmory or {}
SArmory.Action = SArmory.Action or {}
SArmory.Database = SArmory.Database or {}
local folder = "starwars_armory"

function SArmory.Action.loadWeapons()
	MsgC(Color(0, 195,255), "[Si-Fi Armoury and Blackmarket] ", Color(115, 255,0), "Loading Weapon Files", "\n")
	local foundFiles = file.Find(folder .. "/weapons/*.lua", "LUA")

	for k, v in pairs(foundFiles) do
		local fileName = folder .. "/weapons/" .. v

		if SERVER then
			AddCSLuaFile(fileName)
		end

		include(fileName)
		MsgC(Color(0, 195,255), "[Si-Fi Armoury and Blackmarket] ", Color(255, 208,0), fileName, "\n")
	end
	MsgC(Color(0, 195,255), "[Si-Fi Armoury and Blackmarket] ", Color(115, 255,0), "Loaded Weapon Files", "\n")
end

function SArmory.Action.registerWeapon(tblWeapon)
	SArmory.Database[tblWeapon.ID] = tblWeapon
end

function SArmory.Action.loadFiles()
	MsgC(Color(0, 195,255), "[Si-Fi Armoury and Blackmarket] ", Color(115, 255,0), "Loading Client Files", "\n")
	for k, v in pairs(file.Find(folder .. "/client/*.lua", "LUA")) do
		include(folder .. "/client/" .. v)
		MsgC(Color(0, 195,255), "[Si-Fi Armoury and Blackmarket] ", Color(255, 208,0), folder .. "/client/" .. v, "\n")
	end
	for k, v in pairs(file.Find(folder .. "/client/vgui/*.lua", "LUA")) do
		include(folder .. "/client/vgui/" .. v)
		MsgC(Color(0, 195,255), "[Si-Fi Armoury and Blackmarket] ", Color(255, 208,0), folder .. "/client/vgui/" .. v, "\n")
	end

	MsgC(Color(0, 195,255), "[Si-Fi Armoury and Blackmarket] ", Color(115, 255,0), "Loaded Client Files", "\n")
	SArmory.Action.loadWeapons()
end
hook.Add("Initialize", "SArmory.Action.loadFiles1", SArmory.Action.loadFiles)

function SArmory.Action.start()
	SArmory.Action.loadWeapons()
	SArmory.Action.loadFiles()
	SArmory.Action.loadWeapons()
end
hook.Add("Initialize", "SArmory.Action.start2_cl", SArmory.Action.start)

function SArmory.Action.onReload()
	SArmory.Action.loadFiles()
	SArmory.Action.loadWeapons()
end
hook.Add("OnReloaded", "SArmory.Action.onReload", SArmory.Action.onReload)














