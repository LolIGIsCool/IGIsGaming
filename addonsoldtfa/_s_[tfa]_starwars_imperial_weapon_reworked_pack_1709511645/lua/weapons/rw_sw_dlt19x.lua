SWEP.Gun							= ("gun_base")
if (GetConVar(SWEP.Gun.."_allowed")) != nil then
	if not (GetConVar(SWEP.Gun.."_allowed"):GetBool()) then SWEP.Base = "tfa_blacklisted" SWEP.PrintName = SWEP.Gun return end
end
SWEP.Base							= "tfa_swsft_base"
SWEP.Category						= "TFA StarWars Reworked Imperial"
SWEP.Manufacturer 					= ""
SWEP.Author							= "ChanceSphere574"
SWEP.Contact						= ""
SWEP.Spawnable						= true
SWEP.AdminSpawnable					= true
SWEP.DrawCrosshair					= true
SWEP.DrawCrosshairIS 				= false
SWEP.PrintName						= "DLT-19X"
SWEP.Type							= "Imperial Sniper Blaster"
SWEP.DrawAmmo						= true
SWEP.data 							= {}
SWEP.data.ironsights				= 1
SWEP.Secondary.IronFOV				= 78
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
SWEP.DefaultFireMode 				= "single"
SWEP.FireModeName 					= nil
SWEP.DisableChambering 				= true

SWEP.Primary.ClipSize				= 8
SWEP.Primary.DefaultClip			= 20
SWEP.Primary.RPM					= 60
SWEP.Primary.RPM_Burst				= 60
SWEP.Primary.Ammo					= "high_power_battery"
SWEP.Primary.AmmoConsumption 		= 1
SWEP.Primary.Range 					= 35000
SWEP.Primary.RangeFalloff 			= -1
SWEP.Primary.NumShots				= 1
SWEP.Primary.Automatic				= false
SWEP.Primary.RPM_Semi				= nil
SWEP.Primary.BurstDelay				= 0.2
SWEP.Primary.Sound 					= Sound ("w/dlt19x.wav");
SWEP.Primary.ReloadSound 			= Sound ("w/heavy.wav");
SWEP.Primary.PenetrationMultiplier 	= 0
SWEP.Primary.Damage					= 144
SWEP.Primary.HullSize 				= 0
SWEP.DamageType 					= nil
SWEP.LuaShellEffect 				= nil

SWEP.FireModes = {
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

SWEP.ViewModel						= "models/weapons/synbf3/c_dlt19.mdl"
SWEP.WorldModel						= "models/weapons/synbf3/w_dlt19.mdl"
SWEP.ViewModelFOV					= 75
SWEP.ViewModelFlip					= false
SWEP.MaterialTable 					= nil
SWEP.UseHands 						= true
SWEP.HoldType 						= "ar2"

SWEP.ShowWorldModel = false
SWEP.LuaShellEject = false


SWEP.BlowbackEnabled 				= true
SWEP.BlowbackVector 				= Vector(0,-2.5,-0.05)
SWEP.BlowbackCurrentRoot			= 0
SWEP.BlowbackCurrent 				= 0
SWEP.BlowbackBoneMods 				= nil
SWEP.Blowback_Only_Iron 			= true
SWEP.Blowback_PistolMode 			= false
SWEP.Blowback_Shell_Enabled 		= false
SWEP.Blowback_Shell_Effect 			= ""

SWEP.Tracer							= 0
SWEP.TracerName 					= "rw_sw_laser_red"
SWEP.TracerCount 					= 1
SWEP.TracerLua 						= false
SWEP.TracerDelay					= 0.01
SWEP.ImpactEffect 					= "rw_sw_impact_red"
SWEP.ImpactDecal 					= "FadingScorch"

SWEP.VMPos = Vector(1.965, -2.814, -0.585)
SWEP.VMAng = Vector(0,0,0)

SWEP.IronSightTime 					= 0.9
SWEP.Primary.KickUp					= 0.50
SWEP.Primary.KickDown				= 0.4
SWEP.Primary.KickHorizontal			= 0.055
SWEP.Primary.StaticRecoilFactor 	= 0.65
SWEP.Primary.Spread					= 0.04
SWEP.Primary.IronAccuracy 			= 0.0001
SWEP.Primary.SpreadMultiplierMax 	= 0.00
SWEP.Primary.SpreadIncrement 		= 0.35
SWEP.Primary.SpreadRecovery 		= 0.98
SWEP.DisableChambering 				= true
SWEP.MoveSpeed 						= 0.85
SWEP.IronSightsMoveSpeed 			= 0.75

SWEP.IronSightsPos = Vector( -5.6, -1.5, 0)
SWEP.IronSightsAng = Vector(0, 0, 0)
SWEP.RunSightsPos = Vector(5.226, -2, 1.5)
SWEP.RunSightsAng = Vector(-22, 32.50, -19)
SWEP.InspectPos = Vector(8, -4.8, -3)
SWEP.InspectAng = Vector(11.199, 38, 0)

SWEP.ViewModelBoneMods = {
	["v_dlt19_reference001"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) }
}

SWEP.VElements = {
    ["e5s"] = { type = "Model", model = "models/markus/swbf2/gameplay/equipment/longrange/dlt19x/dlt19x_mesh1p_mesh.mdl", bone = "v_dlt19_reference001", rel = "", pos = Vector(0, -2.5, -1), angle = Angle(0, -90, 0), size = Vector(1.4, 1.4, 1.4), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
    ["scope"] = { type = "Model", model = "models/rtcircle.mdl", bone = "v_dlt19_reference001", rel = "e5s", pos = Vector(1.5, -0.002, 7.709), angle = Angle(0, 180, 0), size = Vector(0.50, 0.50, 0.50), color = Color(255, 255, 255, 255), surpresslightning = false, material = "!tfa_rtmaterial", skin = 0, bodygroup = {} }
}

SWEP.WElements = {
    ["e5s"] = { type = "Model", model = "models/markus/swbf2/gameplay/equipment/longrange/dlt19x/dlt19x_mesh1p_mesh.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(2, 1, 0), angle = Angle(-12, 0, 173), size = Vector(1.2, 1.2, 1.2), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

SWEP.ThirdPersonReloadDisable		=false
SWEP.Primary.DamageType 			= DMG_BULLET
SWEP.DamageType 					= DMG_BULLET
SWEP.RTScopeAttachment				= -1
SWEP.Scoped_3D 						= false
SWEP.ScopeReticule 					= "#sw/visor/sw_ret_redux_red" 
SWEP.Secondary.ScopeZoom 			= 9
SWEP.ScopeReticule_Scale 			= {1.025,1.025}
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