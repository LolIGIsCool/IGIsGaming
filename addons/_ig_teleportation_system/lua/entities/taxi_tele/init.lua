AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()

	self:SetModel(Taxi_SH.Model)
	self:SetUseType(SIMPLE_USE)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_NONE)

	local phys = self:GetPhysicsObject()
	if phys and phys:IsValid() then phys:Wake() phys:EnableMotion(false) end

	self:SetCollisionGroup(COLLISION_GROUP_WORLD)
end


function ENT:Use(ply, caller)
	net.Start("Taxi_Menu")
	net.Send(ply)
	ply:Freeze(true)
	ply.JustFroze = true
	ply:SetVelocity(Vector(0,0,0))
	ply:SetPos(ply:GetPos())
	ply:SetEyeAngles((self:GetPos()-Vector(0,0,30)-ply:GetPos()):Angle())
end
