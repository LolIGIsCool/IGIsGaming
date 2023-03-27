SBlackmarket = SBlackmarket or {}
SBlackmarket.Config = SBlackmarket.Config or {}
SBlackmarket.Action = SBlackmarket.Action or {}
SBlackmarket.Database = SBlackmarket.Database or {}
local folder = "starwars_blackmarket"

function SBlackmarket.Action.loadWeapons()
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
	SBlackmarket.Action.finish()
end

function SBlackmarket.Action.registerWeapon(tblWeapon)
	SBlackmarket.Database[tblWeapon.ID] = tblWeapon
	-- resource.AddFile( "vanilla/armory/" .. tblWeapon.ID .. ".png" )
end

function SBlackmarket.Action.reloadWeapons()
	if SBlackmarket.Loaded != true then return end
	SBlackmarket.Action.loadWeapons()
end
hook.Add( "OnReloaded", "SBlackmarket.Action.reloadWeapons", SBlackmarket.Action.reloadWeapons )

function SBlackmarket.Action.loadFiles()
	MsgC(Color(0, 195,255), "[Si-Fi Armoury and Blackmarket] ", Color(55, 255,0), "Loading Server Files", "\n")
	SBlackmarket.Action.loadCLFiles()
	for k, v in pairs(file.Find(folder .. "/server/*.lua", "LUA")) do
		include(folder .. "/server/" .. v)
		MsgC(Color(0, 195,255), "[Si-Fi Armoury and Blackmarket] ", Color(255, 208,0),folder .. "/server/" .. v , "\n")
	end
	MsgC(Color(0, 195,255), "[Si-Fi Armoury and Blackmarket] ", Color(55, 255,0), "Loaded Weapon Files", "\n")
end

function SBlackmarket.Action.loadCLFiles()
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

function SBlackmarket.Action.start()
	SBlackmarket.Action.loadWeapons()
	SBlackmarket.Action.loadFiles()
	SBlackmarket.Action.loadWeapons()
end

hook.Add("PostGamemodeLoaded", "SBlackmarket.Action.start", SBlackmarket.Action.start)

function SBlackmarket.Action.finish()
	SBlackmarket.Loaded = true
	hook.Call("SBlackmarket.Action.finished")
end