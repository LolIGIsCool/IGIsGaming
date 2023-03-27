SArmory = SArmory or {}
SArmory.Action = SArmory.Action or {}
SArmory.Database = SArmory.Database or {}
local folder = "starwars_armory"

function SArmory.Action.loadWeapons()
	MsgC(Color(0, 195,255), "[Si-Fi Armoury and Blackmarket] ", Color(55, 255,0), "Loading Weapon Files", "\n")
	local foundFiles = file.Find(folder .. "/weapons/*.lua", "LUA")

	for k, v in pairs(foundFiles) do
		local fileName = folder .. "/weapons/" .. v

		if SERVER then
			AddCSLuaFile(fileName)
		end

		include(fileName)
		MsgC(Color(0, 195,255), "[Si-Fi Armoury and Blackmarket] ", Color(255, 208,0), fileName, "\n")
	end

	MsgC(Color(0, 195,255), "[Si-Fi Armoury and Blackmarket] ", Color(55, 255,0), "Loaded Weapon Files", "\n")
	SArmory.Action.finish()
end

function SArmory.Action.registerWeapon(tblWeapon)
	SArmory.Database[tblWeapon.ID] = tblWeapon
	-- resource.AddFile( "vanilla/armory/" .. tblWeapon.ID .. ".png" )
end

function SArmory.Action.reloadWeapons()
	if SArmory.Loaded != true then return end
	SArmory.Action.loadWeapons()
end
hook.Add( "OnReloaded", "SArmory.Action.reloadWeapons", SArmory.Action.reloadWeapons )

function SArmory.Action.loadFiles()
	MsgC(Color(0, 195,255), "[Si-Fi Armoury and Blackmarket] ", Color(55, 255,0), "Loading Server Files", "\n")
	SArmory.Action.loadCLFiles()
	for k, v in pairs(file.Find(folder .. "/server/*.lua", "LUA")) do
		include(folder .. "/server/" .. v)
		MsgC(Color(0, 195,255), "[Si-Fi Armoury and Blackmarket] ", Color(255, 208,0),folder .. "/server/" .. v , "\n")
	end
	MsgC(Color(0, 195,255), "[Si-Fi Armoury and Blackmarket] ", Color(55, 255,0), "Loaded Weapon Files", "\n")
end

function SArmory.Action.loadCLFiles()
	MsgC(Color(0, 195,255), "[Si-Fi Armoury and Blackmarket] ", Color(55, 255,0), "Loading Client Files", "\n")
	for k, v in pairs(file.Find(folder .. "/client/*.lua", "LUA")) do
		AddCSLuaFile(folder .. "/client/" .. v)
		MsgC(Color(0, 195,255), "[Si-Fi Armoury and Blackmarket] ", Color(255, 208,0), folder .. "/client/" .. v, "\n")
	end
	for k, v in pairs(file.Find(folder .. "/client/vgui/*.lua", "LUA")) do
		AddCSLuaFile(folder .. "/client/vgui/" .. v)
		MsgC(Color(0, 195,255), "[Si-Fi Armoury and Blackmarket] ", Color(255, 208,0), folder .. "/client/vgui/" .. v, "\n")
	end
	MsgC(Color(0, 195,255), "[Si-Fi Armoury and Blackmarket] ", Color(55, 255,0), "Loaded Client Files", "\n")
end

function SArmory.Action.start()
	SArmory.Action.loadWeapons()
	SArmory.Action.loadFiles()
	SArmory.Action.loadWeapons()
end
hook.Add("PostGamemodeLoaded", "SArmory.Action.start", SArmory.Action.start)

function SArmory.Action.finish()
	SArmory.Loaded = true
	hook.Call("SArmory.Action.finished")
end