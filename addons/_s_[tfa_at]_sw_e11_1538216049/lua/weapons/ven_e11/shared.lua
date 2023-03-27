SWEP.Gun							= ("ven_e11")
if (GetConVar(SWEP.Gun.."_allowed")) != nil then
	if not (GetConVar(SWEP.Gun.."_allowed"):GetBool()) then SWEP.Base = "tfa_blacklisted" SWEP.PrintName = SWEP.Gun return end
end
SWEP.Base							= "tfa_gun_base"
SWEP.Category						= "TFA Star Wars In-Development"
SWEP.Manufacturer 					= "BlasTech Industries"
SWEP.Author							= "Servius(code), Venator(model), ChanceSphere574(atts,code)"
SWEP.Contact						= ""
SWEP.Spawnable						= true
SWEP.AdminSpawnable					= true
SWEP.DrawCrosshair					= true
SWEP.DrawCrosshairIS 				= false
SWEP.PrintName						= "E-11 [Standard]"
SWEP.Type							= "Imperial Blaster Carbine"
SWEP.DrawAmmo						= true
SWEP.data 							= {}
SWEP.data.ironsights				= 1
SWEP.Secondary.IronFOV				= 78
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

SWEP.Primary.ClipSize				= 30
SWEP.Primary.DefaultClip			= 150
SWEP.Primary.RPM					= 260
SWEP.Primary.RPM_Burst				= 260
SWEP.Primary.Ammo					= "standard_battery"
SWEP.Primary.AmmoConsumption 		= 1
--SWEP.Primary.Range 					= 52500/10*3
--SWEP.Primary.RangeFalloff 			= -1
--SWEP.Primary.RangeFalloffLUT = {
--    bezier = false, -- Whenever to use Bezier or not to interpolate points?
--    range_func = "quintic", -- function to spline range
    -- "linear" for linear splining.
    -- Possible values are "quintic", "cubic", "cosine", "sinusine", "linear" or your own function
--    units = "meters", -- possible values are "inches", "inch", "hammer", "hu" (are all equal)
    -- everything else is considered to be meters
--    lut = { -- providing zero point is not required
        -- without zero point it is considered to be as {range = 0, damage = 1}
--        {range = 30, damage = 1},
--        {range = 40, damage = 0.6},
--        {range = 80, damage = 0.1},
--    }
--}
SWEP.Primary.NumShots				= 1
SWEP.Primary.Automatic				= true
SWEP.Primary.RPM_Semi				= nil
SWEP.Primary.BurstDelay				= 0.1
SWEP.Primary.Sound 					= Sound ("Weapon_E11_OG.Single");
SWEP.Primary.ReloadSound 			= Sound ("Weapon_vene11reload.Single");
SWEP.Primary.PenetrationMultiplier 	= 0
SWEP.Primary.Damage					= 35
SWEP.Primary.HullSize 				= 0
SWEP.DamageType 					= nil

SWEP.DoMuzzleFlash 					= true
SWEP.CustomMuzzleFlash 				= true
SWEP.MuzzleFlashEffect 				= "rw_sw_muzzleflash_red"

SWEP.FireModes = {
	"Automatic",
	"Single",
}

SWEP.IronRecoilMultiplier			= 0.65
SWEP.CrouchRecoilMultiplier			= 0.85
SWEP.JumpRecoilMultiplier			= 2
SWEP.WallRecoilMultiplier			= 1.1
SWEP.ChangeStateRecoilMultiplier	= 1.2
SWEP.CrouchAccuracyMultiplier		= 0.8
SWEP.ChangeStateAccuracyMultiplier	= 1
SWEP.JumpAccuracyMultiplier			= 10
SWEP.WalkAccuracyMultiplier			= 1.8
SWEP.NearWallTime 					= 0.5
SWEP.ToCrouchTime 					= 0.25
SWEP.WeaponLength 					= 35
SWEP.SprintFOVOffset 				= 12
SWEP.ProjectileVelocity 			= 9

SWEP.ProjectileEntity 				= nil
SWEP.ProjectileModel 				= nil

SWEP.ViewModel = "models/ven/sw_battlefront/weapons/bf2017/v_e11.mdl"
SWEP.WorldModel = "models/bf2017/ven/w_e11.mdl"
SWEP.ViewModelFOV = 70
SWEP.ViewModelFlip					= false
SWEP.MaterialTable 					= nil
SWEP.UseHands 						= true
SWEP.HoldType 						= "ar2"

SWEP.ShowViewModel = true
SWEP.ShowWorldModel = true

SWEP.BlowbackEnabled 				= true
SWEP.BlowbackVector 				= Vector(0,-1,0)
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

SWEP.VMPos = Vector(0.5, -2, 0.5)
SWEP.VMAng = Vector(0,0,0)

