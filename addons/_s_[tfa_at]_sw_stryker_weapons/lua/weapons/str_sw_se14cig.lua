SWEP.Gun							= ("gun_base")
if (GetConVar(SWEP.Gun.."_allowed")) != nil then
	if not (GetConVar(SWEP.Gun.."_allowed"):GetBool()) then SWEP.Base = "tfa_blacklisted" SWEP.PrintName = SWEP.Gun return end
end
SWEP.Base							= "str_sw_se14c_dark"
SWEP.Category						= "TFA StarWars Stryker"
SWEP.Manufacturer 					= ""
SWEP.Author							= "ChanceSphere574"
SWEP.Contact						= ""
SWEP.Spawnable						= true
SWEP.AdminSpawnable					= true
SWEP.DrawCrosshair					= true
SWEP.DrawCrosshairIS 				= false
SWEP.PrintName						= "SE-14c [IG]"
SWEP.Type							= "Imperial Blaster Pistol"
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

SWEP.DoProceduralReload = true
SWEP.ProceduralReloadTime = 2

SWEP.Primary.ClipSize				= 15
SWEP.Primary.DefaultClip			= 75
SWEP.Primary.RPM					= 200
SWEP.Primary.RPM_Burst				= 200
SWEP.Primary.Ammo					= "light_battery"
SWEP.Primary.AmmoConsumption 		= 1
SWEP.Primary.Range 					= 32000
SWEP.Primary.RangeFalloff 			= -1
SWEP.Primary.NumShots				= 1
SWEP.Primary.Automatic				= true
SWEP.Primary.RPM_Semi				= nil
SWEP.Primary.BurstDelay				= 0.2
SWEP.Primary.Sound 					= Sound ("w/se14c.wav");
SWEP.Primary.ReloadSound 			= Sound ("w/pistols.wav");
SWEP.Primary.PenetrationMultiplier 	= 0
SWEP.Primary.Damage					= 65
SWEP.Primary.HullSize 				= 0
SWEP.DamageType 					= nil

SWEP.FireModes = {
	"Auto",
	"Single"
}


SWEP.IronRecoilMultiplier			= 0.66
SWEP.CrouchRecoilMultiplier			= 0.55
SWEP.JumpRecoilMultiplier			= 1.3
SWEP.WallRecoilMultiplier			= 1.1
SWEP.ChangeStateRecoilMultiplier	= 1.3
SWEP.CrouchAccuracyMultiplier		= 0.7
SWEP.ChangeStateAccuracyMultiplier	= 1.18
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
SWEP.TracerName 					= "rw_sw_laser_yellow"
SWEP.TracerCount 					= 1
SWEP.TracerLua 						= false
SWEP.TracerDelay					= 0.01
SWEP.ImpactEffect 					= "rw_sw_impact_yellow"
SWEP.ImpactDecal 					= "FadingScorch"

SWEP.VMPos = Vector(1.248, -3.819, -0.168)
SWEP.VMAng = Vector(0,0,0)

SWEP.IronSightTime 					= 0.6
SWEP.Primary.KickUp					= 0.35
SWEP.Primary.KickDown				= 0.1
SWEP.Primary.KickHorizontal			= 0.055
SWEP.Primary.StaticRecoilFactor 	= 0.5
SWEP.Primary.Spread					= 0.025
SWEP.Primary.IronAccuracy 			= 0.01
SWEP.Primary.SpreadMultiplierMax 	= 0.6
SWEP.Primary.SpreadIncrement 		= 0.55
SWEP.Primary.SpreadRecovery 		= 0.80
SWEP.DisableChambering 				= true
SWEP.MoveSpeed 						= 1
SWEP.IronSightsMoveSpeed 			= 0.85

SWEP.IronSightsPos = Vector(-5.2, -4, 0.65)
SWEP.IronSightsAng = Vector(0, 0, 0)
SWEP.RunSightsPos = Vector(2, -9.5, -15)
SWEP.RunSightsAng = Vector(39, -0.5, -2)
SWEP.InspectPos = Vector(8, -4.8, -3)
SWEP.InspectAng = Vector(11.199, 38, 0)



SWEP.ViewModelBoneMods = {
	["v_scoutblaster_reference001"] = { scale = Vector(0.005, 0.005, 0.005), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) }
}

