if SERVER then
	AddCSLuaFile("character/cl_vgui.lua")
	include("character/sv_hooks.lua")
	include("character/sv_init.lua")
else
	include("character/cl_vgui.lua")
end