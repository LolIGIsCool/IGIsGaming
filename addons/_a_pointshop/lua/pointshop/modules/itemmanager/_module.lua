MODULE = {}

MODULE.ClassName = "itemmanager"
MODULE.Name = "Item Manager"
MODULE.Description = "Allows administrators to manage existing items as well as create new ones in-game."

MODULE.Config = {
	Enable = true,
}

-- Net messages
local easynet = SH_POINTSHOP.easynet

easynet.Start("SH_POINTSHOP.ItemManager.Network")
	easynet.Add("fn", EASYNET_STRING)
	easynet.Add("code", EASYNET_STRING)
easynet.Register()

easynet.Start("SH_POINTSHOP.ItemManager.NetworkCompressed")
	easynet.Add("fn", EASYNET_STRING)
	easynet.Add("code", EASYNET_DATA)
easynet.Register()

easynet.Start("SH_POINTSHOP.ItemManager.NetworkOverride")
	easynet.Add("class", EASYNET_STRING)
	easynet.Add("changes", EASYNET_JSON)
easynet.Register()

easynet.Start("SH_POINTSHOP.ItemManager.NetworkDeletion")
	easynet.Add("class", EASYNET_STRING)
easynet.Register()

easynet.Start("SH_POINTSHOP.ItemManager.Change")
	easynet.Add("class", EASYNET_STRING)
	easynet.Add("changes", EASYNET_JSON)
easynet.Register()

easynet.Start("SH_POINTSHOP.ItemManager.Create")
	easynet.Add("tmpid", EASYNET_STRING)
	easynet.Add("inputs", EASYNET_JSON)
easynet.Register()

easynet.Start("SH_POINTSHOP.ItemManager.Delete")
	easynet.Add("class", EASYNET_STRING)
easynet.Register()

-- Hook to be used for developers
function MODULE:IsAllowed(ply)
	if (SH_POINTSHOP:IsAdmin(ply)) then
		return true
	end

	local can, reason = hook.Run("SH_POINTSHOP.ItemManager.IsAllowed", ply)
	if (can ~= nil) then
		return can, reason
	end

	return false, "no_permission"
end

include("sh_templates.lua")
include("sh_serialize.lua")

if (SERVER) then
	AddCSLuaFile("sh_templates.lua")
	AddCSLuaFile("sh_serialize.lua")
	AddCSLuaFile("cl_itemmanager.lua")
	include("sv_itemmanager.lua")
else
	include("cl_itemmanager.lua")
end

SH_POINTSHOP:RegisterModule(MODULE)
MODULE = nil