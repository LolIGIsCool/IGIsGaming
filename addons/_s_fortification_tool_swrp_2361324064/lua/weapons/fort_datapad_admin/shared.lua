SWEP.PrintName = "Resource Datapad"
SWEP.Author =	"Joe"

SWEP.Spawnable =	true
SWEP.Adminspawnable =	false
SWEP.Category = "Datapads"
SWEP.ShowWorldModel = false

SWEP.Primary.Clipsize =	-1
SWEP.Primary.DefaultClip =	-1
SWEP.Primary.Automatic =	false
SWEP.Primary.Ammo =	"none"
SWEP.Slot = 3
SWEP.Instructions = [[
LMB - Opens resource allocation menu
Allocate upto 5000 resource to Engineers/Shore
Only do this if resources are needed and
the map isn't covered in placements already.
]]

SWEP.Secondary.Clipsize =	-1
SWEP.Secondary.DefaultClip =	-1
SWEP.Secondary.Automatic =	false
SWEP.Secondary.Ammo =	"none"
SWEP.UseHands = false


SWEP.HoldType = "slam"
SWEP.ViewModelFOV = 80
SWEP.ViewModelFlip = false
SWEP.ViewModel = "models/joes/c_datapad.mdl"
SWEP.WorldModel = "models/joes/w_datapad.mdl"
SWEP.ShowViewModel = true
SWEP.ShowWorldModel = true
SWEP.DrawCrosshair = false

function SWEP:PrimaryAttack()
	if CLIENT then JoeFort:OpenAdminFortMenu() end
	self:SetNextPrimaryFire(CurTime() + 1)
end

function SWEP:SecondaryAttack()

end

function SWEP:Initialize()

end

function SWEP:Holster()
	
	return true
end

function SWEP:OnRemove()

end
