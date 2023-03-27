--DO NOT EDIT OR REUPLOAD THIS FILE

AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )
include("shared.lua")

function ENT:SpawnFunction( ply, tr, ClassName )

	if not tr.Hit then return end

	local ent = ents.Create( ClassName )
	ent.dOwnerEntLFS = ply
	ent:SetPos( tr.HitPos + tr.HitNormal * 120 )
	ent:Spawn()
	ent:Activate()

	return ent

end

--thanks to the guy who made this line of code down here, really saved a lot of time.
local AnimateOnce = true
local HasAnimated = false;
function ENT:OnTick()
self:DisableWep( self:GetLGear() < 0.99 )
local Driver = self:GetDriver()
	if not IsValid( Driver ) then return end
local trH = util.TraceLine( {
		start = self:GetRotorPos(),
		endpos = self:GetRotorPos() - Vector( 0, 0, 400 ),
		filter = self
	} )
		
	if trH.HitWorld == false or (self:GetVelocity():Length()) > 500 then
		if self.AnimateOnce == false or self.AnimateOnce == nil then
			self:PlayAnimation("f")
			self:EmitSound("vehicles/tank_readyfire1.wav")
			self.AnimateOnce = true
		end
	else
		if self.AnimateOnce == true and (self:GetVelocity():Length()) <= 500 then
			self:PlayAnimation("b")
			self:EmitSound("vehicles/tank_readyfire1.wav")
			self.AnimateOnce = false
		end
	end
end

function ENT:RunOnSpawn()
	self:SetGunnerSeat( self:AddPassengerSeat( Vector(-125,0,22), Angle(0,90,18) ) )
	self:AddPassengerSeat( Vector(-25,0,18), Angle(0,-90,15) )
end

function ENT:SetNextAltPrimary( delay )
	self.NextAltPrimary = CurTime() + delay
end

function ENT:CanAltPrimaryAttack()
	self.NextAltPrimary = self.NextAltPrimary or 0
	return self.NextAltPrimary < CurTime()
end
	
function ENT:AltPrimaryAttack( Driver, Pod )
	if self:GetLGear() > 0.01 then return end
	
	if not self:CanAltPrimaryAttack() then return end
	
	if not IsValid( Pod ) then Pod = self:GetDriverSeat() end
	if not IsValid( Driver ) then Driver = Pod:GetDriver() end
	
	if not IsValid( Pod ) then return end
	if not IsValid( Driver ) then return end
	
	local EyeAngles = Pod:WorldToLocalAngles( Driver:EyeAngles() )
	local Forward = -self:GetForward()
	
	local AimDirToForwardDir = math.deg( math.acos( math.Clamp( Forward:Dot( EyeAngles:Forward() ) ,-1,1) ) )
	if AimDirToForwardDir > 45 then return end
	
	self:EmitSound( "arctail" )
	
	self:SetNextAltPrimary( 0.25 )
	
	local startpos =  self:GetRotorPos()
	local TracePlane = util.TraceHull( {
		start = startpos,
		endpos = (startpos + EyeAngles:Forward() * 50000),
		mins = Vector( -10, -10, -10 ),
		maxs = Vector( 10, 10, 10 ),
		filter = self
	} )

	self.MirrorPrimary = not self.MirrorPrimary
	
	local Mirror = self.MirrorPrimary and -1 or 1
	
	local MuzzlePos = self:LocalToWorld( self.MirrorPrimary and Vector(-175.81,0.,50.26) or Vector(-171.69,0,5.81) )

	local bullet = {}
	bullet.Num 	= 1
	bullet.Src 	= MuzzlePos
	bullet.Dir 	= (TracePlane.HitPos - bullet.Src):GetNormalized()
	bullet.Spread 	= Vector( 0.005,  0.005, 0 )
	bullet.Tracer	= 1
	bullet.TracerName	= "lfs_laser_green2"
	bullet.Force	= 100
	bullet.HullSize 	= 20
	bullet.Damage	= 200
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

	self:EmitSound( "arclaz" )
	
	self:SetNextPrimary( 0.11 )
	
	local startpos =  self:GetRotorPos()
	local TracePlane = util.TraceHull( {
		start = startpos,
		endpos = (startpos + self:GetForward() * 50000),
		mins = Vector( -10, -10, -10 ),
		maxs = Vector( 10, 10, 10 ),
		filter = self
	} )

	self.MirrorPrimary = not self.MirrorPrimary
	
	local Mirror = self.MirrorPrimary and -1 or 1
	
	local bullet = {}
	bullet.Num 	= 1
	bullet.Src 	= self:LocalToWorld( Vector(240,328.52 * Mirror,-51.35) )
	bullet.Dir 	= (TracePlane.HitPos - bullet.Src):GetNormalized()
	bullet.Spread 	= Vector( 0.01,  0.01, 0 )
	bullet.Tracer	= 1
	bullet.TracerName	= "lfs_laser_green"
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

function ENT:SecondaryAttack()
	if self:GetLGear() > 0.01 then return end
	if self:GetAI() then return end
	
	if not self:CanSecondaryAttack() then return end
	
	self:SetNextSecondary( 1 )

	self:TakeSecondaryAmmo()

	self:EmitSound( "arcproton" )
	
	self.MirrorSecondary = not self.MirrorSecondary
	
	local Mirror = self.MirrorSecondary and -1 or 1
	
	local startpos =  self:GetRotorPos()
	local tr = util.TraceHull( {
		start = startpos,
		endpos = (startpos + self:GetForward() * 50000),
		mins = Vector( -40, -40, -40 ),
		maxs = Vector( 40, 40, 40 ),
		filter = function( e )
			local collide = e ~= self
			return collide
		end
	} )
	
	local ent = ents.Create( "lunasflightschool_missile" )
	local Pos = self:LocalToWorld( Vector(230,0,-35) )
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

function ENT:InitWheels()
	local GearPlates = {
	
		Vector(-100,-120,-75),
		Vector(-100,125,-75),
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

function ENT:OnKeyThrottle( bPressed )

end

function ENT:CreateAI()
self:SetBodygroup ( 1, 1 )
self:PlayAnimation("f")
end

function ENT:RemoveAI()
 self:SetBodygroup( 1, 0 ) 
end

function ENT:HandleWeapons(Fire1, Fire2)
	local Driver = self:GetDriver()
	local Gunner = self:GetGunner()
	local HasGunner = IsValid( Gunner )
	
	local FireTurret = false
	
	if IsValid( Driver ) then
		if self:GetAmmoPrimary() > 0 then
			Fire1 = Driver:KeyDown( IN_ATTACK )
		end
		
		FireTurret = Driver:lfsGetInput( "FREELOOK" )
		
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
	
	if self.OldFire2 ~= Fire2 then
		if Fire2 then
			self:SecondaryAttack()
		end
		self.OldFire2 = Fire2
	end
end

function ENT:OnLandingGearToggled( bOn )
	self:EmitSound( "foilss" )
end

function ENT:OnEngineStarted()
	self:EmitSound( "lfs/naboo_n1_starfighter/start.wav" )
end

function ENT:OnEngineStopped()
	self:EmitSound( "lfs/naboo_n1_starfighter/stop.wav" )
end