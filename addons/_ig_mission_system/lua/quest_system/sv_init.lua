include("quest_system/sh_init.lua")
include("quest_system/server/sv_functions.lua")
include("quest_system/server/sv_hooks.lua")
include("quest_system/server/sv_commands.lua")
include("quest_system/server/sv_player.lua")
include("quest_system/server/sv_networking.lua")

AddCSLuaFile("quest_system/sh_init.lua")
AddCSLuaFile("quest_system/client/cl_networking.lua")
AddCSLuaFile("quest_system/client/cl_fonts.lua")
AddCSLuaFile("quest_system/client/cl_vgui.lua")
AddCSLuaFile("quest_system/client/cl_hud.lua")