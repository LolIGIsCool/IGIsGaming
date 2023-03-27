SWEP.Gun							= ("rw_sw_droideka")
if (GetConVar(SWEP.Gun.."_allowed")) != nil then
	if not (GetConVar(SWEP.Gun.."_allowed"):GetBool()) then SWEP.Base = "tfa_blacklisted" SWEP.PrintName = SWEP.Gun return end
end
SWEP.Base							= "tfa_swsft_base"
SWEP.Category						= "TFA StarWars Reworked CIS"
SWEP.Manufacturer 					= ""
SWEP.Author							= "ChanceSphere574"
SWEP.Contact						= ""
SWEP.Spawnable						= true
SWEP.AdminSpawnable					= true
SWEP.DrawCrosshair					= true
SWEP.DrawCrosshairIS 				= false
SWEP.PrintName						= "Droideka Sniper"
SWEP.Type							= "CIS Droideka Sniper"
SWEP.DrawAmmo						= true
SWEP.data 							= {}
SWEP.data.ironsights				= 1
SWEP.Secondary.IronFOV				= 78
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
SWEP.DefaultFireMode 				= "single"
SWEP.FireModeName 					= nil
SWEP.DisableChambering 				= true

SWEP.Primary.ClipSize				= 5
SWEP.Primary.DefaultClip			= 0
SWEP.Primary.RPM					= 60
SWEP.Primary.RPM_Burst				= 90
SWEP.Primary.Ammo					= "battery"
SWEP.Primary.AmmoConsumption 		= 1
SWEP.Primary.Range 					= 32000
SWEP.Primary.RangeFalloff 			= -1
SWEP.Primary.NumShots				= 1
SWEP.Primary.Automatic				= true
SWEP.Primary.RPM_Semi				= nil
SWEP.Primary.BurstDelay				= 0.2
SWEP.Primary.Sound 					= Sound ("w/droideka_fire.wav");
SWEP.Primary.ReloadSound 			= nil
SWEP.Primary.PenetrationMultiplier 	= 0
SWEP.Primary.Damage					= 200
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

SWEP.ViewModel						= "models/weapons/synbf3/c_e11.mdl"
SWEP.WorldModel						= "models/weapons/synbf3/w_e11.mdl"
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
SWEP.TracerName 					= "rw_sw_laser_red"
SWEP.TracerCount 					= 1
SWEP.TracerLua 						= false
SWEP.TracerDelay					= 0.01
SWEP.ImpactEffect 					= "rw_sw_impact_red"
SWEP.ImpactDecal 					= "FadingScorch"

SWEP.VMPos = Vector(1.96, -2.814, 2)
SWEP.VMAng = Vector(0,0,0)

SWEP.IronSightTime 					= 0.6
SWEP.Primary.KickUp					= 0.5
SWEP.Primary.KickDown				= 0.15
SWEP.Primary.KickHorizontal			= 0.055
SWEP.Primary.StaticRecoilFactor 	= 0.65
SWEP.Primary.Spread					= 0.04
SWEP.Primary.IronAccuracy 			= 0.0005
SWEP.Primary.SpreadMultiplierMax 	= 0
SWEP.Primary.SpreadIncrement 		= 0.3
SWEP.Primary.SpreadRecovery 		= 0.98
SWEP.DisableChambering 				= true
SWEP.MoveSpeed 						= 1
SWEP.IronSightsMoveSpeed 			= 0.8

SWEP.IronSightsPos = Vector(0, -2, 2)
SWEP.IronSightsAng = Vector(0, 0, 0)
SWEP.RunSightsPos = Vector(0, 0, 0)
SWEP.RunSightsAng = Vector(0, 0, 0)
SWEP.InspectPos = Vector(0, 0, 0)
SWEP.InspectAng = Vector(0, 0, 0)

SWEP.ViewModelBoneMods = {
	["v_e11_reference001"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 3, -10), angle = Angle(0, 0, 0) }
}

