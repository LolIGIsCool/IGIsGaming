include("shared.lua")

function ENT:OnSpawn()
	self:RegisterTrail( Vector(-30,220,82), 0, 20, 2, 600, 150 )
	self:RegisterTrail( Vector(-30,-220,82), 0, 20, 2, 600, 150 )
	
	self:RegisterTrail( Vector(-450,75,110), 0, 20, 2, 500, 150 )
	self:RegisterTrail( Vector(-450,-75,110), 0, 20, 2, 500, 150 )
end

function ENT:OnFrame()
	self:EngineEffects()
end

function ENT:PostDrawTranslucent()
end

function ENT:EngineEffects()
	if not self:GetEngineActive() then return end

	local T = CurTime()

	if (self.nextEFX or 0) > T then return end

	self.nextEFX = T + 0.01
	
		local emitter = ParticleEmitter( self:GetPos(), false )
		local Pos = {
			Vector(-250,0,75),
			}

		if emitter then
			for _, v in pairs( Pos ) do
				local Sub = Mirror and 1 or -1
				local vOffset = self:LocalToWorld( v )
				local vNormal = -self:GetForward()

				vOffset = vOffset + vNormal * 5

				local particle = emitter:Add( "sprites/heatwave", vOffset )
				if not particle then return end

				particle:SetVelocity( vNormal * math.Rand(1500,1000) + self:GetVelocity() )
				particle:SetLifeTime( 0 )
				particle:SetDieTime( 0.1 )
				particle:SetStartAlpha( 255 )
				particle:SetEndAlpha( 0 )
				particle:SetStartSize( math.Rand(35,50) )
				particle:SetEndSize( math.Rand(0,10) )
				particle:SetRoll( math.Rand(-1,1) * 100 )
				
				particle:SetColor( 255, 255, 255 )
			
				Mirror = true
			end
			
			emitter:Finish()
		end
end

function ENT:AnimAstromech()
end

function ENT:AnimCockpit()
end

function ENT:OnStartBoost()
	self:EmitSound( "lvs/vehicles/naboo_n1_starfighter/boost.wav", 125 )
end

function ENT:OnStopBoost()
	self:EmitSound( "lvs/vehicles/naboo_n1_starfighter/brake.wav", 125 )
end
