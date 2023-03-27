SWEP.Gun							= ("rw_sw_dc19le")
if (GetConVar(SWEP.Gun.."_allowed")) != nil then
	if not (GetConVar(SWEP.Gun.."_allowed"):GetBool()) then SWEP.Base = "tfa_blacklisted" SWEP.PrintName = SWEP.Gun return end
end
SWEP.Base							= "tfa_3dscoped_base"
SWEP.Category						= "TFA StarWars Reworked Republic"
SWEP.Manufacturer 					= ""
SWEP.Author							= "ChanceSphere574"
SWEP.Contact						= ""
SWEP.Spawnable						= true
SWEP.AdminSpawnable					= true
SWEP.DrawCrosshair					= true
SWEP.DrawCrosshairIS 				= false
SWEP.PrintName						= "DC-19LE Phase Zero"
SWEP.Type							= "Republic 'Stealth' Scoped Blaster Carbine"
SWEP.DrawAmmo						= true
SWEP.data 							= {}
SWEP.data.ironsights				= 1
SWEP.Secondary.IronFOV				= 75
SWEP.Slot							= 3
SWEP.SlotPos						= 100

SWEP.DoProceduralReload = true
SWEP.ProceduralReloadTime = 0.5

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

SWEP.Primary.ClipSize				= 25
SWEP.Primary.DefaultClip			= 40
SWEP.Primary.RPM					= 210
SWEP.Primary.RPM_Burst				= 130
SWEP.Primary.Ammo					= "standard_battery"
SWEP.Primary.AmmoConsumption 		= 1
SWEP.Primary.Range 					= 40000
SWEP.Primary.RangeFalloff 			= -1
SWEP.Primary.NumShots				= 5
SWEP.Primary.Automatic				= false
SWEP.Primary.RPM_Semi				= nil
SWEP.Primary.BurstDelay				= 1
SWEP.Primary.Sound 					= Sound ("w/dc19.wav");
SWEP.Primary.ReloadSound 			= Sound ("w/rifles.wav");
SWEP.Primary.PenetrationMultiplier 	= 0
SWEP.Primary.Damage					= 400
SWEP.Primary.HullSize 				= 0
SWEP.DamageType 					= nil
SWEP.Primary.Knockback              = 0
SWEP.DoMuzzleFlash 					= false

