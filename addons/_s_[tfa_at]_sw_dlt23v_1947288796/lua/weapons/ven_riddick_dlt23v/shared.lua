SWEP.Gun							= ("ven_dlt23v")
if (GetConVar(SWEP.Gun.."_allowed")) != nil then
	if not (GetConVar(SWEP.Gun.."_allowed"):GetBool()) then SWEP.Base = "tfa_blacklisted" SWEP.PrintName = SWEP.Gun return end
end

SWEP.Base							= "tfa_gun_base"
SWEP.Category						= "TFA Star Wars In-Development"
SWEP.Manufacturer 					= ""
SWEP.Author							= "Riddick & Venator"
SWEP.Contact						= ""
SWEP.Spawnable						= true
SWEP.AdminSpawnable					= true
SWEP.DrawCrosshair					= true
SWEP.DrawCrosshairIS 				= false
SWEP.PrintName						= "DLT-23V"
SWEP.Type							= "Squad-Supression weapon"
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

SWEP.Primary.ClipSize				= 300
SWEP.Primary.DefaultClip			= 600
SWEP.Primary.RPM					= 1000
SWEP.Primary.RPM_Burst				= 658
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
SWEP.Primary.Damage					= 20
SWEP.Primary.HullSize 				= 0
SWEP.DamageType 					= nil

SWEP.DoMuzzleFlash 					= true
SWEP.CustomMuzzleFlash 				= true
SWEP.MuzzleFlashEffect 				= "rw_sw_muzzleflash_red"

SWEP.FireModes = {
	"Auto",
}

SWEP.IronRecoilMultiplier			= 1
SWEP.CrouchRecoilMultiplier			= 0.3
SWEP.JumpRecoilMultiplier			= 15
SWEP.WallRecoilMultiplier			= 1
SWEP.ChangeStateRecoilMultiplier	= 1.2
SWEP.CrouchAccuracyMultiplier		= 0.95
SWEP.ChangeStateAccuracyMultiplier	= 1.18
SWEP.JumpAccuracyMultiplier			= 2
SWEP.WalkAccuracyMultiplier			= 1.18
SWEP.NearWallTime 					= 4
SWEP.ToCrouchTime 					= 3
SWEP.WeaponLength 					= 35
SWEP.SprintFOVOffset 				= 0

SWEP.ViewModel						= "models/weapons/ven_riddick/dlt23v2.mdl"
SWEP.WorldModel						= "models/weapons/ven_riddick/w_dlt23v.mdl"
SWEP.ViewModelFOV					= 70
SWEP.ViewModelFlip					= false
SWEP.MaterialTable 					= nil
SWEP.UseHands 						= true
SWEP.HoldType 						= "shotgun"
SWEP.ReloadHoldTypeOverride 		= "ar2"

SWEP.ShowWorldModel = false

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
SWEP.Primary.KickUp					= 0.7
SWEP.Primary.KickDown				= 0.85
SWEP.Primary.KickHorizontal			= 0.15
SWEP.Primary.StaticRecoilFactor 	= 0.6
SWEP.Primary.Spread					= 0.1
SWEP.Primary.IronAccuracy 			= 0.07
SWEP.Primary.SpreadMultiplierMax 	= 1.5
SWEP.Primary.SpreadIncrement 		= 0.1325
SWEP.Primary.SpreadRecovery 		= 0.8
SWEP.DisableChambering 				= true
SWEP.MoveSpeed 						= 0.7
SWEP.IronSightsMoveSpeed 			= 0.5
--SWEP.UnSightOnReload = false

SWEP.IronSightsPos = Vector(-3.4, -5, 2.2)
SWEP.IronSightsAng = Vector(0, 0.5, 3)
SWEP.RunSightsPos = Vector(5.226, -0, -1)
SWEP.RunSightsAng = Vector(-19, 42, -22)
SWEP.InspectPos = Vector(8, -4.8, -3)
SWEP.InspectAng = Vector(11.199, 38, 0)

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
	["bipod_deployed"] = { type = "Model", model = "models/weapons/ven_riddick/bipod_deployed.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(31.2, 0.518, -4.676), angle = Angle(1.169, -82.987, 167.143), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, active = false },
	["bipod_up"] = { type = "Model", model = "models/weapons/ven_riddick/bipod_up.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(28, 0.589, -6.2), angle = Angle(5.843, -85.325, 167.143), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, active = false }
}

SWEP.Attachments = {
	[1] = { offset = { 0, 0 }, atts = { "bipod_deployed", "bipod_up" }, order = 1, sel = 2 },
}

DEFINE_BASECLASS( SWEP.Base )

function SWEP:SetupDataTables()
    BaseClass.SetupDataTables(self)

    self:NetworkVar("Float", 15, "Heat")
	if SERVER then
		self:SetHeat(0)
	end
end

local mat = Material("models/ven-rid/dlt23v/base")

function SWEP:DrawWorldModel()
	mat:SetFloat("$detailblendfactor", tostring(self:GetHeat() ) )
	BaseClass.DrawWorldModel(self)
	mat:SetFloat("$detailblendfactor", "0")
end

function SWEP:PreDrawViewModel(vm, wep, ply)
	mat:SetFloat("$detailblendfactor",tostring(self:GetHeat()))
	BaseClass.PreDrawViewModel(self, vm, wep, ply)
end

function SWEP:PostDrawViewModel(vm, wep, ply)
    if BaseClass.PostDrawViewModel then
		BaseClass.PostDrawViewModel(self, vm, wep, ply)
	end
	mat:SetFloat("$detailblendfactor", "0")
end

function SWEP:Think()
    BaseClass.Think(self)

	if self:GetHeat() != 0 then
		if (self.LastAttack || 0 ) < CurTime() then
			self:SetHeat( math.max(self:GetHeat() - 1/11 * FrameTime(), 0) )
		end
    end
end

function SWEP:PrimaryAttack()
    BaseClass.PrimaryAttack(self)

    self:SetHeat( math.min( self:GetHeat() + 1/2200 * self.Primary.RPM/30, 1 ) )
end
