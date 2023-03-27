AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )
include("shared.lua")

function ENT:SpawnFunction( ply, tr, ClassName )
	if not tr.Hit then return end

	local ent = ents.Create( ClassName )
	ent.dOwnerEntLFS = ply
	ent:SetPos( tr.HitPos + tr.HitNormal * 44 )
	ent:Spawn()
	ent:Activate()
	
	return ent
end

function ENT:CreateNewPos( ply )

	local boneAngles = {
		[1] = {
			bone = "ValveBiped.Bip01_L_Thigh",
			ang = Angle(-20,-65,30)
		},
		[2] = {
			bone = "ValveBiped.Bip01_R_Thigh",
			ang = Angle(20,-65,-30)
		},
		[3] = {
			bone = "ValveBiped.Bip01_L_Calf",
			ang = Angle(15,110,10)
		},
		[4] = {
			bone = "ValveBiped.Bip01_R_Calf",
			ang = Angle(-15,110,-10)
		},
		[5] = {
			bone = "ValveBiped.Bip01_L_Foot",
			ang = Angle(20,-15,0)
		},
		[6] = {
			bone = "ValveBiped.Bip01_R_Foot",
			ang = Angle(-20,-15,0)
		},
		[7] = {
			bone = "ValveBiped.Bip01_Spine",
			ang = Angle(0,22,0)
		},
		[8] = {
			bone = "ValveBiped.Bip01_Spine1",
			ang = Angle(0,20,0)
		},
		[9] = {
			bone = "ValveBiped.Bip01_Spine2",
			ang = Angle(0,20,0)
		},
		[10] = {
			bone = "ValveBiped.Bip01_Spine3",
			ang = Angle(0,20,0)
		},
		[11] = {
			bone = "ValveBiped.Bip01_Neck1",
			ang = Angle(0,20,0)
		},
		[12] = {
			bone = "ValveBiped.Bip01_Head1",
			ang = Angle(0,20,0)
		},
		[13] = {
			bone = "ValveBiped.Bip01_L_UpperArm",
			ang = Angle(0,-95,0)
		},
		[14] = {
			bone = "ValveBiped.Bip01_R_UpperArm",
			ang = Angle(0,-95,0)
		},
		[15] = {
			bone = "ValveBiped.Bip01_L_Forearm",
			ang = Angle(-35,-70,20)
		},
		[16] = {
			bone = "ValveBiped.Bip01_R_Forearm",
			ang = Angle(35,-70,-20)
		},
		[17] = {
			bone = "ValveBiped.Bip01_L_Hand",
			ang = Angle(-20,0,44)
		},
		[18] = {
			bone = "ValveBiped.Bip01_R_Hand",
			ang = Angle(20,0,-44)
		},
		[19] = {
			bone = "ValveBiped.Bip01_R_Finger1",
			ang = Angle(0,-40,0)
		},
		[20] = {
			bone = "ValveBiped.Bip01_R_Finger2",
			ang = Angle(-10,-40,0)
		},
		[21] = {
			bone = "ValveBiped.Bip01_R_Finger3",
			ang = Angle(-20,-40,0)
		},
		[22] = {
			bone = "ValveBiped.Bip01_R_Finger4",
			ang = Angle(-30,-40,0)
		},
		[23] = {
			bone = "ValveBiped.Bip01_L_Finger1",
			ang = Angle(0,-40,0)
		},
		[24] = {
			bone = "ValveBiped.Bip01_L_Finger2",
			ang = Angle(10,-40,0)
		},
		[25] = {
			bone = "ValveBiped.Bip01_L_Finger3",
			ang = Angle(20,-40,0)
		},
		[26] = {
			bone = "ValveBiped.Bip01_L_Finger4",
			ang = Angle(30,-40,0)
		},
		[27] = {
			bone = "ValveBiped.Bip01_R_Finger11",
			ang = Angle(0,-30,0)
		},
		[28] = {
			bone = "ValveBiped.Bip01_R_Finger21",
			ang = Angle(0,-30,0)
		},
		[29] = {
			bone = "ValveBiped.Bip01_R_Finger31",
			ang = Angle(0,-30,0)
		},
		[30] = {
			bone = "ValveBiped.Bip01_R_Finger41",
			ang = Angle(0,-30,0)
		},
		[31] = {
			bone = "ValveBiped.Bip01_L_Finger11",
			ang = Angle(0,-30,0)
		},
		[32] = {
			bone = "ValveBiped.Bip01_L_Finger21",
			ang = Angle(0,-30,0)
		},
		[33] = {
			bone = "ValveBiped.Bip01_L_Finger31",
			ang = Angle(0,-30,0)
		},
		[34] = {
			bone = "ValveBiped.Bip01_L_Finger41",
			ang = Angle(0,-30,0)
		},
	}

	local ragdoll = ents.Create("prop_physics")
	ragdoll:SetPos(self:LocalToWorld(self:WorldToLocal(self:GetDriverSeat():GetPos() + Vector(-2, 0, -33))))
	ragdoll:SetAngles(self:LocalToWorldAngles(self:WorldToLocalAngles(self:GetDriverSeat():GetAngles()) + Angle(5, 90, 0)))
	ragdoll:SetModel(ply:GetModel())
	ragdoll:Spawn()
	ragdoll:SetParent(self)
	for _, inf in pairs( boneAngles ) do
		local bone = ragdoll:LookupBone(inf.bone)
		if bone then
			ragdoll:ManipulateBoneAngles(bone, inf.ang )
		end
	end
	
	self:DeleteOnRemove( ragdoll )
	ragdoll:SetOwner( ply )
	
	self.rag = ragdoll
	table.insert(self.FilterEnts, ragdoll)
