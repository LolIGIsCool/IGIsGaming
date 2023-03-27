--DO NOT EDIT OR REUPLOAD THIS FILE

AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )
include("shared.lua")

function ENT:SpawnFunction( ply, tr, ClassName )
	if not tr.Hit then return end

	local ent = ents.Create( ClassName )
	ent:SetPos( tr.HitPos + tr.HitNormal * 250 )
	ent:Spawn()
	ent:Activate()

	return ent
end

function ENT:OnTick()
	local Vel = self:GetVelocity():Length()
	local TurnSub = (math.max(self:GetRPM() - self:GetMaxRPM(),0) / self:GetLimitRPM()) * 200
	
	self.MaxTurnPitch = 400 - TurnSub
	self.MaxTurnRoll = 400 - TurnSub
	
	local bodygroup = self:GetBodygroup( 3 )
	self.olddish = isnumber( self.olddish ) and self.olddish or 0
	
	if bodygroup ~= 2 then
		local StartPos = self:LocalToWorld( Vector(275.91,225.83,60) )
		
		local trace = util.TraceHull( {
			start = StartPos,
			endpos = StartPos + self:GetUp() * 80,
			mins = Vector( -40, -40, -40 ),
			maxs = Vector( 40, 40, 40 ),
			filter = function( ent ) 
				if ent:IsPlayer() or ent == self then return false end
				return true
			end

		} )
		
		if trace.Hit then
			self:SetBodygroup( 3, 2 ) 
		end
	end
	
	if self.olddish ~= bodygroup then
		if IsValid( self.Dish ) then self.Dish:Remove() end
		
		if bodygroup == 2 then
			self.Dish = ents.Create( "prop_physics" )
		
			if IsValid( self.Dish ) then
				if self.olddish == 0 then
					self.Dish:SetModel( "models/salza/round_dish.mdl" )
					self.Dish:SetPos( self:LocalToWorld( Vector(289,226,100) ) )
				else
					self.Dish:SetModel( "models/salza/square_dish.mdl" )
					self.Dish:SetPos( self:LocalToWorld( Vector(283,226,94) ) )
				end
				self.Dish:SetAngles( self:GetAngles() )
				self.Dish:Spawn()
				self.Dish:Activate()
				self.Dish:SetRenderMode( RENDERMODE_TRANSALPHA )
				self.Dish:SetCollisionGroup( COLLISION_GROUP_WORLD )
				
				local PhysObj = self.Dish:GetPhysicsObject()
				if IsValid( PhysObj ) then
					PhysObj:SetVelocityInstantaneous( VectorRand() * 200 + Vector(0,0,600) )
					PhysObj:AddAngleVelocity( VectorRand() * 800 ) 
					PhysObj:EnableDrag( false ) 
				end
				
				self:DeleteOnRemove( self.Dish )
			end
		end
		self.olddish = bodygroup
	end
end

function ENT:RunOnSpawn()
	self:PlayAnimation("land_gears_open")
	self:SetLGear( 1 )
	
	self.LandingGearUp = false
	
	self:SetGunnerSeat( self:AddPassengerSeat( Vector(15,0,60), Angle(0,90,90) ) )
	self:SetLowerGunnerSeat( self:AddPassengerSeat( Vector(15,0,-70), Angle(0,-90,-90) ) )
	
	self:AddPassengerSeat( Vector(0,0,0), Angle(0,0,0) )
	self:AddPassengerSeat( Vector(0,0,0), Angle(0,0,0) )
	self:AddPassengerSeat( Vector(0,0,0), Angle(0,0,0) )
	self:AddPassengerSeat( Vector(0,0,0), Angle(0,0,0) )
	self:AddPassengerSeat( Vector(0,0,0), Angle(0,0,0) )
	self:AddPassengerSeat( Vector(0,0,0), Angle(0,0,0) )
end

