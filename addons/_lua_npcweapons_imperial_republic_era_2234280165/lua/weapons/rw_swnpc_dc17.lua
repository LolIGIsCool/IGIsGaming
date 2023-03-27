DEFINE_BASECLASS("swep_ai_base")

-- No modifications autorized ;)
-- by Xyzzy & ChanceSphere574

SWEP.WorldModel					= "models/bf2017/w_scoutblaster.mdl"
SWEP.HoldType					= "pistol"

SWEP.MuzzleEffect 				= ""
SWEP.EnableMuzzleEffect			= false
SWEP.ShellEffect				= ""
SWEP.EnableShellEffect			= false
SWEP.TracerEffect				= "rw_sw_laser_blue"
SWEP.ReloadSounds				= {{0, "rw_swnpc_reload_light"}}
SWEP.ImpactDecal 				= "FadingScorch"
SWEP.ExtraShootEffects			= {
	{ EffectName = "rw_sw_impact_blue", Scale = 1, Magnitude = 1, Radius = 1 },
}

SWEP.ReloadTime					= NPC_WEAPONS_RELOAD_TIME_MED
local Damage 					= 30
SWEP.Primary.DamageMin			= (Damage*0.9)/5
SWEP.Primary.DamageMax			= (Damage*1.1)/5
SWEP.Primary.MinDropoffDistance	= NPC_WEAPONS_MIN_DROPOFF_DISTANCE_RIFLE
SWEP.Primary.MaxDropoffDistance	= NPC_WEAPONS_MAX_DROPOFF_DISTANCE_RIFLE
SWEP.Primary.Force				= 1
SWEP.Primary.Spread				= 0.05
SWEP.Primary.SpreadMoveMult		= NPC_WEAPONS_SPREAD_MOVE_MULT_MED
SWEP.Primary.BurstMinShots		= 1
SWEP.Primary.BurstMaxShots		= 1
SWEP.Primary.BurstMinDelay		= 0
SWEP.Primary.BurstMaxDelay		= 0
local RPM 						= 325
SWEP.Primary.FireDelay			= 1/(RPM/60)
SWEP.Primary.NumBullets			= 1
SWEP.Primary.ClipSize			= 20
SWEP.Primary.DefaultClip		= 20
SWEP.Primary.AimDelayMin		= NPC_WEAPONS_MIN_AIM_DELAY_MED
SWEP.Primary.AimDelayMax		= NPC_WEAPONS_MAX_AIM_DELAY_MED
SWEP.Primary.Sound				= "rw_swnpc_dc17"

SWEP.ClientModel				= {
	model						= "models/sw_battlefront/weapons/dc17_blaster.mdl",
	pos							= Vector(4, 01, -1),
	angle						= Angle(180, 180, 0),
	size						= Vector(1.0, 1.0, 1.0),
	color						= Color(255, 255, 255, 255),
	skin						= 0,
	bodygroup					= {},
}