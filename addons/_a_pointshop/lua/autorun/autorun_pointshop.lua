SH_POINTSHOP = {}

include("pointshop_config.lua")
include("pointshop/lib_easynet.lua")
include("pointshop/lib_panelhook.lua")
include("pointshop/lib_filesystem.lua")
include("pointshop/sh_constants.lua")
include("pointshop/sh_main.lua")
include("pointshop/sh_networking.lua")
include("pointshop/sh_loader.lua")
include("pointshop/sh_obj_player_extend.lua")

SH_POINTSHOP.Language = include("pointshop/language/" .. (SH_POINTSHOP.LanguageName or "english") .. ".lua")

if (SERVER) then
	AddCSLuaFile("pointshop_config.lua")
	AddCSLuaFile("pointshop/language/" .. (SH_POINTSHOP.LanguageName or "english") .. ".lua")
	AddCSLuaFile("pointshop/lib_easynet.lua")
	AddCSLuaFile("pointshop/lib_loungeui.lua")
	AddCSLuaFile("pointshop/lib_panelhook.lua")
	AddCSLuaFile("pointshop/lib_filesystem.lua")
	AddCSLuaFile("pointshop/sh_constants.lua")
	AddCSLuaFile("pointshop/sh_main.lua")
	AddCSLuaFile("pointshop/sh_networking.lua")
	AddCSLuaFile("pointshop/sh_loader.lua")
	AddCSLuaFile("pointshop/sh_obj_player_extend.lua")
	AddCSLuaFile("pointshop/cl_main.lua")
	AddCSLuaFile("pointshop/cl_menu.lua")
	AddCSLuaFile("pointshop/cl_rendering.lua")

	include("pointshop_database.lua")
	include("pointshop/lib_database.lua")
	include("pointshop/sv_main.lua")
	include("pointshop/sv_obj_player_extend.lua")
	include("pointshop/sv_actions.lua")
	timer.Create("POINTSHOPCONTINUITYHEHE",10,0,function()
		for k,v in pairs(player.GetAll()) do 
			if v:SH_GetPremiumPoints() < 0 then
				v:SH_SetPremiumPoints(0,false,false)
			end
			if v:SH_GetStandardPoints() < 0 then
				v:SH_SetStandardPoints(0,false,false)
			end
		end
	end)
else
	include("pointshop/lib_loungeui.lua")
	include("pointshop/cl_main.lua")
	include("pointshop/cl_menu.lua")
	include("pointshop/cl_rendering.lua")
end

if (SH_POINTSHOP.UseLibGModStore) then
	if (SERVER) then
		AddCSLuaFile("pointshop/libgmodstore.lua")
	end
	include("pointshop/libgmodstore.lua")

	local SHORT_SCRIPT_NAME = "SH Pointshop"
	local SCRIPT_ID = 4953
	local SCRIPT_VERSION = "1.0.4"
	local LICENSEE = "76561198006360138"
	hook.Add("libgmodstore_init",SHORT_SCRIPT_NAME .. "_libgmodstore",function()
		libgmodstore:InitScript(SCRIPT_ID,SHORT_SCRIPT_NAME,{
			version = SCRIPT_VERSION,
			licensee = LICENSEE
		})
	end)
end