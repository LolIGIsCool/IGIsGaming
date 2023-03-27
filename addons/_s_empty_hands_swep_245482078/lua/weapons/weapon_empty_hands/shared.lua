if SERVER then
	AddCSLuaFile ("shared.lua")
	SWEP.Weight = 0
	SWEP.AutoSwitchTo = false
	SWEP.AutoSwitchFrom = false
 
elseif CLIENT then 
	SWEP.PrintName = "Hands"
	SWEP.Slot = 0
	SWEP.SlotPos = 0
	SWEP.DrawAmmo = false
	SWEP.DrawCrosshair = true
	SWEP.Author			= ""
	SWEP.Contact		= ""
	SWEP.Purpose		= ""
	SWEP.Instructions	= ""
end

SWEP.Name					=  "Hands"
SWEP.Category				=  "Other"

SWEP.Spawnable				=  true
SWEP.AdminSpawnable			=  true

SWEP.WorldModel = "models/props_borealis/bluebarrel001.mdl"
SWEP.ViewModel = "models/props_borealis/bluebarrel001.mdl"

SWEP.Primary.Automatic		=  false
SWEP.Primary.Ammo			=  "none"

SWEP.Secondary.Automatic	=  false
SWEP.Secondary.Ammo			=  "none"

function SWEP:DrawWorldModel()
	return true
end

function SWEP:PreDrawViewModel(vm)
    return true
end

function SWEP:PrimaryAttack()
end

function SWEP:SecondaryAttack()
end

function SWEP:Reload()
end

function SWEP:Holster()
    if not SERVER then return true end

    self:GetOwner():DrawViewModel(true)
    self:GetOwner():DrawWorldModel(true)

    return true
end

function SWEP:Initialize()
	self:SetHoldType( "normal" )
	self.Weapon:DrawShadow(false)
end