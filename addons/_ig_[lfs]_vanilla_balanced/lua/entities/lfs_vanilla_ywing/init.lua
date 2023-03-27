--DO NOT EDIT OR REUPLOAD THIS FILE
AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )
include("shared.lua")

function ENT:SpawnFunction( ply, tr, ClassName )
	if not tr.Hit then return end
	local ent = ents.Create( ClassName )
	ent.dOwnerEntLFS = ply
	ent:SetPos( tr.HitPos + tr.HitNormal * 50 )
	ent:Spawn()
	ent:Activate()
	return ent
end

function ENT:OnTick()
end

function ENT:RunOnSpawn()
end

function ENT:SetNextAltPrimary( delay )
	self.NextAltPrimary = CurTime() + delay
end

function ENT:CanAltPrimaryAttack()
	self.NextAltPrimary = self.NextAltPrimary or 0
	return self.NextAltPrimary < CurTime()
end

function ENT:AltPrimaryAttack( Driver, Pod )
	if not self:CanAltPrimaryAttack() then return end

	if not IsValid( Pod ) then Pod = self:GetDriverSeat() end
	if not IsValid( Driver ) then Driver = Pod:GetDriver() end

	if not IsValid( Pod ) then return end
	if not IsValid( Driver ) then return end

	local EyeAngles = Pod:WorldToLocalAngles( Driver:EyeAngles() )
	local Forward = -self:GetForward()

	local AimDirToForwardDir = math.deg( math.acos( math.Clamp( Forward:Dot( EyeAngles:Forward() ) ,-1,1) ) )
	if AimDirToForwardDir > 180 then return end

	self:EmitSound( "laser_#561" )

	self:SetNextAltPrimary( 0.25 )


	local startpos =  self:GetRotorPos()
	local TracePlane = util.TraceHull( {
		start = startpos,
		endpos = startpos + EyeAngles:Forward() * 50000,
		mins = Vector( -10, -10, -10 ),
		maxs = Vector( 10, 10, 10 ),
		filter = self
	} )

	self.MirrorPrimary = not self.MirrorPrimary

	local fp = { Vector(170,5.5,46),Vector(170,5,46) }

	self.NumPrim = self.NumPrim and self.NumPrim + 1 or 1
	if self.NumPrim > 2 then self.NumPrim = 1 end

	local bullet = {}
	bullet.Num 	= 1
	bullet.Src 	= self:LocalToWorld(fp[self.NumPrim])
	bullet.Dir 	= (TracePlane.HitPos - bullet.Src):GetNormalized()
	bullet.Spread 	= Vector( 0.04,  0.04, 0 )
	bullet.Tracer	= 1
	bullet.TracerName	= "lfs_laser_blue"
	bullet.Force	= 100
	bullet.HullSize 	= 20
	bullet.Damage	= 45
	bullet.Attacker 	= Driver
	bullet.AmmoType = "Pistol"
	bullet.Callback = function(att, tr, dmginfo)
		dmginfo:SetDamageType(DMG_AIRBOAT)
	end
	self:FireBullets( bullet )
end

function ENT:PrimaryAttack()
	if self:GetLGear() > 0.01 then return end
	if not self:CanPrimaryAttack() then return end

	self:EmitSound( "laser_#240" )

	self:SetNextPrimary( 0.1930 )

	local startpos =  self:GetRotorPos()
	local TracePlane = util.TraceHull( {
		start = startpos,
		endpos = (startpos + self:GetForward() * 50000),
		mins = Vector( -0, -0, -0 ),
		maxs = Vector( 0, 0, 0 ),
		filter = self
	} )

	self.MirrorPrimary = not self.MirrorPrimary

	local Mirror = self.MirrorPrimary and -1 or 1

	local bullet = {}
	bullet.Num 	= 1
	bullet.Src 	= self:LocalToWorld( Vector(350,14.5 * Mirror,-5.00) )
	bullet.Dir 	= (TracePlane.HitPos - bullet.Src):GetNormalized()
	bullet.Spread 	= Vector( 0.01,  0.01, 0 )
	bullet.Tracer	= 1
	bullet.TracerName	= "lfs_laser_red_large"
	bullet.Force	= 100
	bullet.HullSize 	= 25
	bullet.Damage	= 15
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

	if self:GetAI() then return end

	self:SetNextSecondary( 1 )

	self:TakeSecondaryAmmo(2)

	self:EmitSound( "torpedo_#1502" )

	self.MirrorPrimary = not self.MirrorPrimary

	local Mirror = self.MirrorPrimary and -1 or 1

	local startpos =  self:GetRotorPos()
	local tr = util.TraceHull( {
		start = startpos,
		endpos = (startpos + self:GetForward() * 50000),
		mins = Vector( -0, -0, -0 ),
		maxs = Vector( 0, 0, 0 ),
		filter = function( DualProton )
			local collide = DualProton ~= self
			return collide
		end
	} )

		for i = 0,1 do
		self.MirrorPrimary = not self.MirrorPrimary

		local Mirror = self.MirrorPrimary and -1 or 1

	local DualProton = { ( Vector(230,-28 * Mirror,-20) ) }

	self.DualP = self.DualP and self.DualP + 1 or 1
	if self.DualP > 1 then self.DualP = 1 end

	local ent = ents.Create( "lunasflightschool_missile" )
	local Pos = self:LocalToWorld( DualProton[self.DualP] )
	ent:SetPos( Pos )
	ent:SetAngles( (tr.HitPos - Pos):Angle() )
	ent:Spawn()
	ent:Activate()
	ent:SetAttacker( self:GetDriver() )
	ent:SetInflictor( self )
	ent:SetStartVelocity( self:GetVelocity():Length() )
	ent:SetDirtyMissile( true )

	if tr.Hit then
		local Target = tr.Entity
		if IsValid( Target ) then
			if Target:GetClass():lower() ~= "lunasflightschool_missile" then
				ent:SetLockOn( Target )
				ent:SetStartVelocity( 0 )
			end
		end
	end

	constraint.NoCollide( ent, self, 0, 0 )
	end
