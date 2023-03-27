AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "lunasflightschool_proton_torpedo.lua" )
AddCSLuaFile( "lunasflightschool_seismic_canister.lua" )
include("shared.lua")

function ENT:SpawnFunction( ply, tr, ClassName )

	if not tr.Hit then return end

	local ent = ents.Create( ClassName )
	ent.dOwnerEntLFS = ply
	ent:SetPos( tr.HitPos + tr.HitNormal * 500 )
	ent:Spawn()
	ent:Activate()

	return ent

end

local lBomb = Vector(-20,-20,-140)
local rBomb = Vector(-20,20,-140)

function ENT:RunOnSpawn()
end

function ENT:OnTick()
end

function ENT:PrimaryAttack()
	if not self:CanPrimaryAttack() then return end


	self:EmitSound("slave1/slave1fire.wav")
	self:SetNextPrimary( 0.15 )

	local fP = { Vector(290,-55,-460), Vector(290,55,-460) }

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
	bullet.Spread 	= Vector( 0.01,  0.01, 0 )
	bullet.Tracer	= 1
	bullet.TracerName	= "lfs_laser_red"
	bullet.Force	= 100
	bullet.HullSize 	= 40
	bullet.Damage	= 110
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

	self:TakeSecondaryAmmo()



	local startpos =  self:GetRotorPos()
	local tr = util.TraceHull( {
		start = startpos,
		endpos = (startpos + self:GetForward() * 50000),
		mins = Vector( -40, -40, -40 ),
		maxs = Vector( 40, 40, 40 ),
		filter = self
} )

	local rocketpos = {
		Vector(204,75,-122),
		Vector(204,-75,-122),
	}

	local ent = ents.Create( "lunasflightschool_proton_torpedo" )
	local mPos
	if (self:GetAmmoSecondary()+1)%4 == 0 then
		mPos = self:LocalToWorld(rocketpos[1])
		self:EmitSound( "slave1/torpedofire.wav" )
		self:SetNextSecondary( 0.30 )
		self.tee = 1
	elseif (self:GetAmmoSecondary()+1)%4 == 3 then
		mPos = self:LocalToWorld(rocketpos[2])
		self:EmitSound( "slave1/torpedofire.wav" )
		self:SetNextSecondary( 0.30 )
		self.tee = 1
	elseif (self:GetAmmoSecondary()+1)%4 == 2 then
		mPos = self:LocalToWorld(rocketpos[1])
		self:EmitSound( "slave1/torpedofire.wav" )
		self:SetNextSecondary( 0.30 )
		self.tee = 1
	else
		mPos = self:LocalToWorld(rocketpos[2])
		self:EmitSound( "slave1/torpedofire.wav" )
		self:SetNextSecondary( 7 )
		self.tee = 0
	end

	if self.tee == 0 then
		timer.Simple(1,function()
			if IsValid(self) then
				self:EmitSound("slave1/torpedoreload.wav")
			end
		end)
		timer.Simple(6,function()
			if IsValid(self) then
				self:EmitSound("slave1/torpedofinish.wav")
			end
		end)
		self.tee = 1
	end

	local Ang = self:WorldToLocal( mPos ).y > 0 and -1 or 1
	ent:SetPos( mPos )
	ent:SetAngles( self:LocalToWorldAngles( Angle(0,Ang,0) ) )
	ent:Spawn()
	ent:Activate()
	ent:SetAttacker( self:GetDriver() )
	ent:SetInflictor( self )
	ent:SetStartVelocity( self:GetVelocity():Length() )
	ent:SetDirtyMissile( true )

	if self:GetAI() then
		local enemy = self:AIGetTarget()
		if IsValid(enemy) then
			if math.random(1,8) != 1 then
				if string.find(enemy:GetClass(),"lunasflightschool") then
					if enemy:GetClass() == "lunasflightschool_proton_torpedo" then return end
					ent:SetLockOn(enemy)
					ent:SetStartVelocity(0)
				end
			end
		end
	else
		if tr.Hit then
			local Target = tr.Entity
			if IsValid(Target) then
				if Target:GetClass():lower() ~= "lunasflightschool_proton_torpedo" then
					ent:SetLockOn(Target)
					ent:SetStartVelocity(0)
				end
			end
		end
	end
	constraint.NoCollide(ent,self,0,0)
end

function ENT:SetNextAltPrimary( delay )
	self.NextAltPrimary = CurTime() + delay
end

function ENT:CanAltPrimaryAttack()
	self.NextAltPrimary = self.NextAltPrimary or 0
	return self.NextAltPrimary < CurTime()
end

ENT.TotalBombsFire = 0
function ENT:AltPrimaryAttack( Driver, Pod )

	if not self:CanAltPrimaryAttack() then return end

	if self.TotalBombsFire >= 5 then
		return
	end
	self:SetNextAltPrimary( 1 )
	self.TotalBombsFire = self.TotalBombsFire +1
	if self.TotalBombsFire >= 5 then
		timer.Simple(14,function()
			if IsValid(self) then
				self.TotalBombsFire = 0
			end
		end)
	end

	self:EmitSound("slave1/seismicdeploy.wav")

	self.MirrorPrimary = not self.MirrorPrimary
	local Mirror = self.MirrorPrimary and -1 or 1

	local ent = ents.Create("lunasflightschool_seismic_canister")
	local Pos
	if Mirror == 1 then
		Pos = self:LocalToWorld(lBomb)
	else
		Pos = self:LocalToWorld(rBomb)
	end
	ent:SetPos(Pos)
	ent:SetAngles(Angle(90,0,0))
	ent.SmallExplosion = true
	ent:Spawn()
	ent:Activate()
	ent:SetAttacker(self:GetDriver())
	ent:SetInflictor(self)
	ent:SetStartVelocity(0)
	constraint.NoCollide(ent,self,0,0)
end

function ENT:OnKeyThrottle( bPressed )
	if bPressed then
		if self:CanSound() then
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

	if Fire2 then
		self:SecondaryAttack()
	end
end

function ENT:OnEngineStarted()
	self:EmitSound( "slave1/startengine.wav" )
end

function ENT:OnEngineStopped()
	self:EmitSound( "slave1/startengine.wav" )
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

	local Speed = FrameTime() * 4

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
