AddCSLuaFile()

ENT.Type            = "anim"
DEFINE_BASECLASS( "lunasflightschool_missile" )

if SERVER then
    function ENT:Initialize()	
		self:SetModel("models/weapons/w_missile_launch.mdl")
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		self:SetRenderMode(RENDERMODE_TRANSALPHA)
		self:PhysWake()

		local pObj = self:GetPhysicsObject()
		if IsValid(pObj) then
			pObj:EnableGravity(false) 
			pObj:SetMass(1) 
		end
		
		self.LifeTime = CurTime() + 12
	end

	function ENT:FollowTarget( followent )
		self:GetPhysicsObject():SetVelocity(self:GetForward() * 8250)

		local ang = (followent:GetPos() - self:GetPos()):Angle()
		self:SetAngles(ang)

		--[[local speed = self:GetStartVelocity() + (self:GetDirtyMissile() and 5000 or 3500)
		local turnrate = (self:GetCleanMissile() or self:GetDirtyMissile()) and 60 or 50
		
		local TargetPos = followent:LocalToWorld( followent:OBBCenter() )
		
		if isfunction( followent.GetMissileOffset ) then
			local Value = followent:GetMissileOffset()
			if isvector( Value ) then
				TargetPos = followent:LocalToWorld( Value )
			end
		end
		
		local pos = TargetPos + followent:GetVelocity() * 0.25
		
		local pObj = self:GetPhysicsObject()
		
		if IsValid( pObj ) then
			if not self:GetDisabled() then
				local targetdir = (pos - self:GetPos()):GetNormalized()
				
				local AF = self:WorldToLocalAngles( targetdir:Angle() )
				AF.p = math.Clamp( AF.p * 400,-turnrate,turnrate )
				AF.y = math.Clamp( AF.y * 400,-turnrate,turnrate )
				AF.r = math.Clamp( AF.r * 400,-turnrate,turnrate )
				
				local AVel = pObj:GetAngleVelocity()
				pObj:AddAngleVelocity( Vector(AF.r,AF.p,AF.y) - AVel ) 
				
				pObj:SetVelocityInstantaneous( self:GetForward() * speed )
			end
		end]]
	end

	local function GetValidEntity(ent)
		return IsValid(ent) and ent or Entity(0)
	end

    function ENT:Think()	
		local curtime = CurTime()
		self:NextThink(curtime)
		
		local Target = self:GetLockOn()
		if IsValid(Target) then
			self:FollowTarget(Target)
		else
			self:BlindFire()
		end

		if self.MarkForRemove then
			self:Detonate()
		end
		
		if self.Explode then
			local Inflictor = self:GetInflictor()
			local Attacker = self:GetAttacker()

			util.BlastDamage(GetValidEntity(Inflictor), GetValidEntity(Attacker), self:GetPos(), 250, 150)
			
			self:Detonate()
		end
		
		if self.LifeTime <= curtime then
			self:Detonate()
		end
		
		return true
	end

    function ENT:PhysicsCollide( data )
		if self:GetDisabled() then
			self.MarkForRemove = true
		else
			local HitEnt = data.HitEntity
			
			if IsValid(HitEnt) && not self.Explode && (HitEnt.LFS || HitEnt.IdentifiesAsLFS) then 
                local Pos = self:GetPos()

                local effectdata = EffectData()
                    effectdata:SetOrigin(Pos)
                    effectdata:SetNormal(-self:GetForward())
                util.Effect("manhacksparks", effectdata, true, true)

                local dmginfo = DamageInfo()
                    dmginfo:SetDamage(500)
                    dmginfo:SetAttacker(IsValid(self:GetAttacker()) && self:GetAttacker() || self)
                    dmginfo:SetDamageType(DMG_BLAST)
                    dmginfo:SetInflictor(self) 
                    dmginfo:SetDamagePosition(Pos) 
                HitEnt:TakeDamageInfo(dmginfo)

                sound.Play("Missile.ShotDown", Pos, 140)
			end
			
			self.Explode = true
		end
	end
else
	function ENT:Initialize()	
		self.snd = CreateSound(self, "weapons/flaregun/burn.wav")
			self.snd:Play()

		local effectdata = EffectData()
			effectdata:SetOrigin(self:GetPos())
			effectdata:SetEntity(self)
		util.Effect("lfs_fb_wingrocket", effectdata)
	end
end