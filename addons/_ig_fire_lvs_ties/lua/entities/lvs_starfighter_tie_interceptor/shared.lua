
ENT.Base = "lvs_base_starfighter"

ENT.PrintName = "TIE Interceptor"
ENT.Author = "Fire"
ENT.Information = "Another of the empire's shitty combustion boxes"
ENT.Category = "[LVS] - Star Wars"

ENT.Spawnable			= true
ENT.AdminSpawnable		= false

ENT.MDL = "models/kingpommes/starwars/tie/interceptor.mdl"

ENT.GibModels = {
	"models/XQM/wingpiece2.mdl",
	"models/XQM/wingpiece2.mdl",
	"models/XQM/jetwing2medium.mdl",
	"models/XQM/jetwing2medium.mdl",
	"models/props_c17/TrapPropeller_Engine.mdl",
	"models/props_junk/Shoe001a.mdl",
	"models/XQM/jetbody2fuselage.mdl",
	"models/XQM/jettailpiece1medium.mdl",
	"models/XQM/pistontype1huge.mdl",
	"models/kingpommes/starwars/tie/gib_cockpit.mdl",
	"models/kingpommes/starwars/tie/gib_fighter1.mdl",
	"models/kingpommes/starwars/tie/gib_fighter2.mdl",
}

ENT.AITEAM = 1

ENT.MaxVelocity = 2600
ENT.MaxThrust = 2000

ENT.TurnRatePitch = 1.25
ENT.TurnRateYaw = 1.25
ENT.TurnRateRoll = 1

ENT.ForceLinearMultiplier = 1

ENT.ForceAngleMultiplier = 1
ENT.ForceAngleDampingMultiplier = 1

ENT.MaxHealth = 1200

sound.Add({
	name = "TIE_ROAR",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 125,
	pitch = {95, 105},
	sound = {
	"kingpommes/starwars/tie/roar1.wav",
	"kingpommes/starwars/tie/roar2.wav",
	"kingpommes/starwars/tie/roar3.wav",
	"kingpommes/starwars/tie/roar4.wav"
	}
})

sound.Add({
	name = "TIE_PEW",
	channel = CHAN_WEAPON,
	volume = 1.0,
	level = 125,
	pitch = {95, 105},
	sound = {
		"kingpommes/starwars/tie/shoot1.wav",
		"kingpommes/starwars/tie/shoot2.wav"
	}
})

function ENT:InitWeapons()
	self.FirePositions = {
		Vector(225.99,127.58,31.98),
		Vector(225.99,-127.58,31.98),
		Vector(225.99,-127.58,-31.98),
		Vector(225.99,127.58,-31.98),
	}

	local weapon = {}
	weapon.Icon = Material("lvs/weapons/mg.png")
	weapon.Ammo = 1000
	weapon.Delay = 0.2
	weapon.HeatRateUp = 0.3
	weapon.HeatRateDown = 0.5
	weapon.Attack = function(ent)
		local bullet = {}
		bullet.Dir 	= ent:GetForward()
		bullet.Spread 	= Vector(0.01,  0.01, 0)
		bullet.TracerName = "lvs_laser_green"
		bullet.Force	= 100
		bullet.HullSize 	= 40
		bullet.Damage	= 60
		bullet.Velocity = 60000
		bullet.Attacker 	= ent:GetDriver()
		bullet.Callback = function(att, tr, dmginfo)
			local effectdata = EffectData()
				effectdata:SetStart(Vector(50,255,50)) 
				effectdata:SetOrigin(tr.HitPos)
				effectdata:SetNormal(tr.HitNormal)
			util.Effect("lvs_laser_impact", effectdata)
		end

		for i = -1,1,2 do
			bullet.Src 	= ent:LocalToWorld(Vector(49.91, 14.53 * i, -42.09))
			ent:LVSFireBullet(bullet)

			local effectdata = EffectData()
			effectdata:SetStart(Vector(50,255,50))
			effectdata:SetOrigin(bullet.Src)
			effectdata:SetNormal(ent:GetForward())
			effectdata:SetEntity(ent)
			util.Effect("lvs_muzzle_colorable", effectdata)
		end

		ent:TakeAmmo()

		ent.PrimarySND:PlayOnce( 100 + math.cos( CurTime() + ent:EntIndex() * 1337 ) * 5 + math.Rand(-1,1), 1 )
	end
	weapon.OnSelect = function(ent) ent:EmitSound("physics/metal/weapon_impact_soft3.wav") end
	weapon.OnOverheat = function(ent) ent:EmitSound("lvs/overheat.wav") end
	self:AddWeapon(weapon)

	local weapon = {}
	weapon.Icon = Material("lvs/weapons/dual_mg.png")
	weapon.Ammo = 1000
	weapon.Delay = 0.1
	weapon.HeatRateUp = 0.5
	weapon.HeatRateDown = 0.5
	weapon.Attack = function(ent)
		local bullet = {}
		bullet.Dir 	= ent:GetForward()
		bullet.Spread 	= Vector(0.01,  0.01, 0)
		bullet.TracerName = "lvs_laser_green"
		bullet.Force	= 100
		bullet.HullSize 	= 40
		bullet.Damage	= 30
		bullet.Velocity = 60000
		bullet.Attacker 	= ent:GetDriver()
		bullet.Callback = function(att, tr, dmginfo)
			local effectdata = EffectData()
				effectdata:SetStart(Vector(50,255,50)) 
				effectdata:SetOrigin(tr.HitPos)
				effectdata:SetNormal(tr.HitNormal)
			util.Effect("lvs_laser_impact", effectdata)
		end

		ent.NumPrim = ent.NumPrim and ent.NumPrim + 1 or 1
		if ent.NumPrim > #ent.FirePositions then ent.NumPrim = 1 end

		bullet.Src 	= ent:LocalToWorld(ent.FirePositions[ent.NumPrim])
		ent:LVSFireBullet(bullet)

		local effectdata = EffectData()
		effectdata:SetStart(Vector(50,255,50))
		effectdata:SetOrigin(bullet.Src)
		effectdata:SetNormal(ent:GetForward())
		effectdata:SetEntity(ent)
		util.Effect("lvs_muzzle_colorable", effectdata)

		ent:TakeAmmo()

		ent.WingSND[ent.NumPrim]:PlayOnce( 100 + math.cos( CurTime() + ent:EntIndex() * 1337 ) * 5 + math.Rand(-1,1), 1 )
	end
	weapon.OnSelect = function(ent) ent:EmitSound("physics/metal/weapon_impact_soft3.wav") end
	weapon.OnOverheat = function(ent) ent:EmitSound("lvs/overheat.wav") end
	self:AddWeapon(weapon)
end

ENT.FlyByAdvance = 0.5
ENT.FlyBySound = "kingpommes/starwars/tie/roar1.wav" 
ENT.DeathSound = "lvs/vehicles/generic/crash.wav"

ENT.EngineSounds = {
	{
		sound = "^kingpommes/starwars/tie/distance.wav",
		Pitch = 80,
		PitchMin = 0,
		PitchMax = 255,
		PitchMul = 40,
		FadeIn = 0.33,
		FadeOut = 1,
		FadeSpeed = 1.5,
		VolumeMin = 0,
		VolumeMax = 1,
		SoundLevel = 110,
		UseDoppler = true,
	},
	{
		sound = "^kingpommes/starwars/tie/engine.wav",
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