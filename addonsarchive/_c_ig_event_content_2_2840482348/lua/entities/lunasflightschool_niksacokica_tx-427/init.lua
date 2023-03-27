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
	self.co_driver = self:AddPassengerSeat( Vector(20,-25,35), Angle(0,-90,0) )
	self.gunner = self:AddPassengerSeat( Vector(-85,0,80), Angle(0,-90,0) )
	
	self:AddPassengerSeat( Vector(-30,-30,35), Angle(0,0,0) )
	self:AddPassengerSeat( Vector(-70,-30,35), Angle(0,00,0) )
	self:AddPassengerSeat( Vector(-30,30,35), Angle(0,180,0) )
	self:AddPassengerSeat( Vector(-70,30,35), Angle(0,180,0) )
	
	self.DriverFlashlights = {}
	self.GunnerFlashlights = {}
	self.FlashlightsDriver = {
        { Vector( 110, 48, 60 ), Angle( 15, 0, 0 ) },
		{ Vector( 110, -48, 60 ), Angle( 15, 0, 0 ) }
    }
	self.FlashlightsGunner = {
		{ Vector( 0, -70, -10 ), Angle( 0, 90, 0 ) },
		{ Vector( -16, -106, -25 ), Angle( 0, 90, 0 ) }
	}
	self.DriverFlash = false
	self.GunnerFlash = false
	self.DriverFlashCool = CurTime()
	self.GunnerFlashCool = CurTime()
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

function ENT:OnIsCarried( name, old, new)
	if new == old then return end
	
	if new then
		self:StopEngine()
		
		self:SetPoseParameter("turret_yaw", 0 )
		self:SetPoseParameter("turret_pitch", 0 )

		self:SetPoseParameter("blasters_left_yaw", 0 )
		self:SetPoseParameter("blasters_left_pitch", 0 )

		self:SetPoseParameter("blasters_right_yaw", 0 )
		self:SetPoseParameter("blasters_right_pitch", 0 )
		
		self:SetPoseParameter("missiles_left_pitch", 0 )
		self:SetPoseParameter("missiles_right_pitch", 0 )
		
		if self.DriverFlash then
			self:RemoveFlashlights( true )
		end
		if self.GunnerFlash then
			self:RemoveFlashlights( false )
		end
	end
end

function ENT:OnTick()
	self:Passengers()
	self:Lights()
	
	local driver = self:GetDriver()
	if IsValid( driver ) and not self:GetIsCarried() and self:GetEngineActive() then
		self:DriverWeapons( driver, self:GetDriverSeat() )
	end
	
	local co_driver = self:GetCoDriver()
	if IsValid( co_driver ) and not self:GetIsCarried() and self:GetEngineActive() then
		self:CoDriverWeapons( co_driver, self.co_driver )
	end
	
	local gunner = self:GetMainGunner()
	if IsValid( gunner ) and not self:GetIsCarried() and self:GetEngineActive() then
		self:GunnerWeapons( gunner, self.gunner )
	end

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

	self:ApplyAngForce( AngForce * Mass * FT )
	
	if not self:HitGround() then return end

	local Speed = self.MaxVelocity - (Boost and 0 or self.BoostVelAdd)
	PhysObj:ApplyForceCenter( ((self:GetForward() * MoveX + self:GetRight() * MoveY):GetNormalized() * Speed + (-self:GetForward() * VelL.x + self:GetRight() * VelL.y) * self.DampingMul) * self.ThrustMul * Mass * FT ) 
end

