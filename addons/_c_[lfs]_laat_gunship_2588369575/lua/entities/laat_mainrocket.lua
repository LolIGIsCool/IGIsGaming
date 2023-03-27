AddCSLuaFile()

ENT.Type            = "anim"
DEFINE_BASECLASS( "lunasflightschool_missile" )

if SERVER then
    function ENT:Initialize()	
		self:SetModel( "models/weapons/w_missile_launch.mdl" )
		self:PhysicsInit( SOLID_VPHYSICS )
		self:SetMoveType( MOVETYPE_VPHYSICS )
		self:SetSolid( SOLID_VPHYSICS )
		self:SetRenderMode( RENDERMODE_TRANSALPHA )
		self:PhysWake()
		local pObj = self:GetPhysicsObject()
		
		if IsValid( pObj ) then
			pObj:EnableGravity( false ) 
			pObj:SetMass( 1 ) 
		end
		
		self.LifeTime = CurTime() + 12
	end

	local function GetValidEntity(ent)
		return IsValid(ent) and ent or Entity(0)
	end

    function ENT:Think()	
		local curtime = CurTime()
		self:NextThink(curtime)
		
		self:BlindFire()
		
		if self.MarkForRemove then
			self:Detonate()
		end
		
		if self.Explode then
			local Inflictor = self:GetInflictor()
			local Attacker = self:GetAttacker()

			util.BlastDamage(GetValidEntity(Inflictor), GetValidEntity(Attacker), self:GetPos(), 500, 500)
			
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
end