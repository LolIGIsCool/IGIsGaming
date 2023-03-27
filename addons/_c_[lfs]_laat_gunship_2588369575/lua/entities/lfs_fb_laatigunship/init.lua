AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )
include("shared.lua")

function ENT:SpawnFunction( ply, tr, ClassName )
	if not tr.Hit then return end

	local ent = ents.Create( ClassName )
	ent.dOwnerEntLFS = ply
	ent:SetPos( tr.HitPos + tr.HitNormal * 50 )
    local angs = ply:GetAngles()
		angs.z = 0
		angs.x = 0
        angs.y = angs.y + 180
	ent:SetAngles(angs)
    ent:Spawn()
	ent:Activate()

	return ent
end

function ENT:RunOnSpawn()
	local pod = self:GetDriverSeat()
		pod.ExitPos = Vector(170, 0, 36)
		pod:SetCameraDistance(1)
	
	local GunnerSeat = self:AddPassengerSeat(Vector(180, 0, 160), Angle(0, -90, 0))
		GunnerSeat.ExitPos = Vector(170, 0, 36)
	self:SetGunnerSeat(GunnerSeat)

	do
		local BallTurretPod = self:AddPassengerSeat(Vector(0, 0, 100), Angle(0, -90, 0))
			-- BallTurretPod:SetColor(Color(255, 255, 255, 255))

		local ID = self:LookupAttachment("L_Ball_Attachement")
		local Muzzle = self:GetAttachment(ID)
		
		if Muzzle then
			local Pos, Ang = LocalToWorld(Vector(0, 0, 0), Angle(0, -90, 15), Muzzle.Pos, Muzzle.Ang)
			
			BallTurretPod:SetParent(NULL)
			BallTurretPod:SetPos(Pos)
			BallTurretPod:SetAngles(Ang)
			BallTurretPod:SetParent(self, ID)

			self:SetBTPodL(BallTurretPod)
		end
	end
	
	do
		local BallTurretPod = self:AddPassengerSeat(Vector(0, 0, 100), Angle(0, -90, 0))
			-- BallTurretPod:SetColor(Color(255, 255, 255, 255))
		
		local ID = self:LookupAttachment("R_Ball_Attachement" )
		local Muzzle = self:GetAttachment(ID)
		
		if Muzzle then
			local Pos, Ang = LocalToWorld(Vector(0, 0, 0), Angle(0, 90, 15), Muzzle.Pos, Muzzle.Ang)
			
			BallTurretPod:SetParent(NULL)
			BallTurretPod:SetPos(Pos)
			BallTurretPod:SetAngles(Ang)
			BallTurretPod:SetParent(self, ID)

			self:SetBTPodR(BallTurretPod)
		end
	end

	local seat = self:AddPassengerSeat(Vector(-60, 0, 7), Angle(0, 90, 0))
		seat.ExitPos = Vector(135, 0, 36)
	self:SetLoadMasterSeat(seat)

	self:AddPassengerSeat(Vector(135, 0, 7), Angle(0, 90, 0)).ExitPos = Vector(135, 0, 36)

	local ang1, ang2, ang3 = Angle(0, 0, 0), Angle(0, -90, 0), Angle(0, 180, 0) -- Avoid recreating same angles multiple times
	for i = 0, 5 do
		local X = i * 35
		local Y = 35 + i * 3
		
		self:AddPassengerSeat(Vector(120 - X, Y, 7), ang1).ExitPos = Vector(10 - X, 25, 33)
		if i <= 3 then 
			self:AddPassengerSeat(Vector(105 - X, 0, 7), ang2).ExitPos = Vector(10 - X, 0, 33)
		end
		self:AddPassengerSeat(Vector(120 - X, -Y, 7), ang3).ExitPos = Vector(10 - X, -25, 33)
	end

	self:SetPoseParameter("left_side_turret_z", 0)
	self:SetPoseParameter("left_side_turret_y", -5)
	self:SetPoseParameter("right_side_turret_z", 0)
	self:SetPoseParameter("right_side_turret_y", 5)

	self:OnBallturretMounted(self:IsBallmounted(), nil)

	if FrameTime() > 0.067 then
		self.MaxTurnPitch = 70
		self.MaxTurnYaw = 70
		self.MaxTurnRoll = 70

		self.PitchDamping = 1
		self.YawDamping = 1
		self.RollDamping = 1

		self.TurnForcePitch = 3000
		self.TurnForceYaw = 3000
		self.TurnForceRoll = 400
	end

	-- Avoid recreating the same arrays/damageinfo several times
	self.RocketTrData = {
		mins = Vector(-40, -40, -40),
		maxs = Vector(40, 40, 40),
		filter = function(e)
			return e ~= self
		end,
	}

	self.PrimaryBulletData = {
		Num 		= 1,
		Spread 		= Vector(0.025,  0.025, 0),
		Tracer		= 1,
		TracerName	= "lfs_laser_green",
		Force		= 100,
		HullSize 	= 20,
		Damage		= 63,
		AmmoType 	= "Pistol",
		Callback = function(att, tr, dmginfo)
			dmginfo:SetDamageType(DMG_AIRBOAT)
		end,
	}

	self.RearGunBulletData = {
		Num 		= 1,
		Spread 		= Vector(0.02,  0.02, 0),
		Tracer		= 1,
		TracerName	= "lfs_laser_green",
		Force		= 100,
		HullSize 	= 20,
		Damage		= 125,
		AmmoType 	= "Pistol",
		Callback = function(att, tr, dmginfo)
			dmginfo:SetDamageType(DMG_AIRBOAT)
		end,
	}

	self.PhysicDamage = DamageInfo()
		self.PhysicDamage:SetDamageType(DMG_DIRECT)

	-- Rocketlauncher & hatch models are separated to play their animation and the doors animation at the same time
	self.RocketsModel = ents.Create("laat_rocketlauncher")
		self.RocketsModel:SetPos(self:GetPos())
		self.RocketsModel:SetAngles(self:GetAngles())
		self.RocketsModel:SetParent(self)
		self.RocketsModel:Spawn()

	self.HatchModel = ents.Create("laat_hatch")
		self.HatchModel:SetPos(self:GetPos())
		self.HatchModel:SetAngles(self:GetAngles())
		self.HatchModel:SetParent(self)
		self.HatchModel:Spawn()

	self.NextLanding = 0
	self.closeSequence = ""
	self.NextLaunchWingRocket = 0

	self.MirrorWingRocket = 0
	self.WingRocketPos = {
		[0] = Vector(-30, 265, 130),
		[1] = Vector(-30, -265, 130),
	}
	self.TimeLock = 0

	self:SetWingTurretHeat(0)
	self.NextReduceWingTurretHeat = 0
	self.NextUpWingTurretHeat = 0

	self:InitDoors()
	self.NextUseHatch = 0

	self:SetBallTurretLHeat(0)
	self.NextReduceBallTurretLHeat = 0
	self.NextUpBallTurretLHeat = 0

	self:SetBallTurretRHeat(0)
	self.NextReduceBallTurretRHeat = 0
	self.NextUpBallTurretRHeat = 0

	self.OldSkin = self:GetSkin()

	self.NextFind = 0
	self.HeldEntities = {}
	self.NextGrab = 0
	self.NextDrop = 0

	self.DamageSounds = {
		"physics/metal/metal_sheet_impact_bullet2.wav",
		"physics/metal/metal_sheet_impact_hard2.wav",
		"physics/metal/metal_sheet_impact_hard6.wav",
	}

	self.DoorMode = 0

	self.Light = ents.Create("light_dynamic")
		self.Light:SetKeyValue("brightness", "6")
		self.Light:SetKeyValue("distance", "150")
		self.Light:SetPos(self:GetPos() + self:GetForward() * 50 + self:GetUp() * 120 + self:GetRight() * 3)
		self.Light:SetLocalAngles(Angle(0, 0, 0))
		self.Light:Fire("Color", "255 0 0")
		self.Light:SetParent(self)
		self.Light:Spawn()
		self.Light:Activate()
		self.Light:Fire("TurnOn", "", 0)
		self:DeleteOnRemove(self.Light)

	self.Light2 = ents.Create("light_dynamic")
		self.Light2:SetKeyValue("brightness", "6")
		self.Light2:SetKeyValue("distance", "150")
		self.Light2:SetPos(self:GetPos() + self:GetForward() * -60 + self:GetUp() * 120 + self:GetRight() * 3)
		self.Light2:SetLocalAngles(Angle(0, 0, 0))
		self.Light2:Fire("Color", "255 0 0")
		self.Light2:SetParent(self)
		self.Light2:Spawn()
		self.Light2:Activate()
		self.Light2:Fire("TurnOn", "", 0)
		self:DeleteOnRemove(self.Light2)

	self.nextLFX = 0
	self.nextLightState = "TurnOff"

	self.IsLightOn = true
	self.LastLightState = 1
	self:SetLampMode(1)