function ENT:CreateFlashlights( driver )
	if driver then
		local i = 1;
		for k,v in pairs( self.FlashlightsDriver ) do
			self.DriverFlashlights[i] = ents.Create( "env_projectedtexture" )
			self.DriverFlashlights[i]:SetParent( self )

			self.DriverFlashlights[i]:SetLocalPos( v[1] )
			self.DriverFlashlights[i]:SetLocalAngles( v[2] )

			self.DriverFlashlights[i]:SetKeyValue( "enableshadows", 1 )
			self.DriverFlashlights[i]:SetKeyValue( "farz", 5000 )
			self.DriverFlashlights[i]:SetKeyValue( "nearz", 12 )
			self.DriverFlashlights[i]:SetKeyValue( "lightfov", 60 )
			self.DriverFlashlights[i]:SetKeyValue( "lightcolor", "180 180 180 255" )
			
			self.DriverFlashlights[i]:Spawn()
			self.DriverFlashlights[i]:Input( "SpotlightTexture", NULL, NULL, "effects/flashlight001" )
			i = i + 1;
		end
		
		self.DriverFlash = true
	else
		local i = 1;
		for k,v in pairs( self.FlashlightsGunner ) do
			self.GunnerFlashlights[i] = ents.Create( "env_projectedtexture" )
			self.GunnerFlashlights[i]:SetParent( self, self:LookupAttachment( "turret_muzzle" ) )
			self.GunnerFlashlights[i]:SetMoveType( MOVETYPE_NONE )

			self.GunnerFlashlights[i]:SetLocalPos( v[1] )
			self.GunnerFlashlights[i]:SetLocalAngles( v[2] )

			self.GunnerFlashlights[i]:SetKeyValue( "enableshadows", 1 )
			self.GunnerFlashlights[i]:SetKeyValue( "farz", 5000 )
			self.GunnerFlashlights[i]:SetKeyValue( "nearz", 12 )
			self.GunnerFlashlights[i]:SetKeyValue( "lightfov", 60 )
			self.GunnerFlashlights[i]:SetKeyValue( "lightcolor", "180 180 180 255" )
			
			self.GunnerFlashlights[i]:Spawn()
			self.GunnerFlashlights[i]:Input( "SpotlightTexture", NULL, NULL, "effects/flashlight001" )
			i = i + 1;
		end
		
		self.GunnerFlash = true
    end
end
    
function ENT:RemoveFlashlights( driver )
	if driver then
		if not table.IsEmpty( self.DriverFlashlights ) then
			for k, v in pairs( self.DriverFlashlights ) do
				v:Remove(); 
			end
			
			table.Empty( self.DriverFlashlights );
		end
		
		self.DriverFlash = false;
	else
		if not table.IsEmpty( self.GunnerFlashlights ) then
			for k, v in pairs( self.GunnerFlashlights ) do
				v:Remove(); 
			end
			
			table.Empty( self.GunnerFlashlights );
		end
		
		self.GunnerFlash = false;
	end
end

function ENT:Lights()
	local driver = self:GetDriver()
	local gunner = self:GetMainGunner()
	
	if self.DriverFlashCool < CurTime() and IsValid( driver ) and driver:KeyDown( IN_JUMP ) then
		self.DriverFlashCool = CurTime() + 1
		
		if self.DriverFlash then			
			self:RemoveFlashlights( true )
		elseif self:GetEngineActive() and not self:GetIsCarried() then			
			self:CreateFlashlights( true )
		end
	end
	if self.GunnerFlashCool < CurTime() and IsValid( gunner ) and gunner:KeyDown( IN_JUMP ) then
		self.GunnerFlashCool = CurTime() + 1
		
		if self.GunnerFlash then
			self:RemoveFlashlights( false )
		elseif self:GetEngineActive() and not self:GetIsCarried() then		
			self:CreateFlashlights( false )
		end
	end
	
	if self.GunnerFlash then
		local ang = self.GunnerFlashlights[2]:GetLocalAngles()
		ang.x = -self:GetPoseParameter( "turret_pitch" )
		self.GunnerFlashlights[2]:SetLocalAngles( ang )
	end
end

function ENT:Passengers()
	if IsValid( self.gunner ) then
		local gunner = self.gunner:GetDriver()
		if gunner ~= self:GetMainGunner() then
			self:SetMainGunner( gunner )
			
			if IsValid( gunner ) then
				gunner:lfsBuildControls()
			end
		end
	end
	
	if IsValid( self.co_driver ) then
		local co_driver = self.co_driver:GetDriver()
		if co_driver ~= self:GetCoDriver() then
			self:SetCoDriver( co_driver )
			
			if IsValid( co_driver ) then
				co_driver:lfsBuildControls()
			end
		end
	end
