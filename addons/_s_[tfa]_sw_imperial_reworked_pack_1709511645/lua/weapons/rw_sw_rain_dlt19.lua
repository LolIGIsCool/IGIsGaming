SWEP.Gun							= ("gun_base")
if (GetConVar(SWEP.Gun.."_allowed")) != nil then
	if not (GetConVar(SWEP.Gun.."_allowed"):GetBool()) then SWEP.Base = "tfa_blacklisted" SWEP.PrintName = SWEP.Gun return end
end
SWEP.Base							= "tfa_gun_base"
SWEP.Category						= "TFA StarWars Reworked Imperial"
SWEP.Manufacturer 					= ""
SWEP.Author							= "ChanceSphere574"
SWEP.Contact						= ""
SWEP.Spawnable						= false
SWEP.AdminSpawnable					= true
SWEP.DrawCrosshair					= true
SWEP.DrawCrosshairIS 				= false
SWEP.PrintName						= "DLT-19s [Rainbow]"
SWEP.Type							= "Imperial Smoll Blaster Rifle"
SWEP.DrawAmmo						= true
SWEP.data 							= {}
SWEP.data.ironsights				= 1
SWEP.Secondary.IronFOV				= 75
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
SWEP.DefaultFireMode 				= "Automatic"
SWEP.FireModeName 					= nil
SWEP.DisableChambering 				= true

SWEP.Primary.ClipSize				= 40
SWEP.Primary.DefaultClip			= 50*4
SWEP.Primary.RPM					= 600
SWEP.Primary.RPM_Burst				= 600
SWEP.Primary.Ammo					= "standard_battery"
SWEP.Primary.AmmoConsumption 		= 1
SWEP.Primary.Range 					= 40000
SWEP.Primary.RangeFalloff 			= -1
SWEP.Primary.NumShots				= 1
SWEP.Primary.Automatic				= true
SWEP.Primary.RPM_Semi				= 600
SWEP.Primary.BurstDelay				= 0.2
SWEP.Primary.Sound 					= Sound ("w/dlt19.wav");
SWEP.Primary.ReloadSound 			= Sound ("w/heavy.wav");
SWEP.Primary.PenetrationMultiplier 	= 0
SWEP.Primary.Damage					= 25.0
SWEP.Primary.HullSize 				= 0
SWEP.DamageType 					= nil

SWEP.DoMuzzleFlash 					= false

SWEP.FireModes = {
	"Automatic",
	"Single"
}


SWEP.IronRecoilMultiplier			= 0.65
SWEP.CrouchRecoilMultiplier			= 0.85
SWEP.JumpRecoilMultiplier			= 2
SWEP.WallRecoilMultiplier			= 1.1
SWEP.ChangeStateRecoilMultiplier	= 1.2
SWEP.CrouchAccuracyMultiplier		= 0.8
SWEP.ChangeStateAccuracyMultiplier	= 1
SWEP.JumpAccuracyMultiplier			= 2.6
SWEP.WalkAccuracyMultiplier			= 1.8
SWEP.NearWallTime 					= 0.5
SWEP.ToCrouchTime 					= 0.25
SWEP.WeaponLength 					= 35
SWEP.SprintFOVOffset 				= 12
SWEP.ProjectileVelocity 			= 9

SWEP.ProjectileEntity 				= nil
SWEP.ProjectileModel 				= nil

SWEP.ViewModel						= "models/weapons/synbf3/c_e11.mdl"
SWEP.WorldModel						= "models/weapons/synbf3/w_e11.mdl"
SWEP.ViewModelFOV					= 75
SWEP.ViewModelFlip					= false
SWEP.MaterialTable 					= nil
SWEP.UseHands 						= true
SWEP.HoldType 						= "ar2"
SWEP.ReloadHoldTypeOverride 		= "ar2"

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
SWEP.TracerName 					= "rw_sw_laser_purple"
SWEP.TracerCount 					= 1
SWEP.TracerLua 						= false
SWEP.TracerDelay					= 0.01
SWEP.ImpactEffect 					= "rw_sw_impact_purple"
SWEP.ImpactDecal 					= "FadingScorch"

