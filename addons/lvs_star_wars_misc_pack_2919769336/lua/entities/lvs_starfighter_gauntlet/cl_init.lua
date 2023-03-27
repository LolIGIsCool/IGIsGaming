include("shared.lua")

function ENT:CalcViewOverride( ply, pos, angles, fov, pod )

	if self:GetGunnerSeat() == ply:GetVehicle() then
		if pod:GetThirdPersonMode() then
			return pos + self:GetUp() * 100, angles, fov
		end
	end

	return pos, angles, fov
end

ENT.RED = Color(255,0,0,255)
ENT.WHITE = Color(255,255,255,255)

function ENT:LVSPreHudPaint( X, Y, ply )
	local Pod = self:GetGunnerSeat()

	if Pod ~= ply:GetVehicle() then return true end

	local weapon = Pod:lvsGetWeapon()

	if not IsValid( weapon ) then return true end
	
	local Col = (self:AngleBetweenNormal( weapon:GetAimVector(), weapon:GetForward() ) > 60) and self.RED or self.WHITE

	local Pos2D = weapon:GetEyeTrace().HitPos:ToScreen() 

	self:PaintCrosshairCenter( Pos2D, Col )
	self:PaintCrosshairOuter( Pos2D, Col )
	self:LVSPaintHitMarker( Pos2D )

	return true
end

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

	local Size = 280 + self:GetThrottle() * 120 + self:GetBoost()
	local Mirror = false

	render.SetMaterial( self.EngineGlow )
	render.DrawSprite( self:LocalToWorld( Vector(-480,270,175) ), Size, Size, Color( 255, 200, 0, 255) )
	render.DrawSprite( self:LocalToWorld( Vector(-480,-270,175) ), Size, Size, Color( 255, 200, 0, 255) )
	render.DrawSprite( self:LocalToWorld( Vector(-480,210,175) ), Size, Size, Color( 255, 200, 0, 255) )
	render.DrawSprite( self:LocalToWorld( Vector(-480,-210,175) ), Size, Size, Color( 255, 200, 0, 255) )
end

function ENT:EngineEffects()
	if not self:GetEngineActive() then return end
	
	self.nextEFX = self.nextEFX or 0
	
	if self.nextEFX < CurTime() then
		self.nextEFX = CurTime() + 0.01
		
		local emitter = ParticleEmitter( self:GetPos(), false )
		local Pos = {
			Vector(-495,210,175),
			Vector(-495,-210,175),
			Vector(-495,270,175),
			Vector(-495,-270,175),
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
				particle:SetStartSize( math.Rand(35,55) )
				particle:SetEndSize( math.Rand(1,20) )
				particle:SetRoll( math.Rand(-1,1) * 100 )
				
				particle:SetColor( 200, 250, 200 )
			
				Mirror = true
			end
			
			emitter:Finish()
		end
	end
end

function ENT:AnimAstromech()
end

function ENT:AnimCockpit()
end

function ENT:OnStartBoost()
	self:EmitSound( "w_wing_by_1.wav", 125 )
end

function ENT:OnStopBoost()
	self:EmitSound( "w_wing_by_2.wav", 125 )
end
