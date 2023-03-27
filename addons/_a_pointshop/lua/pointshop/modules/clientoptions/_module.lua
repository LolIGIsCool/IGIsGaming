MODULE = {}

MODULE.ClassName = "clientoptions"
MODULE.Name = "Client Options"
MODULE.Description = "Allows connected players to modify clientside SH Pointshop options."

MODULE.Options = {
	{
		catname = "opt_interface",
		opts = {
			{text = "opt_simple_item_icons", cvar = "sh_pointshop_interface_simple_icons", type = TYPE_BOOL},
		},
	},
	{
		catname = "opt_rendering",
		opts = {
			{text = "opt_render_distance", cvar = "sh_pointshop_rendering_distance", type = TYPE_NUMBER, min = 0, max = 2^16, decimals = 0},
			{text = "opt_disable_hats_on_players", cvar = "sh_pointshop_rendering_players_disable", type = TYPE_BOOL},
			{text = "opt_disable_hats_on_ragdolls", cvar = "sh_pointshop_rendering_ragdolls_disable", type = TYPE_BOOL},
		},
	},
}

if (SERVER) then
	AddCSLuaFile("cl_clientoptions.lua")
else
	include("cl_clientoptions.lua")
end

SH_POINTSHOP:RegisterModule(MODULE)
MODULE = nil