end

function ENT:GetLoadMaster()
	local seat = self:GetLoadMasterSeat()
	return IsValid(seat) && seat:GetDriver() || NULL
end

function ENT:CreateDoor(pos, ang, model)
	local door = ents.Create("prop_dynamic")
		door:SetModel(model || "models/fisher/laat/door_phys.mdl")
		door:SetPos(pos)
		door:SetAngles(ang)
		door:SetColor(Color(255, 255, 255, 0))
		door:SetRenderMode(RENDERMODE_TRANSALPHA)
		door:PhysicsInit(SOLID_VPHYSICS)
		door:SetSolid(SOLID_VPHYSICS)
		door:Spawn()
		door:Activate()
		door:SetParent(self)
		door:SetLightingOriginEntity(self)
		self:DeleteOnRemove(door)
		door:DeleteOnRemove(self)
		door.LAATDoor = true

		function door:OnTakeDamage(dmginfo)
			self:TakeDamageInfo(dmginfo)
		end

	constraint.NoCollide(door, self, 0, 0)

	return door
end

function ENT:PhysicsCollide( data, physobj )
	if self:IsDestroyed() then
		self.MarkForDestruction = true
	end
	
	if IsValid( data.HitEntity ) then
		if data.HitEntity:IsPlayer() or data.HitEntity:IsNPC() or simfphys.LFS.CollisionFilter[ data.HitEntity:GetClass():lower() ] then
			return
		end
	end

	if self:GetUncontrollable() then
		if self:GetEngineActive() then 
			self:StopEngine() 
			self.IsCrashed = true
		end

		if self:HitGround() then
			physobj:SetVelocity(physobj:GetVelocity() * 0.25)
			physobj:SetAngleVelocity(physobj:GetAngleVelocity() * 0.25)
		end
	end

	if data.Speed > 60 and data.DeltaTime > 0.2 then
		local VelDif = data.OurOldVelocity:Length() - data.OurNewVelocity:Length()

		if VelDif > 500 then
			self:EmitSound("Airboat_impact_hard")

			local hitDamage = self.PhysicDamage
				hitDamage:SetDamage(VelDif)
				hitDamage:SetAttacker(data.HitEntity)
				hitDamage:SetInflictor(data.HitEntity)
				hitDamage:SetDamagePosition(data.HitPos)
				hitDamage:SetDamageForce(data.HitNormal)

				self.ExplosionEffectPostDamage = true

			self:TakeDamageInfo(hitDamage)
		else
			self:EmitSound("MetalVehicle.ImpactSoft")
		end
	end
end

function ENT:CreateHatch(pos, ang)
	return self:CreateDoor(pos, ang, "models/fisher/laat/hatch_phys.mdl")
end

function ENT:InitDoors()
	self.Doors = {}

	local bonePos, boneAng = self:GetBonePosition(self:LookupBone("LAAT")) 
	local boneAngL = Angle(boneAng.p, boneAng.y, boneAng.r)
		boneAngL.y = boneAngL.y - 90

	local offset = self:GetRight() * 10 + self:GetForward() * 0 + self:GetUp() * -110
	local door = self:CreateDoor(bonePos + offset, boneAngL)
	self.Doors["L_Door2"] = {ent = door, closeoffset = Vector(10, 0, -110), openoffsethalf = Vector(-20, -140, -110), openoffsetboth = Vector(0, 125, -110)}

	local offset = self:GetRight() * 3 + self:GetForward() * -130 + self:GetUp() * -110
	local door = self:CreateDoor(bonePos + offset, boneAngL)
	self.Doors["L_Door1"] = {ent = door, closeoffset = Vector(3, -130, -110), openoffsetboth = Vector(-10, -200, -110)}

	local boneAngR = Angle(boneAng.p, boneAng.y, boneAng.r)
		boneAngR.y = boneAngR.y + 95

	local offset = self:GetRight() * -20 + self:GetForward() * 100 + self:GetUp() * -110
	local door = self:CreateDoor(bonePos + offset, boneAngR)
	self.Doors["R_Door2"] = {ent = door, closeoffset = Vector(-20, 100, -110), openoffsethalf = Vector(10, -35, -115), openoffsetboth = Vector(-10, 230, -115)}

	local offset = self:GetRight() * -17 + self:GetForward() * -25 + self:GetUp() * -110
	local door = self:CreateDoor(bonePos + offset, boneAngR)
	self.Doors["R_Door1"] = {ent = door, closeoffset = Vector(-17, -25, -110), openoffsetboth = Vector(0, -90, -115)}

	local boneAngRear = Angle(boneAng.p, boneAng.y, boneAng.r)
		boneAngRear.y = boneAngRear.y - 90
		boneAngRear.p = boneAngRear.p + 1
	local offset = self:GetRight() * 2 + self:GetForward() * 20 + self:GetUp() * -140
	local hatch = self:CreateHatch(bonePos + offset, boneAngRear)
	hatch:SetParent(self.HatchModel, self.HatchModel:LookupAttachment("Hatch_L_Barc"))
	self.HatchPhysic = hatch
end

function ENT:PrimaryAttack()
	if not self:CanPrimaryAttack() or not self:GetEngineActive() then return end

	local boneRPos, boneRAng = self:GetBonePosition(self:LookupBone("R_Cannon_End"))
	local boneLPos, boneLAng = self:GetBonePosition(self:LookupBone("L_Cannon_End"))

	self:SetNextPrimary(0.15)
	self:EmitSound("LAAT_FIRE")

	for i = 1, 2 do
		self.MirrorPrimary = not self.MirrorPrimary

		local Pos = self.MirrorPrimary and boneLPos or boneRPos
		local Dir = (self.MirrorPrimary and boneLAng or boneRAng):Right()
		
		local bullet = self.PrimaryBulletData
			bullet.Src 		= Pos
			bullet.Dir 		= Dir
			bullet.Attacker = self:GetDriver()
		self:FireBullets(bullet)
		
		self:TakePrimaryAmmo()
	end
end

function ENT:HandleWeapons(Fire1, Fire2)
	local Driver = self:GetDriver()
	
	if IsValid( Driver ) then
		if self:GetAmmoPrimary() > 0 then
			Fire1 = Driver:KeyDown( IN_ATTACK )
		end
		
		if self:GetAmmoSecondary() > 1 then
			Fire2 = Driver:KeyDown( IN_ATTACK2 )
		end
	end
	
	if Fire1 then
		self:PrimaryAttack()
	end
	
	if Fire2 then
		self:SecondaryAttack()
	end
end

function ENT:SecondaryAttack()
	if self:GetAI() then return end
	if not self:CanSecondaryAttack() then return end
	
	self:LaunchMainRocket(self.RocketsModel:LookupBone("l_Single_Missile"))
	self:LaunchMainRocket(self.RocketsModel:LookupBone("r_Single_Missile"))

	self.RocketsModel:ResetSequence("Load_Missile")
	self:SetNextSecondary(2.5)
end

function ENT:LaunchMainRocket(boneID)
	if not boneID then return end

	local ent = ents.Create("laat_mainrocket")
		ent:SetPos(self.RocketsModel:GetBonePosition(boneID) + self:GetForward() * 250 + self:GetUp() * 5)
		ent:SetAngles(self:GetAngles())
		ent:Spawn()
		ent:Activate()
		ent:SetAttacker(self:GetDriver())
		ent:SetInflictor(self)
		ent:SetStartVelocity(self:GetVelocity():Length())
		ent:SetDirtyMissile(true)
		ent:EmitSound("LAAT_FIREMISSILE")

	constraint.NoCollide(ent, self, 0, 0)

	self:TakeSecondaryAmmo()
