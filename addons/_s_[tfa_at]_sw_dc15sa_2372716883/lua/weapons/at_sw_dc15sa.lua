SWEP.Gun							= ("gun_base")
if (GetConVar(SWEP.Gun.."_allowed")) != nil then
	if not (GetConVar(SWEP.Gun.."_allowed"):GetBool()) then SWEP.Base = "tfa_blacklisted" SWEP.PrintName = SWEP.Gun return end
end

SWEP.Base							= "tfa_gun_base"
SWEP.Category						= "TFA StarWars [AT] Pack"
SWEP.Manufacturer 					= ""
SWEP.Author							= "ChanceSphere574"
SWEP.Contact						= ""
SWEP.Spawnable						= true
SWEP.AdminSpawnable					= true
SWEP.DrawCrosshair					= true
SWEP.DrawCrosshairIS 				= false
SWEP.PrintName						= "[AT] DC-15SA"
SWEP.Type							= "Customisable Republic Experimental Blaster Pistol"
SWEP.DrawAmmo						= true
SWEP.data 							= {}
SWEP.data.ironsights				= 1
SWEP.Secondary.IronFOV				= 75
SWEP.Slot							= 1
SWEP.SlotPos						= 100

SWEP.FiresUnderwater 				= true

SWEP.IronInSound 					= nil
SWEP.IronOutSound 					= nil
SWEP.CanBeSilenced					= true
SWEP.Silenced 						= false
SWEP.DoMuzzleFlash 					= false
SWEP.SelectiveFire					= true
SWEP.DisableBurstFire				= false
SWEP.OnlyBurstFire					= false
SWEP.DefaultFireMode 				= "Single"
SWEP.FireModeName 					= nil
SWEP.DisableChambering 				= true

SWEP.Primary.ClipSize				= 12
SWEP.Primary.DefaultClip			= 20*4
SWEP.Primary.RPM					= 250
SWEP.Primary.RPM_Burst				= 250*2
SWEP.Primary.Ammo					= "light_battery"
SWEP.Primary.AmmoConsumption 		= 1
SWEP.Primary.Range 					= 32000
SWEP.Primary.RangeFalloff 			= -1
SWEP.Primary.NumShots				= 1
SWEP.Primary.Automatic				= false
SWEP.Primary.RPM_Semi				= 315
SWEP.Primary.BurstDelay				= 0.3
SWEP.Primary.Sound 					= Sound ("w/dc15sa.wav");
SWEP.Primary.ReloadSound 			= Sound ("w/dc15sa_reload.wav");
SWEP.Primary.PenetrationMultiplier 	= 0
SWEP.Primary.Damage					= 40
SWEP.Primary.HullSize 				= 0
SWEP.DamageType 					= nil

SWEP.DoMuzzleFlash 					= true
SWEP.CustomMuzzleFlash 				= true
SWEP.MuzzleFlashEffect 				= "rw_sw_muzzleflash_blue"
SWEP.MuzzlePosOverride 				= Vector(0, 0, 0)

SWEP.FireModes = {
	"Automatic",
	"2Burst",
	"Single"
}

SWEP.IronRecoilMultiplier			= 0.44
SWEP.CrouchRecoilMultiplier			= 0.33
SWEP.JumpRecoilMultiplier			= 1.3
SWEP.WallRecoilMultiplier			= 1.1
SWEP.ChangeStateRecoilMultiplier	= 1.18
SWEP.CrouchAccuracyMultiplier		= 0.7
SWEP.ChangeStateAccuracyMultiplier	= 1
SWEP.JumpAccuracyMultiplier			= 5
SWEP.WalkAccuracyMultiplier			= 1.18
SWEP.NearWallTime 					= 0.25
SWEP.ToCrouchTime 					= 0.1
SWEP.WeaponLength 					= 35
SWEP.SprintFOVOffset 				= 12
SWEP.ProjectileVelocity 			= 9

