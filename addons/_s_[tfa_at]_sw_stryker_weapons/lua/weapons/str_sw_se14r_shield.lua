SWEP.Gun							= ("gun_base")
if (GetConVar(SWEP.Gun.."_allowed")) != nil then
	if not (GetConVar(SWEP.Gun.."_allowed"):GetBool()) then SWEP.Base = "tfa_blacklisted" SWEP.PrintName = SWEP.Gun return end
end
SWEP.Base							= "tfa_gun_base"
SWEP.Category						= "TFA StarWars Stryker"
SWEP.Manufacturer 					= ""
SWEP.Author							= "ChanceSphere574"
SWEP.Contact						= ""
SWEP.Spawnable						= true
SWEP.AdminSpawnable					= true
SWEP.DrawCrosshair					= true
SWEP.DrawCrosshairIS 				= false
SWEP.PrintName						= "SE-14r Shielded"
SWEP.Type							= "Imperial Weaponized Shield"
SWEP.DrawAmmo						= true
SWEP.data 							= {}
SWEP.data.ironsights				= 0
SWEP.Secondary.IronFOV				= 75
SWEP.Slot							= 2
SWEP.SlotPos						= 100

SWEP.FiresUnderwater 				= true

SWEP.IronInSound 					= nil
SWEP.IronOutSound 					= nil
SWEP.CanBeSilenced					= false
SWEP.Silenced 						= false
SWEP.DoMuzzleFlash 					= false
SWEP.SelectiveFire					= false
SWEP.DisableBurstFire				= false
SWEP.OnlyBurstFire					= false
SWEP.DefaultFireMode 				= "auto"
SWEP.FireModeName 					= nil
SWEP.DisableChambering 				= true

SWEP.Primary.ClipSize				= 32
SWEP.Primary.DefaultClip			= 32*5
SWEP.Primary.RPM					= 765
SWEP.Primary.RPM_Burst				= 765
SWEP.Primary.Ammo					= "light_battery"
SWEP.Primary.AmmoConsumption 		= 1
SWEP.Primary.Range 					= 32000
SWEP.Primary.RangeFalloff 			= -1
SWEP.Primary.NumShots				= 1
SWEP.Primary.Automatic				= true
SWEP.Primary.RPM_Semi				= nil
SWEP.Primary.BurstDelay				= 0.3
SWEP.Primary.Sound 					= Sound ("w/se14c.wav");
SWEP.Primary.ReloadSound 			= Sound ("w/pistols.wav");
SWEP.Primary.PenetrationMultiplier 	= 0
SWEP.Primary.Damage					= 17
SWEP.Primary.HullSize 				= 0
SWEP.DamageType 					= nil

SWEP.DoMuzzleFlash 					= false

SWEP.FireModes = {
	"4burst"
}

SWEP.IronRecoilMultiplier			= 0.66
SWEP.CrouchRecoilMultiplier			= 0.55
SWEP.JumpRecoilMultiplier			= 1.3
SWEP.WallRecoilMultiplier			= 1.1
SWEP.ChangeStateRecoilMultiplier	= 1.3
SWEP.CrouchAccuracyMultiplier		= 0.7
SWEP.ChangeStateAccuracyMultiplier	= 1.18
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
SWEP.ViewModelFOV					= 75
SWEP.ViewModelFlip					= false
SWEP.MaterialTable 					= nil
SWEP.UseHands 						= true
SWEP.HoldType 						= "duel"

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

SWEP.VMPos = Vector(08, -04, -02)
SWEP.VMAng = Vector(0,0,0)

SWEP.IronSightTime 					= 0.25
SWEP.Primary.KickUp					= 0.35
SWEP.Primary.KickDown				= 0.12
SWEP.Primary.KickHorizontal			= 0.055
SWEP.Primary.StaticRecoilFactor 	= 0.5
SWEP.Primary.Spread					= 0.025
SWEP.Primary.IronAccuracy 			= 0.01
SWEP.Primary.SpreadMultiplierMax 	= 0.6
SWEP.Primary.SpreadIncrement 		= 0.35
SWEP.Primary.SpreadRecovery 		= 0.98
SWEP.DisableChambering 				= true
SWEP.MoveSpeed 						= 1
SWEP.IronSightsMoveSpeed 			= 0.85

SWEP.IronSightsPos = Vector(0, 0, 0)
SWEP.IronSightsAng = Vector(0, 0, 0)
SWEP.RunSightsPos = Vector(2, -9.5, -15)
SWEP.RunSightsAng = Vector(39, -0.5, -2)
SWEP.InspectPos = Vector(8, -4.8, -3)
SWEP.InspectAng = Vector(11.199, 38, 0)