end

function ENT:IsBallmounted()
	return self:GetBodygroup(5) == 0
end

function ENT:SetNextAltPrimary( delay )
	self.NextAltPrimary = CurTime() + delay
end

function ENT:CanAltPrimaryAttack()
	self.NextAltPrimary = self.NextAltPrimary or 0
	return self.NextAltPrimary < CurTime()
end

function ENT:FireRearGun( TargetPos )
	if not self:CanAltPrimaryAttack() then return end
	if not isvector(TargetPos) then return end 

	self:EmitSound("LAAT_FIRE")
	self:SetNextAltPrimary(0.15)

	local startpos = self:GetBonePosition(self:LookupBone("Rear_Gun_End"))
	local dir = (TargetPos - startpos):GetNormalized()
	
	local bullet = self.RearGunBulletData
		bullet.Src 		= startpos
		bullet.Dir 		= dir
		bullet.Attacker = self:GetGunner()
	self:FireBullets(bullet)
end

function ENT:MainGunPoser( EyeAngles )
	local startpos =  self:GetRotorPos()
	local TracePlane = util.TraceHull( {
		start = startpos,
		endpos = (startpos + EyeAngles:Forward() * 50000),
		mins = Vector( -10, -10, -10 ),
		maxs = Vector( 10, 10, 10 ),
		filter = self
	} )
	
	local AimAngles = self:WorldToLocalAngles((TracePlane.HitPos - self:LocalToWorld(Vector(256, 0, 36))):GetNormalized():Angle())
	self.frontgunYaw = -AimAngles.y
	
	self:SetPoseParameter("front_turret_z", AimAngles.p)
	self:SetPoseParameter("front_turret_y", -AimAngles.y)
end

function ENT:OnGravityModeChanged( b )
end

function ENT:CreateAI()
end

function ENT:RemoveAI()
end

function ENT:OnKeyThrottle( bPressed )
end

function ENT:OnEngineStarted()
	self:EmitSound("LAAT_ENGINE_START")

	local RotorWash = ents.Create("env_rotorwash_emitter")
	
	if IsValid(RotorWash) then
		RotorWash:SetPos( self:LocalToWorld( Vector(50,0,0) ) )
		RotorWash:SetAngles(Angle(0,0,0))
		RotorWash:Spawn()
		RotorWash:Activate()
		RotorWash:SetParent(self)
		
		RotorWash.DoNotDuplicate = true
		self:DeleteOnRemove( RotorWash )
		self:dOwner( RotorWash )
		
		self.RotorWashEnt = RotorWash
	end
end

function ENT:OnEngineStopped()
	self:EmitSound("LAAT_ENGINE_STOP")
	
	if IsValid(self.RotorWashEnt) then
		self.RotorWashEnt:Remove()
	end
	
	self:SetGravityMode(true)
end

function ENT:OnVtolMode( IsOn )
end

function ENT:GetDoorMode()
	return self.DoorMode
end

function ENT:SetDoorMode(amount)
	self.DoorMode = amount
end

function ENT:OnLandingGearToggled( bOn )
	if self:GetAI() then return end
	
	local Driver = self:GetDriver()
	if not IsValid(Driver) then return end

	if self.NextLanding >= CurTime() then return end -- Against spammers
	self.NextLanding = CurTime() + 2

	if not self.IsCrashed && Driver:KeyDown(IN_ZOOM) then
		self.IsLightOn = not self.IsLightOn

		local stateLight
		if self.IsLightOn then
			stateLight = "TurnOn"
			self:SetLampMode(self.LastLightState)
		else
			stateLight = "TurnOff"
			self:SetLampMode(0)
		end

		self.Light:Fire(stateLight, "", 0)
		self.Light2:Fire(stateLight, "", 0)

		return
	end

	local DoorMode = self:GetDoorMode() + 1
	DoorMode = DoorMode >= 2 && 0 || DoorMode
	self:SetDoorMode(DoorMode)

	if DoorMode == 0 then
		self:ResetSequence(self.closeSequence)
		self:SetPlaybackRate(1.5)

		local bonePos, _ = self:GetBonePosition(self:LookupBone("LAAT"))
		
		for doorID, _ in pairs(self.DoorsToClose) do
			local doorData = self.Doors[doorID]
			local offset = self:GetRight() * doorData.closeoffset.x + self:GetForward() * doorData.closeoffset.y + self:GetUp() * doorData.closeoffset.z
			doorData.ent:SetParent(nil)
			doorData.ent:SetPos(bonePos + offset)
			doorData.ent:SetParent(self)
		end

		timer.Simple(0.75, function()
			if not IsValid(self) then return end
			self:EmitSound("laat_bf2/door_close.mp3")

			if not self.IsHatchOpen then
				self:TurnLightRed()
			end
		end)

		if not self:GetlfsLockedStatus() then
			self:SetlfsLockedStatus(true)
		end
	else
		if self:GetlfsLockedStatus() then
			self:SetlfsLockedStatus(false)
		end
	end

	if DoorMode == 1 then
		if self:IsBallmounted() then
			self:ResetSequence("Door_Open_Half")
			self.closeSequence = "Door_Closed_Half"
			
			local bonePos = self:GetBonePosition(self:LookupBone("LAAT"))
			
			local doorData = self.Doors["L_Door2"]
			local offset = self:GetRight() * doorData.openoffsethalf.x + self:GetForward() * doorData.openoffsethalf.y + self:GetUp() * doorData.openoffsethalf.z
			doorData.ent:SetParent(nil)
			doorData.ent:SetPos(bonePos + offset)
			doorData.ent:SetParent(self)

			local doorData = self.Doors["R_Door2"]
			local offset = self:GetRight() * doorData.openoffsethalf.x + self:GetForward() * doorData.openoffsethalf.y + self:GetUp() * doorData.openoffsethalf.z
			doorData.ent:SetParent(nil)
			doorData.ent:SetPos(bonePos + offset)
			doorData.ent:SetParent(self)

			self.DoorsToClose = {
				["L_Door2"] = true,
				["R_Door2"] = true,
			}
		else
			self:ResetSequence("Door_Open_Both") 
			self.closeSequence = "Door_Closed_Both"

			local bonePos = self:GetBonePosition(self:LookupBone("LAAT"))

			local doorData = self.Doors["L_Door2"]
			local offset = self:GetRight() * doorData.openoffsetboth.x + self:GetForward() * doorData.openoffsetboth.y + self:GetUp() * doorData.openoffsetboth.z
			doorData.ent:SetParent(nil)
			doorData.ent:SetPos(bonePos + offset)
			doorData.ent:SetParent(self)
			
			local doorData = self.Doors["L_Door1"]
			local offset = self:GetRight() * doorData.openoffsetboth.x + self:GetForward() * doorData.openoffsetboth.y + self:GetUp() * doorData.openoffsetboth.z
			doorData.ent:SetParent(nil)
			doorData.ent:SetPos(bonePos + offset)
			doorData.ent:SetParent(self)

			local doorData = self.Doors["R_Door2"]
			local offset = self:GetRight() * doorData.openoffsetboth.x + self:GetForward() * doorData.openoffsetboth.y + self:GetUp() * doorData.openoffsetboth.z
			doorData.ent:SetParent(nil)
			doorData.ent:SetPos(bonePos + offset)
			doorData.ent:SetParent(self)

			local doorData = self.Doors["R_Door1"]
			local offset = self:GetRight() * doorData.openoffsetboth.x + self:GetForward() * doorData.openoffsetboth.y + self:GetUp() * doorData.openoffsetboth.z
			doorData.ent:SetParent(nil)
			doorData.ent:SetPos(bonePos + offset)
			doorData.ent:SetParent(self)

			self.DoorsToClose = {
				["L_Door2"] = true,
				["L_Door1"] = true,
				["R_Door2"] = true,
				["R_Door1"] = true,
			}
		end

		self:EmitSound("laat_bf2/door_open.mp3")

		self:TurnLightGreen()
	end	
end

