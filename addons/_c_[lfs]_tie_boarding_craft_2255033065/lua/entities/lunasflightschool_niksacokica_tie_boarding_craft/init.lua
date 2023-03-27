AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )
include("shared.lua")

function ENT:SpawnFunction( ply, tr, ClassName )
	if not tr.Hit then return end

	local ent = ents.Create( ClassName )
	ent.dOwnerEntLFS = ply
	ent:SetPos( tr.HitPos + tr.HitNormal * 125 )
	ent:Spawn()
	ent:Activate()

	return ent
end

function ENT:RunOnSpawn()
	for i=0, 19 do
		self:AddPassengerSeat( Vector(0,127,-10), Angle(0,-90,0) )
	end
	
	self.ta = 10
end

function ENT:OnTick()
end

function ENT:PrimaryAttack()
	if not self:CanPrimaryAttack() then return end
	if not self:GetEngineActive() then return end

	self:EmitSound( "niksacokica/tie_boarding_craft/light_canon.wav" )
	
	self:SetNextPrimary( 0.11 )
	
	local fP = {
		Vector(66,9.5,-32),
		Vector(66,-15,-32),
	}

	self.NumPrim = self.NumPrim and self.NumPrim + 1 or 1
	if self.NumPrim > 2 then self.NumPrim = 1 end
	
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
	bullet.Spread 	= Vector( 0.01,  0.01, 0.01 )
	bullet.Tracer	= 1
	bullet.TracerName	= "lfs_laser_green"
	bullet.Force	= 100
	bullet.HullSize 	= 50
	bullet.Damage	= 25
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
	if not self:GetEngineActive() then return end
	
	self:EmitSound( "niksacokica/tie_boarding_craft/heavy_canon.wav" )
	
	self:SetNextSecondary( 0.4 )
	
	local fP = {
		Vector(63,9.5,-50),
		Vector(63,-15,-50),
	}

	self.NumPrim = self.NumPrim and self.NumPrim + 1 or 1
	if self.NumPrim > 2 then self.NumPrim = 1 end
	
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
	bullet.Spread 	= Vector( 0.01,  0.01, 0.01 )
	bullet.Tracer	= 1
	bullet.TracerName	= "lfs_laser_green"
	bullet.Force	= 111
	bullet.HullSize 	= 55
	bullet.Damage	= 50
	bullet.Attacker 	= self:GetDriver()
	bullet.AmmoType = "Pistol"
	bullet.Callback = function(att, tr, dmginfo)
		dmginfo:SetDamageType(DMG_AIRBOAT)
	end
	self:FireBullets( bullet )
	self:TakeSecondaryAmmo()
end

function ENT:CanTertiaryAttack()
	self.NextTertiary = self.NextTertiary or 0
	return self.NextTertiary < CurTime()
end

function ENT:SetNextTertiary( delay )
	self.NextTertiary = CurTime() + delay
end

function ENT:TertiaryAttack()
	if not self:CanTertiaryAttack() then return end
	if self.ta == 0 then return end
	if not self:GetEngineActive() then return end
	
	self:EmitSound( "niksacokica/tie_boarding_craft/bomb.wav" )
	
	self:SetNextTertiary( 0.5 )
	
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
	local Pos = self:LocalToWorld( Vector(63,128,-50) )
	ent:SetPos( Pos )
	ent:SetAngles( (tr.HitPos - Pos):Angle() )
	ent:Spawn()
	ent:Activate()
	ent:SetAttacker( self:GetDriver() )
	ent:SetInflictor( self )
	ent:SetStartVelocity( self:GetVelocity():Length() )
	
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
	self.ta = self.ta - 1
	if self.ta == 0 then
		if not timer.Exists("ReloadTertiary") then
			timer.Create("ReloadTertiary", 5, 1, function()
				if not IsValid(self) then return end
				self.ta = 10
				self:EmitSound(Sound("ambient/levels/caves/ol04_gearengage.wav"), 120, math.random(90,110))
			end)
		end
	end
end

function ENT:CreateAI()
end

function ENT:RemoveAI()
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
		Fire3 = Driver:KeyDown( IN_WALK )
	end
	
	if Fire1 then
		self:PrimaryAttack()
	end
	
	if Fire2 then
		self:SecondaryAttack()
	end
	
	if Fire3 then
		self:TertiaryAttack()
	end
end

function ENT:OnLandingGearToggled( bOn )
end

function ENT:OnEngineStarted()
	self:EmitSound( "niksacokica/tie_boarding_craft/engine_on.wav" )
end

function ENT:OnEngineStopped()
	self:EmitSound( "niksacokica/tie_boarding_craft/engine_off.wav" )
end