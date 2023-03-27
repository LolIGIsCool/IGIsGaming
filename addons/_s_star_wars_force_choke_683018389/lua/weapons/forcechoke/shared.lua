if SERVER then // This is where the init.lua stuff goes.
	AddCSLuaFile ("shared.lua")
	SWEP.Weight = 1
	SWEP.AutoSwitchTo = false
	SWEP.AutoSwitchFrom = false

elseif CLIENT then
	SWEP.PrintName = "Force Choke"
	SWEP.Slot = 4
	SWEP.SlotPos = 1
	SWEP.DrawAmmo = false
	SWEP.DrawCrosshair = true
end
local a = "weapons/sound/choke.wav"
SWEP.Author = "PIXX"
SWEP.Contact = ""
SWEP.Purpose = "Force Choke"
SWEP.Instructions = "Left click to choke them (500 dmg), Right click to lift them up and choke them (20 dmg)"
SWEP.Category = "Force Choke"
SWEP.AccurateCrosshair = true
SWEP.DrawCrosshair = true
SWEP.Weight = 10
SWEP.DrawAmmo = false

SWEP.Spawnable = true
SWEP.AdminSpawnable = true

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"

SWEP.ViewModelFOV = 70
SWEP.ViewModelFlip = false

SWEP.UseHands = false
SWEP.ViewModel = "models/weapons/v_hands.mdl"
SWEP.WorldModel = ""

SWEP.ShowViewModel = true
SWEP.ShowWorldModel = false
SWEP.ViewModelBoneMods = {}

SWEP.Primary.Recoil = 5
SWEP.Primary.Damage = 0

SWEP.Pistol = false
SWEP.Rifle = false
SWEP.Shotgun = false
SWEP.Sniper = false

function SWEP:PrimaryAttack()
	self.Weapon:SetNextPrimaryFire( CurTime() + 1 )
	self.Weapon:SetNextSecondaryFire( CurTime() + 1 )
	local eyetrace = self.Owner:GetEyeTrace()
	local gun = weapons.Get("forcechoke")
	if SERVER then
	if eyetrace.Entity:IsPlayer() == true then
		if (self.Owner:GetRegiment() == "Imperial High Command") then --Vader
			eyetrace.Entity:TakeDamage(1000,self.Owner,"forcechoke")
		else
			-- They don't get OP Force choke.
			--eyetrace.Entity:TakeDamage(900,self.Owner,"forcechoke")
			eyetrace.Entity:TakeDamage(400,self.Owner,"forcechoke")
		end
	elseif eyetrace.Entity:IsNPC() == true then
		if (self.Owner:GetRegiment() == "Imperial High Command") then --Vader
			eyetrace.Entity:TakeDamage(1000,self.Owner,"forcechoke")
		else
			eyetrace.Entity:TakeDamage(400,self.Owner,"forcechoke")
		end
	end
	end
			self:EmitSound(a)

end
function SWEP:SecondaryAttack()
	self.Weapon:SetNextSecondaryFire( CurTime() + 1 )
	self.Weapon:SetNextPrimaryFire( CurTime() + 1 )
	local eyetrace = self.Owner:GetEyeTrace()
 	trace = self.Owner:GetEyeTraceNoCursor()
	if eyetrace.Entity:IsPlayer() then eyetrace.Entity:SetPos(trace.HitPos + trace.HitNormal / 32) end

	if SERVER then
	if eyetrace.Entity:IsPlayer() == true then
			eyetrace.Entity:TakeDamage(20,self.Owner,"forcechoke")
	elseif eyetrace.Entity:IsNPC() == true then
		eyetrace.Entity:TakeDamage(20,self.Owner,"forcechoke")
	end
	end
			self:EmitSound(a)
end
