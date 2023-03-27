
ENT.Base = "lvs_base_starfighter"

ENT.PrintName = "T-42"
ENT.Author = "Nashatok"
ENT.Information = "Light Interceptor designed by MandalMotors, popular among pirates and militias"
ENT.Category = "[LVS] - Star Wars"

ENT.Spawnable			= true
ENT.AdminSpawnable		= false

ENT.MDL = "models/t42/sfp_t42.mdl"

ENT.AITEAM = 1

ENT.MaxVelocity = 2150
ENT.MaxThrust = 2150

ENT.TurnRatePitch = 1
ENT.TurnRateYaw = 1
ENT.TurnRateRoll = 1

ENT.ForceLinearMultiplier = 1

ENT.ForceAngleMultiplier = 1
ENT.ForceAngleDampingMultiplier = 1

ENT.MaxHealth = 450
ENT.MaxShield = 100

function ENT:InitWeapons()
	self.FirePositions = {
		Vector(180,40,90),
		Vector(180,-40,90),
		Vector(180,40,55),
		Vector(180,-40,55),
	}
	
	--Weapon 1 - Rapid-fire Laser Cannons
	local weapon = {}
	weapon.Icon = Material("lvs/weapons/mg.png")
	weapon.Ammo = 1200
	weapon.Delay = 0.1
	weapon.HeatRateUp = 0.25
	weapon.HeatRateDown = 1
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
		bullet.Spread 	= Vector( 0.02,  0.02, 0 )
		bullet.TracerName = "lvs_laser_red"
		bullet.Force	= 10
		bullet.HullSize 	= 40
		bullet.Damage	= 30
		bullet.Velocity = 60000
		bullet.Attacker 	= ent:GetDriver()
		bullet.Callback = function(att, tr, dmginfo)
			local effectdata = EffectData()
				effectdata:SetStart( Vector(255,50,50) ) 
				effectdata:SetOrigin( tr.HitPos )
				effectdata:SetNormal( tr.HitNormal )
			util.Effect( "lvs_laser_impact", effectdata )
		end

		local effectdata = EffectData()
		effectdata:SetStart( Vector(255,50,50) )
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
	
	self:AddWeapon( LVS:GetWeaponPreset( "TURBO" ) )
end

ENT.FlyByAdvance = 0.75
ENT.FlyBySound = "lvs/vehicles/vwing/flyby.wav" 
ENT.DeathSound = "lvs/vehicles/generic_starfighter/crash.wav"

ENT.EngineSounds = {
	{
		sound = "lvs/vehicles/arc170/loop.wav",
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