end

function ENT:GunnerWeapons( gunner, Pod )
	self:RotateTurret( Pod:WorldToLocalAngles( gunner:EyeAngles() ), Pod )

	if gunner:KeyDown( IN_ATTACK ) then
		self:FireTurretPrimary()
	end
	
	if gunner:KeyDown( IN_ATTACK2 ) then
		self:FireTurretSecondary()
	end
end

function ENT:RotateTurret( TargetAngle, pod )
	local TurretPos = self:GetBonePosition( self:LookupBone( "rig_tx427.turret" ) )
	
	local TraceLine = util.TraceLine( {
		start = TurretPos,
		endpos = (TurretPos + TargetAngle:Forward() * 10000),
		filter = self,
	} )
	
	local Pos, Ang = WorldToLocal( Vector(0,0,0), (TraceLine.HitPos - TurretPos):GetNormalized():Angle(), Vector(0,0,0), self:GetAngles() )
	local AimRate = 100 * FrameTime()
	
	self.main_pitch = self.main_pitch and math.ApproachAngle( self.main_pitch, Ang.p, AimRate ) or 0
	self.main_yaw = self.main_yaw and math.ApproachAngle( self.main_yaw, Ang.y, AimRate ) or 0
	
	local TargetAng = Angle(-self.main_pitch, self.main_yaw, 0)
	TargetAng:Normalize()
	
	self:SetPoseParameter("turret_pitch", TargetAng.p + ( 1 - TraceLine.Fraction ) )
	self:SetPoseParameter("turret_yaw", TargetAng.y )
end

function ENT:FireTurretPrimary()
	self.turretfirep = self.turretfirep or 0
	if self.turretfirep > CurTime() then return end
	self.turretfirep = CurTime() + 3
	
	local ID = self:LookupAttachment( "turret_muzzle" )
	local Muzzle = self:GetAttachment( ID )

	self:EmitSound( "niksacokica/tx-427/cannon_big.wav" )

	if Muzzle then		
		local effectdata = EffectData()
			effectdata:SetEntity( self )
		util.Effect( "lfs_aat_muzzle", effectdata )
		
		local ent = ents.Create( "lfs_tx-427_main" )
		ent:SetPos( Muzzle.Pos )
		ent:SetAngles( (-Muzzle.Ang:Right()):Angle() )
		ent:Spawn()
		ent.attacker = self:GetMainGunner()
		ent.inflictor = self

		local PhysObj = self:GetPhysicsObject()
		if IsValid( PhysObj ) then
			PhysObj:ApplyForceOffset( -Muzzle.Ang:Up() * 20000, Muzzle.Pos )
		end
	end
end

function ENT:FireTurretSecondary()
	self.turretfires = self.turretfires or 0
	if self.turretfires > CurTime() then return end
	self.turretfires = CurTime() + 0.2
	
	local Muzzle = self:GetAttachment( self:LookupAttachment( "turret_muzzle" ) )

	if Muzzle then
		self:EmitSound( "niksacokica/tx-427/cannon_small.wav" )
	
		local bullet = {}
		bullet.Num 	= 1
		bullet.Src 	= Muzzle.Pos-Muzzle.Ang:Forward()*9+Muzzle.Ang:Right()*50
		bullet.Dir 	= -Muzzle.Ang:Right()
		bullet.Spread 	= Vector( 0.01,  0.01, 0 )
		bullet.Tracer	= 1
		bullet.TracerName	= "lfs_laser_blue"
		bullet.Force	= 20
		bullet.HullSize 	= 2
		bullet.Damage	= 20
		bullet.Attacker 	= self:GetMainGunner()
		bullet.AmmoType = "Pistol"
		bullet.Callback = function(att, tr, dmginfo)
			dmginfo:SetDamageType(DMG_AIRBOAT)
		end
		self:FireBullets( bullet )
	end
