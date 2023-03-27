include("rebel_system/server/sv_mission_functions.lua")
include("rebel_system/server/sv_player_functions.lua")
include("rebel_system/sh_init.lua")
include("rebel_system/server/sv_networking.lua")
include("rebel_system/server/sv_concommands.lua")
resource.AddFile("material/vanilla/rebel.png")
--make sure to include all files in the server folder as well

AddCSLuaFile("rebel_system/client/cl_player_point_tracking.lua")
AddCSLuaFile("rebel_system/server/sv_player_functions.lua")
AddCSLuaFile("rebel_system/client/cl_player_point_hacking.lua")
AddCSLuaFile("rebel_system/client/cl_player_theft.lua")
AddCSLuaFile("rebel_system/client/cl_player_receive_instructions.lua")
AddCSLuaFile("rebel_system/client/rebel_hud.lua")