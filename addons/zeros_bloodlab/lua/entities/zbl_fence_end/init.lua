AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:SpawnFunction(ply, tr)
	local SpawnPos = tr.HitPos + tr.HitNormal * 75
	local ent = ents.Create(self.ClassName)
	ent:SetPos(SpawnPos)
	ent:Spawn()
	ent:Activate()
	zbl.f.SetOwner(ent, ply)

	return ent
end

function ENT:Initialize()
	self:SetModel(self.Model)

	local parent = self:GetMain()

	if IsValid(parent) then

		local min,max = self:GetBoxData(parent)

		local x0 = min.x
		local y0 = min.y
		local z0 = min.z

		local x1 = max.x
		local y1 = max.y
		local z1 = max.z
		self:PhysicsInitConvex( {
			Vector( x0, y0, z0 ),
			Vector( x0, y0, z1 ),
			Vector( x0, y1, z0 ),
			Vector( x0, y1, z1 ),

			Vector( x1, y0, z0 ),
			Vector( x1, y0, z1 ),
			Vector( x1, y1, z0 ),
			Vector( x1, y1, z1 )
		} )

		self:SetSolid( SOLID_VPHYSICS )

		self:SetMoveType( MOVETYPE_NONE )
		self:SetCollisionGroup(COLLISION_GROUP_NONE)

		self:EnableCustomCollisions( true )
		self:SetTrigger(true)

		self:SetCollisionBounds(min,max)

		self.PhysgunDisabled = true

		self:PhysWake()
	else
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)
	end

	local phys = self:GetPhysicsObject()
	if IsValid(phys) then
		phys:Wake()
		phys:EnableMotion(false)
	end

	self:DrawShadow( false )
end

function ENT:StartTouch(other)
	if not IsValid(other) then return end

	if other:IsPlayer() and other:Alive() then
		if zbl.config.Fence.dmg_per_touch > 0 then
			zbl.f.Fence_ShockPlayer(self,other)
		end
	elseif other:IsVehicle() and zbl.config.Fence.kill_driver == true then
		local ply = other:GetDriver()
		if IsValid(ply) then
			ply:Kill()
			self:EmitSound("zbl_fence_zap")
		end
	end
end

function ENT:OnTakeDamage(dmginfo)
	if (not self.m_bApplyingDamage) then
		self.m_bApplyingDamage = true
		self:TakeDamageInfo(dmginfo)
		if IsValid(self:GetMain()) then
			zbl.f.Fence_OnDamage(self:GetMain(), dmginfo)
		end
		self.m_bApplyingDamage = false
	end
end
