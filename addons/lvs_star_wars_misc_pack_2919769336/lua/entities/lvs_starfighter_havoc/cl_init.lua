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

	local Pos2D = weapon:GetEyeTrace().HitPos:ToScreen() 

	self:PaintCrosshairCenter( Pos2D, Col )
	self:PaintCrosshairOuter( Pos2D, Col )
	self:LVSPaintHitMarker( Pos2D )

	return true
end

function ENT:OnSpawn()
	self:RegisterTrail( Vector(-95,220,24), 0, 20, 2, 1000, 150 )
	self:RegisterTrail( Vector(-95,-220,24), 0, 20, 2, 1000, 150 )
	
	self:RegisterTrail( Vector(-160,48,68), 0, 20, 2, 700, 150 )
	self:RegisterTrail( Vector(-160,-48,68), 0, 20, 2, 700, 150 )
end


function ENT:OnFrame()
	self:EngineEffects()
	self:AnimGunner()
end

ENT.EngineGlow = Material( "sprites/light_glow02_add" )

function ENT:PostDrawTranslucent()
	if not self:GetEngineActive() then return end

	local Size = 80 + self:GetThrottle() * 120 + self:GetBoost()
	local Mirror = false

	render.SetMaterial( self.EngineGlow )

	for i = -1,1,2 do
		local pos = self:LocalToWorld( Vector(-120,20 * i,35) )
		render.DrawSprite( pos, Size, Size, Color( 255, 150, 0, 255) )
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
		local vOffset = self:LocalToWorld( Vector(-104.75,-20 * i,30) )
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
				
		particle:SetColor( 255, 100, 200 )
	end
end

function ENT:AnimGunner()
	local Pod = self:GetGunnerSeat()

	if not IsValid( Pod ) then return end

	local weapon = Pod:lvsGetWeapon()

	if not IsValid( weapon ) then return end

	local EyeAngles = self:WorldToLocalAngles( weapon:GetAimVector():Angle() )
	EyeAngles:RotateAroundAxis( EyeAngles:Up(), 180 )

	local Yaw = math.Clamp( EyeAngles.y,-180,180)
	local Pitch = math.Clamp( EyeAngles.p,-180,180 )

	self:ManipulateBoneAngles( 1, Angle(-Yaw,0,0) )
	self:ManipulateBoneAngles( 2, Angle(0,0, math.max( Pitch, -25 ) ) )
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
