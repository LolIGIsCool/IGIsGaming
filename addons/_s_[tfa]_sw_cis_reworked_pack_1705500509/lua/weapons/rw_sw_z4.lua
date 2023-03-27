SWEP.Gun							= ("gun_base")
if (GetConVar(SWEP.Gun.."_allowed")) != nil then
	if not (GetConVar(SWEP.Gun.."_allowed"):GetBool()) then SWEP.Base = "tfa_blacklisted" SWEP.PrintName = SWEP.Gun return end
end
SWEP.Base							= "tfa_gun_base"
SWEP.Category						= "TFA StarWars CIS"
SWEP.Manufacturer 					= ""
SWEP.Author							= "ChanceSphere574"
SWEP.Contact						= ""
SWEP.Spawnable						= true
SWEP.AdminSpawnable					= true
SWEP.DrawCrosshair					= true
SWEP.DrawCrosshairIS 				= false
SWEP.PrintName						= "Z-4"
SWEP.Type							= "CIS Rotary Canon Blaster"
SWEP.DrawAmmo						= true
SWEP.data 							= {}
SWEP.data.ironsights				= 0
SWEP.Secondary.IronFOV				= 75
SWEP.Slot							= 4
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

SWEP.Primary.ClipSize				= 150
SWEP.Primary.DefaultClip			= 180*5
SWEP.Primary.RPM 					= 380/5
--SWEP.Primary.RPM_max                = 380
SWEP.Primary.RPM_MAX				= 380
SWEP.Primary.RPM_Burst				= 380
SWEP.Primary.Ammo					= "heavy_battery"
SWEP.Primary.AmmoConsumption 		= 1
SWEP.Primary.Range 					= 40000
SWEP.Primary.RangeFalloff 			= 40000
SWEP.Primary.NumShots				= 1
SWEP.Primary.Automatic				= true
SWEP.Primary.RPM_Semi				= 4
SWEP.Primary.BurstDelay				= 0.2
SWEP.Primary.Sound 					= Sound ("w/z4.wav");
SWEP.Primary.ReloadSound 			= Sound ("w/heavy.wav");
SWEP.Primary.PenetrationMultiplier 	= 0
SWEP.Primary.Damage					= 37
SWEP.Primary.HullSize 				= 0
SWEP.DamageType 					= nil

SWEP.DoMuzzleFlash 					= false

SWEP.FireModes = {
	"Automatic",
}


SWEP.IronRecoilMultiplier			= 0.65
SWEP.CrouchRecoilMultiplier			= 0.85
SWEP.JumpRecoilMultiplier			= 2
SWEP.WallRecoilMultiplier			= 1.1
SWEP.ChangeStateRecoilMultiplier	= 1.2
SWEP.CrouchAccuracyMultiplier		= 0.8
SWEP.ChangeStateAccuracyMultiplier	= 1
SWEP.JumpAccuracyMultiplier			= 2.5
SWEP.WalkAccuracyMultiplier			= 1.8
SWEP.NearWallTime 					= 0.5
SWEP.ToCrouchTime 					= 0.25
SWEP.WeaponLength 					= 35
SWEP.SprintFOVOffset 				= 12
SWEP.ProjectileVelocity 			= 9

SWEP.ProjectileEntity 				= nil
SWEP.ProjectileModel 				= nil

SWEP.ViewModel						= "models/weapons/synbf3/c_t21.mdl"
SWEP.WorldModel						= "models/weapons/synbf3/w_t21.mdl"
SWEP.ViewModelFOV					= 75
SWEP.ViewModelFlip					= false
SWEP.MaterialTable 					= nil
SWEP.UseHands 						= false
SWEP.HoldType 						= "crossbow"
SWEP.ReloadHoldTypeOverride 		= "crossbow"

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

SWEP.VMPos = Vector(5, -18, -8)
SWEP.VMAng = Vector(0, 0, 0)

SWEP.IronSightTime 					= 0.45
SWEP.Primary.KickUp					= 0.35
SWEP.Primary.KickDown				= 0.08
SWEP.Primary.KickHorizontal			= 0.035
SWEP.Primary.StaticRecoilFactor 	= 0.6
SWEP.Primary.Spread					= 0.05
SWEP.Primary.IronAccuracy 			= 0.02
SWEP.Primary.SpreadMultiplierMax 	= 1.5
SWEP.Primary.SpreadIncrement 		= 0.35
SWEP.Primary.SpreadRecovery 		= 0.98
SWEP.DisableChambering 				= true
SWEP.MoveSpeed 						= 0.8
SWEP.IronSightsMoveSpeed 			= 0.6

SWEP.IronSightsPos = Vector(0, -6, 0)
SWEP.IronSightsAng = Vector(0, 0, 0)
SWEP.RunSightsPos = Vector(5.226, -2, 0)
SWEP.RunSightsAng = Vector(-18, 36, -13.5)
SWEP.InspectPos = Vector(8, -4.8, -3)
SWEP.InspectAng = Vector(11.199, 38, 0)

SWEP.ViewModelBoneMods = {
	["v_t21_reference001"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) }
}

SWEP.VElements = {
	["z6"] = { type = "Model", model = "models/sw_battlefront/weapons/z6_rotary_cannon.mdl", bone = "v_t21_reference001", rel = "", pos = Vector(0.75, 0, 1), angle = Angle(0, -90, 0), size = Vector(1.2, 1.2, 1.2), color = Color(80, 80, 80, 255), surpresslightning = false, material = "models/sw_battlefront/weapons/z6rc/t_z6rotary_skin_cs", skin = 0, bodygroup = {} }
}	

SWEP.WElements = {
	["z6"] = { type = "Model", model = "models/sw_battlefront/weapons/z6_rotary_cannon.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(4, 1, 1), angle = Angle(-6, 0, 180), size = Vector(1, 1, 1), color = Color(80, 80, 80, 255), surpresslightning = false, material = "models/sw_battlefront/weapons/z6rc/t_z6rotary_skin_cs", skin = 0, bodygroup = {} }
}

SWEP.ProceduralHolsterPos = Vector(0,-25,0)
SWEP.ProceduralHolsterAng = Vector(75,-45,0)
SWEP.DoProceduralReload = true
SWEP.ProceduralReloadTime = 3.2

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

function SWEP:Initialize(...)
    self.StatCache_Blacklist["Primary.RPM"] = true
    return BaseClass.Initialize(self, ...)
end

function SWEP:PrePrimaryAttack(...)
    if self.Owner:KeyDown(IN_ATTACK) then
		self.Primary_TFA.RPM = math.Approach(self.Primary_TFA.RPM, self.Primary.RPM_MAX, 30)
    end
    return BaseClass.PrePrimaryAttack(self, ...)
end

function SWEP:Think(...)
	if self.Owner:KeyReleased(IN_ATTACK) then
		self.Primary_TFA.RPM = 300
		self:ClearStatCache("Primary.RPM")
	end
	return BaseClass.Think(self, ...)
end