SWEP.ProjectileEntity 				= nil
SWEP.ProjectileModel 				= nil

SWEP.ViewModel						= "models/jellyton/view_models/c_DC15SA.mdl"
SWEP.WorldModel						= "models/bf2017/w_scoutblaster.mdl"
SWEP.ViewModelFOV					= 75
SWEP.ViewModelFlip					= false
SWEP.MaterialTable 					= nil
SWEP.UseHands 						= true
SWEP.HoldType 						= "revolver"

SWEP.ShowWorldModel = false

SWEP.BlowbackEnabled 				= true
SWEP.BlowbackVector 				= Vector(0,-2.5,-0.05)
SWEP.BlowbackCurrentRoot			= 0
SWEP.BlowbackCurrent 				= 0
SWEP.BlowbackBoneMods 				= nil
SWEP.Blowback_Only_Iron 			= true
SWEP.Blowback_PistolMode 			= true
SWEP.Blowback_Shell_Enabled 		= false
SWEP.Blowback_Shell_Effect 			= "None"

SWEP.Tracer							= 0
SWEP.TracerName 					= "rw_sw_laser_blue"
SWEP.TracerCount 					= 1
SWEP.TracerLua 						= false
SWEP.TracerDelay					= 0.01
SWEP.ImpactEffect 					= "rw_sw_impact_blue"
SWEP.ImpactDecal 					= "FadingScorch"

SWEP.VMPos = Vector(1.5, -7, -2)
SWEP.VMAng = Vector(0,0,0)

SWEP.IronSightTime 					= 0.2
SWEP.Primary.KickUp					= 0.35
SWEP.Primary.KickDown				= 0.1
SWEP.Primary.KickHorizontal			= 0.05
SWEP.Primary.StaticRecoilFactor 	= 0.5
SWEP.Primary.Spread					= 0.025
SWEP.Primary.IronAccuracy 			= 0.01
SWEP.Primary.SpreadMultiplierMax 	= 0.6
SWEP.Primary.SpreadIncrement 		= 0.3
SWEP.Primary.SpreadRecovery 		= 0.98
SWEP.DisableChambering 				= true
SWEP.MoveSpeed 						= 1
SWEP.IronSightsMoveSpeed 			= 0.85

SWEP.RunSightsPos = Vector(2, -9.5, -15)
SWEP.RunSightsAng = Vector(39, -0.5, -2)

SWEP.InspectPos = Vector(8, -4.8, -3)
SWEP.InspectAng = Vector(11.199, 38, 0)

SWEP.Attachments = {
	[1] = {atts = {"training_mod","destabilized_mod","explosive_mod"},order = 1},
	[2] = {atts = {"dc15sa_holo","dc15_s4"},order = 2},
	[3] = {atts = {"dc15sa_optimized_cell","dc15sa_overload_cell"},order = 3},
    [5] = {atts = {"dc15_laser_off","dc15_laser_on"},order = 4},
}

SWEP.AttachmentTableOverride = {
	["training_mod"] = {["MuzzleFlashEffect"] = "rw_sw_muzzleflash_orange",["VElements"] = {["dc15sa_cell"] = {["skin"] = 4}},["WElements"] = {["dc15sa_cell"] = {["skin"] = 4}}},
	["destabilized_mod"] = {["MuzzleFlashEffect"] = "rw_sw_muzzleflash_aqua",["VElements"] = {["dc15sa_cell"] = {["skin"] = 1}},["WElements"] = {["dc15sa_cell"] = {["skin"] = 1}}},
	["explosive_mod"] = {["Primary"] = {["BurstDelay"] = function(wep,stat) return stat*3.333 end},["MuzzleFlashEffect"] = "rw_sw_muzzleflash_yellow",["VElements"] = {["dc15sa_cell"] = {["skin"] = 8}},["WElements"] = {["dc15sa_cell"] = {["skin"] = 8}}},
	["stun_mod"] = {["MuzzleFlashEffect"] = "rw_sw_muzzleflash_white",["VElements"] = {["dc15sa_cell"] = {["skin"] = 7}},["WElements"] = {["dc15sa_cell"] = {["skin"] = 7}}},
	["dc15_s4"] = {["VElements"] = {["dc15sa_iron"] = {["active"] = false}},["WElements"] = {["dc15sa_iron"] = {["active"] = false}}}
}

