SWEP.Gun							= ("gun_base")
if (GetConVar(SWEP.Gun.."_allowed")) != nil then
	if not (GetConVar(SWEP.Gun.."_allowed"):GetBool()) then SWEP.Base = "tfa_blacklisted" SWEP.PrintName = SWEP.Gun return end
end
SWEP.Base							= "tfa_3dscoped_base"
SWEP.Category						= "TFA StarWars Reworked Galactic"
SWEP.Manufacturer 					= "Merr-Sonn Munitions, Inc."
SWEP.Author							= "ChanceSphere574"
SWEP.Contact						= ""
SWEP.Spawnable						= true
SWEP.AdminSpawnable					= true
SWEP.DrawCrosshair					= true
SWEP.DrawCrosshairIS 				= false
SWEP.PrintName						= "M-57"
SWEP.Type							= "Galactic Blaster Pistol"
SWEP.DrawAmmo						= true
SWEP.data 							= {}
SWEP.data.ironsights				= 1
SWEP.Secondary.IronFOV				= 78
SWEP.Slot							= 1
SWEP.SlotPos						= 200

SWEP.FiresUnderwater 				= true

SWEP.IronInSound 					= nil
SWEP.IronOutSound 					= nil
SWEP.CanBeSilenced					= false
SWEP.Silenced 						= false
SWEP.DoMuzzleFlash 					= false
SWEP.SelectiveFire					= true
SWEP.DisableBurstFire				= false
SWEP.OnlyBurstFire					= false
SWEP.DefaultFireMode 				= "single"
SWEP.FireModeName 					= nil
SWEP.DisableChambering 				= true

SWEP.Primary.ClipSize				= 8
SWEP.Primary.DefaultClip			= 8*5
SWEP.Primary.RPM					= 115
SWEP.Primary.RPM_Burst				= 115
SWEP.Primary.Ammo					= "light_battery"
SWEP.Primary.AmmoConsumption 		= 1
SWEP.Primary.Range 					= 32000
SWEP.Primary.RangeFalloff 			= -1
SWEP.Primary.NumShots				= 1
SWEP.Primary.Automatic				= false
SWEP.Primary.RPM_Semi				= nil
SWEP.Primary.BurstDelay				= 0.2
SWEP.Primary.Sound 					= Sound ("w/m57.wav");
SWEP.Primary.ReloadSound 			= Sound ("w/pistols.wav");
SWEP.Primary.PenetrationMultiplier 	= 0
SWEP.Primary.Damage					= 55
SWEP.Primary.HullSize 				= 0
SWEP.DamageType 					= nil

SWEP.FireModes = {
	"Single"
}


SWEP.IronRecoilMultiplier			= 0.44
SWEP.CrouchRecoilMultiplier			= 0.33
SWEP.JumpRecoilMultiplier			= 1.3
SWEP.WallRecoilMultiplier			= 1.1
SWEP.ChangeStateRecoilMultiplier	= 1.18
SWEP.CrouchAccuracyMultiplier		= 0.7
SWEP.ChangeStateAccuracyMultiplier	= 1
SWEP.JumpAccuracyMultiplier			= 2.6
SWEP.WalkAccuracyMultiplier			= 1.18
SWEP.NearWallTime 					= 0.25
SWEP.ToCrouchTime 					= 0.1
SWEP.WeaponLength 					= 35
SWEP.SprintFOVOffset 				= 12
SWEP.ProjectileVelocity 			= 9

SWEP.ProjectileEntity 				= nil
SWEP.ProjectileModel 				= nil

SWEP.ViewModel						= "models/weapons/synbf3/c_scoutblaster.mdl"
SWEP.WorldModel						= "models/weapons/synbf3/w_scoutblaster.mdl"
SWEP.ViewModelFOV					= 70
SWEP.ViewModelFlip					= false
SWEP.MaterialTable 					= nil
SWEP.UseHands 						= true
SWEP.HoldType 						= "pistol"

SWEP.ShowWorldModel = false

SWEP.BlowbackEnabled 				= true
SWEP.BlowbackVector 				= Vector(0,-2.5,0)
SWEP.BlowbackCurrentRoot			= 0
SWEP.BlowbackCurrent 				= 0
SWEP.BlowbackBoneMods 				= nil
SWEP.Blowback_Only_Iron 			= true
SWEP.Blowback_PistolMode 			= false
SWEP.Blowback_Shell_Enabled 		= false
SWEP.Blowback_Shell_Effect 			= "None"

