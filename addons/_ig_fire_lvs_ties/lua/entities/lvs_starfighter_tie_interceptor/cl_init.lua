include("shared.lua")

ENT.TrailAlpha = 10

function ENT:OnSpawn()
    self:RegisterTrail( Vector(-39.84, -38.25, 0), 0, 20, 2, 1000, 150 )
    self:RegisterTrail( Vector(-39.84, 38.25, 0), 0, 20, 2, 1000, 150 )
end

function ENT:OnFrame()
    self:EngineEffects()
    self:AnimCabin()
end

ENT.EngineGlow = Material( "sprites/light_glow02_add" )

function ENT:EngineEffects()
	if not self:GetEngineActive() then return end

    local T = CurTime()

    if (self.nextEFX or 0) > T then return end

    self.nextEFX = T + 0.01
		
    local emitter = ParticleEmitter( self:GetPos(), false )

    if not IsValid( emitter ) then return end

    for i = -1,1,2 do
        local vOffset = self:LocalToWorld(Vector(-39.84, 38.25 * i, 0))
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
        
        particle:SetColor( 255, 100, 200 )
    end

    emitter:Finish()
end

function ENT:PostDrawTranslucent()
	if not self:GetEngineActive() then return end

	local Size = self:GetThrottle() * 80 + self:GetBoost()
	local Mirror = false

	for i = -1,1,2 do
		local pos = self:LocalToWorld( Vector(-39.84, 38.25 * i, 0) )
		
		render.SetMaterial( self.EngineGlow )
		render.DrawSprite( pos, 80, Size, Color( 255, 0, 0) )
		Mirror = true
	end
end

function ENT:AnimCabin()
	local Driver = self:GetDriver()
	if not self:GetAI() then
		if IsValid( Driver )then
			if self:GetSequence() == self:LookupSequence("TopOpen") then
				self:ResetSequence(self:LookupSequence("TopClose"))
			end
		else
			if self:GetSequence() == self:LookupSequence("TopClose") then
				self:ResetSequence(self:LookupSequence("TopOpen"))
			end
		end
	else
		self:ResetSequence(self:LookupSequence("TopClose"))
	end
end

function ENT:OnStartBoost()
	self:EmitSound("TIE_ROAR")
end

function ENT:OnStopBoost()
	self:EmitSound("TIE_ROAR")
end