end

function ENT:DriverWeapons( driver, Pod )
	self:RotateDriverWeapons( Pod:WorldToLocalAngles( driver:EyeAngles() ), Pod )
	
	if driver:KeyDown( IN_ATTACK ) then
		self:FireRockets()
	end
end

function ENT:FireRockets()
	self.firer = self.firer or 0
	if self.firer > CurTime() then return end
	self.firer = CurTime() + 1
	
	local fpr = {}
	local fpl = {}
	for j = 0, 3 do
		for k = 0, 3 do
			table.insert( fpr, "missiles_right_muzzle_" .. j .. k )
			table.insert( fpl, "missiles_left_muzzle_" .. j .. k )
		end
	end
	
	self.NumR = self.NumR and self.NumR + 1 or 1
	if self.NumR > 16 then self.NumR = 1
	elseif self.NumR == 16 then self.firer = CurTime() + 30 end
	
	local pos1 = self:GetAttachment( self:LookupAttachment( fpr[self.NumR] ) ).Pos
	local ang1 = ( -self:GetAttachment( self:LookupAttachment( fpr[self.NumR] ) ).Ang:Right() ):Angle()
	local pos2 = self:GetAttachment( self:LookupAttachment( fpl[self.NumR] ) ).Pos
	local ang2 = ( -self:GetAttachment( self:LookupAttachment( fpl[self.NumR] ) ).Ang:Right() ):Angle()
	
	local ent1 = ents.Create( "lunasflightschool_missile" )
	ent1:SetPos( pos1 )
	ent1:SetAngles( ang1 )
	ent1:Spawn()
	ent1:Activate()
	ent1:SetAttacker( self:GetCoDriver() )
	ent1:SetInflictor( self )
	ent1:SetStartVelocity( self:GetVelocity():Length() )
	
	constraint.NoCollide( ent1, self, 0, 0 )
	
	local startpos1 = pos1
	local tr1 = util.TraceHull( {
		start = startpos1,
		endpos = (startpos1 - self:GetAttachment( self:LookupAttachment( fpr[self.NumR] ) ).Ang:Right() * 50000),
		mins = Vector( -10, -10, -10 ),
		maxs = Vector( 10, 10, 10 ),
		filter = function( e )
			local collide = e ~= self
			return collide
		end
	})
	
	if tr1.Hit then
		local Target1 = tr1.Entity
		if IsValid( Target1 ) then
			if Target1:GetClass():lower() ~= "lunasflightschool_missile" then
				ent1:SetLockOn( Target1 )
				ent1:SetStartVelocity( 0 )
			end
		end
	end
	
	local ent2 = ents.Create( "lunasflightschool_missile" )
	ent2:SetPos( pos2 )
	ent2:SetAngles( ang2 )
	ent2:Spawn()
	ent2:Activate()
	ent2:SetAttacker( self:GetCoDriver() )
	ent2:SetInflictor( self )
	ent2:SetStartVelocity( self:GetVelocity():Length() )
	
	constraint.NoCollide( ent2, self, 0, 0 )
	
	local startpos2 = pos2
	local tr2 = util.TraceHull( {
		start = startpos2,
		endpos = (startpos2 - self:GetAttachment( self:LookupAttachment( fpl[self.NumR] ) ).Ang:Right() * 50000),
		mins = Vector( -10, -10, -10 ),
		maxs = Vector( 10, 10, 10 ),
		filter = function( e )
			local collide = e ~= self
			return collide
		end
	})
	
	if tr2.Hit then
		local Target2 = tr2.Entity
		if IsValid( Target2 ) then
			if Target2:GetClass():lower() ~= "lunasflightschool_missile" then
				ent2:SetLockOn( Target2 )
				ent2:SetStartVelocity( 0 )
			end
		end
	end
end

