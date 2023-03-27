--DO NOT EDIT OR REUPLOAD THIS FILE

AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )
include("shared.lua")

function ENT:SpawnFunction( ply, tr, ClassName )
	if not tr.Hit then return end

	local ent = ents.Create( ClassName )
	ent.dOwnerEntLFS = ply
	ent:SetPos( tr.HitPos + tr.HitNormal * 80 )
	ent:Spawn()
	ent:Activate()

	return ent
end

function ENT:RunOnSpawn()
	local TXGunnerSeat = self:AddPassengerSeat( Vector(0,0,0), Angle(0,-90,0) )
	self:SetGunnerSeat( TXGunnerSeat )

	local ID = self:LookupAttachment( "driver_turret" )
	local Attachment = self:GetAttachment( ID )
	
	if Attachment then
		local Pos,Ang = LocalToWorld( Vector(0,-60,0), Angle(180,0,-90), Attachment.Pos, Attachment.Ang )
		
		TXGunnerSeat:SetParent( NULL )
		TXGunnerSeat:SetPos( Pos )
		TXGunnerSeat:SetAngles( Ang )
		TXGunnerSeat:SetParent( self, ID )
	end
	
	self:AddPassengerSeat( Vector(-68,-23,18), Angle(0,-90,15) )
	
end

function ENT:MainGunPoser( EyeAngles )

	self.MainGunDir = EyeAngles:Forward()
	
	local startpos =  self:GetRotorPos()
	local TracePlane = util.TraceHull( {
		start = startpos,
		endpos = (startpos + EyeAngles:Forward() * 50000),
		mins = Vector( -10, -10, -10 ),
		maxs = Vector( 10, 10, 10 ),
		filter = function( ent ) 
			if IsValid( ent ) then
				if ent == self or ent:GetClass() == "lunasflightschool_tx130_missile" then 
					return false
				end
			end
			return true
		end
	} )
	
	local AimAnglesG = self:WorldToLocalAngles( (TracePlane.HitPos - self:LocalToWorld( Vector(-5,51,43) ) ):GetNormalized():Angle() )
	local AimAnglesL = self:WorldToLocalAngles( (TracePlane.HitPos - self:LocalToWorld( Vector(5,51,43) ) ):GetNormalized():Angle() )
	local AimAnglesR = self:WorldToLocalAngles( (TracePlane.HitPos - self:LocalToWorld( Vector(5,-51,43) ) ):GetNormalized():Angle() )
	
	
	self:SetPoseParameter("sidegun_pitch", AimAnglesG.p )
	self:SetPoseParameter("sidegun_left_yaw", AimAnglesL.y )
	self:SetPoseParameter("sidegun_right_yaw", AimAnglesR.y )

	local ID = self:LookupAttachment( "muzzle_left" )
	local Muzzle = self:GetAttachment( ID )
	

    self:SetWeaponOutOfRange( (AimAnglesG.p >= 13.5) or (AimAnglesG.p <= -22 ))

end

function ENT:PrimaryAttack()
	if self:GetIsCarried() then return end
	if not self:CanPrimaryAttack() or self:GetWeaponOutOfRange() then return end

	local ID_L = self:LookupAttachment( "muzzle_left" )
	local ID_R = self:LookupAttachment( "muzzle_right" )
	local MuzzleL = self:GetAttachment( ID_L )
	local MuzzleR = self:GetAttachment( ID_R )
	
	if not MuzzleL or not MuzzleR then return end
	
	if not MuzzleL or not MuzzleR then return end

	self:SetNextPrimary( 0.3 )
	
	self:EmitSound( "TX_FIRE" )

	self.MirrorPrimary = not self.MirrorPrimary

	local Pos = self.MirrorPrimary and MuzzleL.Pos or MuzzleR.Pos
	local Dir =  (self.MirrorPrimary and MuzzleL.Ang or MuzzleR.Ang):Up()
	
	local bullet = {}
	bullet.Num 	= 1
	bullet.Src 	= Pos
	bullet.Dir 	= Dir
	bullet.Spread 	= Vector( 0.01,  0.01, 0 )
	bullet.Tracer	= 1
	bullet.TracerName	= "lfs_laser_red"
	bullet.Force	= 100
	bullet.HullSize 	= 2
	bullet.Damage	= 69
	bullet.Attacker 	= self:GetDriver()
	bullet.AmmoType = "Pistol"
	bullet.Callback = function(att, tr, dmginfo)
		dmginfo:SetDamageType(DMG_AIRBOAT)
	end
	self:FireBullets( bullet )
	
	self:TakePrimaryAmmo()


	
	if self:GetAmmoPrimary() <= 0 then 
	self:EmitSound("TX_TWINCANNON_DEACTIVATE")
	end