SWEP.IronSightTime 					= 0.3
SWEP.Primary.KickUp					= 0.45
SWEP.Primary.KickDown				= 0.08
SWEP.Primary.KickHorizontal			= 0.055
SWEP.Primary.StaticRecoilFactor 	= 0.6
SWEP.Primary.Spread					= 0.02
SWEP.Primary.IronAccuracy 			= 0.005
SWEP.Primary.SpreadMultiplierMax 	= 0.4
SWEP.Primary.SpreadIncrement 		= 0.35
SWEP.Primary.SpreadRecovery 		= 0.98
SWEP.DisableChambering 				= true
SWEP.MoveSpeed 						= 1
SWEP.IronSightsMoveSpeed 			= 0.85

SWEP.IronSightsPos = Vector(-3.875, -7, 1.83)
SWEP.IronSightsAng = Vector(0, 0, 0)
SWEP.RunSightsPos = Vector(4, -2, 1.5)
SWEP.RunSightsAng = Vector(-28, 42, -25)
SWEP.InspectPos = Vector(8, -4.8, -3)
SWEP.InspectAng = Vector(11.199, 38, 0)


SWEP.WorldModelBoneMods = {
	["ATTACH_Muzzle"] = { scale = Vector(0.5, 0.5, 0.5), pos = Vector(7.025, 0.075, 2.475), angle = Angle(0, 0, 0) },
}