function ENT:OnBallturretMounted( ismounted, oldvar )
	if ismounted == oldvar then return end

	if ismounted then
		if IsValid( self.BTPodR_ent_orig ) then 
			self:SetBTPodR( self.BTPodR_ent_orig )
			self.BTPodR_ent_orig:SetNWInt( "pPodIndex", self.BTPodR_index_orig )
		end

		if IsValid( self.BTPodL_ent_orig ) then 
			self:SetBTPodL( self.BTPodL_ent_orig )
			self.BTPodL_ent_orig:SetNWInt( "pPodIndex", self.BTPodL_index_orig )
		end
	else
		local Pod_R = self:GetBTPodR()
		if IsValid( Pod_R ) then 
			self.BTPodR_ent_orig = Pod_R
			self.BTPodR_index_orig = Pod_R:GetNWInt( "pPodIndex" )
			Pod_R:SetNWInt( "pPodIndex", -1 )
		end

		local Pod_L = self:GetBTPodL()
		if IsValid( Pod_L ) then 
			self.BTPodL_ent_orig = Pod_L
			self.BTPodL_index_orig = Pod_L:GetNWInt( "pPodIndex" )
			Pod_L:SetNWInt( "pPodIndex", -1 )
		end

		local Gunner_R = self:GetBTGunnerR()
		if IsValid( Gunner_R ) then
			Gunner_R:ExitVehicle()
		end

		local Gunner_L = self:GetBTGunnerL()
		if IsValid( Gunner_L ) then
			Gunner_L:ExitVehicle()
		end

		self:SetBTPodR( NULL )
		self:SetBTRFire( false )
		self:SetBTGunnerR( NULL )
		
		self:SetBTPodL( NULL )
		self:SetBTLFire( false )
		self:SetBTGunnerL( NULL )
	end
end

function ENT:GetPassengerSeats()
	if not istable( self.pSeats ) then
		self.pSeats = {}
		
		local DriverSeat = self:GetDriverSeat()

		for _, v in pairs( self:GetChildren() ) do
			if v ~= DriverSeat and v:GetClass():lower() == "prop_vehicle_prisoner_pod" then
				table.insert( self.pSeats, v )
			end
		end
	end

	if self:GetBodygroup(5) == 1 then
		local pSeats = table.Copy( self.pSeats )

		for k, v in pairs( pSeats ) do
			if v == self.BTPodR_ent_orig or v == self.BTPodL_ent_orig then
				pSeats[k] = nil
			end
		end

		return pSeats
	else
		return self.pSeats
	end
end

local boneAnglesL = {
	[1] = {
		bone = "ValveBiped.Bip01_L_Thigh",
		ang = Angle(-10, 5, 10)
	},
	[2] = {
		bone = "ValveBiped.Bip01_R_Thigh",
		ang = Angle(10, 5, -10)
	},
	[3] = {
		bone = "ValveBiped.Bip01_L_Calf",
		ang = Angle(15, -30, 0)
	},
	[4] = {
		bone = "ValveBiped.Bip01_R_Calf",
		ang = Angle(-15, -30, 0)
	},
	[5] = {
		bone = "ValveBiped.Bip01_L_Foot",
		ang = Angle(20, -15, 0)
	},
	[6] = {
		bone = "ValveBiped.Bip01_R_Foot",
		ang = Angle(-20, -15, 0)
	},
	[7] = {
		bone = "ValveBiped.Bip01_L_UpperArm",
		ang = Angle(-30, -70, 0)
	},
	[8] = {
		bone = "ValveBiped.Bip01_R_UpperArm",
		ang = Angle(25, -65, 0)
	},
	[9] = {
		bone = "ValveBiped.Bip01_L_Forearm",
		ang = Angle(10, 70, -30)
	},
	[10] = {
		bone = "ValveBiped.Bip01_R_Forearm",
		ang = Angle(-25, 70, 30)
	},
	[11] = {
		bone = "ValveBiped.Bip01_L_Hand",
		ang = Angle(-5, 15, 10)
	},
	[12] = {
		bone = "ValveBiped.Bip01_R_Hand",
		ang = Angle(-25, 30, -40)
	},
	[13] = {
		bone = "ValveBiped.Bip01_Spine2",
		ang = Angle(0, 10, -2)
	},
	[14] = {
		bone = "ValveBiped.Bip01_L_Finger1",
		ang = Angle(-15, -10, 0)
	},
	[15] = {
		bone = "ValveBiped.Bip01_L_Finger2",
		ang = Angle(-10, -10, 0)
	},
	[16] = {
		bone = "ValveBiped.Bip01_L_Finger3",
		ang = Angle(0, -5, 0)
	},
	[17] = {
		bone = "ValveBiped.Bip01_L_Finger4",
		ang = Angle(0, 5, 0)
	},
	[18] = {
		bone = "ValveBiped.Bip01_R_Finger1",
		ang = Angle(15, -30, 0)
	},
	[19] = {
		bone = "ValveBiped.Bip01_R_Finger2",
		ang = Angle(5, -30, 0)
	},
	[20] = {
		bone = "ValveBiped.Bip01_R_Finger3",
		ang = Angle(0, -20, 0)
	},
	[21] = {
		bone = "ValveBiped.Bip01_R_Finger4",
		ang = Angle(-5, -10, 0)
	},
}

