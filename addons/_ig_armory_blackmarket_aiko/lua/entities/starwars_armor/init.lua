AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")


function ENT:Initialize()
	self:SetModel("models/machine/phoenix/empire_base/prop/stormtrooper_m_08.mdl")
	self:SetSolid(SOLID_BBOX);
	self:PhysicsInit(SOLID_BBOX);
	self:SetMoveType(MOVETYPE_NONE);
	self:DrawShadow(true);
	self:SetUseType(SIMPLE_USE);
end

function ENT:Use(activator)
	if not activator then return end
	if not activator:IsPlayer() then return end
	net.Start("Armory_OpenMenu")
	net.Send(activator)
end