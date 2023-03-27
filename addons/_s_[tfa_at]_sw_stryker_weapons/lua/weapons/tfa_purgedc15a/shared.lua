SWEP.Base							= "tfa_3dscoped_base"
SWEP.Category						= "Purge Troopers"
SWEP.Manufacturer 					= "BlasTech Industries"
SWEP.Author							= "Ventrici"
SWEP.Contact						= ""
SWEP.Spawnable						= true
SWEP.AdminSpawnable					= true
SWEP.DrawCrosshair					= true
SWEP.DrawCrosshairIS 				= false
SWEP.PrintName						= "Imperial DC-15a"
SWEP.Type							= "Modular Elite Blaster"
SWEP.DrawAmmo						= true
SWEP.data 							= {}
SWEP.data.ironsights				= 1
SWEP.Secondary.IronFOV				= 78
SWEP.Slot							= 2
SWEP.SlotPos						= 100

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

SWEP.Primary.ClipSize				= 30
SWEP.Primary.DefaultClip			= 40
SWEP.Primary.RPM					= 240
SWEP.Primary.RPM_Burst				= 100
SWEP.Primary.Ammo					= "standard_battery"
SWEP.Primary.AmmoConsumption 		= 1
SWEP.Primary.Range 					= 40000
SWEP.Primary.RangeFalloff 			= -1
SWEP.Primary.NumShots				= 1
SWEP.Primary.Automatic				= false
SWEP.Primary.RPM_Semi				= nil
SWEP.Primary.BurstDelay				= 0.2
SWEP.Primary.Sound 					= Sound ("w/dc15a.wav");
SWEP.Primary.ReloadSound 			= Sound ("w/heavy.wav");
SWEP.Primary.PenetrationMultiplier 	= 0
SWEP.Primary.Damage					= 36
SWEP.Primary.HullSize 				= 0
SWEP.DamageType 					= nil

SWEP.DoMuzzleFlash 					= false

SWEP.FireModes = {
	"Auto"
}

SWEP.IronRecoilMultiplier			= 0.5
SWEP.CrouchRecoilMultiplier			= 0.55
SWEP.JumpRecoilMultiplier			= 1.3
SWEP.WallRecoilMultiplier			= 1.1
SWEP.ChangeStateRecoilMultiplier	= 1.3
SWEP.CrouchAccuracyMultiplier		= 0.5
SWEP.ChangeStateAccuracyMultiplier	= 1.18
SWEP.JumpAccuracyMultiplier			= 2
SWEP.WalkAccuracyMultiplier			= 1.8
SWEP.NearWallTime 					= 0.5
SWEP.ToCrouchTime 					= 0.25
SWEP.WeaponLength 					= 35
SWEP.SprintFOVOffset 				= 12
SWEP.ProjectileVelocity 			= 9

SWEP.ProjectileEntity 				= nil
SWEP.ProjectileModel 				= nil

SWEP.ViewModel						= "models/bf2017/c_dlt19.mdl"
SWEP.WorldModel						= "models/bf2017/w_dlt19.mdl"
SWEP.ViewModelFOV					= 90
SWEP.ViewModelFlip					= false
SWEP.MaterialTable 					= nil
SWEP.UseHands 						= true
SWEP.HoldType 						= "ar2"
SWEP.ReloadHoldTypeOverride 		= "ar2"

SWEP.ShowWorldModel = false

SWEP.BlowbackEnabled 				= true
SWEP.BlowbackVector 				= Vector(0,-1,-0.05)
SWEP.BlowbackCurrentRoot			= 0
SWEP.BlowbackCurrent 				= 0
SWEP.BlowbackBoneMods 				= nil
SWEP.Blowback_Only_Iron 			= true
SWEP.Blowback_PistolMode 			= false
SWEP.Blowback_Shell_Enabled 		= false
SWEP.Blowback_Shell_Effect 			= "None"

SWEP.Tracer							= 0
SWEP.TracerName 					= "strasser_laser_red"
SWEP.TracerCount 					= 1
SWEP.TracerLua 						= false
SWEP.TracerDelay					= 0.01
SWEP.ImpactDecal 					= "FadingScorch"

SWEP.VMPos = Vector(1.2, -3, 0)
SWEP.VMAng = Vector(0,-1.2,0)
--SWEP.VMPos = Vector(5, -50, 0)
--SWEP.VMAng = Vector(0,90,0)

SWEP.IronSightTime 					= 0.7
SWEP.Primary.KickUp					= 0.45
SWEP.Primary.KickDown				= 0.12
SWEP.Primary.KickHorizontal			= 0.12
SWEP.Primary.StaticRecoilFactor 	= 0.6
SWEP.Primary.Spread					= 0.06
SWEP.Primary.IronAccuracy 			= 0.02
SWEP.Primary.SpreadMultiplierMax 	= 0.4
SWEP.Primary.SpreadIncrement 		= 0.2
SWEP.Primary.SpreadRecovery 		= 0.8
SWEP.DisableChambering 				= true
SWEP.MoveSpeed 						= 1
SWEP.IronSightsMoveSpeed 			= 0.85