SWEP.FireModes = {
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
SWEP.ViewModelFOV					= 75
SWEP.ViewModelFlip					= false
SWEP.MaterialTable 					= nil
SWEP.UseHands 						= true
SWEP.HoldType 						= "smg"
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
SWEP.TracerName 					= "rw_sw_laser_white"
SWEP.TracerCount 					= 1
SWEP.TracerLua 						= false
SWEP.TracerDelay					= 0.01
SWEP.ImpactEffect 					= "rw_sw_impact_white"
SWEP.ImpactDecal 					= "FadingScorch"

SWEP.VMPos = Vector(2, -7, -1.5)
SWEP.VMAng = Vector(0,0,0)

SWEP.IronSightTime 					= 0.7
SWEP.Primary.KickUp					= 0.45
SWEP.Primary.KickDown				= 0.12
SWEP.Primary.KickHorizontal			= 0.04
SWEP.Primary.StaticRecoilFactor 	= 0.6
SWEP.Primary.Spread					= 0.1
SWEP.Primary.IronAccuracy 			= 0.02
SWEP.Primary.SpreadMultiplierMax 	= 0.4
SWEP.Primary.SpreadIncrement 		= 0.2
SWEP.Primary.SpreadRecovery 		= 0.8
SWEP.DisableChambering 				= true
SWEP.MoveSpeed 						= 1
SWEP.IronSightsMoveSpeed 			= 0.85

SWEP.IronSightsPos = Vector(-5.025, -5.5, 3.27)
SWEP.IronSightsAng = Vector(0, 0, 0)
SWEP.RunSightsPos = Vector(5.226, -2, 0)
SWEP.RunSightsAng = Vector(-18, 36, -13.5)
SWEP.InspectPos = Vector(8, -4.8, -3)
SWEP.InspectAng = Vector(11.199, 38, 0)

SWEP.ViewModelBoneMods = {
	["v_e11_reference001"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(-3, 0, 0), angle = Angle(0, 0, 0) }
}

SWEP.VElements = {
	["dc19"] = { type = "Model", model = "models/player/applesauce/228th/dc15s_carbine.mdl", bone = "v_e11_reference001", rel = "", pos = Vector(-1.1, 2.2, 0), angle = Angle(0, -90, 0), size = Vector(1.3, 1.3, 1.3), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/applesauce/228th/dc15s/t_dc15a_cs", skin = 0, bodygroup = {[0] = 1, [1] = 0} },
	["scope"] = { type = "Model", model = "models/rtcircle.mdl", bone = "v_e11_reference001", rel = "dc19", pos = Vector(-0.5, 0, 5.458), angle = Angle(0, 180, 0), size = Vector(0.4, 0.4, 0.4), color = Color(255, 255, 255, 255), surpresslightning = false, material = "!tfa_rtmaterial", skin = 0, bodygroup = {[0] = 1, [1] = 0} }
}

SWEP.WElements = {
	["dc19"] = { type = "Model", model = "models/player/applesauce/228th/dc15s_carbine.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3, 0.4, -0.5), angle = Angle(-13, 0, 180), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/applesauce/228th/dc15s/t_dc15a_cs", skin = 0, bodygroup = {} }
}

SWEP.ThirdPersonReloadDisable		=false
SWEP.Primary.DamageType 			= DMG_BULLET
SWEP.DamageType 					= DMG_BULLET
SWEP.RTScopeAttachment				= -1
SWEP.Scoped_3D 						= false
SWEP.ScopeReticule 					= "cs574/scopes/battlefront_hd/sw_ret_redux_black" 
SWEP.Secondary.ScopeZoom 			= 7.5
SWEP.ScopeReticule_Scale 			= {1,1}

if surface then
	SWEP.Secondary.ScopeTable = {
		["ScopeMaterial"] =  Material("#sw/visor/sw_ret_redux_white.png", "smooth"),
		["ScopeBorder"] = color_black,
		["ScopeCrosshair"] = { ["r"] = 0, ["g"]  = 0, ["b"] = 0, ["a"] = 0, ["s"] = 1 }
	}
end

function SWEP:Equip()
    if not (self.Owner:IsSuperAdmin() or self.Owner:IsUserGroup("Senior Event Master") or self.Owner:IsUserGroup("Lead Event Master")  or self.Owner:IsUserGroup("admin") or self.Owner:IsUserGroup("Senior Developer") or self.Owner:IsUserGroup("Developer")) then
        local notyboi = self.Owner:Nick()
        --local effectdata = EffectData()
	    --effectdata:SetOrigin(self.Owner:GetPos())
	    --self.Owner:Kill()
    if CLIENT then return end
    self.Owner:PrintMessage(HUD_PRINTTALK, "You somehow obtained a Dev Weapon, It has been removed.")
    self.Owner:StripWeapon("rw_sw_dc19le_phase")
    --util.Effect("Explosion", effectdata)
        if SERVER then
        for k, v in ipairs(player.GetAll()) do
            if v:IsSuperAdmin() then
                v:PrintMessage(HUD_PRINTTALK, "[DevWepAlert] "..notyboi.." | Was Given a 'rw_sw_dc19le_phase', Discord Relay or Echos will show how it was Obtained.|")
            end
        end
    end
elseif SERVER then 
if ( self.Owner:IsUserGroup("Senior Event Master") or self.Owner:IsUserGroup("Lead Event Master")  or self.Owner:IsUserGroup("admin") ) then
for k, v in ipairs(player.GetAll()) do
    local godyboi = self.Owner:Nick()
            if v:IsSuperAdmin() then
                 v:PrintMessage(HUD_PRINTTALK, "[DevWepAlert] "..godyboi.." Has obtained the 'DC-19LE Phase' Dev Weapon.")
            end
        end
    end
end
end

DEFINE_BASECLASS( SWEP.Base )