local boneAnglesR = {
	[1] = {
		bone = "ValveBiped.Bip01_L_Thigh",
		ang = Angle(-10, 5, 10)
	},
	[2] = {
		bone = "ValveBiped.Bip01_R_Thigh",
		ang = Angle(10, 7, -10)
	},
	[3] = {
		bone = "ValveBiped.Bip01_L_Calf",
		ang = Angle(15, -30, 0)
	},
	[4] = {
		bone = "ValveBiped.Bip01_R_Calf",
		ang = Angle(-15, -30, 0)
	},
	[5] = {
		bone = "ValveBiped.Bip01_L_Foot",
		ang = Angle(20, -15, 0)
	},
	[6] = {
		bone = "ValveBiped.Bip01_R_Foot",
		ang = Angle(-20, -15, 0)
	},
	[7] = {
		bone = "ValveBiped.Bip01_L_UpperArm",
		ang = Angle(-30, -75, 0)
	},
	[8] = {
		bone = "ValveBiped.Bip01_R_UpperArm",
		ang = Angle(25, -70, 0)
	},
	[9] = {
		bone = "ValveBiped.Bip01_L_Forearm",
		ang = Angle(10, 70, -30)
	},
	[10] = {
		bone = "ValveBiped.Bip01_R_Forearm",
		ang = Angle(-25, 70, 30)
	},
	[11] = {
		bone = "ValveBiped.Bip01_L_Hand",
		ang = Angle(-5, 10, 10)
	},
	[12] = {
		bone = "ValveBiped.Bip01_R_Hand",
		ang = Angle(-20, 40, -40)
	},
	[13] = {
		bone = "ValveBiped.Bip01_Spine2",
		ang = Angle(0, 15, 7)
	},
	[14] = {
		bone = "ValveBiped.Bip01_L_Finger1",
		ang = Angle(-15, -10, 0)
	},
	[15] = {
		bone = "ValveBiped.Bip01_L_Finger2",
		ang = Angle(-10, -10, 0)
	},
	[16] = {
		bone = "ValveBiped.Bip01_L_Finger3",
		ang = Angle(0, -5, 0)
	},
	[17] = {
		bone = "ValveBiped.Bip01_L_Finger4",
		ang = Angle(0, 5, 0)
	},
	[18] = {
		bone = "ValveBiped.Bip01_R_Finger1",
		ang = Angle(15, -30, 0)
	},
	[19] = {
		bone = "ValveBiped.Bip01_R_Finger2",
		ang = Angle(5, -30, 0)
	},
	[20] = {
		bone = "ValveBiped.Bip01_R_Finger3",
		ang = Angle(0, -20, 0)
	},
	[21] = {
		bone = "ValveBiped.Bip01_R_Finger4",
		ang = Angle(-5, -10, 0)
	},
}
function ENT:OnTick()
	if self:GetHP() <= 2000 then
		self:MakeUncontrollable()
	end

	if self:GetUncontrollable() then
		if self:GetHP() > 2000 then
			self.RPMThrottleIncrement = self.SaveRPMThrottleIncrement
			
			self.TurnForcePitch = self.SaveTurnForcePitch
			self.TurnForceYaw = self.SaveTurnForceYaw
			self.TurnForceRoll = self.SaveTurnForceRoll

			self:SetUncontrollable(false)
			self.IsCrashed = false
			if self.IsLightOn then
				self.Light:Fire("TurnOn", "", 0)
				self.Light2:Fire("TurnOn", "", 0)
				self:SetLampMode(self.LastLightState)
			end
			self:StopParticles()
		else
			if self.IsCrashed && self.IsLightOn then
				if self.nextLFX < CurTime() then
					self.nextLFX = CurTime() + math.random(0, 0.01)
					self.Light:Fire(self.nextLightState, "", 0)
					self.Light2:Fire(self.nextLightState, "", 0)

					if self:GetLampMode() != 0 then self:SetLampMode(0) end

					self.nextLightState = self.nextLightState == "TurnOn" && "TurnOff" || "TurnOn"
				end
			end
		end
	end

	local BTbodygroup = self:GetBodygroup(5)
	if BTbodygroup ~= self.oldBTbodygroup then
		self:OnBallturretMounted( BTbodygroup == 0, self.oldBTbodygroup == 0 )

		self.oldBTbodygroup = BTbodygroup
	end

	local curSkin = self:GetSkin()
	if curSkin ~= self.OldSkin then
		self.OldSkin = curSkin
		self.HatchModel:SetSkin(curSkin)
	end

	do
		local Pod = self:GetBTPodL()
		
		if IsValid(Pod) then
			local ply = Pod:GetDriver()
			local lastGunnerL = self:GetBTGunnerL()

			if ply ~= lastGunnerL then
				self:SetBTGunnerL(ply)

				if IsValid(ply) then
					for _, inf in pairs(boneAnglesL) do
						local bone = ply:LookupBone(inf.bone)
						if bone then
							ply:ManipulateBoneAngles(bone, inf.ang)
						end
					end
				end

				if IsValid(lastGunnerL) then
					local ang0 = Angle(0, 0, 0)
					for _, inf in pairs(boneAnglesL) do
						local bone = lastGunnerL:LookupBone(inf.bone)
						if bone then
							lastGunnerL:ManipulateBoneAngles(bone, ang0)
						end
					end
				end
			end

			if self:GetBallTurretLHeat() >= 100 then
				self.BallTurretLSurcharged = true
			end

			if self.BallTurretLSurcharged && self:GetBallTurretLHeat() <= 0 then
				self.BallTurretLSurcharged = false
			end
			
			if IsValid(ply) then
				self:BallTurretL(ply, Pod)
				self:SetBTLFire(not self.BallTurretLSurcharged && ply:KeyDown( IN_ATTACK ))
			else
				self:SetBTLFire(false)
			end

			if not self:GetBTLFire() then
				self:ReduceBallTurretLHeat()
			end
		end
	end
	
	do
		local Pod = self:GetBTPodR()
		
		if IsValid(Pod) then
			local ply = Pod:GetDriver()
			local lastGunnerR = self:GetBTGunnerR()

			if ply ~= lastGunnerR then
				self:SetBTGunnerR(ply)

				if IsValid(ply) then
					for _, inf in pairs(boneAnglesR) do
						local bone = ply:LookupBone(inf.bone)
						if bone then
							ply:ManipulateBoneAngles(bone, inf.ang)
						end
					end
				end

				if IsValid(lastGunnerR) then
					local ang0 = Angle(0, 0, 0)
					for _, inf in pairs(boneAnglesR) do
						local bone = lastGunnerR:LookupBone(inf.bone)
						if bone then
							lastGunnerR:ManipulateBoneAngles(bone, ang0)
						end
					end
				end
			end

			if self:GetBallTurretRHeat() >= 100 then
				self.BallTurretRSurcharged = true
			end

			if self.BallTurretRSurcharged && self:GetBallTurretRHeat() <= 0 then
				self.BallTurretRSurcharged = false
			end
			
			if IsValid(ply) then
				self:BallTurretR(ply, Pod)
				self:SetBTRFire(not self.BallTurretRSurcharged && ply:KeyDown( IN_ATTACK ))
			else
				self:SetBTRFire(false)
			end

			if not self:GetBTRFire() then
				self:ReduceBallTurretRHeat()
			end
		end
	end
	
	self:GunnerWeapons(self:GetGunner(), self:GetGunnerSeat())
	self:LoadMasterFunc(self:GetLoadMaster(), self:GetLoadMasterSeat())
	self:Grabber()
end

function ENT:OnRemove()
	local lastGunnerL = self:GetBTGunnerL()
	if IsValid(lastGunnerL) then
		local ang0 = Angle(0, 0, 0)
		for _, inf in pairs(boneAnglesL) do
			local bone = lastGunnerL:LookupBone(inf.bone)
			if bone then
				lastGunnerL:ManipulateBoneAngles(bone, ang0)
			end
		end
	end
	
	local lastGunnerR = self:GetBTGunnerR()
	if IsValid(lastGunnerR) then
		local ang0 = Angle(0, 0, 0)
		for _, inf in pairs(boneAnglesR) do
			local bone = lastGunnerR:LookupBone(inf.bone)
			if bone then
				lastGunnerR:ManipulateBoneAngles(bone, ang0)
			end
		end
	end
end

local GrabberValidType = {
	["dual_atrt"] = 2,
	["dual_barc"] = 2,
	["solo_barc"] = 1,
}
local GrabberValidClass = {
	["lunasflightschool_niksacokica_at-rt"] = {type = "dual_atrt", pos = Vector(0, 0, 0), ang = Angle(27, -90, 0)},
	["lunasflightschool_niksacokica_barc"] = {type = "dual_barc", pos = Vector(0, 30, 30), ang = Angle(27, -90, 0)},
	["lunasflightschool_niksacokica_barc_stretcher"] = {type = "solo_barc", pos = Vector(0, 30, 30), ang = Angle(27, -90, 0)},
	["lunasflightschool_niksacokica_74-z_speeder_bike"] = {type = "dual_barc", pos = Vector(0, -20, 20), ang = Angle(30, -90, 0)},
}
function ENT:Grabber()
	local HeldEntitiesAmount = #self.HeldEntities
	if HeldEntitiesAmount < 2 then
		if self.NextFind < CurTime() then
			self.NextFind = CurTime() + 1
			
			local StartPos = self:LocalToWorld(Vector(-200, 0, 100))
			self.CanPickupEnt = NULL
			local Dist = 1000
			local SphereRadius = 150

			for k, v in pairs(ents.FindInSphere(StartPos, SphereRadius)) do
				if v.LAATIsHelding then continue end

				if GrabberValidType[v.LAATHeldType] && isvector(v.LAATHeldPos) && isangle(v.LAATHeldAngle) then
					local Len = (StartPos - v:GetPos()):Length()

					if Len < Dist then
						self.CanPickupEnt = v
						Dist = Len
					end
				else
					local heldData = GrabberValidClass[v:GetClass()]
					if heldData then
						if self.HeldEntitiesType && self.HeldEntitiesType != heldData.type then continue end
						local Len = (StartPos - v:GetPos()):Length()

						if Len < Dist then
							self.CanPickupEnt = v
							Dist = Len
						end
					end
				end
			end
		end
	end
end

function ENT:LoadMasterFunc( Driver, Pod )
	if not IsValid(Pod) || not IsValid(Driver) then return end

	if self.IsHatchOpen then
		local KeyAttack = Driver:KeyDown( IN_ATTACK )
		if KeyAttack then
			self:GrabEntity()
		end

		local KeyAttack2 = Driver:KeyDown( IN_ATTACK2 )
		if KeyAttack2 then
			self:DropHeldEntity()
		end
	end

	local KeyJump = Driver:KeyDown( IN_JUMP )
	if KeyJump then
		self:ToggleHatch()
	end
end

function ENT:GetAttachmentID(heldType)
	local attachment

	if heldType == "dual_barc" then
		attachment = #self.HeldEntities == 0 && "Hatch_L_Barc" || "Hatch_R_Barc"
	elseif heldType == "solo_barc" then
		attachment = "Hatch_R_Barc"
	elseif heldType == "dual_atrt" then
		attachment = #self.HeldEntities == 0 && "Hatch_L_ATRT" || "Hatch_R_ATRT"
	end

	return self.HatchModel:LookupAttachment(attachment)
end

