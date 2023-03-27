AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )
include("shared.lua")

function ENT:SpawnFunction( ply, tr, ClassName )

	if not tr.Hit then return end

	local ent = ents.Create( ClassName )
	ent.dOwnerEntLFS = ply
	ent:SetPos( tr.HitPos + tr.HitNormal * 60 )
	ent:Spawn()
	ent:Activate()

	return ent

end

function ENT:RunOnSpawn()
	local cpd = "lava_skiff_stand"
	self:GetChildren()[1]:SetVehicleClass(cpd)
	self:SetAutomaticFrameAdvance(true)

	local Pod
	for i = 0, 3 do
		for j = 0, 2 do
			Pod = self:AddPassengerSeat( Vector(80 - 40 * i,40 - 40 * j,25), Angle(0,-90,0) )
			Pod:SetVehicleClass(cpd)
		end
	end
end

function ENT:OnTick()
	local Pod = self:GetDriverSeat()
	if not IsValid( Pod ) then return end

	local Driver = Pod:GetDriver()

	local FT = FrameTime()

	local PObj = self:GetPhysicsObject()
	local MassCenterL = PObj:GetMassCenter()
	local MassCenter = self:LocalToWorld( MassCenterL )
	self:SetMassCenter( MassCenter )

	local Forward = self:GetForward()
	local Right = self:GetRight()
	local Up = self:GetUp()

	self:DoTrace()

	local Trace = self.GroundTrace
	if self.WaterTrace.Fraction <= Trace.Fraction and !self.IgnoreWater and self:GetEngineActive() then
		Trace = self.WaterTrace
	end

	local IsOnGround = true//Trace.Hit and math.deg( math.acos( math.Clamp( Trace.HitNormal:Dot( Vector(0,0,1) ) ,-1,1) ) ) < 70
	PObj:EnableGravity( not IsOnGround )
	local vAngles = PObj:GetAngles().y
	PObj:SetAngles(Angle(0,vAngles,360))

	local EyeAngles = Angle(0,0,0)
	local KeyForward = false
	local KeyBack = false
	local KeyLeft = false
	local KeyRight = false

	local Sprint = false

	if IsValid( Driver ) then
		EyeAngles = Driver:EyeAngles()
		KeyForward = Driver:lfsGetInput( "+THROTTLE" ) or self.IsTurnMove
		KeyBack = Driver:lfsGetInput( "-THROTTLE" )
		if self.CanMoveSideways then
			KeyLeft = Driver:lfsGetInput( "+ROLL" )
			KeyRight = Driver:lfsGetInput( "-ROLL" )
		end

		if KeyBack then
			KeyForward = false
		end

		if KeyLeft then
			KeyRight = false
		end

		Sprint = Driver:lfsGetInput( "VSPEC" ) or Driver:lfsGetInput( "+PITCH" ) or Driver:lfsGetInput( "-PITCH" )

		self:MainGunPoser( Pod:WorldToLocalAngles( EyeAngles ) )
	end
	local MoveSpeed = Sprint and self.BoostSpeed or self.MoveSpeed

	if (IsOnGround) then
		local pos = Vector( self:GetPos().x, self:GetPos().y, Trace.HitPos.z + self.HeightOffset)
		local speedVector = Vector(0,0,0)

		if IsValid( Driver ) && !Driver:lfsGetInput( "FREELOOK" ) && self:GetEngineActive() then
			local lookAt = Vector(0,-1,0)
			lookAt:Rotate(Angle(0,Pod:WorldToLocalAngles( EyeAngles ).y,0))
			self.StoredForwardVector = lookAt
		else
			local lookAt = Vector(0,-1,0)
			lookAt:Rotate(Angle(0,self:GetAngles().y,0))
			self.StoredForwardVector = lookAt
		end

		local ang = self:LookRotation( self.StoredForwardVector, Trace.HitNormal ) - Angle(0,0,90)
		if self:GetEngineActive() then
			speedVector = Forward * ((KeyForward and MoveSpeed or 0) - (KeyBack and MoveSpeed or 0)) + Right * ((KeyLeft and MoveSpeed or 0) - (KeyRight and MoveSpeed or 0))
		end

		self.deltaV = LerpVector( self.LerpMultiplier * FT, self.deltaV, speedVector )
		self:SetDeltaV( self.deltaV )
		pos = pos + self.deltaV
		self:SetIsMoving(pos != self:GetPos())

		self.ShadowParams.pos = pos
		self.ShadowParams.angle = ang
		PObj:ComputeShadowControl( self.ShadowParams )
	end

	local GunnerPod = self:GetGunnerSeat()
	if IsValid( GunnerPod ) then
		local Gunner = GunnerPod:GetDriver()
		if Gunner ~= self:GetGunner() then
			self:SetTurretDriver( Gunner )
		end
	end

	local TurretPod = self:GetTurretSeat()
	if IsValid( TurretPod ) then
		local TurretDriver = TurretPod:GetDriver()
		if TurretDriver ~= self:GetTurretDriver() then
			self:SetTurretDriver( TurretDriver )
		end
	end
	self:Gunner( self:GetGunner(), GunnerPod )
	self:Turret( self:GetTurretDriver(), TurretPod )
end

function ENT:PrimaryAttack()
	if not self:GetEngineActive() then return end
	self.HeightOffset = self.HeightOffset + 5
	if self.HeightOffset > 250 then self.HeightOffset = 250 end
end

function ENT:SecondaryAttack()
	if not self:GetEngineActive() then return end
	self.HeightOffset = self.HeightOffset - 5
	if self.HeightOffset < 0 then self.HeightOffset = 0 end
end

function ENT:MainGunPoser( EyeAngles )
end

function ENT:OnKeyThrottle( bPressed )
end

function ENT:OnLandingGearToggled( bOn )
end

function ENT:OnEngineStarted()
	--local holod = self.GetDriver()
	local Pod = self:GetDriverSeat()
	if not IsValid( Pod ) then return end
	local Driver = Pod:GetDriver()
	-- if IsValid( Driver ) then
		-- Driver:SetMaterial("models/props_combine/stasisshield_sheet")
	-- else
		-- Driver:SetMaterial()
	-- end
end

function ENT:OnEngineStopped()
	self.HeightOffset = 0
	local Pod = self:GetDriverSeat()
	if not IsValid( Pod ) then return end
	local Driver = Pod:GetDriver()
	-- if IsValid( Driver ) then
		-- Driver:SetMaterial()
	-- end
end

function ENT:OnRemove()
	local Pod = self:GetDriverSeat()
	if not IsValid( Pod ) then return end
	local Driver = Pod:GetDriver()
	-- if IsValid( Driver ) then
		-- Driver:SetMaterial()
	-- end
end