end

function ENT:SetNextAltSecondary( delay )
	self.NextAltSecondary = CurTime() + delay
end

function ENT:CanAltSecondaryAttack()
	self.NextAltSecondary = self.NextAltSecondary or 0
	return self.NextAltSecondary < CurTime() and self:GetAmmoSecondary() > 0
end

function ENT:SecondaryAttack()
	if self:GetIsCarried() then return end
	if not self:CanAltSecondaryAttack() or not self.MainGunDir then return end
	if self:GetDoorMode() == 0 then return end

	local ID1 = self:LookupAttachment( "left_launch_tube_1" )
	local ID2 = self:LookupAttachment( "right_launch_tube_1" )
	local ID3 = self:LookupAttachment( "left_launch_tube_2" )
	local ID4 = self:LookupAttachment( "right_launch_tube_2" )
	local ID5 = self:LookupAttachment( "left_launch_tube_3" )
	local ID6 = self:LookupAttachment( "right_launch_tube_3" )
	local ID7 = self:LookupAttachment( "left_launch_tube_4" )
	local ID8 = self:LookupAttachment( "right_launch_tube_4" )
	local ID9 = self:LookupAttachment( "left_launch_tube_5" )
	local ID10 = self:LookupAttachment( "right_launch_tube_5" )

	local Muzzle1 = self:GetAttachment( ID1 )
	local Muzzle2 = self:GetAttachment( ID2 )
	local Muzzle3 = self:GetAttachment( ID3 )
	local Muzzle4 = self:GetAttachment( ID4 )
	local Muzzle5 = self:GetAttachment( ID5 )
	local Muzzle6 = self:GetAttachment( ID6 )
	local Muzzle7 = self:GetAttachment( ID7 )
	local Muzzle8 = self:GetAttachment( ID8 )
	local Muzzle9 = self:GetAttachment( ID9 )
	local Muzzle10 = self:GetAttachment( ID10 )
	
	local FirePos = {
		[1] = Muzzle1,
		[2] = Muzzle2,
		[3] = Muzzle3,
		[4] = Muzzle4,
		[5] = Muzzle5,
		[6] = Muzzle6,
		[7] = Muzzle7,
		[8] = Muzzle8,
		[9] = Muzzle9,
		[10] = Muzzle10,
	}
	
	if not FirePos then return end
	
	self.FireIndex2 = self.FireIndex2 and self.FireIndex2 + 1 or 1
	
	if self.FireIndex2 > 10 then
		self.FireIndex2 = 1
		self:SetNextAltSecondary( 1 )
	else
		if self.FireIndex2 == 10 then
			self:SetNextAltSecondary( 6 )
		else
			self:SetNextAltSecondary( 1 )
		end
	end
	
	self:EmitSound( "TX_ROCKET" )

	local Pos = FirePos[self.FireIndex2].Pos
	local Dir =  FirePos[self.FireIndex2].Ang:Up()
	
	if math.deg( math.acos( math.Clamp( Dir:Dot( self.MainGunDir ) ,-1,1) ) ) < 8 then
		Dir = self.MainGunDir
	end
	
	local ent = ents.Create( "lunasflightschool_tx130_missile" )
	ent:SetPos( Pos )
	ent:SetAngles( Dir:Angle() )
	ent:Spawn()
	ent:Activate()
	ent:SetAttacker( self:GetDriver() )
	ent:SetInflictor( self )

	
	constraint.NoCollide( ent, self, 0, 0 )
	
	self:TakeSecondaryAmmo()
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

	if self:WorldToLocal( data.HitPos ).z > 0 then -- no collision sound when the lower part of the model touches the ground
		if data.Speed > 60 and data.DeltaTime > 0.2 then
			if data.Speed > 500 then
				self:EmitSound( "Airboat_impact_hard" )
				
				self:TakeDamage( 400, data.HitEntity, data.HitEntity )
			else
				self:EmitSound( "MetalVehicle.ImpactSoft" )
			end
		end
	end
end