function ENT:GrabEntity()
	if self.HeldEntitiesLimit && #self.HeldEntities >= self.HeldEntitiesLimit then return end
	if self.NextGrab >= CurTime() then return end
	self.NextGrab = CurTime() + 1

	if IsValid(self.CanPickupEnt) then
		local entData = GrabberValidClass[self.CanPickupEnt:GetClass()]
		
		if not istable(entData) then
			entData = {}
			entData.pos = self.CanPickupEnt.LAATHeldPos
			entData.ang = self.CanPickupEnt.LAATHeldAngle
			entData.type = self.CanPickupEnt.LAATHeldType
		end

		local attachmentID = self:GetAttachmentID(entData.type)
		local Muzzle = self.HatchModel:GetAttachment(attachmentID)

		if Muzzle then
			local Pos, Ang = LocalToWorld(entData.pos, entData.ang, Muzzle.Pos, Muzzle.Ang)

			self.CanPickupEnt:StopEngine()

			self.CanPickupEnt:PhysicsDestroy()
			
			if self.CanPickupEnt.SetIsCarried then
				self.CanPickupEnt:SetIsCarried(true)
			end

			self.CanPickupEnt:SetPos(Pos)
			self.CanPickupEnt:SetAngles(Ang)
			self.CanPickupEnt:SetParent(self.HatchModel, attachmentID)

			local OldOnTick = self.CanPickupEnt.OnTick
			self.CanPickupEnt.OnTick = function(self) end

			local OldToggleEngine = self.CanPickupEnt.ToggleEngine
			self.CanPickupEnt.ToggleEngine = function(self) end

			self.CanPickupEnt.LAATIsHelding = true

			self.HeldEntitiesLimit = GrabberValidType[entData.type]
			self.HeldEntitiesType = entData.type

			self.HeldEntities[#self.HeldEntities + 1] = {ent = self.CanPickupEnt, PosEnt = PosEnt, OldOnTick = OldOnTick, OldToggleEngine = OldToggleEngine} 
		end
	end
end

function ENT:DropHeldEntity()
	if #self.HeldEntities <= 0 then return end
	if self.NextDrop >= CurTime() then return end
	self.NextDrop = CurTime() + 1
	
	local heldEntityData = self.HeldEntities[#self.HeldEntities]
	local FrontEnt = heldEntityData.ent
	if IsValid(FrontEnt) then
		if FrontEnt.SetIsCarried then
			FrontEnt:SetIsCarried(false)
		end

		local mirror = #self.HeldEntities > 1 && -1 || 1
		FrontEnt:SetParent(NULL)
		FrontEnt:SetPos(self:GetPos() + self:GetForward() * -400 + self:GetUp() * 50 + self:GetRight() * 60 * mirror)

		FrontEnt:PhysicsInit(SOLID_VPHYSICS)
		FrontEnt:SetMoveType(MOVETYPE_VPHYSICS)
		FrontEnt:SetSolid(SOLID_VPHYSICS)
		FrontEnt:SetUseType(SIMPLE_USE)
		FrontEnt:SetRenderMode(RENDERMODE_TRANSALPHA)
		FrontEnt:AddFlags(FL_OBJECT)

		local PObj = FrontEnt:GetPhysicsObject()
		if not IsValid(PObj) then 
			FrontEnt:Remove()
			print("LFS: missing model. Plane terminated.")
			return
		end

		PObj:EnableMotion(false)
		PObj:SetMass(FrontEnt.Mass) 
		PObj:SetDragCoefficient(FrontEnt.Drag) 
		FrontEnt.LFSInertiaDefault = PObj:GetInertia()
		PObj:SetInertia(FrontEnt.Inertia) 

		FrontEnt.OnTick = heldEntityData.OldOnTick
		FrontEnt.ToggleEngine = heldEntityData.OldToggleEngine

		FrontEnt:InitPod()
		FrontEnt:InitWheels()
		
		FrontEnt.smSpeed = 200
		FrontEnt.LAATIsHelding = false
	end
	
	self.HeldEntities[#self.HeldEntities] = nil

	if #self.HeldEntities == 0 then
		self.HeldEntitiesLimit = nil
		self.HeldEntitiesType = nil
	end
end

function ENT:TurnLightGreen()
	self.Light:Fire("Color", "0 255 0")
	self.Light:SetKeyValue("brightness", "5")
	self.Light2:Fire("Color", "0 255 0")
	self.Light2:SetKeyValue("brightness", "5")

	self.LastLightState = 2
	if self.IsLightOn then self:SetLampMode(2) end
end

function ENT:TurnLightRed()
	self.Light:Fire("Color", "255 0 0")
	self.Light:SetKeyValue("brightness", "6")
	self.Light2:Fire("Color", "255 0 0")
	self.Light2:SetKeyValue("brightness", "6")

	self.LastLightState = 1
	if self.IsLightOn then self:SetLampMode(1) end
end

function ENT:ToggleHatch()
	if self.NextUseHatch >= CurTime() then return end
	self.NextUseHatch = CurTime() + 2.5

	self.IsHatchOpen = not self.IsHatchOpen
	
	self:EmitSound("LAAT_HATCH")

	if self.IsHatchOpen then	
		self.HatchModel:ResetSequence("Rear_Hatch_Open")
		self.HatchModel:SetPlaybackRate(0.7)

		self:TurnLightGreen()
	else
		self.HatchModel:ResetSequence("Rear_Hatch_Closed")
		self.HatchModel:SetPlaybackRate(0.7)

		if self.DoorMode != 1 then
			self:TurnLightRed()
		end
	end
end

function ENT:ReduceBallTurretLHeat()
	if self:GetBallTurretLHeat() <= 0 then return end
	local curtime = CurTime()
	if self.NextReduceBallTurretLHeat >= curtime then return end
	self.NextReduceBallTurretLHeat = curtime + 0.1
	self:SetBallTurretLHeat(math.max(self:GetBallTurretLHeat() - 4, 0))
end

function ENT:UpBallTurretLHeat()
	local curtime = CurTime()
	if self.NextUpBallTurretLHeat >= curtime then return end
	self.NextUpBallTurretLHeat = curtime + 0.1

	self:SetBallTurretLHeat(math.min(self:GetBallTurretLHeat() + 4, 100))
end

function ENT:BallTurretL( Driver, Pod )
	local EyeAngles = Pod:WorldToLocalAngles( Driver:EyeAngles() )
	
	local _, LocalAng = WorldToLocal( Vector(0,0,0), EyeAngles, Vector(0,0,0), self:LocalToWorldAngles( Angle(0,90,0)  ) )
	LocalAng = LocalAng * 0.33

	self:SetPoseParameter("left_side_turret_z", LocalAng.p)
	self:SetPoseParameter("left_side_turret_y", -LocalAng.y)
	
	if self:GetBTLFire() then
		local ID = self:LookupAttachment("L_Ball_Attachement")
		local Muzzle = self:GetAttachment(ID)
		
		if Muzzle then
			local Dir = Muzzle.Ang:Forward()
			local startpos = Muzzle.Pos
			
			local Trace = util.TraceLine({
				start = startpos,
				endpos = (startpos + Dir * 50000),
			})
			
			self:UpBallTurretLHeat()
			self:BallturretDamage(Driver, Trace.HitPos, 10)
		end
	end
end

function ENT:ReduceBallTurretRHeat()
	if self:GetBallTurretRHeat() <= 0 then return end
	local curtime = CurTime()
	if self.NextReduceBallTurretRHeat >= curtime then return end
	self.NextReduceBallTurretRHeat = curtime + 0.1
	self:SetBallTurretRHeat(math.max(self:GetBallTurretRHeat() - 4, 0))
end

function ENT:UpBallTurretRHeat()
	local curtime = CurTime()
	if self.NextUpBallTurretRHeat >= curtime then return end
	self.NextUpBallTurretRHeat = curtime + 0.1
	self:SetBallTurretRHeat(math.min(self:GetBallTurretRHeat() + 4, 100))
end

function ENT:BallTurretR( Driver, Pod )
	local EyeAngles = Pod:WorldToLocalAngles( Driver:EyeAngles() )
	
	local _,LocalAng = WorldToLocal( Vector(0,0,0), EyeAngles, Vector(0,0,0), self:LocalToWorldAngles( Angle(0,-90,0)  ) )
	LocalAng = LocalAng * 0.33

	self:SetPoseParameter("right_side_turret_z", LocalAng.p)
	self:SetPoseParameter("right_side_turret_y", -LocalAng.y)
	
	if self:GetBTRFire() then
		local ID = self:LookupAttachment("R_Ball_Attachement")
		local Muzzle = self:GetAttachment(ID)
		
		if Muzzle then
			local Dir = -Muzzle.Ang:Forward()
			local startpos = Muzzle.Pos
			
			local Trace = util.TraceLine({
				start = startpos,
				endpos = (startpos + Dir * 50000),
			})
			
			self:UpBallTurretRHeat()
			self:BallturretDamage(Driver, Trace.HitPos, 10)
		end
	end
end

function ENT:CanLaunchWingRocket()
	return self.NextLaunchWingRocket <= CurTime()
end

function ENT:SetNextLaunchWingRocket(amount)
	self.NextLaunchWingRocket = CurTime() + amount
end

function ENT:LaunchWingRocket()
	if not self:CanLaunchWingRocket() then return end
	if self:GetAmmoThird() < 1 then return end
	self:SetNextLaunchWingRocket(1)

	self.MirrorWingRocket = self.MirrorWingRocket == 0 && 1 || 0

	local ent = ents.Create("laat_wingrocket")
		ent:SetPos(self:LocalToWorld(self.WingRocketPos[self.MirrorWingRocket]))
		ent:SetAngles(self:GetAngles())
		ent:Spawn()
		ent:Activate()
		ent:SetAttacker(self:GetDriver())
		ent:SetInflictor(self)
		ent:SetStartVelocity(self:GetVelocity():Length())
		ent:SetDirtyMissile(true)
		ent:EmitSound("LAAT_FIREMISSILE")
		ent:SetLockOn(self:GetWingRocketTarget())
		ent:SetStartVelocity(0)

	constraint.NoCollide(ent, self, 0, 0)

	self:TakeThirdAmmo()
end

function ENT:ReloadWeapon()
	self:SetAmmoPrimary( self:GetMaxAmmoPrimary() )
	self:SetAmmoSecondary( self:GetMaxAmmoSecondary() )
	self:SetAmmoThird( self:GetMaxAmmoThird() )

	self:OnReloadWeapon()
end

function ENT:TakeThirdAmmo(amount)
	amount = amount or 1
	self:SetAmmoThird(math.max(self:GetAmmoThird() - amount, 0))
end

function ENT:ReduceWingTurretHeat()
	if self:GetWingTurretHeat() <= 0 then return end
	local curtime = CurTime()
	if self.NextReduceWingTurretHeat >= curtime then return end
	self.NextReduceWingTurretHeat = curtime + 0.1
	self:SetWingTurretHeat(math.max(self:GetWingTurretHeat() - 2, 0))
end

function ENT:UpWingTurretHeat()
	local curtime = CurTime()
	if self.NextUpWingTurretHeat >= curtime then return end
	self.NextUpWingTurretHeat = curtime + 0.1
	self:SetWingTurretHeat(math.min(self:GetWingTurretHeat() + 6, 100))
end

function ENT:GunnerWeapons( Driver, Pod )
	if not IsValid(Pod) or not IsValid(Driver) then 
		self:SetWingTurretFire(false)
		self:ReduceWingTurretHeat()
		return false
	else
		Driver:CrosshairDisable()
	end

	local EyeAngles = Pod:WorldToLocalAngles(Driver:EyeAngles())
	local Forward = self:GetForward()
	local Back = -Forward
	local KeyAttack = Driver:KeyDown(IN_ATTACK)

	local startpos = self:GetRotorPos() + EyeAngles:Up() * 250
	local TracePlane = util.TraceLine({
		start = startpos,
		endpos = (startpos + EyeAngles:Forward() * 50000),
		filter = self
	})
	
	local AimAngYaw = math.abs(self:WorldToLocalAngles(EyeAngles).y)
	local WingTurretActive = AimAngYaw < 55
	local FireWingTurret = KeyAttack and WingTurretActive
	local FireRearGun = KeyAttack

	local WingTurretSurcharged = self:GetWingTurretHeat() >= 100
	if WingTurretSurcharged then 
		FireWingTurret = false
		self.WingTurretHeatOver = true 
	end
	if self.WingTurretHeatOver && self:GetWingTurretHeat() <= 0 then self.WingTurretHeatOver = false end

	if not self.WingTurretHeatOver && FireWingTurret then
		self:SetWingTurretTarget(TracePlane.HitPos)
		self:UpWingTurretHeat()

		local DesEndPos = TracePlane.HitPos
		local DesStartPos = Vector(-55, 350, 90)
		for i = -1, 1, 2 do
			local StartPos = self:LocalToWorld( DesStartPos * Vector(1,i,1) )
			local Trace = util.TraceLine({
				start = StartPos, 
				endpos = DesEndPos,
			})
			local EndPos = Trace.HitPos
			
			if self.Entity:WorldToLocal( EndPos ).z < 0 then
				DesStartPos = Vector(-55, 350, 90)
			else
				DesStartPos = Vector(-55, 370, 125)
			end
			
			self:BallturretDamage(Driver, EndPos)
		end
	else
		self:ReduceWingTurretHeat()
	end
	self:SetWingTurretFire(not self.WingTurretHeatOver && FireWingTurret)

	if AimAngYaw > 120 then
		local AimDir = EyeAngles:Forward()
		local startpos = self:LocalToWorld(Vector(-200, 0, 180))
		local TracePlane = util.TraceLine({
			start = startpos,
			endpos = (startpos + AimDir * 50000),
			filter = {self, self.HatchModel, self.RocketsModel}
		})

		local bonePos = self:GetBonePosition(self:LookupBone("Rear_Gun_Base"))
		local Pos, Ang = WorldToLocal(Vector(0, 0, 0), (TracePlane.HitPos - bonePos):GetNormalized():Angle(), Vector(0, 0, 0), self:LocalToWorldAngles(Angle(18, 180, 0)))

		self:SetPoseParameter("back_turret_z", Ang.p)
		self:SetPoseParameter("back_turret_y", -Ang.y)

		self:SetGXHairRG(true)
		self:SetGXHairWT(false)

		if FireRearGun then
			self:FireRearGun( TracePlane.HitPos )
		end
	else
		self:SetPoseParameter("back_turret_z", 0)
		self:SetPoseParameter("back_turret_y", 0)

		self:SetGXHairRG(false)
		self:SetGXHairWT(true)
	end
	
	local Gunner = self:GetGunner()
	local GunnerPod = self:GetGunnerSeat()

	if IsValid(Gunner) then
		local EyeAngles = GunnerPod:WorldToLocalAngles(Gunner:EyeAngles())
		local WingRocketActive = math.deg(math.acos(math.Clamp(self:GetForward():Dot(EyeAngles:Forward()), -1, 1))) < 35

		if WingRocketActive then
			local startpos = self:GetRotorPos() + EyeAngles:Up() * 250

			local tr = util.TraceHull({
				start = startpos,
				endpos = (startpos + EyeAngles:Forward() * 50000),
				filter = function(ent) 
					return ent != self && (ent.LFS || ent.IdentifiesAsLFS)
				end,
				mins = Vector( -300, -300, -300 ),
				maxs = Vector( 300, 300, 300 ),
			})

			local ent = tr.Entity
			if IsValid(ent) && (ent.LFS || ent.IdentifiesAsLFS) then 
				if ent == self:GetWingRocketTarget() then
					if self:GetTimeLock() <= 2 && self.NextTimeLockLevelUp < CurTime() then
						self:SetTimeLock(self:GetTimeLock() + 1)
						self.NextTimeLockLevelUp = CurTime() + 1
					end
				else
					self:SetWingRocketTarget(ent)
					self:SetTimeLock(0)
					self.NextTimeLockLevelUp = CurTime() + 1
				end
			else
				self:SetWingRocketTarget(nil)
				self:SetTimeLock(0)
				self.NextTimeLockLevelUp = 0
			end
		end
	end

	if self:GetTimeLock() >= 3 then
		local KeyAttack2 = Driver:KeyDown( IN_ATTACK2 )

		if KeyAttack2 then
			self:LaunchWingRocket()
		end
	end

	--[[local KeyAttack3 = Driver:KeyDown( IN_JUMP )
	if KeyAttack3 then
		self:DropDetonators()
	end]]
end

function ENT:BallturretDamage( attacker, HitPos, Dmg )
	Dmg = Dmg or 5
	util.BlastDamage(self, attacker, HitPos, 100, Dmg)
end

function ENT:HitGround()
	local tr = util.TraceLine({
		start = self:LocalToWorld(Vector(0, 0, 100)),
		endpos = self:LocalToWorld(Vector(0, 0, -20)),
		filter = function(ent) 
			if ent == self then 
				return false
			end
		end
	})
	
	return tr.Hit 
end

function ENT:StartEngine()
	if self:GetUncontrollable() or self:GetEngineActive() or self:IsDestroyed() or self:InWater() or not self:IsEngineStartAllowed() or self:GetRotorDestroyed() then return end
	
	self:SetEngineActive( true )
	self:OnEngineStarted()
	
	self:InertiaSetNow()
end

function ENT:CreateExplosionEffect(pos, normal)
	local effectdata = EffectData()
		effectdata:SetOrigin(pos)
		if normal then effectdata:SetNormal(normal) end
	util.Effect("lfs_explosion_nodebris", effectdata)
end

function ENT:MakeUncontrollable()
	if self:GetUncontrollable() then return end

	self:SetUncontrollable(true)
	self.TimeUncontrollable = CurTime()

	self.SaveRPMThrottleIncrement = self.RPMThrottleIncrement
	self.RPMThrottleIncrement = 0

	self.SaveTurnForcePitch = self.TurnForcePitch
	self.TurnForcePitch = self.TurnForcePitch * 0.6

	self.SaveTurnForceYaw = self.TurnForceYaw
	self.TurnForceYaw = self.TurnForceYaw * 0.6

	self.SaveTurnForceRoll = self.TurnForceRoll
	self.TurnForceRoll = self.TurnForceRoll * 0.8

	self:CreateExplosionEffect(self:LocalToWorld(Vector(-300, 0, 180)))

	ParticleEffectAttach("env_fire_large_smoke", PATTACH_POINT_FOLLOW, self, self:LookupAttachment("R_Heat_Hatch"))
end

function ENT:OnTakeDamage(dmginfo)
	self:TakePhysicsDamage(dmginfo)
	self:StopMaintenance()

	local Damage = dmginfo:GetDamage()
	local CurHealth = self:GetHP()
	local NewHealth = math.Clamp(CurHealth - Damage, -self:GetMaxHP(), self:GetMaxHP())
	local dmgPos = dmginfo:GetDamagePosition()
	local dmgNormal = -dmginfo:GetDamageForce():GetNormalized()

	sound.Play(Sound(table.Random(self.DamageSounds)), dmgPos, SNDLVL_70dB)
	
	local effectdata = EffectData()
		effectdata:SetOrigin(dmgPos)
		effectdata:SetNormal(dmgNormal)
	util.Effect("MetalSpark", effectdata)
	
	self:SetHP(NewHealth)
	
	if NewHealth <= 2000 then
		if not self:GetUncontrollable() then
			self.FinalAttacker = dmginfo:GetAttacker() 
			self.FinalInflictor = dmginfo:GetInflictor()

			self:MakeUncontrollable()
		else
			if self.ExplosionEffectPostDamage then
				self:CreateExplosionEffect(dmgPos, dmgNormal)
				self.ExplosionEffectPostDamage = false
			end
		end
	end

	if NewHealth <= 0 then
		self:Explode()
	end
end

local function CalcFlight(self, PhysObj, vDirection, fForce )
	local Pod = self:GetDriverSeat()
	if not IsValid(Pod) then return end
	
	local Mass = PhysObj:GetMass()
	local Driver = Pod:GetDriver()
	
	local AI = self:GetAI()
	local EyeAngles = Angle(0,0,0)
	local VtolMovement = Vector(0,0,0)
	
	local Vel = self:GetVelocity()
	local FT = FrameTime()
	local OnGround = self:HitGround()
	local IsVtolActive = self:IsVtolModeActive()
	local Up = 0
	
	if self.oldVtolMode ~= IsVtolActive then
		self.oldVtolMode = IsVtolActive
		self:OnVtolMode(IsVtolActive)
	end
	
	if IsValid(Driver) then 
		EyeAngles = Pod:WorldToLocalAngles(Driver:EyeAngles())
		
		self:MainGunPoser(EyeAngles)
		
		if Driver:lfsGetInput("FREELOOK") then
			if isangle(self.StoredEyeAngles) then
				EyeAngles = self.StoredEyeAngles
				EyeAngles.r = 0
			end
		else
			self.StoredEyeAngles = EyeAngles
		end
		
		if IsVtolActive then
			local Thrust = self:GetThrustVtol()

			Up = (OnGround and Driver:lfsGetInput( "+THROTTLE" ) or Driver:lfsGetInput( "+PITCH" )) and Thrust or 0
			local Down = ((Driver:lfsGetInput( "-THROTTLE" ) and self:GetThrottlePercent() <= 10) or Driver:lfsGetInput( "-PITCH" )) and -Thrust or 0
			local Right = Driver:lfsGetInput( "+ROLL" ) and Thrust or 0
			local Left = Driver:lfsGetInput( "-ROLL" ) and -Thrust or 0
			
			VtolMovement = self:GetRight() * (Left + Right) + self:GetUp() * (Up + Down)
		end
	else
		EyeAngles = self:GetAngles()
		
		if AI then
			EyeAngles = self:RunAI()
			OnGround = false
		end
		
		self:MainGunPoser( EyeAngles )
	end
	
	if self:GetThrottlePercent() > 10 then
		EyeAngles.r = EyeAngles.r + math.Clamp( -self:GetAngVel().y * (math.min(self:GetThrottlePercent(),100) / 100) + math.cos(CurTime()), -90,90 )
	end
	
	local Angles = self:GetAngles()
	local TargetAngle = EyeAngles

	if self:GetUncontrollable() && TargetAngle.p < -20 then TargetAngle.p = -20 end
	
	self.smP = self.smP and math.ApproachAngle( self.smP, TargetAngle.p, self.MaxTurnPitch * FT ) or Angles.p
	self.smY = self.smY and math.ApproachAngle( self.smY, TargetAngle.y, self.MaxTurnYaw * FT ) or Angles.y
	self.smR = self.smR and math.ApproachAngle( self.smR, TargetAngle.r, self.MaxTurnRoll * FT ) or Angles.r

	local LocalAngles = self:WorldToLocalAngles( Angle(self.smP,self.smY,self.smR) )
	
	LocalAngles.p = LocalAngles.p * 4 + math.cos(CurTime() * 0.98)
	LocalAngles.y = LocalAngles.y * 4
	LocalAngles.r = LocalAngles.r * 4
	
	if OnGround and self:GetThrottlePercent() <= 10 then
		self:SetRPM( 0 )
		
		if Up <= 0 then 
			self:SetGravityMode( true )
			
			return
		else
			self:SetGravityMode( false )
		end
	else
		self:SetGravityMode( false )
	end
	local AngVel = self:GetAngVel()
	-- print(AngVel.p)
	AngVel.p = AngVel.p * self.PitchDamping 
	AngVel.y = AngVel.y * self.YawDamping 
	AngVel.r = AngVel.r * self.RollDamping 
	
	local AngForce = (LocalAngles - AngVel)
	-- print(AngForce.p)
	AngForce.p = AngForce.p * self.TurnForcePitch
	AngForce.y = AngForce.y * self.TurnForceYaw
	AngForce.r = AngForce.r * self.TurnForceRoll
	
	if self:GetUncontrollable() then
		VtolMovement.z = -1000
	end

	self:ApplyAngForce( AngForce * Mass * FT )
	PhysObj:ApplyForceCenter( (-Vel * 0.7 + vDirection * fForce + VtolMovement) * Mass * FT ) 
end

function ENT:ApplyThrust( PhysObj, vDirection, fForce ) 
	if self:GetEngineActive() and not self:IsDestroyed() then
		CalcFlight(self, PhysObj, vDirection, fForce )
	end
end

hook.Add("PhysgunPickup", "LFS.FB.DoorPhysgun", function( _, ent )
	if ent.LAATDoor then return false end
end)