SWEP.Tracer							= 0
SWEP.TracerName 					= "rw_sw_laser_red"
SWEP.TracerCount 					= 1
SWEP.TracerLua 						= false
SWEP.TracerDelay					= 0.01
SWEP.ImpactEffect 					= "rw_sw_impact_red"
SWEP.ImpactDecal 					= "FadingScorch"

SWEP.VMPos = Vector(2, -4, -2)
SWEP.VMAng = Vector(0,0,0)

SWEP.IronSightTime 					= 0.3
SWEP.Primary.KickUp					= 0.35
SWEP.Primary.KickDown				= 0.15
SWEP.Primary.KickHorizontal			= 0.055
SWEP.Primary.StaticRecoilFactor 	= 0.5
SWEP.Primary.Spread					= 0.025
SWEP.Primary.IronAccuracy 			= 0.01
SWEP.Primary.SpreadMultiplierMax 	= 0.6
SWEP.Primary.SpreadIncrement 		= 0.3
SWEP.Primary.SpreadRecovery 		= 0.98
SWEP.DisableChambering 				= true
SWEP.MoveSpeed 						= 1
SWEP.IronSightsMoveSpeed 			= 0.85

SWEP.IronSightsPos = Vector(-5.95, -12, 2.5)
SWEP.IronSightsAng = Vector(0, 0, 0)
SWEP.RunSightsPos = Vector(2, -9.5, -15)
SWEP.RunSightsAng = Vector(39, -0.5, -2)
SWEP.InspectPos = Vector(8, -4.8, -3)
SWEP.InspectAng = Vector(11.199, 38, 0)

SWEP.ViewModelBoneMods = {
	["v_scoutblaster_reference001"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) }
}

SWEP.VElements = {
	["m57"] = { type = "Model", model = "models/sw_battlefront/weapons/dl44_pistol_ext.mdl", bone = "v_scoutblaster_reference001", rel = "", pos = Vector(0, 0, 0.65), angle = Angle(0, 180, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {[2]=1} },
	["m57_scope"] = { type = "Model", model = "models/sw_battlefront/weapons/e11_scope.mdl", bone = "", rel = "m57", pos = Vector(-0.03, 07.05, -04.45), angle = Angle(0, -90, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["scope"] = { type = "Model", model = "models/rtcircle.mdl", bone = "", rel = "m57", pos = Vector(0, 0, 4.05), angle = Angle(0, 90, 0), size = Vector(0.29, 0.29, 0.29), color = Color(255, 255, 255, 255), surpresslightning = false, material = "!tfa_rtmaterial", skin = 0, bodygroup = {} }
}

SWEP.WElements = {
	["m57"] = { type = "Model", model = "models/sw_battlefront/weapons/dl44_pistol_ext.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3.5, 1.5, -1.4), angle = Angle(0, -90, 170), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {[2]=1} },
	["m57_scope"] = { type = "Model", model = "models/sw_battlefront/weapons/e11_scope.mdl", bone = "", rel = "m57", pos = Vector(-0.03, 07.05, -04.45), angle = Angle(0, -90, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
}

SWEP.Animations = { --Override this after SWEP:Initialize, for example, in attachments
	["reload"] = {
		["type"] = TFA.Enum.ANIMATION_ACT, --Sequence or act
		["value"] = ACT_VM_RELOAD_EMPTY,
		["enabled"] = true
	},
	["reload_empty"] = {
		["type"] = TFA.Enum.ANIMATION_ACT, --Sequence or act
		["value"] = ACT_VM_RELOAD_EMPTY
	},
	["reload_silenced"] = {
		["type"] = TFA.Enum.ANIMATION_ACT, --Sequence or act
		["value"] = ACT_VM_RELOAD_EMPTY,
		["enabled"] = true
	},
}

SWEP.ThirdPersonReloadDisable		=false
SWEP.Primary.DamageType 			= DMG_BULLET
SWEP.DamageType 					= DMG_BULLET
SWEP.RTScopeAttachment				= -1
SWEP.Scoped_3D 						= false
SWEP.ScopeReticule 					= "#sw/visor/sw_ret_redux_red"
SWEP.Secondary.ScopeZoom 			= 4
SWEP.ScopeReticule_Scale 			= {1,1}

if surface then
	SWEP.Secondary.ScopeTable = {
		["ScopeMaterial"] =  Material("#sw/visor/sw_ret_redux_red.png", "smooth"),
		["ScopeBorder"] = color_black,
		["ScopeCrosshair"] = { ["r"] = 0, ["g"]  = 0, ["b"] = 0, ["a"] = 0, ["s"] = 1 }
	}
end

DEFINE_BASECLASS( SWEP.Base )