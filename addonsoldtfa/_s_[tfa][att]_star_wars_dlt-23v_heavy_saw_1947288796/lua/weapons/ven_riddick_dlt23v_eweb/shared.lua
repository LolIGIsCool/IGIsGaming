SWEP.Gun							= ("ven_dlt23v_eweb")
if (GetConVar(SWEP.Gun.."_allowed")) != nil then
	if not (GetConVar(SWEP.Gun.."_allowed"):GetBool()) then SWEP.Base = "tfa_blacklisted" SWEP.PrintName = SWEP.Gun return end
end
SWEP.Base							= "tfa_swsft_base"
SWEP.Category						= "TFA Star Wars In-Development"
SWEP.Manufacturer 					= ""
SWEP.Author							= "Riddick & Venator"
SWEP.Contact						= ""
SWEP.Spawnable						= true
SWEP.AdminSpawnable					= true
SWEP.DrawCrosshair					= true
SWEP.DrawCrosshairIS 				= false
SWEP.PrintName						= "DLT-23V E-WEB"
SWEP.Type							= "Squad-supression weapon"
SWEP.DrawAmmo						= true
SWEP.data 							= {}
SWEP.data.ironsights				= 1
SWEP.Secondary.IronFOV				= 58
SWEP.Slot							= 3
SWEP.SlotPos						= 5

SWEP.FiresUnderwater 				= true

SWEP.IronInSound 					= nil
SWEP.IronOutSound 					= nil
SWEP.CanBeSilenced					= false
SWEP.Silenced 						= false
SWEP.DoMuzzleFlash 					= false
SWEP.SelectiveFire					= true
SWEP.DisableBurstFire				= false
SWEP.OnlyBurstFire					= false
SWEP.DefaultFireMode 				= "auto"
SWEP.FireModeName 					= nil
SWEP.DisableChambering 				= true

SWEP.Primary.ClipSize				= 300
SWEP.Primary.DefaultClip			= 600
SWEP.Primary.RPM					= 500
SWEP.Primary.RPM_Burst				= 500
SWEP.Primary.Ammo					= "heavy_battery"
SWEP.Primary.AmmoConsumption 		= 1
SWEP.Primary.Range 					= 10000
SWEP.Primary.RangeFalloff 			= -1
SWEP.Primary.NumShots				= 1
SWEP.Primary.Automatic				= true
SWEP.Primary.RPM_Semi				= nil
SWEP.Primary.BurstDelay				= 0.2
SWEP.Primary.Sound 					= Sound ("Weapon_DLT23V.Single");
SWEP.Primary.ReloadSound 			= Sound ("weapons/bf3/dlt23v_reload6.wav");
SWEP.Primary.PenetrationMultiplier 	= 0
SWEP.Primary.Damage					= 50
SWEP.Primary.HullSize 				= 0
SWEP.DamageType 					= nil

SWEP.DoMuzzleFlash 					= true
SWEP.CustomMuzzleFlash 				= true
SWEP.MuzzleFlashEffect 				= "tfa_muzzleflash_rifle"

SWEP.FireModes = {
	"Auto",
}


SWEP.IronRecoilMultiplier			= 0
SWEP.CrouchRecoilMultiplier			= 0
SWEP.JumpRecoilMultiplier			= 0
SWEP.WallRecoilMultiplier			= 0
SWEP.ChangeStateRecoilMultiplier	= 0
SWEP.CrouchAccuracyMultiplier		= 0
SWEP.ChangeStateAccuracyMultiplier	= 1.18
SWEP.JumpAccuracyMultiplier			= 2
SWEP.WalkAccuracyMultiplier			= 1.18
SWEP.NearWallTime 					= 4
SWEP.ToCrouchTime 					= 3
SWEP.WeaponLength 					= 35
SWEP.SprintFOVOffset 				= 0

--SWEP.ProjectileEntity 				= "sw_blue_laser_red"
--SWEP.ProjectileModel 				= "models/weapons/w_eq_fraggrenade.mdl"
--SWEP.ProjectileVelocity 			= 4000