end

function ENT:Use( ply )
	if not IsValid( ply ) then return end

	if self:GetlfsLockedStatus() or (simfphys.LFS.TeamPassenger:GetBool() and ((self:GetAITEAM() ~= ply:lfsGetAITeam()) and ply:lfsGetAITeam() ~= 0 and self:GetAITEAM() ~= 0)) then 

		self:EmitSound( "doors/default_locked.wav" )

		return
	end

	self:SetPassenger( ply )
	self:CreateNewPos( ply )
end

function ENT:PrimaryAttack()
	if not self:CanPrimaryAttack() then return end
	if not self:GetEngineActive() then return end

	self:EmitSound( "niksacokica/74-z_speeder_bike/cannon.wav" )
	
	self:SetNextPrimary( 0.2 )
	
	local startpos =  self:GetRotorPos()
	local TracePlane = util.TraceHull( {
		start = startpos,
		endpos = (startpos + self:GetForward() * 50000),
		mins = Vector( -10, -10, -10 ),
		maxs = Vector( 10, 10, 10 ),
		filter = self.FilterEnts
	} )

	local bullet = {}
	bullet.Num 	= 1
	bullet.Src 	= self:LocalToWorld( Vector(10,0,-5) )
	bullet.Dir 	= (TracePlane.HitPos - bullet.Src):GetNormalized()
	bullet.Spread 	= Vector( 0.01,  0.01, 0.01 )
	bullet.Tracer	= 1
	bullet.TracerName	= "lfs_laser_green"
	bullet.Force	= 200
	bullet.HullSize 	= 10
	bullet.Damage	= 200
	bullet.Attacker 	= self:GetDriver()
	bullet.AmmoType = "Pistol"
	local startpos =  bullet.Src
	local tp = util.TraceHull( {
		start = startpos,
		endpos = (startpos + self:GetForward() * 50000),
		mins = Vector( -10, -10, -10 ),
		maxs = Vector( 10, 10, 10 ),
		filter = self
	} )
	if tp.Hit and tp.Entity == self.FilterEnts[2] then
		bullet.IgnoreEntity = self.FilterEnts[2]
	elseif tp.Hit and tp.Entity == self.FilterEnts[4] then
		bullet.IgnoreEntity = self.FilterEnts[4]
	end
	bullet.Callback = function(att, tr, dmginfo)
		dmginfo:SetDamageType(DMG_AIRBOAT)
	end
	self:FireBullets( bullet )
	self:TakePrimaryAmmo()
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

function ENT:OnTick()
	if not IsValid(self:GetDriver()) and IsValid(self.rag) then self.rag:Remove() end
	
	if self:GetAI() then self:SetAI( false ) end
	
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

	self:ApplyAngForce( AngForce * Mass * FT )
	
	if not self:HitGround() then return end

	local Speed = self.MaxVelocity - (Boost and 0 or self.BoostVelAdd)
	PhysObj:ApplyForceCenter( ((self:GetForward() * MoveX + self:GetRight() * MoveY):GetNormalized() * Speed + (-self:GetForward() * VelL.x + self:GetRight() * VelL.y) * self.DampingMul) * self.ThrustMul  * Mass * FT ) 
end

function ENT:InitWheels()
	self.FilterEnts = { self }

	local Wheels = {
		Vector(75,35,-20),
		Vector(-50,35,-21),
		
		Vector(75,-35,-20),
		Vector(-50,-35,-21),
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
			wheel:SetCollisionGroup( COLLISION_GROUP_WEAPON )
			
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
	
	return tr.Hit or tr_w.Hit
end

function ENT:OnLandingGearToggled( bOn )
	if bOn then
		local boneAngles = {
			[1] = {
				bone = "ValveBiped.Bip01_L_Forearm",
				ang = Angle(-25,-10,10)
			},
			[2] = {
				bone = "ValveBiped.Bip01_R_Forearm",
				ang = Angle(20,-10,-10)
			},
		}
		for _, inf in pairs( boneAngles ) do
			local bone = self.rag:LookupBone(inf.bone)
			if bone then
				self.rag:ManipulateBoneAngles(bone, inf.ang )
			end
		end
	else
		local boneAngles = {
			[1] = {
				bone = "ValveBiped.Bip01_L_Forearm",
				ang = Angle(-35,-70,20)
			},
			[2] = {
				bone = "ValveBiped.Bip01_R_Forearm",
				ang = Angle(35,-70,-20)
			},
		}
		for _, inf in pairs( boneAngles ) do
			local bone = self.rag:LookupBone(inf.bone)
			if bone then
				self.rag:ManipulateBoneAngles(bone, inf.ang )
			end
		end
	end
end

function ENT:InWater()
	return false
end

function ENT:OnEngineStarted()
	self:EmitSound( "niksacokica/74-z_speeder_bike/engine_on.wav" )
end

function ENT:OnEngineStopped()
	self:EmitSound( "niksacokica/74-z_speeder_bike/engine_off.wav" )
	self:SetGravityMode( true )
end