-----------------------------------------------------------------------------------------------------
-- Config section here
-- Features
SWEP.AllowDamage = true						// Should a player be able to inflict damage at all?
SWEP.GiveWeaponsBack = true					// Should the player get the weapons he had back after he is revived? (Will spawn with default weps)
SWEP.DeathBeepEnabled = true				// Should a player hear a flat tone when they die?
SWEP.GiveMedicRPCash = 0				// How much cash should a medic receive upon reviving someone? Set to 0 to disable.
SWEP.ReviveHeartMedicsOnly = true			// Should only people with SWEP equipped see the heart or every player?

-- Settings (will not take effect if feature is disabled)
SWEP.DeathSound = "HL1/fvox/flatline.wav"	// Sound the player hears when they die (DeathBeep)
SWEP.Damage = 20							// Damage the swep does when using for self-defence
SWEP.HPAfterRespawn = 50					// HP the revived player will have after being revived
SWEP.TimeToRevive = 300						// How many seconds should players be dead for before they can not be revived?
SWEP.ChargeTime = 4						// How many seconds should charging the paddle keep a charge for?
SWEP.GhostTime = 1							// How long should players be ghosted for upon revival? (No collision with players)
SWEP.ReviveDistance = 80					// How far should a medic be able to revive a player?
SWEP.ReviveHeartDistance = 500 			// How far should someone be from a ragdoll to see the revive heart picture?
SWEP.HitDistance = 100						// How far should a medic be from a player to damage another player?
-- END CONFIG
-----------------------------------------------------------------------------------------------------
SWEP.Instructions = "Left click to revive/attack!"
SWEP.UseHands = false
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.Category = "CustomHQ"
SWEP.ViewModelFOV = 62
SWEP.AnimPrefix = "rpg"
SWEP.Primary.Damage = 0
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = 1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = 1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"
SWEP.WorldModel = Model("models/weapons/custom/w_defib.mdl")
SWEP.ViewModel = Model("models/weapons/custom/v_defib.mdl")
SWEP.PrintName = "Defibrillator"
SWEP.Author = "CustomHQ"
SWEP.Slot = 1
SWEP.SlotPos = 1
SWEP.CanUse = 0
util.PrecacheModel("models/weapons/custom/defib2")
if SERVER then
	function makefx(ent, pos, fx, ply, broadcast)
		net.Start("defibfx")
		net.WriteEntity(ent)
		net.WriteVector(pos)
		net.WriteString(fx)
		net.WriteEntity(ply)
		if broadcast then net.Broadcast()
		else net.Send(ply) end
	end
	util.AddNetworkString("defibfx")
	util.AddNetworkString("defibgetents")
	util.AddNetworkString("defibgiveents")
	resource.AddWorkshop("824479456")
	AddCSLuaFile("cl_init.lua")
	include("sv_init.lua")
	function SWEP:OnDrop() self:makefxN("decharge") end
	function SWEP:OnRemove() self:makefxN("decharge") end
end
function SWEP:makefxN(type) makefx(self.Owner, Vector(0, 0, 0), type, self.Owner, false) end
--it's clientside location, need to talk with client and gmod makes that a pain in ass (afaik)
local delay = 4
local shouldOccur = true

function SWEP:PrimaryAttack()
	if CLIENT or CurTime() > self.CanUse then return end
	if shouldOccur then
	self.Owner:SetMoveType(MOVETYPE_NONE)
	shouldOccur = false
	if IsValid(self) then self:SendWeaponAnim(ACT_VM_SECONDARYATTACK) end
	timer.Simple(3, function()
	net.Start("defibgetents")
	net.Send(self.Owner)
	self.Owner:SetMoveType(MOVETYPE_WALK)
	timer.Simple( delay, function() shouldOccur = true end )
	end)
	else
	self.Owner:PrintMessage(HUD_PRINTTALK, "Your Defibrillator is recharging!")
end
end

function SWEP:SecondaryAttack()
	if CLIENT or CurTime() <= self.CanUse then return end
	--double animation because GMod is broken and doesn't play anims properly, hack around it
	self:SendWeaponAnim(ACT_VM_IDLE)
	timer.Simple(0.16, function() if IsValid(self) then self:SendWeaponAnim(ACT_VM_SECONDARYATTACK) end end)
	self:SetNextSecondaryFire(CurTime()+self.ChargeTime+2)
	timer.Simple(.9, function()
		if !IsValid(self.Owner) or !IsValid(self) then return end
		self.Owner:EmitSound("buttons/button1.wav", 50)
		self.CanUse = CurTime() + self.ChargeTime
		self:makefxN("charge")
	end)
end
function SWEP:Initialize()
	self:SetHoldType("knife")
end
function SWEP:Deploy()
	self.CanUse = 0
	return true
end
function SWEP:Holster()
	if SERVER then self:makefxN("decharge") end
	return true
end
function SWEP:Reload() end