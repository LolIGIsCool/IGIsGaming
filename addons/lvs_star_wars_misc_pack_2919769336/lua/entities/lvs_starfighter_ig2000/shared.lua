
ENT.Base = "lvs_base_starfighter"

ENT.PrintName = "IG-2000"
ENT.Author = "Nashatok"
ENT.Information = "Modified Aggressor-class Assault Fighter, used by bounty hunter and assassin IG-88B"
ENT.Category = "[LVS] - Star Wars"

ENT.Spawnable			= true
ENT.AdminSpawnable		= false

ENT.SpawnNormalOffset = -25

ENT.MDL = "models/ig2000/sfp_ig2000.mdl"

ENT.AITEAM = 1

ENT.MaxVelocity = 2500
ENT.MaxThrust = 2500

ENT.TurnRatePitch = 1
ENT.TurnRateYaw = 1
ENT.TurnRateRoll = 1

ENT.ForceLinearMultiplier = 1

ENT.ForceAngleMultiplier = 1
ENT.ForceAngleDampingMultiplier = 1

ENT.MaxHealth = 500
ENT.MaxShield = 100

function ENT:InitWeapons()
	local weapon = {}
	weapon.Icon = Material("lvs/weapons/dual_mg.png")
	weapon.Ammo = 600
	weapon.Delay = 0.12
	weapon.HeatRateUp = 0.34
	weapon.HeatRateDown = 1
	weapon.Attack = function( ent )
		local bullet = {}
		bullet.Dir 	= ent:GetForward()
		bullet.Spread 	= Vector( 0.015,  0.015, 0 )
		bullet.TracerName = "lvs_laser_red"
		bullet.Force	= 10
		bullet.HullSize 	= 25
		bullet.Damage	= 20
		bullet.Velocity = 60000
		bullet.SpashDamage 	= 45
		bullet.SplashDamageRadius	= 150
		bullet.Attacker 	= ent:GetDriver()
		bullet.Callback = function(att, tr, dmginfo)
			local effectdata = EffectData()
				effectdata:SetStart( Vector(255,50,50) ) 
				effectdata:SetOrigin( tr.HitPos )
				effectdata:SetNormal( tr.HitNormal )
			util.Effect( "lvs_laser_impact", effectdata )
		end

		for i = -1,1,2 do
			bullet.Src 	= ent:LocalToWorld( Vector(280,90 * i,100) )

			local effectdata = EffectData()
			effectdata:SetStart( Vector(255,50,50) )
			effectdata:SetOrigin( bullet.Src )
			effectdata:SetNormal( ent:GetForward() )
			effectdata:SetEntity( ent )
			util.Effect( "lvs_muzzle_colorable", effectdata )

			ent:LVSFireBullet( bullet )
		end

		ent:TakeAmmo()

		ent.PrimarySND:PlayOnce( 100 + math.cos( CurTime() + self:EntIndex() * 1337 ) * 5 + math.Rand(-1,1), 1 )
	end
	weapon.OnSelect = function( ent ) ent:EmitSound("physics/metal/weapon_impact_soft3.wav") end
	weapon.OnOverheat = function( ent ) ent:EmitSound("lvs/overheat.wav") end
	self:AddWeapon( weapon )

	--Weapon 2 - Ion Cannon
	local weapon = {}

	local weapon = {}
	weapon.Icon = Material("lvs/weapons/bullet.png")
	weapon.Ammo = 250
	weapon.Delay = 0.15
	weapon.HeatRateUp = 0.6
	weapon.HeatRateDown = 0.5
	weapon.Attack = function( ent )
		local bullet = {}
		bullet.Src 	= ent:LocalToWorld( Vector(120,0,60) )
		bullet.Dir 	= ent:GetForward()
		bullet.Spread 	= Vector( 0.015,  0.015, 0 )
		bullet.TracerName = "lvs_laser_blue"
		bullet.Force	= 10
		bullet.HullSize 	= 15
		bullet.Damage	= 30
		bullet.Velocity = 60000
		bullet.SplashDamage = 100
		bullet.SplashDamageRadius = 25
		bullet.Attacker 	= ent:GetDriver()
		bullet.Callback = function(att, tr, dmginfo)
			local effectdata = EffectData()
				effectdata:SetStart( Vector(50,50,250) ) 
				effectdata:SetOrigin( tr.HitPos )
				effectdata:SetNormal( tr.HitNormal )
			util.Effect( "cball_bounce", effectdata )
		end

		ent:LVSFireBullet( bullet )

		ent:TakeAmmo( 1 )
		ent.SecondarySND:PlayOnce( 100 + math.cos( CurTime() + self:EntIndex() * 1337 ) * 5 + math.Rand(-1,1), 1 )
	end
	weapon.OnSelect = function( ent ) ent:EmitSound("physics/metal/weapon_impact_soft3.wav") end
	weapon.OnOverheat = function( ent ) ent:EmitSound("lvs/overheat.wav") end
	self:AddWeapon( weapon )
end

ENT.FlyByAdvance = 0.75
ENT.FlyBySound = "lvs/vehicles/naboo_n1_starfighter/flyby.wav" 
ENT.DeathSound = "lvs/vehicles/generic_starfighter/crash.wav"

ENT.EngineSounds = {
	{
		sound = "lvs/vehicles/naboo_n1_starfighter/loop.wav",
		Pitch = 80,
		PitchMin = 0,
		PitchMax = 255,
		PitchMul = 40,
		FadeIn = 0,
		FadeOut = 1,
		FadeSpeed = 1.5,
		UseDoppler = true,
	},
}