end

function ENT:PrepExplode()
	if self.MarkForDestruction then
		self:Explode()
	end

	if self:IsDestroyed() then
		if self:GetVelocity():Length() < 800 then
			self:Explode()
		end
	end
end

function ENT:Explode()
	if self.ExplodedAlready then return end

	self.ExplodedAlready = true

	local Driver = self:GetDriver()
	local Gunner = self:GetGunner()

	if IsValid( Driver ) then
		Driver:TakeDamage( Driver:Health(), self.FinalAttacker or Entity(0), self.FinalInflictor or Entity(0) )
	end

	if IsValid( Gunner ) then
		Gunner:TakeDamage( Gunner:Health(), self.FinalAttacker or Entity(0), self.FinalInflictor or Entity(0) )
	end

	if istable( self.pSeats ) then
		for _, pSeat in pairs( self.pSeats ) do
			if IsValid( pSeat ) then
				local psgr = pSeat:GetDriver()
				if IsValid( psgr ) then
					psgr:TakeDamage( psgr:Health(), self.FinalAttacker or Entity(0), self.FinalInflictor or Entity(0) )
				end
			end
		end
	end
local ent = ents.Create( "lunasflightschool_explosion_y" )
	if IsValid( ent ) then
		ent:SetPos( self:GetPos() + Vector(0,0,100) )
		ent.GibModels = self.GibModels

		ent:Spawn()
		ent:Activate()
	end

	self:Remove()
end

function ENT:CreateAI()
	self:SetBodygroup( 2, 1 )
end

function ENT:RemoveAI()
    self:SetBodygroup( 2, 0 )
end

function ENT:OnKeyThrottle( bPressed )
end

function ENT:OnEngineStarted()
self:SetBodygroup( 1, 1 )
end

function ENT:OnEngineStopped()
self:SetBodygroup( 1, 0 )
end

function ENT:OnVtolMode( IsOn )
end

function ENT:RunOnSpawn()
	self:PlayAnimation("land_gear_open")
	self:SetLGear( 1 )
	self.LandingGearUp = false
end

function ENT:OnLandingGearToggled( bOn )
	self:EmitSound( "vehicles/tank_readyfire1.wav" )
	if bOn then
	 	 self:PlayAnimation("land_gear_close")
    else
	     self:PlayAnimation("land_gear_open")
   end
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

function ENT:HandleWeapons(Fire1, Fire2)
	local Driver = self:GetDriver()

	local FireTurret = false

	if IsValid( Driver ) then
		if self:GetAmmoPrimary() > 0 then
			Fire1 = Driver:KeyDown( IN_ATTACK )
		end

		FireTurret = Driver:KeyDown( IN_WALK )

		if self:GetAmmoSecondary() > 0 then
			Fire2 = Driver:KeyDown( IN_ATTACK2 )
		end
	end

	if Fire1 then
		if FireTurret and not HasGunner then
			self:AltPrimaryAttack()
		else
			self:PrimaryAttack()
		end
	end

	if HasGunner then
		if Gunner:KeyDown( IN_ATTACK ) then
			self:AltPrimaryAttack( Gunner, self:GetGunnerSeat() )
		end
	end

	if Fire2 then
		self:SecondaryAttack()
	end
end

function ENT:InitWheels()
	local GearPlates = {
		Vector(220,0,-50),
		Vector(-90,-150,-50),
		Vector(-90,150,-50),
	}
	self.LandingGearPlates = {}
	for _, v in pairs( GearPlates ) do
		local Plate = ents.Create( "prop_physics" )
		if IsValid( Plate ) then
			Plate:SetPos( self:LocalToWorld( v ) )
			Plate:SetAngles( self:LocalToWorldAngles( Angle(0,0,0) ) )
			Plate:SetModel( "models/hunter/plates/plate05x05.mdl" )
			Plate:Spawn()
			Plate:Activate()
			Plate:SetNoDraw( true)
			Plate:DrawShadow( false )
			Plate.DoNotDuplicate = tru
			local pObj = Plate:GetPhysicsObject()
			if not IsValid( pObj ) then
				self:Remove()
				return
			end
			pObj:EnableMotion(false)
			pObj:SetMass( 1500 )
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