SWEP.VMPos = Vector(2.165, -2, -0.35)
SWEP.VMAng = Vector(0.5, 0, 0)

SWEP.IronSightTime 					= 0.3
SWEP.Primary.KickUp					= 0.6
SWEP.Primary.KickDown				= 0.06
SWEP.Primary.KickHorizontal			= 0.045
SWEP.Primary.StaticRecoilFactor 	= 0.60
SWEP.Primary.Spread					= 0.08
SWEP.Primary.IronAccuracy 			= 0.05
SWEP.Primary.SpreadMultiplierMax 	= 1.50
SWEP.Primary.SpreadIncrement 		= 0.35
SWEP.Primary.SpreadRecovery 		= 0.98
SWEP.DisableChambering 				= true
SWEP.MoveSpeed 						= 1
SWEP.IronSightsMoveSpeed 			= 0.90

SWEP.IronSightsPos = Vector(-5.1, -5, 3.8)
SWEP.IronSightsAng = Vector(1, 0, 0)
SWEP.RunSightsPos = Vector(5.226, -2, 0)
SWEP.RunSightsAng = Vector(-18, 36, -13.5)
SWEP.InspectPos = Vector(8, -4.8, -3)
SWEP.InspectAng = Vector(11.199, 38, 0)

--local count = 0
--local tracertable = {"rw_sw_laser_red","rw_sw_laser_orange","rw_sw_laser_green","rw_sw_laser_blue","rw_sw_laser_purple", "rw_sw_laser_white",}
--local impacttable = {"rw_sw_impact_red","rw_sw_impact_orange","rw_sw_impact_green","rw_sw_impact_blue","rw_sw_impact_purple", "rw_sw_impact_white",}
--function SWEP:Think()
--	if count == 7 then
--		count = 1
--	end
--	self.TracerName = tracertable[count]
--	self.ImpactEffect = impacttable[count]
--	count = count + 1	
--end

SWEP.ViewModelBoneMods = {
	["v_e11_reference001"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) }
}

SWEP.VElements = {
	["dlt19"] = { type = "Model", model = "models/sw_battlefront/weapons/dlt19_heavy_rifle_ext.mdl", bone = "v_e11_reference001", rel = "", pos = Vector(-01, -01, -01), angle = Angle(0, -90, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/rainbow/hull_gay", skin = 0, bodygroup = {[1]=2,[2]=2,[3]=0,[4]=0,[5]=0,[6]=2} },
	["muz"] = { type = "Model", model = "models/sw_battlefront/weapons/2019/dlt19_heavyrifle_muzzle1.mdl", bone = "", rel = "dlt19", pos = Vector(-21.5, 0, 0), angle = Angle(0, 0, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/rainbow/hull_gay", skin = 0, bodygroup = {} },
}	

SWEP.WElements = {
	["dlt19"] = { type = "Model", model = "models/sw_battlefront/weapons/dlt19_heavy_rifle_ext.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3, 0.75, -0.5), angle = Angle(-13, 0, 180), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/rainbow/hull_gay", skin = 0, bodygroup = {[1]=2,[2]=2,[3]=0,[4]=0,[5]=0,[6]=2} },
	["muz"] = { type = "Model", model = "models/sw_battlefront/weapons/2019/dlt19_heavyrifle_muzzle1.mdl", bone = "", rel = "dlt19", pos = Vector(-21.5, 0, 0), angle = Angle(0, 0, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/rainbow/hull_gay", skin = 0, bodygroup = {} },
}

SWEP.ThirdPersonReloadDisable		=false
SWEP.Primary.DamageType 			= DMG_BULLET
SWEP.DamageType 					= DMG_BULLET
SWEP.RTScopeAttachment				= -1
SWEP.Scoped_3D 						= false
SWEP.ScopeReticule 					= "scope/gdcw_elcanreticle" 
SWEP.Secondary.ScopeZoom 			= 3
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