function ENT:RotateDriverWeapons( TargetAngle, pod )
	local TurretPos = self:GetRotorPos()
	
	local TracePlane = util.TraceLine( {
		start = TurretPos,
		endpos = (TurretPos + TargetAngle:Forward() * 50000),
		filter = self,
	} )
	
	local AimAnglesR = self:WorldToLocalAngles( (TracePlane.HitPos - self:LocalToWorld( Vector(0,-80,-20) ) ):GetNormalized():Angle() )
	local AimAnglesL = self:WorldToLocalAngles( (TracePlane.HitPos - self:LocalToWorld( Vector(0,90,-70) ) ):GetNormalized():Angle() )
	
	if TargetAngle.p > 0 then
		AimAnglesL.p = TargetAngle.p - 3
		AimAnglesR.p = TargetAngle.p - 2
	end
	
	self:SetPoseParameter("missiles_left_pitch", -AimAnglesR.p )
	self:SetPoseParameter("missiles_right_pitch", -AimAnglesL.p )
end

function ENT:CoDriverWeapons( co_driver, Pod )
	self:RotateCoDriverWeapons( Pod:WorldToLocalAngles( co_driver:EyeAngles() ), Pod )

	if co_driver:KeyDown( IN_ATTACK ) then
		self:FireSmallCannons()
	end
end

function ENT:FireSmallCannons()
	self.firesc = self.firesc or 0
	if self.firesc > CurTime() then return end
	self.firesc = CurTime() + 0.6
	
	local mru = self:GetAttachment( self:LookupAttachment( "blaster_right_muzzle_up" ) )
	local mrd = self:GetAttachment( self:LookupAttachment( "blaster_right_muzzle_down" ) )
	local mlu = self:GetAttachment( self:LookupAttachment( "blaster_left_muzzle_up" ) )
	local mld = self:GetAttachment( self:LookupAttachment( "blaster_left_muzzle_down" ) )
	
	if not mru or not mrd or not mlu or not mld then return end
	
	self:EmitSound( "niksacokica/tx-427/cannon_small.wav" )
	
	self.MirrorSmallCannons = not self.MirrorSmallCannons
	local pos1 = self.MirrorSmallCannons and mru.Pos or mlu.Pos
	local dir1 = -( self.MirrorSmallCannons and mru.Ang or mlu.Ang ):Right()
	local pos2 = self.MirrorSmallCannons and mrd.Pos or mld.Pos
	local dir2 = -( self.MirrorSmallCannons and mrd.Ang or mld.Ang ):Right()
	
	local bullet = {}
	bullet.Num 	= 1
	bullet.Src 	= pos1
	bullet.Dir 	= dir1
	bullet.Spread 	= Vector( 0.01,  0.01, 0 )
	bullet.Tracer	= 1
	bullet.TracerName	= "lfs_laser_blue"
	bullet.Force	= 40
	bullet.HullSize 	= 4
	bullet.Damage	= 40
	bullet.Attacker 	= self:GetMainGunner()
	bullet.AmmoType = "Pistol"
	bullet.Callback = function(att, tr, dmginfo)
		dmginfo:SetDamageType(DMG_AIRBOAT)
	end
	self:FireBullets( bullet )
	
	bullet = {}
	bullet.Num 	= 1
	bullet.Src 	= pos2
	bullet.Dir 	= dir2
	bullet.Spread 	= Vector( 0.01,  0.01, 0 )
	bullet.Tracer	= 1
	bullet.TracerName	= "lfs_laser_blue"
	bullet.Force	= 40
	bullet.HullSize 	= 4
	bullet.Damage	= 40
	bullet.Attacker 	= self:GetMainGunner()
	bullet.AmmoType = "Pistol"
	bullet.Callback = function(att, tr, dmginfo)
		dmginfo:SetDamageType(DMG_AIRBOAT)
	end
	self:FireBullets( bullet )
end

