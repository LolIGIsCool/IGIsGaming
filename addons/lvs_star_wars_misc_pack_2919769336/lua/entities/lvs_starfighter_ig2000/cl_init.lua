include("shared.lua")

function ENT:OnSpawn()
	self:RegisterTrail( Vector(-320,190,100), 0, 20, 2, 1000, 150 )
	self:RegisterTrail( Vector(-320,-190,100), 0, 20, 2, 1000, 150 )
	
	self:RegisterTrail( Vector(-240,0,60), 0, 20, 2, 700, 150 )
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
	render.DrawSprite( self:LocalToWorld( Vector(-250,0,60) ), Size, Size, Color( 255, 200, 100, 255) )
end

function ENT:EngineEffects()
	if not self:GetEngineActive() then return end

	local T = CurTime()

	if (self.nextEFX or 0) > T then return end

	self.nextEFX = T + 0.01

	local THR = self:GetThrottle()

	local emitter = self:GetParticleEmitter( self:GetPos() )

	if not IsValid( emitter ) then return end

	local vOffset = self:LocalToWorld( Vector(-250,0,60) )
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
				
	particle:SetColor( 255, 255, 255 )
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
