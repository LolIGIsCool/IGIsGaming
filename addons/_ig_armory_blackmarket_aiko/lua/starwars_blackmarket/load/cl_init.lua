if not CLIENT then return end

SBlackmarket = SBlackmarket or {}
SBlackmarket.Config = SBlackmarket.Config or {}
SBlackmarket.Action = SBlackmarket.Action or {}
SBlackmarket.Database = SBlackmarket.Database or {}
local folder = "starwars_blackmarket"

function SBlackmarket.Action.loadWeapons()
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

function SBlackmarket.Action.registerWeapon(tblWeapon)
	SBlackmarket.Database[tblWeapon.ID] = tblWeapon
end

function SBlackmarket.Action.loadFiles()
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
	SBlackmarket.Action.loadWeapons()
end
hook.Add("Initialize", "SBlackmarket.Action.loadFiles1", SBlackmarket.Action.loadFiles)

function SBlackmarket.Action.start()
	SBlackmarket.Action.loadWeapons()
	SBlackmarket.Action.loadFiles()
	SBlackmarket.Action.loadWeapons()
end
hook.Add("Initialize", "SBlackmarket.Action.start2_cl", SBlackmarket.Action.start)

function SBlackmarket.Action.onReload()
	SBlackmarket.Action.loadFiles()
	SBlackmarket.Action.loadWeapons()
end
hook.Add("OnReloaded", "SBlackmarket.Action.onReload", SBlackmarket.Action.onReload)