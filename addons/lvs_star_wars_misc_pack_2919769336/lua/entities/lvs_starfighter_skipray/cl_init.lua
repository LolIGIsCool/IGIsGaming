include("shared.lua")

function ENT:OnSpawn()	
	self:RegisterTrail( Vector(-5,73,37), 0, 20, 2, 1000, 150 )
	self:RegisterTrail( Vector(-5,-73,37), 0, 20, 2, 1000, 150 )
	
	self:RegisterTrail( Vector(-140,90,70), 0, 20, 2, 1000, 150 )
	self:RegisterTrail( Vector(-140,-90,70), 0, 20, 2, 1000, 150 )
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

	for i = -1,1,2 do
		local pos = self:LocalToWorld( Vector(-236,0,70) )
		render.DrawSprite( pos, Size, Size, Color( 255, 49, 0, 255) )
	end
end

function ENT:EngineEffects()
	if not self:GetEngineActive() then return end

	local T = CurTime()

	if (self.nextEFX or 0) > T then return end

	self.nextEFX = T + 0.01

	local THR = self:GetThrottle()

	local emitter = self:GetParticleEmitter( self:GetPos() )

	if not IsValid( emitter ) then return end

	for i = -1,1,2 do
		local vOffset = self:LocalToWorld( Vector(-240,0,70) )
		local vNormal = -self:GetForward()

		vOffset = vOffset + vNormal * 5

		local particle = emitter:Add( "effects/muzzleflash2", vOffset )

		if not particle then continue end

		particle:SetVelocity( vNormal * math.Rand(500,1000) + self:GetVelocity() )
		particle:SetLifeTime( 0 )
		particle:SetDieTime( 0.1 )
		particle:SetStartAlpha( 255 )
		particle:SetEndAlpha( 0 )
		particle:SetStartSize( math.Rand(15,25) )
		particle:SetEndSize( math.Rand(0,10) )
		particle:SetRoll( math.Rand(-1,1) * 100 )
			
		particle:SetColor( 255, 50, 200 )
	end
end

function ENT:OnStartBoost()
	self:EmitSound( "lvs/vehicles/naboo_n1_starfighter/boost.wav", 125 )
end

function ENT:OnStopBoost()
	self:EmitSound( "lvs/vehicles/naboo_n1_starfighter/brake.wav", 125 )
end
