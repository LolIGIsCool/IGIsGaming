if (!file.Exists("autorun/vj_base_autorun.lua","LUA")) then return end

ENT.Base 			= "base_gmodentity"
ENT.Type 			= "anim"
ENT.PrintName		= "Dark Trooper"
ENT.Author 			= "DrVrej"
ENT.Contact 		= "http://steamcommunity.com/groups/vrejgaming"
ENT.Information		= "Gibs for SNPCs"
ENT.Category		= "VJ Bases"

ENT.Spawnable		= false
ENT.AdminSpawnable	= false

if (CLIENT) then
	function ENT:Draw() self:DrawModel() end
end