AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )
include("shared.lua")

function ENT:SpawnFunction( ply, tr, ClassName )
	if not tr.Hit then return end

	local ent = ents.Create( ClassName )
	ent.dOwnerEntLFS = ply
	ent:SetPos( tr.HitPos + tr.HitNormal )
	ent:Spawn()
	ent:Activate()
	
	return ent
end

function ENT:RunOnSpawn()
	local x = ents.Create("prop_dynamic")
	x:SetModel("models/KingPommes/starwars/hailfire/hailfire_wheel_r.mdl")
	x:SetPos(self:GetPos())
	x:SetAngles(self:GetAngles())
	x:SetParent(self)
	x:Spawn()
	x:Activate()
	self.WR = x

	local y = ents.Create("prop_dynamic")
	y:SetModel("models/KingPommes/starwars/hailfire/hailfire_wheel_l.mdl")
	y:SetPos(self:GetPos())
	y:SetAngles(self:GetAngles())
	y:SetParent(self)
	y:Spawn()
	y:Activate()
	self.WL = y
	
	self.WL:ResetSequence(self.WL:LookupSequence("idle"))
	self.WR:ResetSequence(self.WR:LookupSequence("idle"))
	self.WL:SetPlaybackRate(0)
	self.WR:SetPlaybackRate(0)
	
	local e = ents.Create("info_target")
	e:SetPos(self:GetPos()+self:GetUp()*142+self:GetForward()*64)
	e:SetAngles(self:GetAngles())
	e:SetParent(self)
	e:Spawn()
	e:Fire("AddOutput", "targetname target", 0)
	self.Target = e

	local z = ents.Create("npc_launcher")
	z:SetPos(self:GetPos())
	z:SetAngles(self:GetAngles() + Angle(0,90,85))
	z:SetParent(self)
	z:Spawn()
	z:Activate()
	z:Fire("SetEnemyEntity", "target")
	z:Fire("AddOutput", "damage 1000")
	z:Fire("AddOutput", "DamageRadius 300")
	z:Fire("AddOutput", "FlySound KingPommes/starwars/hailfire/flying.wav")
	z:Fire("AddOutput", "Gravity 2.5")
	z:Fire("AddOutput", "HomingDelay 0")
	z:Fire("AddOutput", "HomingDuration 0")
	z:Fire("AddOutput", "HomingStrength 0")
	z:Fire("AddOutput", "LaunchSmoke 1")
	z:Fire("AddOutput", "SmokeTrail 1")
	z:Fire("AddOutput", "LaunchSound KingPommes/starwars/hailfire/rocket.wav")
	z:Fire("AddOutput", "LaunchSpeed 2222")
	z:Fire("AddOutput", "MaxRange 99999")
	z:Fire("AddOutput", "MinRange 100")
	z:Fire("AddOutput", "MissileModel models/kingpommes/starwars/hailfire/hailfire_rocket_flying.mdl")
	z:Fire("AddOutput", "SpinMagnitude 50")
	z:Fire("AddOutput", "SpinSpeed 3")
	self.Launcher = z
	
	self:SpawnRockets()
	
	self.rocketnum = 1
end

