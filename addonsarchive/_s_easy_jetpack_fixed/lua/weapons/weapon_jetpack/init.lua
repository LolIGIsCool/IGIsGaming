if SERVER then
	AddCSLuaFile()
	CreateConVar("jetpack_fly_power", 30,{FCVAR_ARCHIVE},"Change the upward force of the jetpack. (Should be 10 for Singleplayer and 10-30 for Servers depending on tick)")
	CreateConVar("jetpack_hover_power", 9,{FCVAR_ARCHIVE},"Change the hovering force of the jetpack. (Should be 3 for Singleplayer and 3-9 for Servers dpending on tick)")
	CreateConVar("jetpack_drain_fuel", 3,{FCVAR_ARCHIVE},"Change how quickly the Jetpack drains fuel. (Default: 3)")
	CreateConVar("jetpack_max_fuel", 1000,{FCVAR_ARCHIVE},"Change the maximum fuel of the jetpack. (Default: 1000)")
end

--Send files to client
AddCSLuaFile('cl_init.lua')
AddCSLuaFile('shared.lua')

--Include shared code
include('shared.lua')
--Serverside only code below here