SWEP.VElements = {
	["b2rph"] = { type = "Model", model = "models/hunter/misc/roundthing4.mdl", bone = "v_e11_reference001", rel = "", pos = Vector(-1.8, 0, 6), angle = Angle(90, 180.4, 0), size = Vector(0.12, 0.12, 0.12), color = Color(75, 75, 75, 0), surpresslightning = false, material = "models/debug/debugwhite", skin = 0, bodygroup = {} },
	["b2rpb1"] = { type = "Model", model = "models/mechanics/robotics/a4.mdl", bone = "v_e11_reference001", rel = "b2rph", pos = Vector(5.7, 3., 2.84), angle = Angle(0, 90, 0), size = Vector(0.1, 0.1, 0.1), color = Color(150, 150, 150, 255), surpresslightning = false, material = "models/debug/debugwhite", skin = 0, bodygroup = {} },
	["b2rpb2"] = { type = "Model", model = "models/Mechanics/roboticslarge/a1.mdl", bone = "v_e11_reference001", rel = "b2rph", pos = Vector(7, 3, 2.85), angle = Angle(0, 90, 0), size = Vector(0.1, 0.1, 0.1), color = Color(50, 50, 50, 255), surpresslightning = false, material = "models/debug/debugwhite", skin = 0, bodygroup = {} },
	["b2rpb11"] = { type = "Model", model = "models/mechanics/robotics/a4.mdl", bone = "v_e11_reference001", rel = "b2rph", pos = Vector(5.7, -7, 2.84), angle = Angle(0, 90, 90), size = Vector(0.07, 0.07, 0.07), color = Color(50, 50, 50, 255), surpresslightning = false, material = "models/debug/debugwhite", skin = 0, bodygroup = {} },
	["b2rpb22"] = { type = "Model", model = "models/rtcircle.mdl", bone = "v_e11_reference001", rel = "b2rph", pos = Vector(7.2, 5.55, 2.84), angle = Angle(0, -90, -90), size = Vector(0.45, 0.45, 0.45), color = Color(255, 255, 255, 255), surpresslightning = false, material = "!tfa_rtmaterial", skin = 0, bodygroup = {} },
}

SWEP.WElements = {
	["b2rp"] = { type = "Model", model = "models/hunter/plates/plate.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(7.9, 1, 1), angle = Angle(-8, 0, 180), size = Vector(0.1, 0.1, 0.1), color = Color(255, 255, 255, 0), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

local MaxTimer				= 80
local CurrentTimer			= 0

function SWEP:Think()
	if (self.Weapon:Clip1() == 0) and SERVER then
		if (CurrentTimer == 80) then 
			CurrentTimer = 0
			self.Weapon:SetClip1( self.Weapon:Clip1() + 5 )
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
SWEP.ScopeReticule 					= "#sw/visor/sw_ret_redux_red" 
SWEP.Secondary.ScopeZoom 			= 8
SWEP.ScopeReticule_Scale 			= {1.05,1.05}
if surface then
	SWEP.Secondary.ScopeTable = nil --[[
		{
			scopetex = surface.GetTextureID("scope/gdcw_closedsight"),
			reticletex = surface.GetTextureID("scope/gdcw_acogchevron"),
			dottex = surface.GetTextureID("scope/gdcw_acogcross")
		}
	]]--
end
SWEP.RTOpaque = true
local ceedee = {}
SWEP.RTMaterialOverride = -1 --the number of the texture, which you subtract from GetAttachment
local g36
if surface then
	g36 = surface.GetTextureID("#sw/visor/sw_ret_redux_red") --the texture you vant to use
end
SWEP.RTCode = function( self, mat )
	
	render.OverrideAlphaWriteEnable( true, true)
	surface.SetDrawColor(color_white)
	surface.DrawRect(-256,-256,512,512)
	render.OverrideAlphaWriteEnable( true, true)
	
	local ang = self.Owner:EyeAngles()
	ang:RotateAroundAxis(ang:Forward(),0)
	ceedee.angles = ang
	ceedee.origin = self.Owner:GetShootPos()
	
	ceedee.x = 0
	ceedee.y = 0
	ceedee.w = 512	
	ceedee.h = 512
	ceedee.fov = 10
	ceedee.drawviewmodel = false
	ceedee.drawhud = false
	
	
	if self.CLIronSightsProgress>0.01 then
		render.RenderView(ceedee)
	end
		
	render.OverrideAlphaWriteEnable( false, true)
	
	
	cam.Start2D()
		draw.NoTexture()
		surface.SetDrawColor(ColorAlpha(color_black,0))
		surface.DrawTexturedRect(0,0,512,512)
		surface.SetDrawColor(color_white)
		surface.SetTexture(g36)
		surface.DrawTexturedRect(0,0,512,512)
		draw.NoTexture()
		surface.SetDrawColor(ColorAlpha(color_black,(1-self.CLIronSightsProgress)*255))
		surface.DrawTexturedRect(0,0,512,512)
	cam.End2D()
	
end
DEFINE_BASECLASS( SWEP.Base )