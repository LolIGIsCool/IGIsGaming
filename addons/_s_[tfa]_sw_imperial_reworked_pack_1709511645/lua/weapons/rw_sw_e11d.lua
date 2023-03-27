SWEP.Gun							= ("gun_base")
if (GetConVar(SWEP.Gun.."_allowed")) != nil then
	if not (GetConVar(SWEP.Gun.."_allowed"):GetBool()) then SWEP.Base = "tfa_blacklisted" SWEP.PrintName = SWEP.Gun return end
end
SWEP.Base							= "tfa_gun_base"
SWEP.Category						= "TFA StarWars Reworked Imperial"
SWEP.Manufacturer 					= ""
SWEP.Author							= "ChanceSphere574"
SWEP.Contact						= ""
SWEP.Spawnable						= true
SWEP.AdminSpawnable					= true
SWEP.DrawCrosshair					= true
SWEP.DrawCrosshairIS 				= false
SWEP.PrintName						= "E-11D"
SWEP.Type							= "Imperial Carbine Blaster"
SWEP.DrawAmmo						= true
SWEP.data 							= {}
SWEP.data.ironsights				= 1
SWEP.Secondary.IronFOV				= 75
SWEP.Slot							= 3
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
SWEP.DefaultFireMode 				= "Automatic"
SWEP.FireModeName 					= nil
SWEP.DisableChambering 				= true

SWEP.Primary.ClipSize				= 35
SWEP.Primary.DefaultClip			= 35*5
SWEP.Primary.RPM					= 290
SWEP.Primary.RPM_Burst				= 290
SWEP.Primary.Ammo					= "standard_battery"
SWEP.Primary.AmmoConsumption 		= 1
SWEP.Primary.Range 					= 40000
SWEP.Primary.RangeFalloff 			= -1
SWEP.Primary.NumShots				= 1
SWEP.Primary.Automatic				= true
SWEP.Primary.RPM_Semi				= nil
SWEP.Primary.BurstDelay				= 0.2
SWEP.Primary.Sound 					= Sound ("w/e11d.wav");
SWEP.Primary.ReloadSound 			= Sound ("w/rifles.wav");
SWEP.Primary.PenetrationMultiplier 	= 0
SWEP.Primary.Damage					= 40
SWEP.Primary.HullSize 				= 0
SWEP.DamageType 					= nil

SWEP.DoMuzzleFlash 					= false