SWEP.ViewModel						= "models/weapons/ven_riddick/dlt23v2.mdl"
SWEP.WorldModel						= "models/weapons/ven_riddick/w_dlt23v.mdl"
SWEP.ViewModelFOV					= 70
SWEP.ViewModelFlip					= false
SWEP.MaterialTable 					= nil
SWEP.UseHands 						= true
SWEP.HoldType 						= "shotgun"
SWEP.ReloadHoldTypeOverride 		= "ar2"
SWEP.ShootWhileDraw = false
SWEP.AllowReloadWhileDraw = false


SWEP.ShowWorldModel = true

SWEP.BlowbackEnabled 				= true
SWEP.BlowbackVector 				= Vector(0.2,-7.2,.2)
SWEP.BlowbackCurrentRoot			= 0
SWEP.BlowbackCurrent 				= 2
SWEP.BlowbackBoneMods 				= nil
SWEP.Blowback_Only_Iron 			= false
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


SWEP.VMPos = Vector(0, -1.1, -1)
SWEP.VMAng = Vector(0,-2.3,0)



SWEP.IronSightTime 					= 0.85
SWEP.Primary.KickUp					= 0
SWEP.Primary.KickDown				= 0
SWEP.Primary.KickHorizontal			= 0
SWEP.Primary.StaticRecoilFactor 	= 0
SWEP.Primary.Spread					= 0.1
SWEP.Primary.IronAccuracy 			= 0.05
SWEP.Primary.SpreadMultiplierMax 	= 0.1
SWEP.Primary.SpreadIncrement 		= 0.1325
SWEP.Primary.SpreadRecovery 		= 0.8
SWEP.DisableChambering 				= true
SWEP.MoveSpeed 						= .6
SWEP.IronSightsMoveSpeed 			= 0.3


SWEP.IronSightsPos = Vector(-3.4, -5, 2.2)
SWEP.IronSightsAng = Vector(0, 0.5, 3)
SWEP.RunSightsPos = Vector(5.226, -0, -1)
SWEP.RunSightsAng = Vector(-19, 42, -22)
SWEP.InspectPos = Vector(8, -4.8, -3)
SWEP.InspectAng = Vector(11.199, 38, 0)

SWEP.ShowViewModel = true
SWEP.ShowWorldModel = false

SWEP.ViewModelBoneMods = {
	["ValveBiped.Bip01_L_Forearm"] = { scale = Vector(1.016, 1.016, 1.016), pos = Vector(0.185, 1.296, -0.556), angle = Angle(1.11, 1.11, 0) },
	["ValveBiped.Bip01_L_Hand"] = { scale = Vector(0.702, 0.702, 0.702), pos = Vector(-0.556, 0.185, 0), angle = Angle(-7.7, -10, -3.3) },
	["handle"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(125.555, 0, 0) },
	["locket"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0.185), angle = Angle(75, 0, 0) },
}

SWEP.VElements = {
	["bipod_up"] = { type = "Model", model = "models/weapons/ven_riddick/bipod_up.mdl", bone = "DLT23V_main", rel = "", pos = Vector(6.752, -24.417, 2.596), angle = Angle(90, -91, -99.351), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, active = false },
	["bipod_deployed"] = { type = "Model", model = "models/weapons/ven_riddick/bipod_deployed.mdl", bone = "DLT23V_main", rel = "", pos = Vector(5, -27.8, 2.359), angle = Angle(-94.676, 180, -167.144), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, active = false }
}


SWEP.WElements = {
	["world"] = { type = "Model", model = "models/weapons/ven_riddick/w_dlt23v.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(9.869, 1.557, -3.636), angle = Angle(-12.7, 4.3, 141.429), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
}



SWEP.ThirdPersonReloadDisable		= false
SWEP.Primary.DamageType 			= DMG_BULLET
SWEP.DamageType 					= DMG_BULLET
SWEP.RTScopeAttachment				= -1
SWEP.Scoped_3D 						= false
SWEP.ScopeReticule 					= "scope/gdcw_elcanreticle" 
SWEP.Secondary.ScopeZoom 			= 10
SWEP.ScopeReticule_Scale 			= {2.5,2.5}
if surface then
	SWEP.Secondary.ScopeTable = nil --[[
		{
			scopetex = surface.GetTextureID("scope/gdcw_closedsight"),
			reticletex = surface.GetTextureID("scope/gdcw_acogchevron"),
			dottex = surface.GetTextureID("scope/gdcw_acogcross")
		}
	]]--
end
DEFINE_BASECLASS( SWEP.Base )