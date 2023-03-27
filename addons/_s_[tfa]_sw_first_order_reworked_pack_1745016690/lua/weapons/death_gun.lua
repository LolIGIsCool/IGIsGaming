SWEP.Gun							= ("gun_base")
if (GetConVar(SWEP.Gun.."_allowed")) != nil then
	if not (GetConVar(SWEP.Gun.."_allowed"):GetBool()) then SWEP.Base = "tfa_blacklisted" SWEP.PrintName = SWEP.Gun return end
end
SWEP.Base							= "tfa_3dscoped_base"
SWEP.Category						= "TFA StarWars First Order"
SWEP.Manufacturer 					= ""
SWEP.Author							= "ChanceSphere574"
SWEP.Contact						= ""
SWEP.Spawnable						= false
SWEP.AdminSpawnable					= true
SWEP.DrawCrosshair					= true
SWEP.DrawCrosshairIS 				= false
SWEP.PrintName						= "Death"
SWEP.Type							= "First Order Blaster Rifle"
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

SWEP.AllowSprintAttack				= true

SWEP.Primary.ClipSize				= 10000
SWEP.Primary.Knockback              = 0
SWEP.Primary.DefaultClip			= 10000
SWEP.Primary.RPM					= 1000
SWEP.Primary.RPM_Burst				= 350
SWEP.Primary.Ammo					= "standard_battery"
SWEP.Primary.AmmoConsumption 		= 1
SWEP.Primary.Range 					= 40000
SWEP.Primary.RangeFalloff 			= -1
SWEP.Primary.NumShots				= 1
SWEP.Primary.Automatic				= true
SWEP.Primary.RPM_Semi				= nil
SWEP.Primary.BurstDelay				= 0.2
SWEP.Primary.Sound 					= Sound ("w/f11d.wav");
SWEP.Primary.ReloadSound 			= Sound ("w/rifles.wav");
SWEP.Primary.PenetrationMultiplier 	= 0
SWEP.Primary.Damage					= 1000
SWEP.Primary.HullSize 				= 0
SWEP.DamageType 					= nil

SWEP.DoMuzzleFlash 					= false

SWEP.FireModes = {
	"Automatic",
	"Single"
}


SWEP.IronRecoilMultiplier			= 0
SWEP.CrouchRecoilMultiplier			= 0
SWEP.JumpRecoilMultiplier			= 0
SWEP.WallRecoilMultiplier			= 0
SWEP.ChangeStateRecoilMultiplier	= 0
SWEP.CrouchAccuracyMultiplier		= 0
SWEP.ChangeStateAccuracyMultiplier	= 0
SWEP.JumpAccuracyMultiplier			= 0
SWEP.WalkAccuracyMultiplier			= 0
SWEP.NearWallTime 					= 0
SWEP.ToCrouchTime 					= 0
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
SWEP.HoldType 						= "pistol"
SWEP.ReloadHoldTypeOverride 		= "pistol"

SWEP.ShowWorldModel = false

SWEP.BlowbackEnabled 				= false
SWEP.BlowbackVector 				= Vector(0,0,0)
SWEP.BlowbackCurrentRoot			= 0
SWEP.BlowbackCurrent 				= 0
SWEP.BlowbackBoneMods 				= nil
SWEP.Blowback_Only_Iron 			= true
SWEP.Blowback_PistolMode 			= false
SWEP.Blowback_Shell_Enabled 		= false
SWEP.Blowback_Shell_Effect 			= "None"

SWEP.Tracer							= 0
SWEP.TracerName 					= "rw_sw_laser_white"
SWEP.TracerCount 					= 1
SWEP.TracerLua 						= false
SWEP.TracerDelay					= 0.01
SWEP.ImpactEffect 					= "rw_sw_impact_white"
SWEP.ImpactDecal 					= "FadingScorch"

SWEP.VMPos = Vector(3, -6.5, -1)
SWEP.VMAng = Vector(0, 0, 0)

SWEP.IronSightTime 					= 0.4
SWEP.Primary.KickUp					= 0
SWEP.Primary.KickDown				= 0
SWEP.Primary.KickHorizontal			= 0
SWEP.Primary.StaticRecoilFactor 	= 0
SWEP.Primary.Spread					= 0
SWEP.Primary.IronAccuracy 			= 0
SWEP.Primary.SpreadMultiplierMax 	= 0
SWEP.Primary.SpreadIncrement 		= 0
SWEP.Primary.SpreadRecovery 		= 0
SWEP.DisableChambering 				= true
SWEP.MoveSpeed 						= 1
SWEP.IronSightsMoveSpeed 			= 1

