AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:SpawnFunction(ply, tr)
	local SpawnPos = tr.HitPos + tr.HitNormal * 1
	local ent = ents.Create(self.ClassName)
	local angle = ply:GetAimVector():Angle()
	//angle:RotateAroundAxis(angle:Up(), 90)
	angle = Angle(0, angle.yaw, 0)

	ent:SetAngles(angle)
	ent:SetPos(SpawnPos)
	ent:Spawn()
	ent:Activate()
	zbl.f.SetOwner(ent, ply)

	return ent
end

function ENT:Initialize()
	self:SetModel(self.Model)

	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetSolid( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_NONE )
	self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
	self:SetUseType(SIMPLE_USE)
	self:SetTrigger(true)

	local phys = self:GetPhysicsObject()
	if IsValid(phys) then
		phys:Wake()
		phys:EnableMotion(false)
	end

	zbl.f.Fence_Initialize(self)

	self:DrawShadow( false )
end

function ENT:AcceptInput(input, activator, caller, data)
	if string.lower(input) == "use" and IsValid(activator) and activator:IsPlayer() and activator:Alive() and (self.LastUse or 0) < CurTime() then
		zbl.f.Fence_OnUse(self,activator)
		self.LastUse = CurTime() + 1
	end
end

function ENT:StartTouch(other)
	zbl.f.Fence_OnStartTouch(self, other)
end

function ENT:OnTakeDamage(dmginfo)
	if (not self.m_bApplyingDamage) then
		self.m_bApplyingDamage = true
		self:TakeDamageInfo(dmginfo)
		zbl.f.Fence_OnDamage(self, dmginfo)
		self.m_bApplyingDamage = false
	end
end

function ENT:OnRemove()
	zbl.f.Fence_OnRemove(self)
end