function ENT:OnIsCarried( name, old, new)
	if new == old then return end

	if new then
		self:SetPoseParameter("sidegun_pitch", 0 )
		self:SetPoseParameter("sidegun_left_yaw", 0 )
		self:SetPoseParameter("sidegun_right_yaw", 0 )
	
		self:SetPoseParameter("cannon_pitch", 0 )
		self:SetPoseParameter("cannon_yaw", 0 )
		
		self:SetPoseParameter("move_x", 0 )
		self:SetPoseParameter("move_y", 0 )

		self:SetWeaponOutOfRange( true )
		self:SetBTLFire( false )
	end
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
end

function ENT:OnEngineStopped()
	self:SetGravityMode( true )
end

function ENT:OnVtolMode( IsOn )
end

function ENT:OnStartMaintenance()
	if not self:GetRepairMode() and not self:GetAmmoMode() then return end

	self.IsReloading = true
end

function ENT:OnStopMaintenance()
	if self:GetAmmoPrimary() == 1500 and self.IsReloading then
	self:EmitSound("TX_TWINCANNON_ACTIVATE")
	end
	
	self.IsReloading = nil
end

function ENT:OnTick()
	if self:GetAI() then self:SetAI( false ) end

	local HasTurret = IsValid( self:GetGunner() )

	local Rate = FrameTime() * 5
	self.smHatch = self.smHatch and self.smHatch + math.Clamp((HasTurret and 1 or 0) - self.smHatch,-Rate,Rate) or 0

	if not HasTurret and self.smHatch > 0.7 then self.smHatch = 0.7 end

	self:SetPoseParameter( "open_hatch", self.smHatch )

	if self:GetIsCarried() then 
		local Angles = self:GetAngles()

		self.smP = Angles.p
		self.smY = Angles.y
		self.smR = Angles.r
		
		return
	end

	local PhysObj = self:GetPhysicsObject()

	if not IsValid( PhysObj ) then return end

	local Pod = self:GetDriverSeat()
	if not IsValid( Pod ) then return end

	local Mass = PhysObj:GetMass()
	local Driver = Pod:GetDriver()

	local VelL = self:WorldToLocal( self:GetPos() + self:GetVelocity() )
	local FT =  FrameTime()

	local MoveX = 0
	local MoveY = 0
	local Boost = false
	local EyeAngles = Angle(0,0,0)

	if IsValid( Driver ) then 
		Boost = Driver:lfsGetInput( "+PITCH" )
		local Forward = Driver:lfsGetInput( "+THROTTLE" ) and 1 or 0
		local Backward = Driver:lfsGetInput( "-THROTTLE" ) and 1 or 0
		local Right = Driver:lfsGetInput( "+ROLL" ) and 1 or 0
		local Left = Driver:lfsGetInput( "-ROLL" ) and 1 or 0

		MoveX = Forward - Backward
		MoveY = Right - Left

		EyeAngles = Pod:WorldToLocalAngles( Driver:EyeAngles() )
		
		self:MainGunPoser( EyeAngles )
		
		if Driver:lfsGetInput( "FREELOOK" ) then
			if isangle( self.StoredEyeAngles ) then
				EyeAngles = self.StoredEyeAngles
				EyeAngles.r = 0
			end
		else
			self.StoredEyeAngles = EyeAngles
		end

		local KeyReload = Driver:lfsGetInput( "ENGINE" )
		if self.OldKeyReload ~= KeyReload then
			self.OldKeyReload = KeyReload

			if KeyReload and not self.IsReloading then
				self:StartMaintenance()
			end
		end
	else
		EyeAngles = self:GetAngles()
	end

	local Angles = self:GetAngles()
	local TargetAngle = EyeAngles

	self.smP = self.smP and math.ApproachAngle( self.smP, TargetAngle.p, self.MaxTurnPitch * FT ) or Angles.p
	self.smY = self.smY and math.ApproachAngle( self.smY, TargetAngle.y, self.MaxTurnYaw * FT ) or Angles.y
	self.smR = self.smR and math.ApproachAngle( self.smR, TargetAngle.r, self.MaxTurnRoll * FT ) or Angles.r

	local LocalAngles = self:WorldToLocalAngles( Angle(self.smP,self.smY,self.smR) )
	
	LocalAngles.p = LocalAngles.p * 4
	LocalAngles.y = LocalAngles.y * 4
	LocalAngles.r = LocalAngles.r * 4

	local AngVel = self:GetAngVel()
	AngVel.p = AngVel.p * self.PitchDamping 
	AngVel.y = AngVel.y * self.YawDamping 
	AngVel.r = AngVel.r * self.RollDamping 
	
	local AngForce = (LocalAngles - AngVel)
	AngForce.p = AngForce.p * self.TurnForcePitch
	AngForce.y = AngForce.y * self.TurnForceYaw
	AngForce.r = AngForce.r * self.TurnForceRoll


	self:SetRPM( math.min(VelL:Length() / self.MaxVelocity,1) * 100 )

	self:SetPoseParameter( "move_x", math.Clamp(-VelL.x / self.MaxVelocity,-1,1) )
	self:SetPoseParameter( "move_y", math.Clamp(-VelL.y / self.MaxVelocity + self:GetAngVel().y / 100,-1,1) )

	self:ApplyAngForce( AngForce *  Mass * FT )

	self:GunnerWeapons( self:GetGunner(),self:GetGunnerSeat() )

	if not self:HitGround() then return end

	local Speed = self.MaxVelocity - (Boost and 0 or self.BoostVelAdd)
	PhysObj:ApplyForceCenter( ((self:GetForward() * MoveX + self:GetRight() * MoveY):GetNormalized() * Speed + (-self:GetForward() * VelL.x + self:GetRight() * VelL.y) * self.DampingMul) * self.ThrustMul  * Mass * FT ) 
