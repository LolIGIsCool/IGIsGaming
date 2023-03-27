AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )
include("shared.lua")

function ENT:SpawnFunction( ply, tr, ClassName )
	if not tr.Hit then return end

	local ent = ents.Create( ClassName )
	ent.dOwnerEntLFS = ply
	ent:SetPos( tr.HitPos + tr.HitNormal * 75 )
	ent:Spawn()
	ent:Activate()
	
	return ent
end

function ENT:RunOnSpawn()
	local GunnerSeat = self:AddPassengerSeat( Vector(-77,0,35), Angle(0,90,0) )
	self:SetGunnerSeat( GunnerSeat )

	for i=0, 1 do
		for j=0, 2 do
			local Pod = self:AddPassengerSeat( Vector(17-55*j,63-126*i,-35), Angle(0,180*i,0) )
			Pod:SetVehicleClass("k79-s80_pass")
		end
	end
	for i=0, 5 do
		self:AddPassengerSeat( Vector(0,0,0), Angle(0,-90,0) )
	end
	
	self.c = 0
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

	if self:WorldToLocal( data.HitPos ).z > 0 then
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

function ENT:PrimaryAttack()
	if not self:CanPrimaryAttack() then return end
	
	self:SetNextPrimary( 0.3 )
	self:EmitSound( "niksacokica/jfo_vehicles/k79-s80_canons.wav" )
	
	local startpos =  self:GetRotorPos()
	local TracePlane = util.TraceHull( {
		start = startpos,
		endpos = (startpos + self:GetForward() * 50000),
		mins = Vector( -10, -10, -10 ),
		maxs = Vector( 10, 10, 10 ),
		filter = self
	} )
	
	local fP = {
		Vector(160,48,4),
		Vector(160,-48,4),
	}
	
	self.NumPrim = self.NumPrim and self.NumPrim + 1 or 1
	if self.NumPrim > 2 then self.NumPrim = 1 end
	
	local bullet = {}
	bullet.Num 	= 1
	bullet.Src 	= self:LocalToWorld( fP[self.NumPrim] )
	bullet.Dir 	=  (TracePlane.HitPos - bullet.Src):GetNormalized()
	bullet.Spread 	= Vector( 0.01,  0.01, 0 )
	bullet.Tracer	= 1
	bullet.TracerName	= "lfs_laser_red"
	bullet.Force	= 100
	bullet.HullSize 	= 2
	bullet.Damage	= 60 -- Default 50
	bullet.Attacker 	= self:GetDriver()
	bullet.AmmoType = "Pistol"
	bullet.Callback = function(att, tr, dmginfo)
		dmginfo:SetDamageType(DMG_AIRBOAT)
	end
	self:FireBullets( bullet )
	
	self:TakePrimaryAmmo()
end

function ENT:AltPrimaryAttack()
	if not self:CanAltPrimaryAttack() then return end
	
	local MLV, MLA = self:GetBonePosition( self:LookupBone( "turret_muzzle_l" ) )
	local MRV, MRA = self:GetBonePosition( self:LookupBone( "turret_muzzle_r" ) )
	
	if not MLA or not MRA or not MLV or not MRV then return end

	self:SetNextAltPrimary( 0.2 )
	self:EmitSound( "niksacokica/jfo_vehicles/k79-s80_turret.wav" )

	self.MirrorAltPrimary = not self.MirrorAltPrimary

	local Pos = self.MirrorAltPrimary and MLV or MRV
	local Dir = (self.MirrorAltPrimary and MLA or MRA):Up()
	
	local bullet = {}
	bullet.Num 	= 1
	bullet.Src 	= Pos
	bullet.Dir 	=  -Dir+Vector(0,0,0.05)
	bullet.Spread 	= Vector( 0.01,  0.01, 0 )
	bullet.Tracer	= 1
	bullet.TracerName	= "lfs_laser_red"
	bullet.Force	= 100
	bullet.HullSize 	= 2
	bullet.Damage	= 100 -- Default 50
	bullet.Attacker 	= self:GetDriver()
	bullet.AmmoType = "Pistol"
	bullet.Callback = function(att, tr, dmginfo)
		dmginfo:SetDamageType(DMG_AIRBOAT)
	end
	self:FireBullets( bullet )
	
	self:TakePrimaryAmmo()
end

function ENT:SetNextAltPrimary( delay )
	self.NextAltPrimary = CurTime() + delay
end

function ENT:SetNextPrimary( delay )
	self.NextPrimary = CurTime() + delay
end

function ENT:CanAltPrimaryAttack()
	self.NextAltPrimary = self.NextAltPrimary or 0
	return self.NextAltPrimary < CurTime()
end

function ENT:CanPrimaryAttack()
	self.NextPrimary = self.NextPrimary or 0
	return self.NextPrimary < CurTime()
end

function ENT:HandleWeapons(Fire1, Fire2)
	local Gunner = self:GetGunner()
	local Driver = self:GetDriver()
	
	if IsValid( Gunner ) and Gunner:KeyDown( IN_ATTACK ) and self:GetAmmoPrimary() > 0 then
		self:AltPrimaryAttack( Gunner, self:GetGunnerSeat() )
	end
	
	if IsValid( Driver ) and Driver:KeyDown( IN_ATTACK ) and self:GetAmmoPrimary() > 0 then
		self:PrimaryAttack()
	end
