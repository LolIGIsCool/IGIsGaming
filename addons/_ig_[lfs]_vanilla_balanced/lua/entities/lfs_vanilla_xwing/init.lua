-- INSERT A COMMENT ABOUT NOT REUPLOADING THIS

AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )
include("shared.lua")

function ENT:SpawnFunction( ply, tr, ClassName )
	if not tr.Hit then return end

	local ent = ents.Create( ClassName )
	ent.dOwnerEntLFS = ply
	ent:SetPos( tr.HitPos + tr.HitNormal * 140 )
	ent:Spawn()
	ent:Activate()

	return ent
end

function ENT:PrimaryAttack()
	if self:GetLGear() > 0.01 then return end
	if not self:CanPrimaryAttack() then return end

	self:EmitSound( "laz" )

	self:SetNextPrimary( 0.13 )

	local fP = { Vector(171,221,69), Vector(171,-221,69), Vector(171,225,-85), Vector(171,-225,-85) }

	self.NumPrim = self.NumPrim and self.NumPrim + 1 or 1
	if self.NumPrim > 4 then self.NumPrim = 1 end

	local startpos =  self:GetRotorPos()
	local TracePlane = util.TraceHull( {
		start = startpos,
		endpos = (startpos + self:GetForward() * 50000),
		mins = Vector( -10, -10, -10 ),
		maxs = Vector( 10, 10, 10 ),
		filter = self
	} )

	local bullet = {}
	bullet.Num 	= 1
	bullet.Src 	= self:LocalToWorld( fP[self.NumPrim] )
	bullet.Dir 	= (TracePlane.HitPos - bullet.Src):GetNormalized()
	bullet.Spread 	= Vector( 0.0005,  0.0005, 0 )
	bullet.Tracer	= 1
	bullet.TracerName = "lfs_laser_red_large"
	bullet.Force	= 110
	bullet.HullSize = 39
	bullet.Damage	= 90
	bullet.Attacker = self:GetDriver()
	bullet.AmmoType = "Pistol"
	bullet.Callback = function(att, tr, dmginfo)
		dmginfo:SetDamageType(DMG_AIRBOAT)
	end
	self:FireBullets( bullet )

	self:TakePrimaryAmmo()

end

function ENT:SecondaryAttack()
	if self:GetLGear() > 1 then return end
	if self:GetAI() then return end

	if not self:CanSecondaryAttack() then return end

	self:SetNextSecondary( 0.70 )

	self:TakeSecondaryAmmo()

	self:EmitSound( "thor" )

	self.MirrorSecondary = not self.MirrorSecondary

	local Mirror = self.MirrorSecondary and -1 or 1

	local startpos =  self:GetRotorPos()
	local tr = util.TraceHull( {
		start = startpos,
		endpos = (startpos + self:GetForward() * 50000),
		mins = Vector( -0, -0, -0 ),
		maxs = Vector( 0, 0, 0 ),
		filter = function( e )
			local collide = e ~= self
			return collide
		end
	} )

for i = -1,2,2 do
	local ent = ents.Create( "lunasflightschool_missile" )
	local Pos = self:LocalToWorld( Vector(100,-28 * Mirror,-17) )
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
			if Target:GetClass():lower() ~= "missile" then
				ent:SetLockOn( Target )
				ent:SetStartVelocity( 0 )
			end
		end
	end

	constraint.NoCollide( ent, self, 0, 0 )
   end
end

function ENT:CreateAI()
self:SetBodygroup( 1, 1 )
self:EmitSound( "vehicles/tank_readyfire1.wav" )
self:PlayAnimation( "lgc" )
end

function ENT:RemoveAI()
    self:SetBodygroup( 1, 0 )
end

function ENT:OnKeyThrottle( bPressed )
end

function ENT:ApplyThrustVtol( PhysObj, vDirection, fForce )
	PhysObj:ApplyForceOffset( vDirection * fForce,  self:GetElevatorPos() )
	PhysObj:ApplyForceOffset( vDirection * fForce,  self:GetWingPos() )
end

function ENT:ApplyThrust( PhysObj, vDirection, fForce )
	PhysObj:ApplyForceOffset( vDirection * fForce, self:GetRotorPos() )
end

function ENT:HandleWeapons(Fire1, Fire2)
	local Driver = self:GetDriver()

	if IsValid( Driver ) then
		if self:GetAmmoPrimary() > 0 then
			Fire1 = Driver:KeyDown( IN_ATTACK )
		end


		if self:GetAmmoSecondary() > 0 then
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

local AnimateOnce = true
local HasAnimated = false;
function ENT:OnTick()
self:DisableWep( self:GetLGear() < 0.99 )
	local Driver = self:GetDriver()
	if not IsValid( Driver ) then return end

	local Jump = Driver:KeyDown( IN_JUMP )

	if self.oldKeyJump ~= Jump then
		self.oldKeyJump = Jump
		if Jump then
			if self:GetWingsOPC() then
				self:WingsOpen()
			else
				self:WingsClose()
			end

			self:SetWingsOPC( not self:GetWingsOPC() )
		end
	end

local trH = util.TraceLine( {
		start = self:GetRotorPos(),
		endpos = self:GetRotorPos() - Vector( 0, 0, 400 ),
		filter = self
	} )

	if trH.HitWorld == false or (self:GetVelocity():Length()) > 500 then
		if self.AnimateOnce == false or self.AnimateOnce == nil then
			self:PlayAnimation("lgc")
			self:EmitSound("vehicles/tank_readyfire1.wav")
			self.AnimateOnce = true
		end
	else
		if self.AnimateOnce == true and (self:GetVelocity():Length()) <= 500 then
			self:PlayAnimation("lgo")
			self:EmitSound("vehicles/tank_readyfire1.wav")
			self.AnimateOnce = false
		end
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
local ent = ents.Create( "lunasflightschool_explosion_x" )
	if IsValid( ent ) then
		ent:SetPos( self:GetPos() + Vector(0,0,100) )
		ent.GibModels = self.GibModels

		ent:Spawn()
		ent:Activate()
	end

	self:Remove()
end

function ENT:WingsOpen()
	self:EmitSound( "lfs/x-wing/xwingfoilsclose.wav" )
end

function ENT:WingsClose()
	self:EmitSound( "lfs/x-wing/xwingfoilsopen.wav" )
end

function ENT:OnLandingGearToggled( bOn )
end

function ENT:OnEngineStarted()
self:SetBodygroup( 2, 1 )
end

function ENT:OnEngineStopped()
self:SetBodygroup( 2, 0 )
end

function ENT:InitWheels()
	local GearPlates = {

		Vector(175,3,-95),
		Vector(-120,-60,-95),
		Vector(-120,65,-95),
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

			Plate:SetNoDraw( true )
			Plate:DrawShadow( false )
			Plate.DoNotDuplicate = true

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

	timer.Simple( 0.2, function()
		if not IsValid( self ) then return end

		local PObj = self:GetPhysicsObject()
		if IsValid( PObj ) then
			PObj:EnableMotion( true )
		end

		self:PhysWake()
	end)
end