function ENT:PrimaryAttack()
	if not self:CanPrimaryAttack() then return end
	
	local Gunner1 = self:GetGunner()
	local Gunner2 = self:GetGunnerBottom()
	
	if IsValid( Gunner1 ) and IsValid( Gunner2 ) then return end
	
	self:SetNextPrimary( 0.1 )

	if IsValid( Gunner1 ) then
		self.MirrorPrimary = false
		
	elseif IsValid( Gunner2 ) then
		self.MirrorPrimary = true
		
	else
		self.MirrorPrimary = not self.MirrorPrimary
	end
	
	local Pos = self.MirrorPrimary and Vector(108.01,0,125.09) or Vector(115,0,-135)

	local startpos = self:GetRotorPos()
	
	local Trace = util.TraceHull( {
		start = startpos,
		endpos = (startpos + self:GetForward() * 50000),
		mins = Vector( -10, -10, -10 ),
		maxs = Vector( 10, 10, 10 ),
		filter = self,
	} )
	
	local bullet = {}
	bullet.Num 	= 1
	bullet.Src 	= self:LocalToWorld( Pos )
	bullet.Dir 	= (Trace.HitPos - bullet.Src):GetNormalized()
	bullet.Spread 	= Vector( 0.01,  0.01, 0 )
	bullet.Tracer	= 1
	bullet.TracerName	= "lfs_laser_red_large"
	bullet.Force	= 100
	bullet.HullSize 	= 25
	bullet.Damage	= 100
	bullet.Attacker 	= self:GetDriver()
	bullet.AmmoType = "Pistol"
	bullet.Callback = function(att, tr, dmginfo)
		dmginfo:SetDamageType(DMG_AIRBOAT)
	end
	self:FireBullets( bullet )
	
	self:TakePrimaryAmmo()
end

function ENT:CanTurretTopFire()
	self.NextTurretTopFire = isnumber( self.NextTurretTopFire ) and self.NextTurretTopFire or 0
	
	return self.NextTurretTopFire < CurTime()
end

function ENT:SetNextTurretTopFire( delay )
	self.NextTurretTopFire = CurTime() + delay
end

function ENT:CanTurretBottomFire()
	self.NextTurretBottomFire = isnumber( self.NextTurretBottomFire ) and self.NextTurretBottomFire or 0
	
	return self.NextTurretBottomFire < CurTime()
end

function ENT:SetNextTurretBottomFire( delay )
	self.NextTurretBottomFire = CurTime() + delay
end

function ENT:TurretTopFire( Attacker )
	if not self:CanTurretTopFire() then return end
	
	self:SetNextTurretTopFire( 0.1 )

	self.MirrorTop = not self.MirrorTop
	
	local attachment = self:GetAttachment( self:LookupAttachment( "turret_top_attachment" ) )
	
	local Pos = attachment.Pos + attachment.Ang:Right() * (self.MirrorTop and 10 or -10)
	
	local bullet = {}
	bullet.Num 	= 1
	bullet.Src 	= Pos
	bullet.Dir 	= attachment.Ang:Forward()
	bullet.Spread 	= Vector( 0.01,  0.01, 0 )
	bullet.Tracer	= 1
	bullet.TracerName	= "lfs_laser_red_large"
	bullet.Force	= 100
	bullet.HullSize 	= 25
	bullet.Damage	= 100
	bullet.Attacker 	= self:GetGunner()
	bullet.AmmoType = "Pistol"
	bullet.Callback = function(att, tr, dmginfo)
		dmginfo:SetDamageType(DMG_AIRBOAT)
	end
	self:FireBullets( bullet )
	
	self:TakePrimaryAmmo()
end

function ENT:TurretBottomFire( Attacker )
	if not self:CanTurretBottomFire() then return end
	
	self:SetNextTurretBottomFire( 0.1 )

	self.MirrorBottom = not self.MirrorBottom
	
	local attachment = self:GetAttachment( self:LookupAttachment( "turret_bottom_attachment" ) )
	
	local Pos = attachment.Pos + attachment.Ang:Right() * (self.MirrorBottom and 10 or -10)
	
	local bullet = {}
	bullet.Num 	= 1
	bullet.Src 	= Pos
	bullet.Dir 	= attachment.Ang:Forward()
	bullet.Spread 	= Vector( 0.01,  0.01, 0 )
	bullet.Tracer	= 1
	bullet.TracerName	= "lfs_laser_red_large"
	bullet.Force	= 100
	bullet.HullSize 	= 25
	bullet.Damage	= 100
	bullet.Attacker 	= self:GetGunner()
	bullet.AmmoType = "Pistol"
	bullet.Callback = function(att, tr, dmginfo)
		dmginfo:SetDamageType(DMG_AIRBOAT)
	end
	
	self:FireBullets( bullet )
	
	self:TakePrimaryAmmo()
end

function ENT:SecondaryAttack()
end

function ENT:OnKeyThrottle( bPressed )
	if self:GetLGear() > 0.9 then return end
	if bPressed then
		if self:CanSound() then
			self:EmitSound( "MFALCON_BOOST" )
			self:DelayNextSound( 1 )
		end
	else
		if (self:GetRPM() + 1) > self:GetMaxRPM() then
			if self:CanSound() then
				self:EmitSound( "MFALCON_BRAKE" )
				self:DelayNextSound( 0.5 )
			end
		end
	end
