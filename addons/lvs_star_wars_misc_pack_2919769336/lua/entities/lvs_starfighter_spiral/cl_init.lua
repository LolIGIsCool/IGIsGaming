include("shared.lua")

function ENT:OnSpawn()
	self:RegisterTrail( Vector(-80,160,0), 0, 20, 2, 500, 150 )
	self:RegisterTrail( Vector(-80,-160,0), 0, 20, 2, 500, 150 )
end

function ENT:OnFrame()
	self:EngineEffects()
end

ENT.EngineGlow = Material( "sprites/light_glow02_add" )
function ENT:PostDrawTranslucent()
	if not self:GetEngineActive() then return end

	local Size = 80 + self:GetThrottle() * 120 + self:GetBoost()
	local Mirror = false

	render.SetMaterial( self.EngineGlow )

	render.DrawSprite( self:LocalToWorld( Vector(-150,71,57) ), Size, Size, Color( 255, 49, 0, 255) )
	render.DrawSprite( self:LocalToWorld( Vector(-150,-74,57) ), Size, Size, Color( 255, 49, 0, 255) )
end

function ENT:EngineEffects()
	if not self:GetEngineActive() then return end

	local T = CurTime()

	if (self.nextEFX or 0) > T then return end

	self.nextEFX = T + 0.01
	
		local emitter = ParticleEmitter( self:GetPos(), false )
		local Pos = {
			Vector(-150,71,57),
			Vector(-150,-74,57),
			}

		if emitter then
			for _, v in pairs( Pos ) do
				local Sub = Mirror and 1 or -1
				local vOffset = self:LocalToWorld( v )
				local vNormal = -self:GetForward()

				vOffset = vOffset + vNormal * 5

				local particle = emitter:Add( "effects/muzzleflash2", vOffset )
				if not particle then return end

				particle:SetVelocity( vNormal * math.Rand(500,1000) + self:GetVelocity() )
				particle:SetLifeTime( 0 )
				particle:SetDieTime( 0.1 )
				particle:SetStartAlpha( 255 )
				particle:SetEndAlpha( 0 )
				particle:SetStartSize( math.Rand(15,25) )
				particle:SetEndSize( math.Rand(0,10) )
				particle:SetRoll( math.Rand(-1,1) * 100 )
				
				particle:SetColor( 255, 50, 200 )
			
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
	self:EmitSound( "lvs/vehicles/vwing/boost.wav", 125 )
end

function ENT:OnStopBoost()
	self:EmitSound( "lvs/vehicles/vwing/brake.wav", 125 )
end
