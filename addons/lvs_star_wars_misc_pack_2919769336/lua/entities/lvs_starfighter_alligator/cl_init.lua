include("shared.lua")

function ENT:OnSpawn()
	self:RegisterTrail( Vector(-160,155,35), 0, 20, 2, 600, 150 )
	self:RegisterTrail( Vector(-160,-155,35), 0, 20, 2, 600, 150 )
end

function ENT:OnFrame()
	self:EngineEffects()
	self:AnimAstromech()
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
			Vector(-200,0,35),
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
				particle:SetStartSize( math.Rand(15,30) )
				particle:SetEndSize( math.Rand(0,10) )
				particle:SetRoll( math.Rand(-1,1) * 100 )
				
				particle:SetColor( 255, 255, 255 )
			
				Mirror = true
			end
			
			emitter:Finish()
		end
end

function ENT:AnimAstromech()
	local T = CurTime()

	if (self.nextAstro or 0) < T then
		self.nextAstro = T + math.Rand(2,5)

		local HasShield = self:GetShield() > 0

		if self.OldShield == true and not HasShield then
			self:EmitSound( "lvs/vehicles/naboo_n1_starfighter/astromech/shieldsdown"..math.random(1,2)..".ogg" )
		else
			if math.random(0,4) == 3 then
				self:EmitSound( "lvs/vehicles/naboo_n1_starfighter/astromech/"..math.random(1,11)..".ogg" )
			end
		end
		
		self.OldShield = HasShield
	end
end

function ENT:AnimCockpit()
end

function ENT:OnStartBoost()
	self:EmitSound( "lvs/vehicles/naboo_n1_starfighter/boost.wav", 125 )
end

function ENT:OnStopBoost()
	self:EmitSound( "lvs/vehicles/naboo_n1_starfighter/brake.wav", 125 )
end
