if not CLIENT then return end

for k, v in pairs(file.Find("starwars_armory/load/*.lua", "LUA")) do
	include("starwars_armory/load/" .. v)
end