ENT.Type 			= "anim"  
ENT.PrintName			= "CW Rocket"  
ENT.Spawnable			= false
ENT.AdminSpawnable		= false
ENT.SoundTbl_OnCollide = "ambient/explosions/explode_8.wav"

local rSound = Sound("Missile.Accelerate")

if SERVER then

AddCSLuaFile( "shared.lua" )

function ENT:Initialize()   

self.flightvector = self.Entity:GetForward() * ((30*15.5)/5)
self.timeleft = CurTime() + 15
self.Owner = self:GetOwner()
self.Entity:SetModel( "models/rocket/Rocket_v1.mdl" )
self.Entity:PhysicsInit( SOLID_VPHYSICS )      -- Make us work with physics,  	
self.Entity:SetMoveType( MOVETYPE_NONE )   --after all, gmod is a physics  	
self.Entity:SetSolid( SOLID_VPHYSICS )        -- CHEESECAKE!    >:3     
self.Entity:EmitSound(rSound, 75, 100)

--self.Entity:SetColor(Color(128 255 0,255))

Glow = ents.Create("env_sprite")
Glow:SetKeyValue("rendercolor","255, 255, 255")
Glow:SetKeyValue("scale","1")
Glow:SetPos(self.Entity:GetPos())
Glow:SetParent(self.Entity)
Glow:Spawn()
Glow:Activate()
self.Entity:SetNWBool("smoke", 10, true)

end   

 function ENT:Think()

		if self.timeleft < CurTime() then
		self.Entity:Remove()
		end

	Table	={} 			//Table name is table name
	Table[1]	=self.Owner 		//The person holding the gat
	Table[2]	=self.Entity 		//The cap

	local trace = {}
		trace.start = self.Entity:GetPos()
		trace.endpos = self.Entity:GetPos() + self.flightvector
		trace.filter = Table
	local tr = util.TraceLine( trace )
	

		if tr.HitSky then
			self.Entity:Remove()
			return true
		end
	
		if tr.Hit then
				local effectdata = EffectData()
					effectdata:SetOrigin(tr.HitPos)			// Where is hits
					effectdata:SetNormal(tr.HitNormal)		// Direction of particles
					effectdata:SetEntity(self.Entity)		// Who done it?
					effectdata:SetScale(0.5)			        // Size of explosion
					effectdata:SetRadius(tr.MatType)		// What texture it hits
					effectdata:SetMagnitude(3)			    // Length of explosion trails
					util.Effect( "boom_effect", effectdata )
					util.BlastDamage(self.Entity, self:OwnerGet(), tr.HitPos, 250, 350)
					util.Decal("Scorch", tr.HitPos + tr.HitNormal, tr.HitPos - tr.HitNormal)
					self.Entity:SetNWBool("smoke", false)
					
			self:Explosion()
			self.Entity:Remove()	
		end
	
	self.Entity:SetPos(self.Entity:GetPos() + self.flightvector)
	self.flightvector = self.flightvector - (self.flightvector/10000000)  + Vector(math.Rand(-0.1,0.1), math.Rand(-0.1,0.1),math.Rand(-0.1,0.1)) + Vector(0,0,-0.01)
	self.Entity:SetAngles(self.flightvector:Angle() + Angle(0,0,0))
	self.Entity:NextThink( CurTime() )
	return true
	
end
 
 function ENT:Explosion()

	self:EmitSound("BaseExplosionEffect.Sound", 500, 100)	
	self.Entity:StopSound(rSound)

	local shake = ents.Create("env_shake")
		shake:SetOwner(self.Owner)
		shake:SetPos(self.Entity:GetPos())
		shake:SetKeyValue("amplitude", "2000")	// Power of the shake
		shake:SetKeyValue("radius", "900")		// Radius of the shake
		shake:SetKeyValue("duration", "2.5")	// Time of shake
		shake:SetKeyValue("frequency", "255")	// How har should the screenshake be
		shake:SetKeyValue("spawnflags", "4")	// Spawnflags(In Air)
		shake:Spawn()
		shake:Activate()
		shake:Fire("StartShake", "", 0)
	
	local ar2Explo = ents.Create("env_fire")
		ar2Explo:SetOwner(self.Owner)
		ar2Explo:SetPos(self.Entity:GetPos())
		ar2Explo:Spawn()
		ar2Explo:Activate()
		ar2Explo:Fire("Explode", "", 0)

end

function ENT:OwnerGet()
	if IsValid(self.Owner) then
		return self.Owner
	else
		return self.Entity
	end
end

end

if CLIENT then
 function ENT:Draw()             
 self.Entity:DrawModel()       // Draw the model.   
 end
 
   function ENT:Initialize()
	pos = self:GetPos()
	self.emitter = ParticleEmitter( pos )
 end
 
 function ENT:Think()
	if (self.Entity:GetNWBool("smoke")) then
	pos = self:GetPos()
		for i=1, (1) do
			local particle = self.emitter:Add( "particle/smokesprites_000"..math.random(1,9), pos + (self:GetForward() * -10 * i))
			if (particle) then
				particle:SetVelocity((self:GetForward() * -400)+(VectorRand()* 10) )
				particle:SetDieTime( math.Rand( 10, 5 ) )
				particle:SetStartAlpha( math.Rand( 15, 25 ) )
				particle:SetEndAlpha( 0 )
				particle:SetStartSize( math.Rand( 20, 20 ) )
				particle:SetEndSize( math.Rand( 1, 1 ) )
				particle:SetRoll( math.Rand(0, 360) )
				particle:SetRollDelta( math.Rand(-1, 1) )
				particle:SetColor( 255 , 255 , 255 ) 
 				particle:SetAirResistance( 200 ) 
 				particle:SetGravity( Vector( 100, 0, 0 ) ) 	
			end
		
		end
	end
end


end