end

function ENT:TurretPose()
	local ang = self:WorldToLocalAngles(self:GetGunner():EyeAngles())
	local aimy = math.AngleDifference(ang.y, self:GetAngles().y)
	self:ManipulateBoneAngles(self:LookupBone("turret_yaw"), Angle(aimy+90,0,0))
	
	local aimx = math.Clamp( self:GetGunner():EyeAngles().p,-90,3 )
	self:ManipulateBoneAngles(self:LookupBone("turret_pitch"), Angle(0,0,-aimx))
end

function ENT:OnTick()
	if self:GetAI() then self:SetAI( false ) end
	
	if IsValid(self:GetGunner()) then self:TurretPose() end
	
	if not self:GetEngineActive() then return end
	
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

	if not self:HitGround() then return end

	local Speed = self.MaxVelocity - (Boost and 0 or self.BoostVelAdd)
	PhysObj:ApplyForceCenter( ((self:GetForward() * MoveX + self:GetRight() * MoveY):GetNormalized() * Speed + (-self:GetForward() * VelL.x + self:GetRight() * VelL.y) * self.DampingMul) * self.ThrustMul  * Mass * FT ) 
end

function ENT:OnLandingGearToggled( bOn )
	self.s = self.s or 0
	if not (self.s < CurTime()) then return end
	self.s = CurTime() + 1
	
	self:EmitSound( "niksacokica/jfo_vehicles/k79-s80_doors.wav" )
	local i
	if self.c == 0 then
		i=0
		timer.Create( "rotation_open" .. self:EntIndex(), 1/66, 55, function() 
			self:ManipulateBoneAngles(self:LookupBone("door_1_l"), Angle(i,0,0))
			self:ManipulateBoneAngles(self:LookupBone("door_1_r"), Angle(-i,0,0))
			
			self:ManipulateBoneAngles(self:LookupBone("door_2_l"), Angle(i,0,0))
			self:ManipulateBoneAngles(self:LookupBone("door_2_r"), Angle(-i,0,0))
			
			self:ManipulateBoneAngles(self:LookupBone("door_3_l"), Angle(i,0,0))
			self:ManipulateBoneAngles(self:LookupBone("door_3_r"), Angle(-i,0,0))
			
			self:ManipulateBoneAngles(self:LookupBone("door_4_l"), Angle(i,0,0))
			self:ManipulateBoneAngles(self:LookupBone("door_4_r"), Angle(-i,0,0))
			
			self:ManipulateBoneAngles(self:LookupBone("door_5_l"), Angle(i,0,0))
			self:ManipulateBoneAngles(self:LookupBone("door_5_r"), Angle(-i,0,0))
			
			self:ManipulateBoneAngles(self:LookupBone("door_6_l"), Angle(i,0,0))
			self:ManipulateBoneAngles(self:LookupBone("door_6_r"), Angle(-i,0,0))
			i = i-2
		end)
		self.c = 1
	else
	 i=-110
		timer.Create( "rotation_close" .. self:EntIndex(), 1/66, 55, function() 
			self:ManipulateBoneAngles(self:LookupBone("door_1_l"), Angle(i,0,0))
			self:ManipulateBoneAngles(self:LookupBone("door_1_r"), Angle(-i,0,0))
			
			self:ManipulateBoneAngles(self:LookupBone("door_2_l"), Angle(i,0,0))
			self:ManipulateBoneAngles(self:LookupBone("door_2_r"), Angle(-i,0,0))
			
			self:ManipulateBoneAngles(self:LookupBone("door_3_l"), Angle(i,0,0))
			self:ManipulateBoneAngles(self:LookupBone("door_3_r"), Angle(-i,0,0))
			
			self:ManipulateBoneAngles(self:LookupBone("door_4_l"), Angle(i,0,0))
			self:ManipulateBoneAngles(self:LookupBone("door_4_r"), Angle(-i,0,0))
			
			self:ManipulateBoneAngles(self:LookupBone("door_5_l"), Angle(i,0,0))
			self:ManipulateBoneAngles(self:LookupBone("door_5_r"), Angle(-i,0,0))
			
			self:ManipulateBoneAngles(self:LookupBone("door_6_l"), Angle(i,0,0))
			self:ManipulateBoneAngles(self:LookupBone("door_6_r"), Angle(-i,0,0))
			i = i+2
		end)
		self.c = 0
	end
end

function ENT:InitWheels()
	self.FilterEnts = { self }

	local Wheels = {
		Vector(-10,66,-55),
		Vector(-100,66,-55),
		Vector(90,66,-55),
		
		Vector(-10,-66,-55),
		Vector(-100,-66,-55),
		Vector(90,-66,-55),
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

function ENT:InWater()
	return false
end

function ENT:OnEngineStarted()
	self:EmitSound( "niksacokica/jfo_vehicles/k79-s80_engine_on.wav" )
end

function ENT:OnEngineStopped()
	self:EmitSound( "niksacokica/jfo_vehicles/k79-s80_engine_off.wav" )
	self:SetGravityMode( true )
end