SWEP.VElements = {
	["scope_beta"] = { type = "Model", model = "models/sw_battlefront/props/e11_scope/e11_scope.mdl", bone = "E11_GUN", rel = "", pos = Vector(0.1, -3.1, 3.4), angle = Angle(0, -90, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, bonermerge = true, active = false},
	["scope_beta_rt"] = { type = "Model", model = "models/rtcircle.mdl", bone = "E11_GUN", rel = "scope_beta", pos = Vector(-3.0, -0.06, 0.225), angle = Angle(180, 0, 180), size = Vector(0.32, 0.32, 0.32), color = Color(255, 255, 255, 255), surpresslightning = false, material = "!tfa_rtmaterial", skin = 0, bodygroup = {}, bonermerge = true, active = false },
	["flashlight"] = { type = "Model", model = "models/sw_battlefront/props/flashlight/flashlight.mdl", bone = "E11_GUN", rel = "", pos = Vector(-1.9, 5.4, 1), angle = Angle(0, -90, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, active = false },
	["e11bstock"] = { type = "Model", model = "models/sw_battlefront/props/e11b_stock/e11b_stock.mdl", bone = "E11_GUN", rel = "", pos = Vector(0.159, -13, -0.931), angle = Angle(6, -90, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, active = false },
	["ironsight"] = { type = "Model", model = "models/sw_battlefront/props/e11r_scope/e11r_scope.mdl", bone = "E11_GUN", rel = "", pos = Vector(0.13, -3, 2.93), angle = Angle(0, .5, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, active = false },
	["powerprongs"] = { type = "Model", model = "models/sw_battlefront/props/powerprongs/power_prongs.mdl", bone = "E11_GUN", rel = "powerpack", pos = Vector(0, 1, -0.301), angle = Angle(0, -90, 0), size = Vector(0.8, 0.8, 0.8), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, active = false },
	["powerpack"] = { type = "Model", model = "models/sw_battlefront/props/powerpack/power_pack.mdl", bone = "E11_GUN", rel = "", pos = Vector(1.659, -1, 2.299), angle = Angle(0, 0, 0), size = Vector(0.8, 0.8, 0.8), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, active = false },
	["e11rgrip"] = { type = "Model", model = "models/sw_battlefront/props/e11r_grip/e11r_grip.mdl", bone = "E11_GUN", rel = "", pos = Vector(0.17, -2.5, 0.27), angle = Angle(0, 0, 2), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, active = false },
	["grip1"] = { type = "Model", model = "models/sw_battlefront/props/e11_grip/e11_grip.mdl", bone = "E11_GUN", rel = "", pos = Vector(0.15, 0.8, 0.3), angle = Angle(0, 0, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, active = false },
	["stock1"] = { type = "Model", model = "models/sw_battlefront/props/e11r_stock/e11r_stock.mdl", bone = "E11_GUN", rel = "", pos = Vector(0.129, -13.141, 0.699), angle = Angle(0, 0, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, active = false },
	["e11supp"] = { type = "Model", model = "models/sw_battlefront/props/e11_suppressor/e11_suppressor.mdl", bone = "E11_GUN", rel = "", pos = Vector(0, 011.45, 01.12), angle = Angle(0, -90, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, active = false },
	["laser"] = { type = "Model", model = "models/sw_battlefront/props/flashlight/flashlight.mdl", bone = "E11_GUN", rel = "", pos = Vector(-1.9, 5.4, 1), angle = Angle(0, -90, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, active = false },
	["laser_beam"] = { type = "Model", model = "models/tfa/lbeam.mdl", bone = "", rel = "laser", pos = Vector(2.5, 0, 0), angle = Angle(0, 0, 0), size = Vector(1.6, 1.6, 1.6), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, active = false  },
}

SWEP.WElements = {
	["scope"] = { type = "Model", model = "models/sw_battlefront/props/e11_scope/e11_scope.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(2.299, 1.379, -5.301), angle = Angle(-11, 0, 176), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, active = false },
	["flashlight"] = { type = "Model", model = "models/sw_battlefront/props/flashlight/flashlight.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(11, -1.101, -4.676), angle = Angle(-12, 0, -180), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, active = false },
	["powerpack"] = { type = "Model", model = "models/sw_battlefront/props/powerpack/power_pack.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(5.599, 2.9, -4.7), angle = Angle(180, 90, -10.52), size = Vector(0.899, 0.899, 0.899), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, active = false },
	["e11_grip"] = { type = "Model", model = "models/sw_battlefront/props/e11_grip/e11_grip.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(6.75, 1.2, -3), angle = Angle(180, 92, -10), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, active = false },
	["powerprongs"] = { type = "Model", model = "models/sw_battlefront/props/powerprongs/power_prongs.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "powerpack", pos = Vector(0, 0.5, -0.331), angle = Angle(0, -90, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, active = false },
	["e11b_stock"] = { type = "Model", model = "models/sw_battlefront/props/e11b_stock/e11b_stock.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(-5.901, 1.7, -1), angle = Angle(-7, 3, 180), size = Vector(0.899, 1, 0.899), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, active = false },
	["e11r_stock"] = { type = "Model", model = "models/sw_battlefront/props/e11r_stock/e11r_stock.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(-6.801, 1.5, -1), angle = Angle(180, 90, -8.183), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, active = false },
	["ironsight"] = { type = "Model", model = "models/sw_battlefront/props/e11r_scope/e11r_scope.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3, 1.5, -4.801), angle = Angle(0, -90, 169.481), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, active = false },
	["e11r_grip"] = { type = "Model", model = "models/sw_battlefront/props/e11r_grip/e11r_grip.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "e11_grip", pos = Vector(0, -3.27, 0), angle = Angle(0, 0, 1), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, active = false },
    ["e11supp"] = { type = "Model", model = "models/sw_battlefront/props/e11_suppressor/e11_suppressor.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(17.5, 0.89, -5.9), angle = Angle(-09, 0, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, active = false },
	["laser"] = { type = "Model", model = "models/sw_battlefront/props/flashlight/flashlight.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(11, -1.101, -4.676), angle = Angle(-12, 0, -180), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, active = false },
	["laser_beam"] = { type = "Model", model = "models/tfa/lbeam.mdl", bone = "", rel = "laser", pos = Vector(2.5, 0, 0), angle = Angle(0, 0, 0), size = Vector(1.6, 1.6, 1.6), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, active = false  },
}

SWEP.Attachments = {
	[1] = { offset = { 0, 0 }, atts = { "e11_scope", "ironsight" }, order = 1, sel = 2 },
	[2] = { offset = { 0, 0 }, atts = { "blue_ammo"}, order = 2 },
	[3] = { offset = { 0, 0 }, atts = { "e11suppressor"}, order = 3 },
	[4] = { offset = { 0, 0 }, atts = { "flashlight","e11s_laser_off","e11s_laser_on"}, order = 4 },
	--[5] = { offset = { 0, 0 }, atts = { "stock1","e11bstock" }, order = 5 },
	--[6] = { offset = { 0, 0 }, atts = { "grip1","e11rgrip"}, order = 6 },
	[7] = { offset = { 0, 0 }, atts = { "powerpack"}, order = 7 },
    [8] = { offset = { 0, 0 }, atts = { "sound"}, order = 8 },
}

SWEP.AttachmentExclusions = {
	["e11bstock"] = { [6] = "grip1" },
	["grip1"] = { [5] = "e11bstock"},
}

SWEP.Scope1Pos = Vector(-3.828, -9, 1.183)
SWEP.Scope1Ang = Vector(0, 0, 0)

SWEP.RTScopeAttachment				= -1
SWEP.Scoped_3D 						= false
SWEP.ScopeReticule 					= "scope/cs574/e11_ven_red"
SWEP.Secondary.ScopeZoom 			= 2
SWEP.ScopeReticule_Scale 			= {1,1}
SWEP.IronSightsSensitivity 			= 0.25
SWEP.AttachmentDependencies = {["scope_beta"] = {"scope_beta_rt"}}

DEFINE_BASECLASS( SWEP.Base )
