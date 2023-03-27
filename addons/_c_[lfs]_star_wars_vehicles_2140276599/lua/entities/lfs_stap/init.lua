AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )
include("shared.lua")

function ENT:SpawnFunction( ply, tr, ClassName )
	if not tr.Hit then return end

	local ent = ents.Create( ClassName )
	ent.dOwnerEntLFS = ply
	ent:SetPos( tr.HitPos + tr.HitNormal )
	ent:Spawn()
	ent:Activate()
	
	return ent
end

function ENT:RunOnSpawn()
	self:GetChildren()[1]:SetVehicleClass("phx_seat3")
	self:SetAutomaticFrameAdvance(true)
end

function ENT:PrimaryAttack()
	if not self:CanPrimaryAttack() then return end

	self:SetNextPrimary( 0.45 )
	
	--[[ do primary attack code here ]]--
	
	self:EmitSound( "stap/canon.wav" )
	
	local Driver = self:GetDriver()
	
	local bullet = {}
	bullet.Num 	= 1
	bullet.Src 	= self:LocalToWorld( Vector(18,11,45) )
	bullet.Dir 	= self:GetForward()
	bullet.Spread 	= Vector( 0,  0, 0.15 )
	bullet.Tracer	= 1
	bullet.TracerName	= "lfs_laser_red"
	bullet.Force	= 10
	bullet.HullSize 	= 5
	bullet.Damage	= 10
	bullet.Attacker 	= Driver
	bullet.AmmoType = "Pistol"
	
		self:FireBullets( bullet )
	
		local bullet = {}
	bullet.Num 	= 1
	bullet.Src 	= self:LocalToWorld( Vector(18,-11,45))
	bullet.Dir 	= self:GetForward()
	bullet.Spread 	= Vector( 0,  0, 0.15 )
	bullet.Tracer	= 1
	bullet.TracerName	= "lfs_laser_red"
	bullet.Force	= 10
	bullet.HullSize 	= 5
	bullet.Damage	= 10
	bullet.Attacker 	= Driver
	bullet.AmmoType = "Pistol"
	
	self:FireBullets( bullet )
	
	self:TakePrimaryAmmo()
end

function ENT:SecondaryAttack()
end

function ENT:MainGunPoser( EyeAngles )
end

function ENT:OnKeyThrottle( bPressed )
end

function ENT:OnLandingGearToggled( bOn )
end

function ENT:OnEngineStarted()
	self:EmitSound( "lfs/naboo_n1_starfighter/start.wav" )
	self.HeightOffset = 33
end

function ENT:OnEngineStopped()
	self:EmitSound( "lfs/naboo_n1_starfighter/stop.wav" )
	self.HeightOffset = 25
end