SWEP.IronSightsPos = Vector(-4.4, -4, 0.15)
SWEP.IronSightsAng = Vector(0, 1.5, 0)
SWEP.RunSightsPos = Vector(0, -2, 0)
SWEP.RunSightsAng = Vector(-22, 35, -22)
SWEP.InspectPos = Vector(8, -4.8, -3)
SWEP.InspectAng = Vector(11.199, 38, 0)

SWEP.ViewModelBoneMods = {
	["v_dlt19_reference001"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 2), angle = Angle(0, 0, 0) }
}

SWEP.VElements = {
	["scope"] = { type = "Model", model = "models/rtcircle.mdl", bone = "v_dlt19_reference001", rel = "dc15a", pos = Vector(-2, -.01, 5.35), angle = Angle(0,180, 0), size = Vector(0.32, 0.32, 0.32), color = Color(255, 255, 255, 255), surpresslightning = false, material = "!tfa_rtmaterial", skin = 0, bodygroup = {}, active = false },
	["scope2"] = { type = "Model", model = "models/rtcircle.mdl", bone = "v_dlt19_reference001", rel = "dc15a", pos = Vector(9.4, 2.45, 4.05), angle = Angle(0,180, 0), size = Vector(0.28, 0.28, 0.28), color = Color(255, 255, 255, 255), surpresslightning = false, material = "!tfa_rtmaterial", skin = 0, bodygroup = {} },
	["dc15a"] = { type = "Model", model = "models/red menace/fallenorder/props/purgetrooper/dc15a.mdl", bone = "v_dlt19_reference001", rel = "", pos = Vector(0.3, 0, -2), angle = Angle(0, 270, 0), size = Vector(1.3, 1.3, 1.3), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {[1] = 1, [2] = 0 }},
	["barrel1"] = { type = "Model", model = "models/sw_battlefront/weapons/2019/a280cfe_barrel_mod.mdl", bone = "v_dlt19_reference001", rel = "", pos = Vector(.4, 17, -2.7), angle = Angle(0, 270, 0), size = Vector(1.3, 1.3, 1.3), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, active = false },
	["barrel2"] = { type = "Model", model = "models/sw_battlefront/weapons/2019/a280c_barrel3.mdl", bone = "v_dlt19_reference001", rel = "", pos = Vector(0.7, 23, -2.5), angle = Angle(0, 270, 0), size = Vector(1.3, 1.3, 1.3), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, active = false  },
	["barrel3"] = { type = "Model", model = "models/sw_battlefront/weapons/iqa_barrel1.mdl", bone = "v_dlt19_reference001", rel = "", pos = Vector(.4, -2.5, -4.6), angle = Angle(0, 270, 0), size = Vector(2, 2, 2), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, active = false },
	["magazine1"] = { type = "Model", model = "models/sw_battlefront/weapons/2019/rt97_rifle_magazine.mdl", bone = "v_dlt19_reference001", rel = "", pos = Vector(1, -9, -3), angle = Angle(0, -90, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, active = false }
}

SWEP.Attachments = {
	[1] = { offset = { 0, 0 }, atts = { "assault_blasts", "executionerround" }, order = 1 },
	[2] = { offset = { 0, 0 }, atts = { "purgebarrel1", "purgebarrel2", "purgebarrel3" }, order = 2 },
	[3] = { offset = { 0, 0 }, atts = { "purgeextendedmagazine" }, order = 3 },
}

SWEP.WElements = {
	["dc15a"] = { type = "Model", model = "models/red menace/fallenorder/props/purgetrooper/dc15a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3, 1.1, -.5), angle = Angle(-5, 0, 180), size = Vector(1.1, 1.1, 1.1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {[1] = 1, [2] = 0 } },
	["barrel1"] = { type = "Model", model = "models/sw_battlefront/weapons/2019/a280cfe_barrel_mod.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(18, 1, -1.1), angle = Angle(-5, 0, 180), size = Vector(1.1, 1.1, 1.1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, active = false },
	["barrel2"] = { type = "Model", model = "models/sw_battlefront/weapons/2019/a280c_barrel3.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(20, 1.1, -1.5), angle = Angle(-5, 0, 180), size = Vector(1.1, 1.1, 1.1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, active = false },
	["barrel3"] = { type = "Model", model = "models/sw_battlefront/weapons/iqa_barrel1.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(13, 1.1, -.6), angle = Angle(-5, 0, 180), size = Vector(1.1, 1.1, 1.1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, active = false },
	["magazine1"] = { type = "Model", model = "models/sw_battlefront/weapons/2019/rt97_rifle_magazine.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(-8, 1.1, 2), angle = Angle(-5, 0, 180), size = Vector(1.1, 1.1, 1.1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, active = false },
}


SWEP.ThirdPersonReloadDisable		=false
SWEP.Primary.DamageType 			= DMG_BULLET
SWEP.DamageType 					= DMG_BULLET
SWEP.RTScopeAttachment				= -1
SWEP.Scoped_3D 						= false
SWEP.ScopeReticule 					= "#sw/visor/sw_ret_redux_red"
SWEP.Secondary.ScopeZoom 			= 20
SWEP.ScopeReticule_Scale 			= {1,1}
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
