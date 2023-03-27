--DO NOT EDIT OR REUPLOAD THIS FILE
util.PrecacheModel("models/kingpommes/starwars/deathstar/xx9c_static.mdl")
AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )
include("shared.lua")

function ENT:SpawnFunction( ply, tr, ClassName )

	if not tr.Hit then return end

	local ent = ents.Create( ClassName )
	ent.dOwnerEntLFS = ply
	ent:SetPos( tr.HitPos + tr.HitNormal * 5 )
	ent:Spawn()
	ent:Activate()

	return ent

end


function ENT:RunOnSpawn()
end

function ENT:PrimaryAttack( Driver, Pod )
	if not self:CanPrimaryAttack() then return end

	if not IsValid( Pod ) then Pod = self:GetDriverSeat() end
	if not IsValid( Driver ) then Driver = Pod:GetDriver() end

	if not IsValid( Pod ) then return end
	if not IsValid( Driver ) then return end

	local EyeAngles = /*Pod:WorldToLocalAngles*/( Driver:EyeAngles() )
	local Forward = self:GetForward()

	local AimDirToForwardDir = math.deg( math.acos( math.Clamp( Forward:Dot( EyeAngles:Forward() ) ,-1,1) ) )
	if AimDirToForwardDir > 75 then return end

	self:EmitSound( "AV_FIRE" )

	self:SetNextPrimary( 0.45 )

	local startpos =  Vector(550,0,-4960)
	local TracePlane = util.TraceHull( {
		start = startpos,
	endpos = startpos + EyeAngles:Forward() /** 50000*/,
		mins = Vector( -10, -10, -10 ),
		maxs = Vector( 10, 10, 10 ),
		filter = self
	} )

	local bullet = {}
	bullet.Num 	= 1
	bullet.Src 	= startpos
	bullet.Dir 	= (TracePlane.HitPos - bullet.Src):GetNormalized()
	bullet.Spread 	= Vector( 0.01,  0.01, 0 )
	bullet.Tracer	= 1
	bullet.TracerName	= "lfs_laser_green2"
	bullet.Force	= 3000
	bullet.HullSize 	= 2500
	bullet.Damage	= 350
	bullet.Attacker 	= Driver
	bullet.AmmoType = "Pistol"
	bullet.Callback = function(att, tr, dmginfo)
	dmginfo:SetDamageType(DMG_BLAST)
	end
	self:FireBullets( bullet )

	self:TakePrimaryAmmo()
end

function ENT:OnKeyThrottle( bPressed )
end

function ENT:CreateAI()
end

function ENT:RemoveAI()
end

function ENT:ToggleLandingGear()
end

function ENT:RaiseLandingGear()
end

function ENT:HandleWeapons(Fire1, Fire2)
	local Driver = self:GetDriver()

	if IsValid( Driver ) then
		Fire1 = Driver:KeyDown( IN_ATTACK )

		Fire2 = Driver:KeyDown( IN_ATTACK2 )
	end

	if Fire1 then
		self:PrimaryAttack()
	end
end

function ENT:OnEngineStarted()
end

function ENT:OnEngineStopped()
end
