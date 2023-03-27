SWEP.Gun							= ("gun_base")
if (GetConVar(SWEP.Gun.."_allowed")) != nil then
	if not (GetConVar(SWEP.Gun.."_allowed"):GetBool()) then SWEP.Base = "tfa_blacklisted" SWEP.PrintName = SWEP.Gun return end
end
SWEP.Base							= "tfa_gun_base"
SWEP.Category						= "TFA StarWars Stryker"
SWEP.Manufacturer 					= ""
SWEP.Author							= "Stryker"
SWEP.Contact						= ""
SWEP.Spawnable						= true
SWEP.AdminSpawnable					= true
SWEP.DrawCrosshair					= true
SWEP.PrintName						= "TL-50 Inferno"
SWEP.Type							= "Imperial Heavy Blaster Repeater"
SWEP.DrawAmmo						= true
SWEP.Secondary.IronFOV				= 75
SWEP.Slot							= 4
SWEP.SlotPos						= 100
SWEP.Weight							= 1
SWEP.data 							= {}
SWEP.data.ironsights				= 0


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

SWEP.Primary.ClipSize				= 50
SWEP.Primary.DefaultClip			= 250
SWEP.Primary.RPM					= 400
SWEP.Primary.RPM_Burst				= 400
SWEP.Primary.Ammo					= "standard_battery"
SWEP.Primary.AmmoConsumption 		= 1
SWEP.Primary.Range 					= 40000
SWEP.Primary.RangeFalloff 			= -1
SWEP.Primary.NumShots				= 1
SWEP.Primary.Automatic				= true
SWEP.Primary.RPM_Semi				= nil
SWEP.Primary.BurstDelay				= 0.2
SWEP.Primary.Sound 					= Sound ("w/tl50.wav");
SWEP.Primary.ReloadSound 			= Sound ("w/heavy.wav");
SWEP.Primary.PenetrationMultiplier 	= 0
SWEP.Primary.Damage					= 31
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
SWEP.JumpAccuracyMultiplier			= 10
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
SWEP.TracerName 					= "rw_sw_laser_red"
SWEP.TracerCount 					= 1
SWEP.TracerLua 						= false
SWEP.TracerDelay					= 0.01
SWEP.ImpactEffect 					= "rw_sw_impact_red"
SWEP.ImpactDecal 					= "FadingScorch"

SWEP.VMPos = Vector(3, -0, -2)
SWEP.VMAng = Vector(0, 0, 0)

SWEP.IronSightTime 					= 0.45
SWEP.Primary.KickUp					= 0.25
SWEP.Primary.KickDown				= 0.09
SWEP.Primary.KickHorizontal			= 0.055
SWEP.Primary.StaticRecoilFactor 	= 0.60
SWEP.Primary.Spread					= 0.035
SWEP.Primary.IronAccuracy 			= 0.035
SWEP.Primary.SpreadMultiplierMax 	= 0.2
SWEP.Primary.SpreadIncrement 		= 0.15
SWEP.Primary.SpreadRecovery 		= 0.98
SWEP.DisableChambering 				= true
SWEP.MoveSpeed 						= 1
SWEP.IronSightsMoveSpeed 			= 0.85

SWEP.IronSightsPos = Vector(-5.425, -4, 01.7)
SWEP.IronSightsAng = Vector(0, 0, 0)
SWEP.RunSightsPos = Vector(5.226, -2, 0)
SWEP.RunSightsAng = Vector(-18, 36, -13.5)
SWEP.InspectPos = Vector(8, -4.8, -3)
SWEP.InspectAng = Vector(11.199, 38, 0)

function SWEP:FireBlast(pos,gravity,vel,dmg,white50,size,snd)
if (!SERVER) then return end
		local e = ents.Create("tl50_blast");

		e.Damage = 150;
		e.IsWhite50 = white or false;
		e.StartSize50 = 5;
		e.EndSize50 = e.StartSize50*0.75 or 5;


		local sound = snd or Sound("");

		e:SetPos(pos);
		e:Spawn();
		e:Activate();
		e:Prepare(self,sound,gravity,vel);
		e:SetColor(Color(255,255,255,1));
end

SWEP.Secondary.ClipSize             = 1
SWEP.Secondary.DefaultClip			= 1
SWEP.Secondary.Ammo					= "AR2AltFire"
SWEP.Secondary.Delay = 5

function SWEP:SecondaryAttack()
if self:Clip2() <= 0 then return end
if self:IsSafety() then return end
self:SetNextSecondaryFire(CurTime() + self.Secondary.Delay)
self:TakeSecondaryAmmo( 1 )

self:FireBlast(self:GetPos()+self:GetForward()*20+self:GetRight()*-0+Vector(-5,-14,50),true,0.6)
self.Weapon:EmitSound( "weapons/tl50_cannon.wav" )
end
local MaxTimer				=350
local CurrentTimer			=300
function SWEP:Think()
	if (self.Weapon:Clip2() < self.Secondary.ClipSize) and SERVER then
		if (CurrentTimer <= 0) then
			CurrentTimer = MaxTimer
			self.Weapon:SetClip2( self.Weapon:Clip2() + 1 )
		else
			CurrentTimer = CurrentTimer-1
		end
	end
end

SWEP.ViewModelBoneMods = {
	["v_dlt19_reference001"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) }
}

SWEP.VElements = {
	["tl50"] = { type = "Model", model = "models/sw_battlefront/weapons/tl50_repeater.mdl", bone = "v_dlt19_reference001", rel = "", pos = Vector(1.2, -03, -0.8), angle = Angle(0, -90, 0), size = Vector(1.2, 1.1, 1.2), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {[1] = 0, [2] = 1, [3] = 1} }
}

SWEP.WElements = {
	["tl50"] = { type = "Model", model = "models/sw_battlefront/weapons/tl50_repeater.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(2, 0.4, 0.5), angle = Angle(-12, 0, 172), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {[1] = 0, [2] = 1, [3] = 1} }
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
