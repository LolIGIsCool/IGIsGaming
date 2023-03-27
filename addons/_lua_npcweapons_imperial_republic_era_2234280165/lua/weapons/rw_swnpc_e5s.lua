DEFINE_BASECLASS("swep_ai_base")

-- No modifications autorized ;)
-- by Xyzzy & ChanceSphere574

SWEP.WorldModel					= "models/bf2017/w_dlt19.mdl"
SWEP.HoldType					= "ar2"

SWEP.MuzzleEffect 				= ""
SWEP.EnableMuzzleEffect			= false
SWEP.ShellEffect				= ""
SWEP.EnableShellEffect			= false
SWEP.TracerEffect				= "rw_sw_laser_red"
SWEP.ReloadSounds				= {{0, "rw_swnpc_reload_heavy"}}
SWEP.ImpactDecal 				= "FadingScorch"
SWEP.ExtraShootEffects			= {
	{ EffectName = "rw_sw_impact_red", Scale = 1, Magnitude = 1, Radius = 1 },
}

SWEP.ReloadTime					= 3.5
local Damage 					= 135
SWEP.Primary.DamageMin			= (Damage*0.9)/5
SWEP.Primary.DamageMax			= (Damage*1.1)/5
SWEP.Primary.MinDropoffDistance	= NPC_WEAPONS_MIN_DROPOFF_DISTANCE_RIFLE
SWEP.Primary.MaxDropoffDistance	= NPC_WEAPONS_MAX_DROPOFF_DISTANCE_RIFLE
SWEP.Primary.Force				= 1
SWEP.Primary.Spread				= 0.05/7
SWEP.Primary.SpreadMoveMult		= NPC_WEAPONS_SPREAD_MOVE_MULT_MED
SWEP.Primary.BurstMinShots		= 1
SWEP.Primary.BurstMaxShots		= 1
SWEP.Primary.BurstMinDelay		= 0
SWEP.Primary.BurstMaxDelay		= 0
local RPM 						= 110
SWEP.Primary.FireDelay			= 1/(RPM/60)
SWEP.Primary.NumBullets			= 1
SWEP.Primary.ClipSize			= 5
SWEP.Primary.DefaultClip		= 5
SWEP.Primary.AimDelayMin		= NPC_WEAPONS_MIN_AIM_DELAY_MED
SWEP.Primary.AimDelayMax		= NPC_WEAPONS_MAX_AIM_DELAY_MED
SWEP.Primary.Sound				= "rw_swnpc_e5s"

SWEP.ClientModel				= {
	model						= "models/kuro/sw_battlefront/weapons/e5s_blaster.mdl",
	pos							= Vector(4.5, 01, 1),
	angle						= Angle(192, 180, 0),
	size						= Vector(1.0, 1.0, 1.0),
	color						= Color(255, 255, 255, 255),
	skin						= 0,
	bodygroup					= {},
}