end

function ENT:CreateAI()
	self:SetPos( self:GetPos() + Vector(0,0,250) )
end

function ENT:RemoveAI()
end

function ENT:GetGunnerBottom()
	local PodBottom = self:GetLowerGunnerSeat()
	
	if IsValid( PodBottom ) then
		return PodBottom:GetDriver()
	else 
		return NULL
	end
end

function ENT:HandleWeapons(Fire1, Fire2)
	local Driver = self:GetDriver()
	local Gunner = self:GetGunner()
	local GunnerBottom = self:GetGunnerBottom()
	
	local GunnerFire = false
	local GunnerBottomFire = false
	
	if IsValid( Gunner ) then
		GunnerFire = Gunner:KeyDown( IN_ATTACK )
		local Ang = Gunner:GetVehicle():WorldToLocalAngles( Gunner:EyeAngles() )
		self:SetPoseParameter( "top_turret_pitch", -90 -Ang.p) 
		self:SetPoseParameter( "top_turret_roll", -Ang.y ) 
		
		if GunnerFire then
			if self:GetAmmoPrimary() > 0 then
				self:TurretTopFire()
			end
		end
	else
		self:SetPoseParameter( "top_turret_pitch", 0 ) 
		self:SetPoseParameter( "top_turret_roll", 0 ) 
	end
	
	if IsValid( GunnerBottom ) then
		if GunnerBottom ~= self.OldGunnerBottom then
			self.OldGunnerBottom = GunnerBottom
			GunnerBottom:CrosshairEnable() 
		end
		
		GunnerBottomFire = GunnerBottom:KeyDown( IN_ATTACK )
		
		local Ang = GunnerBottom:GetVehicle():WorldToLocalAngles( GunnerBottom:EyeAngles() )
		self:SetPoseParameter( "bottom_turret_pitch", -90 - Ang.p) 
		self:SetPoseParameter( "bottom_turret_roll", -Ang.y ) 
		
		if GunnerBottomFire then
			if self:GetAmmoPrimary() > 0 then
				self:TurretBottomFire()
			end
		end
	else
		self:SetPoseParameter( "bottom_turret_pitch", 0 ) 
		self:SetPoseParameter( "bottom_turret_roll", 0 ) 
	end
	
	if IsValid( Driver ) then
		if self:GetAmmoPrimary() > 0 then
			Fire1 = Driver:KeyDown( IN_ATTACK )
		end
		
		if IsValid( Gunner ) and IsValid( GunnerBottom ) then
			Fire1 = false
		end
	end
	
	if Fire1 then
		self:PrimaryAttack()
	end
	
	local FireSound = GunnerFire or Fire1 or GunnerBottomFire

	if self.OldFire ~= FireSound then
		if FireSound then
			self.wpn = CreateSound( self, "MFALCON_FIRE_LOOP" )
			self.wpn:Play()
			self:CallOnRemove( "stopmesounds", function( ent )
				if ent.wpn then
					ent.wpn:Stop()
				end
			end)
		else
			if self.OldFire == true then
				if self.wpn then
					self.wpn:Stop()
				end
				self.wpn = nil
					
				self:EmitSound( "MFALCON_FIRE_LASTSHOT" )
			end
		end
		
		self.OldFire = FireSound
	end
end

function ENT:Explode()
	if self.ExplodedAlready then return end
	
	self.ExplodedAlready = true
	
	local Driver = self:GetDriver()
	local Gunner = self:GetGunner()
	
	if IsValid( Driver ) then
		Driver:TakeDamage( 200, self.FinalAttacker or Entity(0), self.FinalInflictor or Entity(0) )
	end
	
	if IsValid( Gunner ) then
		Gunner:TakeDamage( 200, self.FinalAttacker or Entity(0), self.FinalInflictor or Entity(0) )
	end
	
	if istable( self.pSeats ) then
		for _, pSeat in pairs( self.pSeats ) do
			if IsValid( pSeat ) then
				local psgr = pSeat:GetDriver()
				if IsValid( psgr ) then
					psgr:TakeDamage( 200, self.FinalAttacker or Entity(0), self.FinalInflictor or Entity(0) )
				end
			end
		end
	end
	
	local ent = ents.Create( "lunasflightschool_destruction" )
	if IsValid( ent ) then
		ent:SetPos( self:GetPos() + Vector(0,0,100) )
		ent.GibModels = self.GibModels
		
		ent:Spawn()
		ent:Activate()
	end
	
	for _,v in pairs( self.GibModels ) do
		local Pos = self:GetPos() + Vector(0,0,250) +  VectorRand() * 300
		local gib = v
		
		timer.Simple(math.Rand(0,0.5), function()
			local ent = ents.Create( "lunasflightschool_destruction" )
			
			if IsValid( ent ) then
				ent:SetPos( Pos )
				ent.GibModels = {gib}
				ent:Spawn()
				ent:Activate()
			end
		end)
	end
	
	self:Remove()
