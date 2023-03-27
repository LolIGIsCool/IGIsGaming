SWEP.Gun							= ("gun_base")
if (GetConVar(SWEP.Gun.."_allowed")) != nil then
	if not (GetConVar(SWEP.Gun.."_allowed"):GetBool()) then SWEP.Base = "tfa_blacklisted" SWEP.PrintName = SWEP.Gun return end
end
SWEP.Base							= "tfa_swsft_base"
SWEP.Category						= "TFA StarWars Reworked Galactic"
SWEP.Manufacturer 					= ""
SWEP.Author							= "ChanceSphere574"
SWEP.Contact						= ""
SWEP.Spawnable						= false
SWEP.AdminSpawnable					= true
SWEP.DrawCrosshair					= true
SWEP.DrawCrosshairIS 				= false
SWEP.PrintName						= "ARC Hand-Blaster"
SWEP.Type							= "Republic ARC Hand-Blaster"
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
SWEP.DefaultFireMode 				= "single"
SWEP.FireModeName 					= nil
SWEP.DisableChambering 				= true

SWEP.Primary.ClipSize				= 10
SWEP.Primary.DefaultClip			= 10
SWEP.Primary.RPM					= 350
SWEP.Primary.RPM_Burst				= 350
SWEP.Primary.Ammo					= "battery"
SWEP.Primary.AmmoConsumption 		= 1
SWEP.Primary.Range 					= 32000
SWEP.Primary.RangeFalloff 			= -1
SWEP.Primary.NumShots				= 1
SWEP.Primary.Automatic				= true
SWEP.Primary.RPM_Semi				= nil
SWEP.Primary.BurstDelay				= 0.2
SWEP.Primary.Sound 					= Sound ("w/ee3.wav");
SWEP.Primary.ReloadSound 			= nil
SWEP.Primary.PenetrationMultiplier 	= 0
SWEP.Primary.Damage					= 24
SWEP.Primary.HullSize 				= 0
SWEP.DamageType 					= nil

SWEP.FireModes = {
	"Auto"
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
SWEP.UseHands 						= false
SWEP.HoldType 						= "pistol"

SWEP.ShowWorldModel = false

SWEP.BlowbackEnabled 				= true
SWEP.BlowbackVector 				= Vector(0,-2.5,-0.05)
SWEP.BlowbackCurrentRoot			= 0
SWEP.BlowbackCurrent 				= 0
SWEP.BlowbackBoneMods 				= nil
SWEP.Blowback_Only_Iron 			= true
SWEP.Blowback_PistolMode 			= false
SWEP.Blowback_Shell_Enabled 		= false
SWEP.Blowback_Shell_Effect 			= "None"

SWEP.Tracer							= 0
SWEP.TracerName 					= "rw_sw_laser_blue"
SWEP.TracerCount 					= 1
SWEP.TracerLua 						= false
SWEP.TracerDelay					= 0.01
SWEP.ImpactEffect 					= "rw_sw_impact_blue"
SWEP.ImpactDecal 					= "FadingScorch"

SWEP.VMPos = Vector(1.96, -2.814, -0.52)
SWEP.VMAng = Vector(0,0,0)

SWEP.IronSightTime 					= 0.6
SWEP.Primary.KickUp					= 0.35
SWEP.Primary.KickDown				= 0.15
SWEP.Primary.KickHorizontal			= 0.055
SWEP.Primary.StaticRecoilFactor 	= 0.5
SWEP.Primary.Spread					= 0.025
SWEP.Primary.IronAccuracy 			= 0.005
SWEP.Primary.SpreadMultiplierMax 	= 0.6
SWEP.Primary.SpreadIncrement 		= 0.3
SWEP.Primary.SpreadRecovery 		= 0.98
SWEP.DisableChambering 				= true
SWEP.MoveSpeed 						= 1
SWEP.IronSightsMoveSpeed 			= 0.8

SWEP.IronSightsPos = Vector(-5.9, -8, 1.8)
SWEP.IronSightsAng = Vector(0, 0, 0)
SWEP.RunSightsPos = Vector(5.226, -2, 1.5)
SWEP.RunSightsAng = Vector(-17.20, 13.50, -13.367)
SWEP.InspectPos = Vector(0, 0, 0)
SWEP.InspectAng = Vector(0, 0, 0)

SWEP.ViewModelBoneMods = {
	["v_scoutblaster_reference001"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, -10), angle = Angle(0, 0, 0) }
}

SWEP.VElements = {
	["b2rph"] = { type = "Model", model = "models/hunter/misc/roundthing4.mdl", bone = "v_scoutblaster_reference001", rel = "", pos = Vector(2.5, -6, 5), angle = Angle(90, 0, 0), size = Vector(0.12, 0.12, 0.12), color = Color(75, 75, 75, 255), surpresslightning = false, material = "models/debug/debugwhite", skin = 0, bodygroup = {} },
	["b2rpb"] = { type = "Model", model = "models/hunter/triangles/trapezium3x3x1c.mdl", bone = "v_scoutblaster_reference001", rel = "b2rph", pos = Vector(3, 6, 2.85), angle = Angle(0, -90, -90), size = Vector(0.12, 0.12, 0.12), color = Color(75, 75, 75, 255), surpresslightning = false, material = "models/debug/debugwhite", skin = 0, bodygroup = {} },
	["b2rpb1"] = { type = "Model", model = "models/mechanics/robotics/a4.mdl", bone = "v_scoutblaster_reference001", rel = "b2rph", pos = Vector(4, 4, 4.5), angle = Angle(0, 90, 0), size = Vector(0.12, 0.12, 0.12), color = Color(50, 50, 50, 255), surpresslightning = false, material = "models/debug/debugwhite", skin = 0, bodygroup = {} },
	["b2rpb2"] = { type = "Model", model = "models/mechanics/robotics/a4.mdl", bone = "v_scoutblaster_reference001", rel = "b2rph", pos = Vector(4, 4, 1), angle = Angle(0, 90, 0), size = Vector(0.12, 0.12, 0.12), color = Color(50, 50, 50, 255), surpresslightning = false, material = "models/debug/debugwhite", skin = 0, bodygroup = {} },
}

SWEP.WElements = {
	["b2rp"] = { type = "Model", model = "models/hunter/plates/plate.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(7.9, 1, 1), angle = Angle(-8, 0, 180), size = Vector(0.1, 0.1, 0.1), color = Color(255, 255, 255, 0), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

local MaxTimer				= 50
local CurrentTimer			= 0

function SWEP:Think()
	if (self.Weapon:Clip1() == 0) and SERVER then
		if (CurrentTimer == 50) then 
			CurrentTimer = 0
			self.Weapon:SetClip1( self.Weapon:Clip1() + 10 )
		else
			CurrentTimer = CurrentTimer + 1
		end
	end
end

SWEP.ThirdPersonReloadDisable		=false
SWEP.Primary.DamageType 			= DMG_BULLET
SWEP.DamageType 					= DMG_BULLET
SWEP.RTScopeAttachment				= -1
SWEP.Scoped_3D 						= false
SWEP.ScopeReticule 					= "scope/gdcw_elcanreticle" 
SWEP.Secondary.ScopeZoom 			= 4
SWEP.ScopeReticule_Scale 			= {1.09,1.09}
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