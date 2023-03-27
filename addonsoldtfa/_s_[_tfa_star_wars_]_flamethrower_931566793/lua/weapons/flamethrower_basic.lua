SWEP.NZPaPName = "Flamethrower"
SWEP.Base				= "tfa_swsft_base"
SWEP.Category				= "TFA Star Wars In-Development"
SWEP.Author				= "Venator, Nikasacokica & DefyTheRush"
SWEP.Manufacturer = "Merr-Sonn Munitions, Inc."
SWEP.Contact				= "Venator"
SWEP.Spawnable				= true
SWEP.AdminSpawnable			= true
SWEP.DrawCrosshair			= true
SWEP.DrawCrosshairIS = false
SWEP.PrintName				= "Imperial Incinerator"
SWEP.Slot				= 4
SWEP.SlotPos				= 1
SWEP.Type 	= 	"Flamethrower"
SWEP.FireModeName = "Flamethrower"

SWEP.Primary.Damage = 115
SWEP.Primary.DamageTypeHandled = true
SWEP.Primary.Knockback = 0
SWEP.Primary.HullSize = 10
SWEP.Primary.NumShots = 1
SWEP.Primary.Automatic = true
SWEP.Primary.RPM = 600
SWEP.FiresUnderwater = false
SWEP.SelectiveFire = false
--Ammo Related
SWEP.Primary.ClipSize = 500
SWEP.Primary.DefaultClip = 500
SWEP.Primary.Ammo = "heavy_battery"
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
SWEP.MaxPenetrationCounter = 2
--[[PROJECTILES]]--
SWEP.ProjectileEntity = nil
SWEP.ProjectileVelocity = 0
SWEP.ProjectileModel = nil
--[[MODELS]]--
SWEP.HoldType = "crossbow"
SWEP.ViewModelFOV      	= 66
--SWEP.ViewModel  = "models/weapons/synbf3/c_dlt19.mdl"
--SWEP.WorldModel = "models/models/weapon/ven/custom/smg/ggn/flame/imperial_incinerator_world.mdl"
SWEP.ViewModel = "models/weapons/tfa_sw_z6_v2.mdl"
SWEP.WorldModel = "models/weapons/w_z6_rotary_blaster.mdl"
SWEP.ShowWorldModel = false
SWEP.UseHands = true


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
	if not self.Owner:GetViewModel() then return end
	if self.Shooting_Old == nil then
		self.Shooting_Old = false
	end
	local shooting = self:GetShooting()
	if shooting ~= self.Shooting_Old then
		if shooting then
			self:EmitSound("flamethrower/start.wav")
			self.NextIdleSound = CurTime() + 0.5
			local fx = EffectData()
			fx:SetEntity(self)
			fx:SetAttachment(1)
			util.Effect("waw_flame",fx)
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

SWEP.ViewModelBoneMods = {
	["barrel"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["minigun"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["ValveBiped.Bip01_R_Forearm"] = { scale = Vector(1, 1, 1), pos = Vector(-0.186, -2.408, 1.667), angle = Angle(0, 0, 0) }
}

SWEP.VElements = {
	["element_name"] = { type = "Model", model = "models/flamethrower.mdl", bone = "minigun", rel = "", pos = Vector(1.1, 7.4, -7.301), angle = Angle(90, -90, 0), size = Vector(0.8, 0.8, 0.8), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}
SWEP.WElements = {
	["element_name"] = { type = "Model", model = "models/flamethrower.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(10, 0.5, -0.201), angle = Angle(0, 0, -180), size = Vector(0.8, 0.8, 0.8), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	
--SWEP.ViewModelBoneMods = {
--	["v_dlt19_reference001"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) }
--}
--
--SWEP.VElements = {
--	["element_name"] = { type = "Model", model = "models/models/weapon/ven/custom/smg/ggn/flame/imperial_incinerator.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(8.831, 1.557, -2.597), angle = Angle(10.519, -94.676, 171.817), size = Vector(0.885, 0.885, 0.885), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}