end

function ENT:OnEngineStarted()
	local RotorWash = ents.Create( "env_rotorwash_emitter" )
	
	if IsValid( RotorWash ) then
		RotorWash:SetPos( self:GetPos() )
		RotorWash:SetAngles( Angle(0,0,0) )
		RotorWash:Spawn()
		RotorWash:Activate()
		RotorWash:SetParent( self )
		
		RotorWash.DoNotDuplicate = true
		self:DeleteOnRemove( RotorWash )
		self:dOwner( RotorWash )
		
		self.RotorWashEnt = RotorWash
	end
end

function ENT:OnEngineStopped()
	if IsValid( self.RotorWashEnt ) then
		self.RotorWashEnt:Remove()
	end
end

function ENT:OnLandingGearToggled( bOn )
	self:EmitSound( "vehicles/tank_readyfire1.wav" )
	if bOn then
		self:PlayAnimation("land_gears_close")
	else
		self:PlayAnimation("land_gears_open")
	end
end


function ENT:InitWheels()
	local GearPlates = {
		Vector(-220,205,-187),
		Vector(-220,-205,-187),
		Vector(365,0,-187),
		Vector(190,200,-187),
		Vector(190,-200,-187),
	}
	
	self.LandingGearPlates = {}

	for _, v in pairs( GearPlates ) do
		local Plate = ents.Create( "prop_physics" )
		if IsValid( Plate ) then
			Plate:SetPos( self:LocalToWorld( v ) )
			Plate:SetAngles( self:LocalToWorldAngles( Angle(0,0,0) ) )
			
			Plate:SetModel( "models/hunter/plates/plate1x1.mdl" )
			Plate:Spawn()
			Plate:Activate()
			
			Plate:SetNoDraw( true )
			Plate:DrawShadow( false )
			Plate.DoNotDuplicate = true
			
			local pObj = Plate:GetPhysicsObject()
			if not IsValid( pObj ) then
				self:Remove()
				print("LFS: Failed to initialize landing gear phys model. Plane terminated.")
				return
			end
		
			pObj:EnableMotion(false)
			pObj:SetMass( 500 )
			
			table.insert( self.LandingGearPlates, Plate )
			self:DeleteOnRemove( Plate )
			self:dOwner( Plate )
			
			constraint.Weld( self, Plate, 0, 0, 0,false, true ) 
			constraint.NoCollide( Plate, self, 0, 0 ) 
			
			pObj:EnableMotion( true )
			pObj:EnableDrag( false ) 
			
			Plate:SetPos( self:GetPos() )
			
		else
			self:Remove()
		
			print("LFS: Failed to initialize landing gear. Plane terminated.")
		end
	end

	timer.Simple( 0.5, function()
		if not IsValid( self ) then return end
		
		local PObj = self:GetPhysicsObject()
		if IsValid( PObj ) then 
			PObj:EnableMotion( true )
		end
		
		self:PhysWake() 
	end)
end


function ENT:HandleLandingGear()
	local Driver = self:GetDriver()
	
	if IsValid( Driver ) then
		local KeyJump = Driver:KeyDown( IN_JUMP )
		
		if self.OldKeyJump ~= KeyJump then
			self.OldKeyJump = KeyJump
			if KeyJump then
				self:ToggleLandingGear()
				self:PhysWake()
			end
		end
	end
	
	local TVal = self.LandingGearUp and 0 or 1
	
	local Speed = FrameTime() * 0.5
	
	self:SetLGear( self:GetLGear() + math.Clamp(TVal - self:GetLGear(),-Speed,Speed) )
	
	if istable( self.LandingGearPlates ) then
		for _, v in pairs( self.LandingGearPlates ) do
			if IsValid( v ) then
				local pObj = v:GetPhysicsObject()
				if IsValid( pObj ) then
					pObj:SetMass( 1 + 2000 * self:GetLGear() ^ 10 )
				end
			end
		end
	end
end