end

function ENT:GunnerWeapons(Driver, Pod)
	if IsValid( Driver ) and IsValid( Pod ) then
		Driver:CrosshairDisable()

		if self:GetBodygroup(1) == 0 then
			self:SetPoseParameter("cannon_pitch", 0 )
			self:SetPoseParameter("cannon_yaw", 0 )

			self:SetBTLFire( false )
		else
			local EyeAngles = Pod:WorldToLocalAngles( Driver:EyeAngles() )

			local _,LocalAng = WorldToLocal( Vector(0,0,0), EyeAngles, Vector(0,0,0), self:LocalToWorldAngles( Angle(0,0,0)  ) )

			self:SetPoseParameter("cannon_pitch", LocalAng.p )
			self:SetPoseParameter("cannon_yaw", LocalAng.y )
			
			if self:GetBodygroup(1) == 1 then
				self:SetBTLFire( Driver:KeyDown( IN_ATTACK ) )

				if self:GetBTLFire() then
					local ID = self:LookupAttachment( "lazer_cannon_muzzle" )
					local Muzzle = self:GetAttachment( ID )
					
					if Muzzle then
						local Dir = Muzzle.Ang:Up()
						local startpos = Muzzle.Pos
						
						local Trace = util.TraceLine( {
							start = startpos,
							endpos = (startpos + Dir * 50000),
						} )
						
						self:BallturretDamage( Trace.Entity, Driver, Trace.HitPos, Dir )
					end
				end
			else
				if Driver:KeyDown( IN_ATTACK ) then
					self:FireTurret( Driver )
				end
			end
		end
	else
		self:SetBTLFire( false )
	end
 end

 function ENT:BallturretDamage( target, attacker, HitPos, HitDir )
	if not IsValid( target ) or not IsValid( attacker ) then return end

	if target ~= self then
		local dmginfo = DamageInfo()
		dmginfo:SetDamage( 500 * FrameTime() )
		dmginfo:SetAttacker( attacker )
		dmginfo:SetDamageType( bit.bor( DMG_SHOCK, DMG_ENERGYBEAM ) )
		dmginfo:SetInflictor( self ) 
		dmginfo:SetDamagePosition( HitPos ) 
		dmginfo:SetDamageForce( HitDir * 10000 ) 
		target:TakeDamageInfo( dmginfo )
	end
end

function ENT:IsEngineStartAllowed() -- always allow it to be turned on
	return true
end

function ENT:HandleStart() -- autostart 
	local Driver = self:GetDriver()
	
	local Active = (IsValid( Driver ) or self:GetAI()) and not self:GetIsCarried()

	if Active then
		if not self:GetEngineActive() then
			self:StartEngine()
		end
	else
		if self:GetEngineActive() then
			self:StopEngine()
		end
	end
end