SWEP.VElements = {
    ["se14c"] = { type = "Model", model = "models/hauptmann/star wars/weapons/se14c.mdl", bone = "v_scoutblaster_reference001", rel = "", pos = Vector(0, 0, -4.5), angle = Angle(0, 90, 0), size = Vector(1.2, 1.2, 1.2), color = Color(150, 150, 150, 255), surpresslightning = false, material = "models/weapons/synbf3/w_models/se14c/t_se14c_c", skin = 0, bodygroup = {} },
	["scope1"] = { type = "Model", model = "models/rtcircle.mdl", bone = "", rel = "se14c", pos = Vector(-8.09+0.1, 0, 9.21+0.24), angle = Angle(0, 180, 0), size = Vector(0.22, 0.22, 0.22), color = Color(255, 255, 255, 255), surpresslightning = false, material = "!tfa_rtmaterial", skin = 0, bodygroup = {} },
	["scope2"] = { type = "Model", model = "models/rtcircle.mdl", bone = "", rel = "se14c", pos = Vector(-7.9+0.09, 1.72, 8.03+0.31), angle = Angle(0, 180, 0), size = Vector(0.22, 0.22, 0.22), color = Color(255, 255, 255, 255), surpresslightning = false, material = "!tfa_rtmaterial", skin = 0, bodygroup = {} },
	["flashlight"] = { type = "Model", model = "models/sw_battlefront/props/flashlight/flashlight.mdl", bone = "", rel = "se14c", pos = Vector(7, -1.6, 7.5), angle = Angle(0, 0, 180), size = Vector(1, 1, 1), color = Color(100, 100, 100, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["powerprongs"] = { type = "Model", model = "models/sw_battlefront/props/powerprongs/power_prongs.mdl", bone = "", rel = "se14c", pos = Vector(8, 0.2, 6.5), angle = Angle(0, -0, 0), size = Vector(1, 1, 1), color = Color(100, 100, 100, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["powerpack"] = { type = "Model", model = "models/sw_battlefront/props/powerpack/power_pack.mdl", bone = "", rel = "se14c", pos = Vector(4.2, -1.3, 8.2), angle = Angle(0, 90, 0), size = Vector(0.7, 0.9, 0.8), color = Color(80, 80, 80, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["power"] = { type = "Model", model = "models/hunter/blocks/cube025x025x025.mdl", bone = "", rel = "powerpack", pos = Vector(-0, -3.8, -0.15), angle = Angle(0, 90, 0), size = Vector(0.01, 0.02, 0.116), color = Color(255, 0, 0, 255), surpresslightning = false, material = "models/debug/debugwhite", skin = 0, bodygroup = {} },
}

SWEP.WElements = {
	["se14c"] = { type = "Model", model = "models/hauptmann/star wars/weapons/se14c.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(4, 1.5, 2.9), angle = Angle(-8, 0, 180), size = Vector(1, 1, 1), color = Color(150, 150, 150, 255), surpresslightning = false, material = "models/weapons/synbf3/w_models/se14c/t_se14c_c", skin = 0, bodygroup = {} },
	["flashlight"] = { type = "Model", model = "models/sw_battlefront/props/flashlight/flashlight.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(9, 2.601, -4.25), angle = Angle(-8, -0, 0), size = Vector(0.8, 0.8, 0.8), color = Color(100, 100, 100, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["light"] = { type = "Model", model = "models/hunter/tubes/circle2x2.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "flashlight", pos = Vector(1.95, 0, 0), angle = Angle(-9, 90, 90), size = Vector(0.008, 0.008, 0.008), color = Color(155, 0, 0, 255), surpresslightning = false, material = "models/debug/debugwhite", skin = 0, bodygroup = {} },
	["powerpack"] = { type = "Model", model = "models/sw_battlefront/props/powerpack/power_pack.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(6.8, 2.7, -4.4), angle = Angle(180, 90, -9), size = Vector(0.7, 0.7, 0.5), color = Color(100, 100, 100, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["powerprongs"] = { type = "Model", model = "models/sw_battlefront/props/powerprongs/power_prongs.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(9.92, 1.44, -3.5), angle = Angle(-9, 0, 180), size = Vector(1, 0.8, 0.8), color = Color(80, 80, 80, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["power"] = { type = "Model", model = "models/hunter/blocks/cube025x025x025.mdl", bone = "", rel = "powerpack", pos = Vector(-0, -2.95, -0.1), angle = Angle(0, 90, 0), size = Vector(0.01, 0.02, 0.075), color = Color(255, 0, 0, 255), surpresslightning = false, material = "models/debug/debugwhite", skin = 0, bodygroup = {} },
}
/*
function SWEP:Think()

	if( self.Weapon:Clip1() <= 10 ) then
		self.VElements["power"].color = Color(255, 0, 0, 255)
	end

	if( self.Weapon:Clip1() <= 8 ) then
		self.VElements["power"].color = Color(180, 0, 0, 255)
	end

	if( self.Weapon:Clip1() <= 6 ) then
		self.VElements["power"].color = Color(140, 0, 0, 255)
	end

	if( self.Weapon:Clip1() <= 4 ) then
		self.VElements["power"].color = Color(100, 0, 0, 255)
	end

	if( self.Weapon:Clip1() == 2 ) then
		self.VElements["power"].color = Color(60, 0, 0, 255)
	end

	if( self.Weapon:Clip1() == 0 ) then
		self.VElements["power"].color = Color(30, 0, 0, 255)
	end

end */

SWEP.ThirdPersonReloadDisable		= false
SWEP.Primary.DamageType 			= DMG_BULLET
SWEP.DamageType 					= DMG_BULLET
SWEP.RTScopeAttachment				= -1
SWEP.Scoped_3D 						= false
SWEP.ScopeReticule 					= "#sw/visor/sw_ret_redux_yellow"
SWEP.Secondary.ScopeZoom 			= 4
SWEP.ScopeReticule_Scale 			= {1.1,1.1}
if surface then
	SWEP.Secondary.ScopeTable =
		{
			scopetex = surface.GetTextureID("scope/gdcw_closedsight"),
			reticletex = surface.GetTextureID("scope/gdcw_acogchevron"),
			dottex = surface.GetTextureID("scope/gdcw_acogcross")
		}
end

DEFINE_BASECLASS( SWEP.Base )