SWEP.ViewModelBoneMods = {
	["v_scoutblaster_reference001"] = { scale = Vector(0.005, 0.005, 0.005), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) }
}

SWEP.VElements = {
	["se14c"] = { type = "Model", model = "models/hauptmann/star wars/weapons/se14c.mdl", bone = "v_scoutblaster_reference001", rel = "", pos = Vector(-0.5, 0, -02.95), angle = Angle(0, 90, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
}

SWEP.WElements = {
	["se14c"] = { type = "Model", model = "models/hauptmann/star wars/weapons/se14c.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3.5, 1.2, -1.5), angle = Angle(0, -07, 180), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
}

SWEP.Animations = { --Override this after SWEP:Initialize, for example, in attachments
	["reload"] = {
		["type"] = TFA.Enum.ANIMATION_ACT, --Sequence or act
		["value"] = ACT_VM_RELOAD_EMPTY,
		["enabled"] = true
	},
	["reload_empty"] = {
		["type"] = TFA.Enum.ANIMATION_ACT, --Sequence or act
		["value"] = ACT_VM_RELOAD_EMPTY
	},
	["reload_silenced"] = {
		["type"] = TFA.Enum.ANIMATION_ACT, --Sequence or act
		["value"] = ACT_VM_RELOAD_EMPTY,
		["enabled"] = true
	},
}

SWEP.ThirdPersonReloadDisable		= false
SWEP.Primary.DamageType 			= DMG_BULLET
SWEP.DamageType 					= DMG_BULLET
SWEP.RTScopeAttachment				= -1
SWEP.Scoped_3D 						= false
SWEP.ScopeReticule 					= "#sw/visor/sw_ret_redux_red" 
SWEP.Secondary.ScopeZoom 			= 4
SWEP.ScopeReticule_Scale 			= {1.1,1.1}
if surface then
	SWEP.Secondary.ScopeTable = nil --[[
		{
			["ScopeMaterial"] =  Material("#sw/visor/sw_ret_redux_red.png", "smooth"),
			["ScopeBorder"] = color_black,
			["ScopeCrosshair"] = { ["r"] = 0, ["g"]  = 0, ["b"] = 0, ["a"] = 0, ["s"] = 1 }
		}
	]]--
end
DEFINE_BASECLASS( SWEP.Base )


function SWEP:Deploy()
	self:SetupShield();
	return true
end


SWEP.canBeDestroyedByDamage = false;
SWEP.onlyExplosionDamage = false;
SWEP.defaultHealth = 5000;

function SWEP:SetupShield()
	if CLIENT then return end;
	self.shieldProp = ents.Create("prop_physics");
	self.shieldProp:SetModel("models/bshields/rshield.mdl");
	self.shieldProp:Spawn(); 
	self.shieldProp:SetModelScale(0,0);
	local phys = self.shieldProp:GetPhysicsObject();

	if not IsValid(phys) then
		self.Owner:ChatPrint("not valid physics object!");
		return;
	end

	phys:SetMass(5000);
	
	local nothand = false;

	local attach = self.Owner:LookupAttachment("bip01_spine4");
	
	local up = -04;
	local forward = 4;
	local right = 05;
	
	local aforward = 0;
	local aup = 90;
	
	if nothand then
	    up = -12;
		forward = 4.44;
		aforward = 11;

		aup = 100;
		right = 2;
	end
	--local attachTable = self.Owner:GetAttachment(attach);
    --local angle = attachTable.Ang
    self.shieldProp:FollowBone(self.Owner,1);
	--self.shieldProp:SetPos(Vector(20, 10, 45));
    self.shieldProp:SetPos(Vector(5, 10, 10));
	--attachTable.Ang:RotateAroundAxis(attachTable.Ang:Forward(),aforward);
	--attachTable.Ang:RotateAroundAxis(attachTable.Ang:Up(),aup);
	self.shieldProp:SetAngles(Angle(270, 180, 0));
	self.shieldProp:SetCollisionGroup( COLLISION_GROUP_WORLD );
	

	timer.Simple(0.2,function()
		if IsValid(self) and IsValid(self.shieldProp) then
			self.shieldProp:SetModelScale(1,0);
		end
	end)
end


function SWEP:Holster()
	if CLIENT then return end;
	if not IsValid(self.shieldProp) then return true end;
	self.shieldProp:Remove();
	return true;
end

function SWEP:OnDrop()
	if CLIENT then return end;
	if not IsValid(self.shieldProp) then return true end;
	self.shieldProp:Remove();
	return true;
end

function SWEP:OnRemove()
	if CLIENT then return end;
	if not IsValid(self.shieldProp) then return true end;
	self.shieldProp:Remove();
	return true;
end