function ENT:InitWheels() -- technically where the hover magic happens
	self.FilterEnts = { self }

	local Wheels = {
		Vector(-100,-80,-12),
		Vector(0,-80,-11),
		Vector(100,-80,-7),

		Vector(-100,80,-12),
		Vector(0,80,-11),
		Vector(100,80,-7),
	}

	local mass = 25
	local radius = 14

	for _, pos in pairs( Wheels ) do
		local wheel = ents.Create( "prop_physics" )
	
		if IsValid( wheel ) then
			wheel:SetPos( self:LocalToWorld( pos ) )
			wheel:SetAngles( self:LocalToWorldAngles( Angle(0,90,0) ) )
			
			wheel:SetModel( "models/props_vehicles/tire001c_car.mdl" )
			wheel:Spawn()
			wheel:Activate()
			
			wheel:SetNoDraw( true )
			wheel:DrawShadow( false )
			wheel.DoNotDuplicate = true
			
			wheel:PhysicsInitSphere( radius, "gmod_silent")
			wheel:SetCollisionBounds( Vector(-radius,-radius,-radius), Vector(radius,radius,radius) )
			
			local WpObj = wheel:GetPhysicsObject()
			if not IsValid( WpObj ) then
				self:Remove()
				
				print("LFS: Failed to initialize landing gear phys model. Plane terminated.")
				return
			end

			WpObj:EnableMotion(false)
			WpObj:SetMass( mass )
			WpObj:SetBuoyancyRatio( 10 )
			
			self:DeleteOnRemove( wheel )
			wheel:DeleteOnRemove( self )
			self:dOwner( wheel )
			
			self:dOwner( constraint.AdvBallsocket(wheel, self,0,0,Vector(0,0,0),Vector(0,0,0),0,0, -180, -180, -180, 180, 180, 180, 0, 0, 0, 0, 1) )
			self:dOwner( constraint.NoCollide( wheel, self, 0, 0 ) )
			
			WpObj:EnableMotion( true )
			WpObj:EnableDrag( false ) 

			if WpObj:GetMaterial() ~= "gmod_silent" then
				self:Remove()

				print("LFS: Failed to initialize landing gear. Plane terminated.")

				return
			end
			table.insert(self.FilterEnts, wheel)
		else
			self:Remove()
		
			print("LFS: Failed to initialize landing gear. Plane terminated.")
		end
	end
	
	local PObj = self:GetPhysicsObject()
	
	if IsValid( PObj ) then 
		PObj:EnableMotion( true )
	end
	
	self:PhysWake() 
end

function ENT:ApplyThrust( PhysObj, vDirection, fForce ) 
end

function ENT:InWater()
	return false
end

function ENT:OnLandingGearToggled( bOn )
	local Driver = self:GetDriver()
	
	if not IsValid( Driver ) then return end
	
	if Driver:KeyDown( IN_ZOOM ) then
	local ToggleHatch = not self:GetRearHatch()
		self:SetRearHatch( ToggleHatch )
		
		if ToggleHatch then
		if self:GetBodygroup(9) == 0 then
		self:SetBodygroup(9, 1)
		self:EmitSound( "items/flashlight1.wav" )
		else
		self:SetBodygroup(9, 0)
		self:EmitSound( "items/flashlight1.wav" )
		end
		else
		if self:GetBodygroup(9) == 1 then
		self:SetBodygroup(9, 0)
		self:EmitSound( "items/flashlight1.wav" )
		else
		self:SetBodygroup(9, 1)
		self:EmitSound( "items/flashlight1.wav" )
		end
		end
		
	else
	
	local DoorMode = self:GetDoorMode() + 1

			self:SetDoorMode( DoorMode )
			
			if DoorMode == 1 then
				self:PlayAnimation( "rocket_hatch_open" )
				self:EmitSound( "TX_ROCKETPODS_RAISE" )
			end
			
			if DoorMode >= 2 then
				self:PlayAnimation( "rocket_hatch_close" )
				self:EmitSound( "TX_ROCKETPODS_LOWER" )
				self:SetDoorMode( 0 )
			end
		
	end
end

function ENT:HitGround()
	if not istable( self.FilterEnts ) then return false end

	if not isvector( self.obbvc ) or not isnumber( self.obbvm ) then
		self.obbvc = self:OBBCenter() 
		self.obbvm = self:OBBMins().z
	end
	
	local tr = util.TraceHull( {
		start = self:LocalToWorld( self.obbvc ),
		endpos = self:LocalToWorld( self.obbvc + Vector(0,0,self.obbvm - 100) ),
		mins = Vector( -50, -50, 0 ),
		maxs = Vector( 50, 50, 0 ),
		filter = self.FilterEnts
	} )
	
	local tr_w = util.TraceHull( {
		start = self:LocalToWorld( self.obbvc ),
		endpos = self:LocalToWorld( self.obbvc + Vector(0,0,self.obbvm - 100) ),
		mins = Vector( -50, -50, 0 ),
		maxs = Vector( 50, 50, 0 ),
		filter = self.FilterEnts,
		mask = MASK_WATER
	} )
	
	return (tr.Hit or tr_w)
end