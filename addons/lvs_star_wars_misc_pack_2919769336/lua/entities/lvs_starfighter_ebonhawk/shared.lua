
ENT.Base = "lvs_base_starfighter"

ENT.PrintName = "Dynamic-class Freighter"
ENT.Author = "Nashatok"
ENT.Information = "Prototype bomber by the Nubian Design Collective, stolen and modified by pirates and other unsavories"
ENT.Category = "[LVS] - Star Wars"

ENT.Spawnable			= true
ENT.AdminSpawnable		= false

ENT.MDL = "models/ehawk/ehawk1.mdl"

ENT.AITEAM = 2

ENT.MaxVelocity = 1900
ENT.MaxThrust = 1900

ENT.TurnRatePitch = 0.8
ENT.TurnRateYaw = 1
ENT.TurnRateRoll = 0.8

ENT.ForceLinearMultiplier = 1

ENT.ForceAngleMultiplier = 1
ENT.ForceAngleDampingMultiplier = 1

ENT.MaxHealth = 750
ENT.MaxShield = 250

function ENT:OnSetupDataTables()
	self:AddDT( "Bool", "Foils" )
	self:AddDT( "Entity", "GunnerSeat" )
end

function ENT:InitWeapons()
	self.FirePositions = {
		Vector(-55,395,85),
		Vector(-55,-395,85),
		Vector(-55,395,110),
		Vector(-55,-395,110)
	}
	
	--Weapon 1 - Heavy Laser Cannons
	local weapon = {}
	weapon.Icon = Material("lvs/weapons/hmg.png")
	weapon.Ammo = 1200
	weapon.Delay = 0.2
	weapon.HeatRateUp = 0.25
	weapon.HeatRateDown = .5
	weapon.Attack = function( ent )
		self.NumPrim = self.NumPrim and self.NumPrim + 1 or 1
		if self.NumPrim > 4 then self.NumPrim = 1 end

		local pod = ent:GetDriverSeat()

		if not IsValid( pod ) then return end

		local startpos = pod:LocalToWorld( pod:OBBCenter() )
		local trace = util.TraceHull( {
			start = startpos,
			endpos = (startpos + ent:GetForward() * 50000),
			mins = Vector( -10, -10, -10 ),
			maxs = Vector( 10, 10, 10 ),
			filter = ent:GetCrosshairFilterEnts()
		} )

		local bullet = {}
		bullet.Src 	= ent:LocalToWorld( ent.FirePositions[ent.NumPrim] )
		bullet.Dir 	= (trace.HitPos - bullet.Src):GetNormalized()
		bullet.Spread 	= Vector( 0,  0.03, 0.03 )
		bullet.TracerName = "lvs_laser_green"
		bullet.Force	= 10
		bullet.HullSize 	= 40
		bullet.Damage	= 50
		bullet.Velocity = 50000
		bullet.SplashDamage	= 80
		bullet.SplashDamageRadius	= 250
		bullet.Attacker 	= ent:GetDriver()
		bullet.Callback = function(att, tr, dmginfo)
			local effectdata = EffectData()
				effectdata:SetStart( Vector(50,255,50) ) 
				effectdata:SetOrigin( tr.HitPos )
				effectdata:SetNormal( tr.HitNormal )
			util.Effect( "lvs_laser_explosion", effectdata )
		end

		local effectdata = EffectData()
		effectdata:SetStart( Vector(50,255,50) )
		effectdata:SetOrigin( bullet.Src )
		effectdata:SetNormal( ent:GetForward() )
		effectdata:SetEntity( ent )
		util.Effect( "lvs_muzzle_colorable", effectdata )
		
		ent:LVSFireBullet( bullet )

		ent:TakeAmmo()

		ent.PrimarySND:PlayOnce( 100 + math.cos( CurTime() + self:EntIndex() * 1337 ) * 5 + math.Rand(-1,1), 1 )
	end
	weapon.OnSelect = function( ent ) ent:EmitSound("physics/metal/weapon_impact_soft3.wav") end
	weapon.OnOverheat = function( ent ) ent:EmitSound("lvs/overheat.wav") end
	self:AddWeapon( weapon )
	
	--Gunner Weapon
	local weapon = {}
	weapon.Icon = Material("lvs/weapons/mg.png")
	weapon.Delay = 0.15
	--weapon.HeatRateUp = 0.6
	--weapon.HeatRateDown = 0.5
	weapon.Attack = function( ent )
		local pod = ent:GetDriverSeat()

		if not IsValid( pod ) then return end

		local dir = ent:GetAimVector()

		if ent:AngleBetweenNormal( dir, ent:GetForward() ) > 60 then return true end

		local trace = ent:GetEyeTrace()

		ent.SwapTopBottom = not ent.SwapTopBottom

		local veh = ent:GetVehicle()

		veh.SNDTail:PlayOnce( 100 + math.Rand(-3,3), 1 )

		local bullet = {}
		bullet.Src = veh:LocalToWorld( ent.SwapTopBottom and Vector(-250,15,200) or Vector(-250,-15,200) )
		bullet.Dir = (trace.HitPos - bullet.Src):GetNormalized()
		bullet.Spread 	= Vector( 0.03,  0.03, 0.03 )
		bullet.TracerName = "lvs_laser_green"
		bullet.Force	= 10
		bullet.HullSize 	= 25
		bullet.Damage	= 25
		bullet.Velocity = 50000
		bullet.Attacker 	= ent:GetDriver()
		bullet.Callback = function(att, tr, dmginfo)
			local effectdata = EffectData()
				effectdata:SetStart( Vector(255,150,50) ) 
				effectdata:SetOrigin( tr.HitPos )
				effectdata:SetNormal( tr.HitNormal )
			util.Effect( "lvs_laser_impact", effectdata )
		end
		ent:LVSFireBullet( bullet )
	end
	weapon.OnSelect = function( ent ) ent:EmitSound("physics/metal/weapon_impact_soft3.wav")end
	weapon.OnOverheat = function( ent ) ent:EmitSound("lvs/overheat.wav") end
	self:AddWeapon( weapon, 2 )
end

ENT.FlyByAdvance = 0.75
ENT.FlyBySound = "lvs/vehicles/naboo_n1_starfighter/flyby.wav" 
ENT.DeathSound = "lvs/vehicles/generic_starfighter/crash.wav"

ENT.EngineSounds = {
	{
		sound = "eng_jedistarfighter_hi_lp.wav",
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