function ENT:SpawnRockets()

	self.Rocket = {}
	for k=1, 30, 1 do
		local rocket = "rocket" .. k
		local i = ents.Create("base_anim")
		i:SetModel("models/KingPommes/starwars/hailfire/hailfire_rocket.mdl")
		i:SetPos(self:GetAttachment(self:LookupAttachment(rocket)).Pos)
		i:SetAngles(self:GetAttachment(self:LookupAttachment(rocket)).Ang)
		i:SetParent(self)
		i:Spawn()
		i:Activate()
		self.Rocket[k] = i
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
	
	local IsOnGround = Trace.Hit and math.deg( math.acos( math.Clamp( Trace.HitNormal:Dot( Vector(0,0,1) ) ,-1,1) ) ) < 70
	PObj:EnableGravity( not IsOnGround )
	
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
	
	if self.LastSkin ~= self:GetSkin() then
		self.LastSkin = self:GetSkin()
		self.WL:SetSkin(self.LastSkin)
		self.WR:SetSkin(self.LastSkin)
	end

	if self.LastColor ~= self:GetColor() then
		self.LastColor = self:GetColor()
		self.WL:SetColor(self.LastColor)
		self.WR:SetColor(self.LastColor)
	end
	
	EndSpeedL = self:GetForwardVelocity()/700
	self.WL:SetPlaybackRate(EndSpeedL)
				
	EndSpeedR = self:GetForwardVelocity()/700
	self.WR:SetPlaybackRate(EndSpeedR)
	
	local Driver = self:GetDriver()
	if not IsValid( Driver ) then return end
	local aimx = math.Clamp(Driver:EyeAngles().x, -25, 15)
	local yaw = Driver:GetVehicle():WorldToLocalAngles( Driver:EyeAngles() )
	local aimy = math.AngleDifference(yaw.y, self:EyeAngles().y)
	aimy = math.Clamp( aimy,-33,33)
	self:ManipulateBoneAngles(self:LookupBone("bone_turret_2"), Angle(0,0,-aimx))
	self:ManipulateBoneAngles(self:LookupBone("bone_turret_1"), Angle(aimy,0,0))
end

function ENT:PrimaryAttack()
	if not self:CanPrimaryAttack() then return end
	local Driver = self:GetDriver()
	if not IsValid( Driver ) then return end

	self:EmitSound( "KingPommes/starwars/hailfire/laser.wav" )
	
	self:SetNextPrimary( 0.2 )
	
	local canon = self:GetAttachment(self:LookupAttachment("barrel"))
	
	if not canon then return end
	
	local bullet = {}
	bullet.Num 	= 1
	bullet.Src 	= canon.Pos
	bullet.Dir 	= canon.Ang:Forward()
	bullet.Spread 	= Vector( 0.01,  0.01, 0.01 )
	bullet.Tracer	= 1
	bullet.TracerName	= "lfs_laser_red"
	bullet.Force	= 100
	bullet.HullSize 	= 50
	bullet.Damage	= 20
	bullet.Attacker 	= self:GetDriver()
	bullet.AmmoType = "Pistol"
	bullet.Callback = function(att, tr, dmginfo)
	dmginfo:SetDamageType(DMG_AIRBOAT)
	end
	self:FireBullets( bullet )
	self:TakePrimaryAmmo()
end

function ENT:SecondaryAttack()
	if not self:CanSecondaryAttack() then return end
	
	self:SetNextSecondary( 0.75 )
	
	if self.rocketnum < 31 then
		self.Launcher:SetPos(self:GetAttachment(self:LookupAttachment("rocket" .. self.rocketnum)).Pos + self:GetForward() * 48)
		self.Launcher:Fire("FireOnce")
		self.Rocket[self.rocketnum]:Remove()
		self.rocketnum = self.rocketnum + 1
		self:TakeSecondaryAmmo()
	else
		if not timer.Exists("ReloadRockets") then
			timer.Create("ReloadRockets", 5, 1, function()
				if not IsValid(self) then return end
				self.rocketnum = 1
				self:EmitSound(Sound("ambient/levels/caves/ol04_gearengage.wav"), 120, math.random(90,110))
				self:SpawnRockets()
				self:SetAmmoSecondary(31)
			end)
		end
	end
end

function ENT:MainGunPoser( EyeAngles )
end

function ENT:OnKeyThrottle( bPressed )
end

function ENT:OnLandingGearToggled( bOn )
end

function ENT:OnEngineStarted()
	self:EmitSound( "hailfire_droid/engine_on.wav" )
end

function ENT:OnEngineStopped()
	self:EmitSound( "hailfire_droid/engine_off.wav" )
end