SWEP.AttachmentExclusions = {
	["stun_mod"] = { [3] = "dc15sa_optimized_cell","dc15sa_overload_cell"},
	["dc15sa_optimized_cell"] = { [1] = "stun_mod"},
	["dc15sa_overload_cell"] = { [1] = "stun_mod"},
}

SWEP.HoloSightsPos = Vector(-6.505, -7, 2.55)
SWEP.Scope4Pos = Vector(-6.515, -12, 2.67)
SWEP.IronSightsPos = Vector(-6.51, -6, 2.8)
SWEP.IronSightsAng = Vector(0, 0, 0)

if CLIENT then
	surface.CreateFont( "CurReworkedFont", {
		font = "Aurebesh",
		extended = false,
		size = 200,
		weight = 0,
		blursize = 0,
		scanlines = 0,
		antialias = false,
		underline = false,
		italic = false,
		strikeout = false,
		symbol = false,
		rotary = false,
		shadow = false,
		additive = false,
		outline = false,
	})
end

SWEP.ViewModelBoneMods = {
	["DC-15SA"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
}

SWEP.VElements = {
	["dc15sa"] = { type = "Model", model = "models/cs574/weapons/dc15sa_base.mdl", bone = "DC-15SA", rel = "", pos = Vector(0, 04.52, -0.98), angle = Angle(90, -90, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}},
	["dc15sa_cell"] = { type = "Model", model = "models/cs574/weapons/dc15sa_cell.mdl", bone = "", rel = "dc15sa", pos = Vector(0, 0, 0), angle = Angle(0, 0, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0},
	["dc15sa_cross"] = { type = "Model", model = "models/cs574/weapons/dc15sa_cross.mdl", bone = "", rel = "dc15sa", pos = Vector(0, 0, 0), angle = Angle(0, 0, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, active = true},
	["dc15sa_iron"] = { type = "Model", model = "models/cs574/weapons/dc15sa_iron.mdl", bone = "", rel = "dc15sa", pos = Vector(0, 0, 0), angle = Angle(0, 0, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, active = true},
	["laser"] = { type = "Model", model = "models/sw_battlefront/weapons/2019/a280cfe_laser.mdl", bone = "", rel = "dc15sa", pos = Vector(-7.5, -01.655, 6.4), angle = Angle(0, 0, 125), size = Vector(0.8, 0.8, 0.8), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, active = false  },
	["laser_beam"] = { type = "Model", model = "models/tfa/lbeam.mdl", bone = "", rel = "dc15sa", pos = Vector(5, 0, 4.15), angle = Angle(0, 0, 0), size = Vector(1.144, 1.144, 1.144), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, active = false  },
	["holosight"] = { type = "Model", model = "models/squad/sf_plates/sf_plate1x1.mdl", bone = "", rel = "dc15sa", pos = Vector(01, 1.02, 8.69), angle = Angle(-90, 0, 0), size = Vector(0.175, 0.175, 0), color = Color(255, 255, 255, 255), surpresslightning = true, material = "cs574/dc15sa_holosight", skin = 0, bodygroup = {}, active = false  },
	["scope4"] = { type = "Model", model = "models/sw_battlefront/weapons/e11_scope.mdl", bone = "", rel = "dc15sa", pos = Vector(7.25, 0.03, -0.985), angle = Angle(0, 0, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, active = false  },
	["scope4_ret"] = { type = "Model", model = "models/rtcircle.mdl", bone = "", rel = "dc15sa", pos = Vector(0.4, 0, 7.51), angle = Angle(180, 0, 180), size = Vector(0.26, 0.26, 0.26), color = Color(255, 255, 255, 255), surpresslightning = false, material = "!tfa_rtmaterial", skin = 0, bodygroup = {}, active = false  },
	["txt_ammo"] = { type = "Quad", bone = "", rel = "holosight", pos = Vector(01.47, -1.035, 0.75), angle = Angle(180, 90, 0), size = 0.0014, draw_func = nil, active = false},
	["txt_mod"] = { type = "Quad", bone = "", rel = "holosight", pos = Vector(01.7, -1.035, 0.2), angle = Angle(180, 90, 0), size = 0.00075, draw_func = nil, active = false},
	["txt_range"] = { type = "Quad", bone = "", rel = "holosight", pos = Vector(0.45, -1.045, 0.4), angle = Angle(180, 90, 0), size = 0.00085, draw_func = nil, active = false},
}

SWEP.WElements = {
	["dc15sa"] = { type = "Model", model = "models/cs574/weapons/dc15sa_base.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(8.5, 1.5, 01.45), angle = Angle(-05, 0, 180), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["dc15sa_cell"] = { type = "Model", model = "models/cs574/weapons/dc15sa_cell.mdl", bone = "", rel = "dc15sa", pos = Vector(0, 0, 0), angle = Angle(0, 0, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0},
	["dc15sa_cross"] = { type = "Model", model = "models/cs574/weapons/dc15sa_cross.mdl", bone = "", rel = "dc15sa", pos = Vector(0, 0, 0), angle = Angle(0, 0, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, active = true},
	["dc15sa_iron"] = { type = "Model", model = "models/cs574/weapons/dc15sa_iron.mdl", bone = "", rel = "dc15sa", pos = Vector(0, 0, 0), angle = Angle(0, 0, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, active = true},
	["laser"] = { type = "Model", model = "models/sw_battlefront/weapons/2019/a280cfe_laser.mdl", bone = "", rel = "dc15sa", pos = Vector(-7.5, -01.655, 6.4), angle = Angle(0, 0, 125), size = Vector(0.8, 0.8, 0.8), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, active = false  },
	["laser_beam"] = { type = "Model", model = "models/tfa/lbeam.mdl", bone = "", rel = "dc15sa", pos = Vector(5, 0, 4.15), angle = Angle(0, 0, 0), size = Vector(1.144, 1.144, 1.144), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, active = false  },
	["scope4"] = { type = "Model", model = "models/sw_battlefront/weapons/e11_scope.mdl", bone = "", rel = "dc15sa", pos = Vector(04.25, 0.03, -0.985), angle = Angle(0, 0, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, active = false  },
}

SWEP.ThirdPersonReloadDisable		=false
SWEP.Primary.DamageType 			= DMG_BULLET
SWEP.DamageType 					= DMG_BULLET
SWEP.RTScopeAttachment				= -1
SWEP.Scoped_3D 						= false
SWEP.ScopeReticule 					= "scope/gdcw_elcanreticle"
SWEP.Secondary.ScopeZoom 			= 1
SWEP.ScopeReticule_Scale 			= {1.1,1.1}

if surface then
	SWEP.Secondary.ScopeTable = nil
end

DEFINE_BASECLASS( SWEP.Base )

local CurHUDColor
local CurrentTimer = 0

function SWEP:Think(...)
	BaseClass.Think(self, ...)

	if self:IsAttached("stun_mod") then
		if ( self.Weapon:Clip1() <= self.Primary.ClipSize -1 ) and SERVER then
			if (CurrentTimer >= 1) then
				CurrentTimer = 0
				self.Weapon:SetClip1( self.Weapon:Clip1() + 1 )
			else
				CurrentTimer = CurrentTimer + 1
			end
		end
	end

	if CLIENT then
	if self:IsAttached("training_mod") then CurHUDColor=Color(255,120,0,150)
	elseif self:IsAttached("destabilized_mod") then CurHUDColor=Color(0,255,160,150)
	elseif self:IsAttached("explosive_mod") then CurHUDColor=Color(255,255,0,150)
	elseif self:IsAttached("stun_mod") then CurHUDColor=Color(245,245,245,150)
	else CurHUDColor=Color(0,120,255,150)
	end
	local o = self.Owner
	local oGSP = o:GetShootPos()
	local oGET = o:GetEyeTrace()
	local wu = oGSP:Distance( oGET.HitPos )
	wu = math.Round( wu, 0 )
	local m = wu / 52.49
	m = math.Round( m, 0 )
	if self:IronSights() and self:IsAttached("dc15sa_holo") then
		fm = self:GetFireMode()
		if fm==1 then self.VElements["txt_mod"].draw_func=function(weapon)draw.SimpleText("full-auto","CurReworkedFont",0,0,CurHUDColor,TEXT_ALIGN_CENTER,TEXT_ALIGN_TOP)end end
		if fm==2 then self.VElements["txt_mod"].draw_func=function(weapon)draw.SimpleText("2-burst","CurReworkedFont",0,0,CurHUDColor,TEXT_ALIGN_CENTER,TEXT_ALIGN_TOP)end end
		if fm==3 then self.VElements["txt_mod"].draw_func=function(weapon)draw.SimpleText("semi-auto","CurReworkedFont",0,0,CurHUDColor,TEXT_ALIGN_CENTER,TEXT_ALIGN_TOP)end end
		if self:IsAttached("dc15_laser_on")then self.VElements["txt_range"].draw_func=function(weapon)draw.SimpleText(""..m.."","CurReworkedFont",0,0,CurHUDColor,TEXT_ALIGN_CENTER,TEXT_ALIGN_TOP)end end
		self.VElements["holosight"].color = CurHUDColor
		if self:Clip1()<=99 then self.VElements["txt_ammo"].draw_func=function(weapon)draw.SimpleText(""..weapon:Clip1(),"CurReworkedFont",0,0,CurHUDColor,TEXT_ALIGN_CENTER,TEXT_ALIGN_TOP)end end
		if self:Clip1()<=9 then self.VElements["txt_ammo"].draw_func=function(weapon)draw.SimpleText("0"..weapon:Clip1(),"CurReworkedFont",0,0,CurHUDColor,TEXT_ALIGN_CENTER,TEXT_ALIGN_TOP)end end
		if self:Clip1()==0 then self.VElements["txt_ammo"].draw_func=function(weapon)draw.SimpleText("00","CurReworkedFont",0,0,CurHUDColor,TEXT_ALIGN_CENTER,TEXT_ALIGN_TOP)end end
	else
		self.VElements["holosight"].color=Color(0,0,0,0)
		self.VElements["txt_ammo"].draw_func=function(weapon)draw.SimpleText("","CurReworkedFont",0,0,Color(0,0,0,0),TEXT_ALIGN_CENTER,TEXT_ALIGN_TOP)end
		self.VElements["txt_mod"].draw_func=function(weapon)draw.SimpleText("","CurReworkedFont",0,0,Color(0,0,0,0),TEXT_ALIGN_CENTER,TEXT_ALIGN_TOP)end
		self.VElements["txt_range"].draw_func=function(weapon)draw.SimpleText("","CurReworkedFont",0,0,Color(0,0,0,0),TEXT_ALIGN_CENTER,TEXT_ALIGN_TOP)end
	end
	end
end

function SWEP:PrimaryAttack(...)
	if self:IsAttached("explosive_mod") then
		if self:CanPrimaryAttack() == true then
			local tr = self.Owner:GetEyeTrace()
			util.BlastDamage(self.Owner, self.Owner, tr.HitPos, 140, self.Primary.Damage*0.75)
		end
	end
	return BaseClass.PrimaryAttack(self, ...)
end