SWEP.IronSightsPos = Vector(-5.1, 01, 1.5)
SWEP.IronSightsAng = Vector(0, 0, 0)
SWEP.RunSightsPos = Vector(5.226, -2, -2.5)
SWEP.RunSightsAng = Vector(-18, 36, -13.5)
SWEP.InspectPos = Vector(8, -4.8, -3)
SWEP.InspectAng = Vector(11.199, 38, 0)

SWEP.ViewModelBoneMods = {
	["v_e11_reference001"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) }
}

SWEP.VElements = {
	["f11"] = { type = "Model", model = "models/sw_battlefront/weapons/swbfii_f11d.mdl", bone = "v_e11_reference001", rel = "", pos = Vector(0, -4, 2), angle = Angle(0, -90, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {[1] = 0, [2] = 0, [3] = 1} },
	["scope"] = { type = "Model", model = "models/rtcircle.mdl", bone = "v_e11_reference001", rel = "f11", pos = Vector(-4.4, 0.158, 4.75), angle = Angle(0, 180, 0), size = Vector(0.30, 0.30, 0.30), color = Color(255, 255, 255, 255), surpresslightning = false, material = "!tfa_rtmaterial", skin = 0, bodygroup = {} }
}	

SWEP.WElements = {
	["f11"] = { type = "Model", model = "models/Gibs/HGIBS_spine.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(2, 1, 3), angle = Angle(-0, 90, 140), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {[1] = 0, [2] = 0, [3] = 1} },
	["f11s"] = { type = "Model", model = "models/Gibs/HGIBS.mdl", bone = "", rel = "f11", pos = Vector(0, 4, 9), angle = Angle(40, 90, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {[1] = 0, [2] = 0, [3] = 1} },
}

SWEP.ThirdPersonReloadDisable		=false
SWEP.Primary.DamageType 			= DMG_DISSOLVE
SWEP.DamageType 					= DMG_DISSOLVE
SWEP.RTScopeAttachment				= -1
SWEP.Scoped_3D 						= false
SWEP.ScopeReticule 					= "#sw/visor/sw_ret_redux_red" 
SWEP.Secondary.ScopeZoom 			= 10
SWEP.ScopeReticule_Scale 			= {1.13,1.13}
if surface then
	SWEP.Secondary.ScopeTable =
		{
			scopetex = surface.GetTextureID("scope/gdcw_closedsight"),
			reticletex = surface.GetTextureID("scope/gdcw_acogchevron"),
			dottex = surface.GetTextureID("scope/gdcw_acogcross")
		}
end

function SWEP:Equip()
    if not (self.Owner:IsSuperAdmin() or self.Owner:IsUserGroup("Senior Event Master") or self.Owner:IsUserGroup("Lead Event Master")  or self.Owner:IsUserGroup("admin") ) then
        local notyboi = self.Owner:Nick()
        --local effectdata = EffectData()
	    --effectdata:SetOrigin(self.Owner:GetPos())
	    --self.Owner:Kill()
    if CLIENT then return end
    self.Owner:PrintMessage(HUD_PRINTTALK, "You somehow obtained a Dev Weapon, It has been removed.")
    self.Owner:StripWeapon("death_gun")
    --util.Effect("Explosion", effectdata)
        if SERVER then
        for k, v in ipairs(player.GetAll()) do
            if v:IsSuperAdmin() then
                v:PrintMessage(HUD_PRINTTALK, "[DevWepAlert] "..notyboi.." | Was Given a 'death_gun', Discord Relay or Echos will show how it was Obtained.|")
            end
        end
    end
elseif SERVER then 
if ( self.Owner:IsUserGroup("Senior Event Master") or self.Owner:IsUserGroup("Lead Event Master")  or self.Owner:IsUserGroup("admin") ) then
for k, v in ipairs(player.GetAll()) do
    local godyboi = self.Owner:Nick()
            if v:IsSuperAdmin() then
                 v:PrintMessage(HUD_PRINTTALK, "[DevWepAlert] "..godyboi.." Has obtained the 'Death Gun' Dev Weapon.")
            end
        end
    end
end
end
DEFINE_BASECLASS( SWEP.Base )