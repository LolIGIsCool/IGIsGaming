SWEP.NZPaPName = "Flamethrower"
SWEP.Base				= "tfa_gun_base"
SWEP.Category				= "TFA VANILLA"
SWEP.Author				= "niksacokica"
SWEP.Contact				= "niksacokica"
SWEP.Spawnable				= true
SWEP.AdminSpawnable			= true
SWEP.DrawCrosshair			= true
SWEP.DrawCrosshairIS = false
SWEP.PrintName				= "Flamethrower"
SWEP.Slot				= 4
SWEP.SlotPos				= 1
SWEP.Type 	= 	"Flamethrower"
SWEP.FireModeName = nil

SWEP.Primary.Damage = 100
SWEP.Primary.DamageTypeHandled = true
SWEP.Primary.Knockback = 0
SWEP.Primary.HullSize = 10
SWEP.Primary.NumShots = 1
SWEP.Primary.Automatic = true
SWEP.Primary.RPM = 600
SWEP.FiresUnderwater = false
SWEP.SelectiveFire = false
--Ammo Related
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = 500
SWEP.Primary.Ammo = "pistol"
SWEP.Primary.AmmoConsumption = 1
SWEP.DisableChambering = false
SWEP.Blowback_Shell_Enabled = false
SWEP.Blowback_Shell_Effect = ""
--Recoil Related
SWEP.Primary.KickUp = 0
SWEP.Primary.KickDown = 0
SWEP.Primary.KickHorizontal = 0
SWEP.Primary.StaticRecoilFactor = 0.5
--Firing Cone Related
SWEP.Primary.Spread = .01
SWEP.Primary.IronAccuracy = .005
SWEP.Primary.SpreadMultiplierMax = 3
--Range Related
SWEP.Primary.Range = 20 * 33
SWEP.Primary.RangeFalloff = -1
--Penetration Related
SWEP.MaxPenetrationCounter = 4
--[[PROJECTILES]]--
SWEP.ProjectileEntity = nil
SWEP.ProjectileVelocity = 0
SWEP.ProjectileModel = nil
--[[MODELS]]--
SWEP.HoldType = "ar2"
SWEP.ViewModelFOV      	= 66
SWEP.ViewModel  = "models/weapons/synbf3/c_dlt19.mdl"
SWEP.WorldModel = "models/weapons/synbf3/w_dlt19.mdl"
SWEP.ShowWorldModel = false
SWEP.UseHands = true
SWEP.ViewModelBoneMods = {
    ["v_dlt19_reference001"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) }
}
SWEP.VElements = {
	["element_name"] = { type = "Model", model = "models/flamethrower/flamethrower.mdl", bone = "v_dlt19_reference001", rel = "", pos = Vector(0.7, 8, 0), angle = Angle(180, 90, 180), size = Vector(0.35, 0.35, 0.35), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

SWEP.WElements = {
	["element_name"] = { type = "Model", model = "models/flamethrower/flamethrower.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(11, 0.5, -2.3), angle = Angle(-11, 1, 175), size = Vector(0.37, 0.37, 0.37), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}
--[[SPRINTING]]--
SWEP.RunSightsPos = Vector(0.201, 0, 1.759)
SWEP.RunSightsAng = Vector(-16.3, 27.799, -22.3)
--[[IRONSIGHTS]]--
SWEP.IronSightsPos = Vector(0, 0, 0)
SWEP.IronSightsAng = Vector(0, 0, 0)
SWEP.Secondary.IronFOV = 75
--[[EFFECTS]]--
--Shell eject override
SWEP.LuaShellEject = false
SWEP.LuaShellEffect = nil
SWEP.LuaShellModel = nil
SWEP.LuaShellScale = nil
SWEP.LuaShellEjectDelay = 0
--Tracer Stuff
SWEP.TracerName 		= nil
SWEP.TracerCount 		= 0
--Impact Effects
SWEP.ImpactEffect = nil
SWEP.ImpactDecal = nil
DEFINE_BASECLASS( SWEP.Base )

game.AddParticles("particles/waw_flamer.pcf")
PrecacheParticleSystem("flamethrower")

function SWEP:Think2( ... )
	if not IsFirstTimePredicted() then
		return BaseClass.Think2(self,...)
	end
	if not self:VMIV() then return end
	if self.Shooting_Old == nil then
		self.Shooting_Old = false
	end
	local shooting = self:GetStatus() == TFA.GetStatus("shooting")
	if shooting ~= self.Shooting_Old then
		if shooting then
			self:EmitSound("flamethrower/start.wav")
			self.NextIdleSound = CurTime() + 0.5
			local fx = EffectData()
			fx:SetEntity(self)
			fx:SetAttachment(1)
            if self:GetOwner():SteamID64() ~= "76561198247581466" then
			             util.Effect("waw_flame",fx)
            end
			--[[
			if self:IsFirstPerson() then
				ParticleEffectAttach("flamethrower",PATTACH_POINT_FOLLOW,self.OwnerViewModel,1)
			else
				ParticleEffectAttach("flamethrower",PATTACH_POINT_FOLLOW,self,1)
			end
			]]--
		else
			self:EmitSound("flamethrower/stop.wav")
			self.NextIdleSound = -1
			self:CleanParticles()
			--self:SendViewModelAnim( ACT_VM_PRIMARYATTACK_EMPTY)
		end
	end
	if shooting then
		if self.NextIdleSound and CurTime() > self.NextIdleSound then
			self:EmitSound("flamethrower/loop.wav")
			self.NextIdleSound = CurTime() + SoundDuration( "flamethrower/loop.wav" )
		end
	end
	self.Shooting_Old = shooting
	BaseClass.Think2(self,...)
end

function SWEP:ShootEffectsCustom() end
function SWEP:DoImpactEffect() return true end
local range
local bul = {}
local function cb( a, b, c )
	if b.HitPos:Distance( a:GetShootPos() ) > range then return end
	c:SetDamageType(DMG_BURN)
	if IsValid(b.Entity) and b.Entity.Ignite and not b.Entity:IsWorld() then
		b.Entity:Ignite( c:GetDamage(), 15 )
	end
end
function SWEP:ShootBullet()
	bul.Attacker = self.Owner
	bul.Distance = self.Primary.Range
	bul.HullSize = self.Primary.HullSize
	bul.Num = 1
	bul.Damage = self.Primary.Damage * ( 60 / self.Primary.RPM )
	bul.Distance = self.Primary.Range
	bul.Tracer = 0
	bul.Callback = cb
	bul.Src = self.Owner:GetShootPos()
	bul.Dir = self.Owner:GetAimVector()
	range = bul.Distance
	self.Owner:FireBullets(bul)
end
