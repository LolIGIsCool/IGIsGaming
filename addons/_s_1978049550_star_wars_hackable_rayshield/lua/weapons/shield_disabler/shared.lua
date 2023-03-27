SWEP.Author			= "Eternal"
SWEP.Contact			= ""
SWEP.Purpose			= ""
SWEP.Instructions		= "Left click to disable rayshield"
 
SWEP.Spawnable			= false
SWEP.AdminSpawnable		= false
 
SWEP.ViewModel			= "models/weapons/v_pistol.mdl"
SWEP.WorldModel		= "models/weapons/w_pistol.mdl"
 
SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo		= "none"
 
SWEP.Secondary.ClipSize	= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo		= "none"

function SWEP:PrimaryAttack()
	if SERVER then
	local ply = self:GetOwner()
	local ent = ply:GetNWEntity("enttodis")
	if (ent:IsValid()) then
 			ent:Remove()
 	end
 	if (self:IsValid()) then
 			self:Remove()
 	end
 	end
end