AddCSLuaFile()

ENT.Type = "anim"

if SERVER then
	function ENT:Initialize()	
		self:SetModel( "models/weapons/w_missile_launch.mdl" )
		self:PhysicsInit( SOLID_VPHYSICS )
		self:SetMoveType( MOVETYPE_VPHYSICS )
		self:SetSolid( SOLID_VPHYSICS )
		self:SetRenderMode( RENDERMODE_TRANSALPHA )
		self:PhysWake()
		self:SetCollisionGroup( COLLISION_GROUP_WORLD )

		local pObj = self:GetPhysicsObject()
		if IsValid( pObj ) then
			pObj:EnableGravity( false ) 
			pObj:SetMass( 1 ) 
		end

		self.SpawnTime = CurTime()
	end
	
	function ENT:Think()
		if self.SpawnTime + 12 < CurTime() then
			self:Detonate()
		end
		
		local pObj = self:GetPhysicsObject()
		if IsValid( pObj ) then
			pObj:SetVelocityInstantaneous( self:GetForward() * 4000 )
		end
	end

	function ENT:Detonate()
		util.BlastDamage( IsValid( self.inflictor ) and self.inflictor or self, IsValid( self.attacker ) and self.attacker or self, self:GetPos(), 100, 200 )

		local effectdata = EffectData()
			effectdata:SetOrigin( self:GetPos() )
		util.Effect( "lfs_tx-427_main_explosion_red", effectdata )

		self:Remove()
	end

	function ENT:PhysicsCollide( data )
		self:Detonate()
	end
else
	local mat = Material( "sprites/light_glow02_add" )
	local mat_laser = Material( "effects/spark" )
	local blue = Color(255,0,0,255)
	local white = Color(255,255,255,255)
	function ENT:Draw()
		local pos = self:GetPos()
		local dir = self:GetForward()
		local length = 100

		render.SetMaterial( mat_laser )
		render.DrawBeam( pos + dir * length, pos, 40, 1, 0, blue )
		render.DrawBeam( pos + dir * length, pos, 15, 1, 0, white )

		render.SetMaterial( mat )
		render.DrawSprite( pos + dir * length * 0.3, 100, 100, blue )
		render.DrawSprite( pos + dir * length * 0.45, 100, 100, blue )
		render.DrawSprite( pos + dir * length * 0.6, 100, 100, blue )
		render.DrawSprite( pos + dir * length * 0.75, 100, 100, blue )
		render.DrawSprite( pos + dir * length * 0.9, 100, 100, blue )
	end
end