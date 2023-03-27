AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/dolunity/starwars/mortar/shell.mdl")

	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	self:SetCollisionGroup(COLLISION_GROUP_NONE)

	self:PhysWake()
end

function ENT:PhysicsCollide()
	local explosion = ents.Create("env_explosion")
	explosion:SetPos(self:GetPos())
	explosion:Spawn()
	explosion:Fire("Explode")
	explosion:SetKeyValue("IMagnitude", 20)

	util.BlastDamage(self, self, self:GetPos(), 500, 200)
	self:Remove()
end