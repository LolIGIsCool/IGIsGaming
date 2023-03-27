AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )
include('shared.lua')

function ENT:SpawnFunction( ply, tr, ClassName )

	if ( !tr.Hit ) then return end

	local ent = ents.Create( ClassName )
	ent:SetPos( tr.HitPos + tr.HitNormal * size )
	ent:Spawn()
	ent:Activate()

	return ent

end

function ENT:Initialize()	
	self:SetModel( "models/weapons/w_missile_launch.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_NONE )
	self:SetRenderMode( RENDERMODE_TRANSALPHA )
	
	local pObj = self:GetPhysicsObject()
	
	if IsValid( pObj ) then
		pObj:EnableMotion( false )  
	end
	
	self.SpawnTime = CurTime()
	self.Vel = self:GetForward() * self.MoveSpeed
end

function ENT:Think()	
	local curtime = CurTime()
	self:NextThink( curtime )
	
	local Size = self:GetSize() * 0.5
	local FixTick = FrameTime() * 80
	
	local trace = util.TraceHull( {
		start = self:GetPos(),
		endpos = self:GetPos() + self.Vel * FixTick,
		maxs = Size,
		mins = -Size,
		filter = self.Filter
	} )
	
	if trace.Hit then
		self:SetPos( trace.HitPos )
		
		local shootDirection = self:GetForward()
		
		local bullet = {}
			bullet.Num 			= 1
			bullet.Src 			= self:GetPos() - shootDirection * 50
			bullet.Dir 			= shootDirection
			bullet.Spread 		= Vector(0,0,0)
			bullet.Tracer		= -1
			bullet.TracerName	= "simfphys_tracer"
			bullet.Force		= self.Force
			bullet.Damage		= self.Damage
			bullet.HullSize		= self:GetSize()
			bullet.Attacker 	= self.Attacker
			bullet.Callback = function(att, tr, dmginfo)
				dmginfo:SetDamageType(DMG_BLAST)
				local attackingEnt = IsValid( self.AttackingEnt ) and self.AttackingEnt or self
				util.BlastDamage( attackingEnt, self.Attacker, tr.HitPos,self.BlastRadius,self.BlastDamage)
				
				util.Decal("", tr.HitPos - tr.HitNormal, tr.HitPos + tr.HitNormal)
			end
			
		self:FireBullets( bullet )

		if self.IsTB then
			for k, v in pairs(ents.FindInSphere(self:GetPos(), self.TBRadius)) do
					if IsValid(v) then
						if v:IsNPC() or v:IsPlayer() then
								if v:IsPlayer() and not v:InVehicle() or v:IsNPC() and v:GetPos():Distance(self:GetPos()) < self.TBRadius then
									local dmginfo = DamageInfo()
										dmginfo:SetDamage( self.TBDamage )
										dmginfo:SetDamageType( DMG_BURN ) 
										dmginfo:SetAttacker( self.Attacker )
									v:TakeDamageInfo( dmginfo )
								end
							end
						end
					end
				end
		
		
		self:Remove()
	else
		self:SetPos( self:GetPos() + self.Vel * FixTick )
		
		self.Vel = self.Vel - Vector(0,0,self.Faloff) * FixTick
	end
	
	if (self.SpawnTime + 100) < curtime then
		self:Remove()
	end
	
	return true
end

function ENT:PhysicsCollide( data )
end

function ENT:OnTakeDamage( dmginfo )
	return
end

function ENT:Use( activator, caller )
end