function ENT:RotateCoDriverWeapons( TargetAngle, pod )
	local TurretPos = self:GetRotorPos()
	
	local TracePlane = util.TraceLine( {
		start = TurretPos,
		endpos = (TurretPos + TargetAngle:Forward() * 50000),
		filter = self,
	} )
	
	local AimAnglesR = self:WorldToLocalAngles( (TracePlane.HitPos - self:LocalToWorld( Vector(0,-80,-20) ) ):GetNormalized():Angle() )
	local AimAnglesL = self:WorldToLocalAngles( (TracePlane.HitPos - self:LocalToWorld( Vector(0,90,-70) ) ):GetNormalized():Angle() )
	
	if TargetAngle.p > 0 then
		AimAnglesL.p = TargetAngle.p - 3
		AimAnglesR.p = TargetAngle.p - 2
	end

	self:SetPoseParameter("blasters_left_pitch", -AimAnglesL.p )
	self:SetPoseParameter("blasters_left_yaw", AimAnglesL.y )
	self:SetPoseParameter("blasters_right_pitch", -AimAnglesR.p )
	self:SetPoseParameter("blasters_right_yaw", AimAnglesR.y )
end

function ENT:InitWheels()
	self.FilterEnts = { self }

	local Wheels = {
		Vector(0,0,-10),
		Vector(120,0,-10),
		Vector(-120,0,-10),
		
		Vector(0,-100,-10),
		Vector(120,-100,-10),
		Vector(-120,-100,-10),
		
		Vector(0,100,-10),
		Vector(120,100,-10),
		Vector(-120,100,-10)
	}

	local mass = 25
	local radius = 11

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

function ENT:OnGravityModeChanged( b )
end

function ENT:CreateAI()
end

function ENT:RemoveAI()
end

function ENT:HitGround()
	if not istable( self.FilterEnts ) then return false end

	if not isvector( self.obbvc ) or not isnumber( self.obbvm ) then
		self.obbvc = self:OBBCenter() 
		self.obbvm = self:OBBMins().z
	end
	
	local tr = util.TraceHull( {
		start = self:LocalToWorld( self.obbvc ),
		endpos = self:LocalToWorld( self.obbvc + Vector(0,0,self.obbvm - 150) ),
		mins = Vector( -50, -50, 0 ),
		maxs = Vector( 50, 50, 0 ),
		filter = self.FilterEnts
	} )
	
	local tr_w = util.TraceHull( {
		start = self:LocalToWorld( self.obbvc ),
		endpos = self:LocalToWorld( self.obbvc + Vector(0,0,self.obbvm - 150) ),
		mins = Vector( -50, -50, 0 ),
		maxs = Vector( 50, 50, 0 ),
		filter = self.FilterEnts,
		mask = MASK_WATER
	} )
	
	return tr.Hit or tr_w.Hit
end

function ENT:InWater()
	return false
end

function ENT:OnEngineStarted()
	self:EmitSound( "niksacokica/tx-427/engine_on.wav" )
end

function ENT:OnEngineStopped()
	self:EmitSound( "niksacokica/tx-427/engine_off.wav" )
	self:SetGravityMode( true )
	
	if self.DriverFlash then
        self:RemoveFlashlights( true )
	end
	if self.GunnerFlash then
		self:RemoveFlashlights( false )
	end
end

function ENT:OnRemove()
	if self.DriverFlash then
        self:RemoveFlashlights( true )
	end
	if self.GunnerFlash then
		self:RemoveFlashlights( false )
	end
end

function ENT:Explode()
	if self.ExplodedAlready then return end
	
	self.ExplodedAlready = true
	
	if istable( self.pSeats ) then
		for _, pSeat in pairs( self.pSeats ) do
			if IsValid( pSeat ) then
				local psgr = pSeat:GetDriver()
				if IsValid( psgr ) then
					psgr:TakeDamage( 1000, self.FinalAttacker or Entity(0), self.FinalInflictor or Entity(0) )
				end
			end
		end
	end
	
	local ent = ents.Create( "lfs_destruction" )
	if IsValid( ent ) then
		ent:SetPos( self:LocalToWorld( self:OBBCenter() ) )
		ent:SetAngles( self:GetAngles() )
		ent.GibModels = self.GibModels
		ent.Vel = self:GetVelocity()
		ent:Spawn()
		ent:Activate()
	end
	
	self:Remove()
end