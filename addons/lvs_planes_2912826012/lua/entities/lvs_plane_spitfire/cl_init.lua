include("shared.lua")

function ENT:OnSpawn()
	self:RegisterTrail( Vector(60,205,70), 0, 20, 2, 1000, 400 )
	self:RegisterTrail( Vector(60,-205,70), 0, 20, 2, 1000, 400 )
end

function ENT:OnFrame()
	local FT = RealFrameTime()

	self:AnimControlSurfaces( FT )
	self:AnimLandingGear( FT )
	self:AnimCabin( FT )
	self:AnimRotor( FT )
end

function ENT:AnimRotor( frametime )
	if not self.RotorRPM then return end

	local PhysRot = self.RotorRPM < 470

	self._rRPM = self._rRPM and (self._rRPM + self.RotorRPM *  frametime * (PhysRot and 4 or 1)) or 0

	local Rot = Angle( self._rRPM,0,0)
	Rot:Normalize() 
	self:ManipulateBoneAngles( 12, Rot )

	self:SetBodygroup( 1, PhysRot and 0 or 1 ) 
end

function ENT:AnimControlSurfaces( frametime )
	local FT = frametime * 10

	local Steer = self:GetSteer()

	local Pitch = -Steer.y * 30
	local Yaw = -Steer.z * 20
	local Roll = math.Clamp(-Steer.x * 60,-30,30)

	self.smPitch = self.smPitch and self.smPitch + (Pitch - self.smPitch) * FT or 0
	self.smYaw = self.smYaw and self.smYaw + (Yaw - self.smYaw) * FT or 0
	self.smRoll = self.smRoll and self.smRoll + (Roll - self.smRoll) * FT or 0

	self:ManipulateBoneAngles( 1, Angle( 0,0,-self.smRoll) )
	self:ManipulateBoneAngles( 2, Angle( 0,0,self.smRoll) )
	
	self:ManipulateBoneAngles( 3, Angle( 0,0,-self.smPitch) )
	
	self:ManipulateBoneAngles( 9, Angle( 0,self.smYaw,0 ) )
end

function ENT:AnimCabin( frametime )
	local bOn = self:GetActive()
	
	local TVal = bOn and 0 or 1
	
	local Speed = frametime * 4
	
	self.SMcOpen = self.SMcOpen and self.SMcOpen + math.Clamp(TVal - self.SMcOpen,-Speed,Speed) or 0

	self:ManipulateBonePosition( 11, Vector( 0,-self.SMcOpen * 18,self.SMcOpen * 1.5) ) 
end

function ENT:AnimLandingGear( frametime )
	self._smLandingGear = self._smLandingGear and self._smLandingGear + (90 *  (1 - self:GetLandingGear()) - self._smLandingGear) * frametime * 8 or 0
	
	self:ManipulateBoneAngles( 8, Angle( -self._smLandingGear,-self._smLandingGear * 0.335,0 ) )
	self:ManipulateBonePosition( 8, Vector( self._smLandingGear * 0.022,-self._smLandingGear * 0.005,0) ) 
	
	self:ManipulateBoneAngles( 7, Angle( self._smLandingGear,self._smLandingGear * 0.335,0 ) )
	self:ManipulateBonePosition( 7, Vector( -self._smLandingGear * 0.022,-self._smLandingGear * 0.005,0) ) 
	
	self:ManipulateBoneAngles( 4, Angle( 0,0,45 - self._smLandingGear / 2) )
	
	self:ManipulateBoneAngles( 5, Angle( 0,0,45 - self._smLandingGear / 2) )
end