SWEP.FireModes = {
	"Automatic",
	"Single"
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

SWEP.ViewModel						= "models/bf2017/c_e11.mdl"
SWEP.WorldModel						= "models/bf2017/w_e11.mdl"
SWEP.ViewModelFOV					= 65
SWEP.ViewModelFlip					= false
SWEP.MaterialTable 					= nil
SWEP.UseHands 						= true
SWEP.HoldType 						= "ar2"
SWEP.ReloadHoldTypeOverride 		= "smg"

SWEP.ShowWorldModel = false

SWEP.BlowbackEnabled 				= true
SWEP.BlowbackVector 				= Vector(0,-1.5,-0.05)
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

SWEP.VMPos = Vector(1.475, 0, -0.75)
SWEP.VMAng = Vector(0,0,0)

SWEP.IronSightTime 					= 0.7
SWEP.Primary.KickUp					= 0.45
SWEP.Primary.KickDown				= 0.12
SWEP.Primary.KickHorizontal			= 0.04
SWEP.Primary.StaticRecoilFactor 	= 0.60
SWEP.Primary.Spread					= 0.1
SWEP.Primary.IronAccuracy 			= 0.02
SWEP.Primary.SpreadMultiplierMax 	= 0.4
SWEP.Primary.SpreadIncrement 		= 0.2
SWEP.Primary.SpreadRecovery 		= 0.8
SWEP.DisableChambering 				= true
SWEP.MoveSpeed 						= 1
SWEP.IronSightsMoveSpeed 			= 0.9

SWEP.IronSightsPos = Vector(-4.9, -4.5, 3.95)
SWEP.IronSightsAng = Vector(0, 0, 0)
SWEP.RunSightsPos = Vector(5.226, -2, 0)
SWEP.RunSightsAng = Vector(-18, 36, -13.5)
SWEP.InspectPos = Vector(8, -4.8, -3)
SWEP.InspectAng = Vector(11.199, 38, 0)

SWEP.ViewModelBoneMods = {
	["v_e11_reference001"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(-3, 0, 0), angle = Angle(0, 0, 0) }
}

SWEP.VElements = {
	["e11d"] = { type = "Model", model = "models/banks/sw_battlefront/weapons/e11d_blaster_carbine.mdl", bone = "v_e11_reference001", rel = "", pos = Vector(-1.5, 6, -0.5), angle = Angle(0, 0, 0), size = Vector(1.3, 1.3, 1.3), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["scope_beta"] = { type = "Model", model = "models/sw_battlefront/props/e11_scope/e11_scope.mdl", bone = "E11_GUN", rel = "", pos = Vector(-1.55, -3.1, 3.9), angle = Angle(0, -90, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, bonermerge = true, active = false},
	["scope_beta_rt"] = { type = "Model", model = "models/rtcircle.mdl", bone = "E11_GUN", rel = "scope_beta", pos = Vector(-3.0, -0.06, 0.225), angle = Angle(180, 0, 180), size = Vector(0.32, 0.32, 0.32), color = Color(255, 255, 255, 255), surpresslightning = false, material = "!tfa_rtmaterial", skin = 0, bodygroup = {}, bonermerge = true, active = false },
	["powerpack"] = { type = "Model", model = "models/sw_battlefront/props/powerpack/power_pack.mdl", bone = "E11_GUN", rel = "", pos = Vector(0, -1, 2.299), angle = Angle(0, 0, 0), size = Vector(0.8, 0.8, 0.8), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, active = false },
	["laser"] = { type = "Model", model = "models/sw_battlefront/props/flashlight/flashlight.mdl", bone = "E11_GUN", rel = "", pos = Vector(-1.9, 5.4, 1), angle = Angle(0, -90, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, active = false },
	["laser_beam"] = { type = "Model", model = "models/tfa/lbeam.mdl", bone = "", rel = "laser", pos = Vector(10, 2.5, 1), angle = Angle(0, 0, 0), size = Vector(1.6, 1.6, 1.6), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, active = false  },
}

SWEP.WElements = {
	["e11d"] = { type = "Model", model = "models/banks/sw_battlefront/weapons/e11d_blaster_carbine.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(7, 0.8, -2.25), angle = Angle(180, 90, -14), size = Vector(1.2, 1.2, 1.2), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["scope"] = { type = "Model", model = "models/sw_battlefront/props/e11_scope/e11_scope.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(2.299, 0.9, -5.301), angle = Angle(-11, 0, 176), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, active = false },
	["laser"] = { type = "Model", model = "models/sw_battlefront/props/flashlight/flashlight.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(11, -1.101, -4.676), angle = Angle(-12, 0, -180), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, active = false },
	["laser_beam"] = { type = "Model", model = "models/tfa/lbeam.mdl", bone = "", rel = "laser", pos = Vector(2.5, 0, 0), angle = Angle(0, 0, 0), size = Vector(1.6, 1.6, 1.6), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, active = false  },
}

SWEP.Attachments = {
	[1] = { offset = { 0, 0 }, atts = { "e11_scope"}, order = 1},
	[2] = { offset = { 0, 0 }, atts = { "blue_ammo"}, order = 2 },
	[3] = { offset = { 0, 0 }, atts = { "e11suppressor"}, order = 3 },
	[4] = { offset = { 0, 0 }, atts = { "flashlight","e11s_laser_off","e11s_laser_on"}, order = 4 },
	[5] = { offset = { 0, 0 }, atts = { "stock1","e11bstock" }, order = 5 },
	[6] = { offset = { 0, 0 }, atts = { "grip1","e11rgrip"}, order = 6 },
	[7] = { offset = { 0, 0 }, atts = { "powerpack"}, order = 7 },
}

SWEP.ThirdPersonReloadDisable		=false
SWEP.Primary.DamageType 			= DMG_BULLET
SWEP.DamageType 					= DMG_BULLET
SWEP.RTScopeAttachment				= -1
SWEP.Scoped_3D 						= false
SWEP.ScopeReticule 					= "#sw/visor/sw_ret_redux_red"
SWEP.Secondary.ScopeZoom 			= 7.5
SWEP.ScopeReticule_Scale 			= {1,1}

SWEP.RTScopeAttachment				= -1
SWEP.Scoped_3D 						= false
SWEP.ScopeReticule 					= "scope/cs574/e11_ven_red"
SWEP.Secondary.ScopeZoom 			= 2
SWEP.ScopeReticule_Scale 			= {1,1}
SWEP.IronSightsSensitivity 			= 0.25
SWEP.AttachmentDependencies = {["scope_beta"] = {"scope_beta_rt"}}

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
