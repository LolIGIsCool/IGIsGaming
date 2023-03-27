if not SERVER then return end


for k, v in pairs(file.Find("starwars_armory/load/*.lua", "LUA")) do
	if v == "cl_init.lua" then
		AddCSLuaFile("starwars_armory/load/" ..v)
	end
	include("starwars_armory/load/" .. v)
end
MsgN("Loaded serverside")

