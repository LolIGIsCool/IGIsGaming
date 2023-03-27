axl = axl or {};
axl.movable_door = axl.movable_door or {};
axl.movable_door.cfg = axl.movable_door.cfg or {};
local cfg = axl.movable_door.cfg;

if (SERVER) then
	AddCSLuaFile("axl_movable_door/sh_pon.lua");
	AddCSLuaFile("axl_movable_door/sh_netstream2.lua");
	AddCSLuaFile("axl_movable_door/shared.lua");
	AddCSLuaFile("axl_movable_door/derma.lua");
	AddCSLuaFile("axl_cfg_movable_door.lua");
end;

include("axl_movable_door/sh_pon.lua");
include("axl_movable_door/sh_netstream2.lua");
include("axl_cfg_movable_door.lua");
include("axl_movable_door/shared.lua");

if (CLIENT) then
	include("axl_movable_door/derma.lua");
end
