SWEP.PrintName 	         = "Thermal FLIR 3"
SWEP.Author              = "Phoenix\nEdited by Aiko"
SWEP.Contact             = ""
SWEP.Purpose             = "A SWEP adaptation of Thermal FLIR."
SWEP.Instructions        = "Left Click to Toggle Thermals.\nHold R and use Scroll Wheel to zoom in and out."

SWEP.ViewModel                  = "models/weapons/v_pistol.mdl"
SWEP.HoldType                   = "slam"
SWEP.Category = "Aiko's Sweps"

SWEP.Weight = 5
SWEP.AutoSwitchTo    = false
SWEP.AutoSwitchFrom    = false

SWEP.Slot             = 1
SWEP.SlotPos         = 4

SWEP.DrawAmmo         = false
SWEP.DrawCrosshair     = true

SWEP.Spawnable                  = true
SWEP.AdminSpawnable             = false

SWEP.Primary.ClipSize           = -1
SWEP.Primary.DefaultClip        = -1
SWEP.Primary.Automatic          = false
SWEP.Primary.Ammo               = "none"
SWEP.Primary.Delay				= 0.25

SWEP.Secondary.ClipSize         = -1
SWEP.Secondary.DefaultClip      = -1
SWEP.Secondary.Automatic        = true
SWEP.Secondary.Ammo             = "none"
SWEP.Secondary.Delay			= 1.75


function SWEP:DrawWorldModel() return false end
function SWEP:ShouldDrawViewModel() return false end

function SWEP:Initialize()
	self:SetWeaponHoldType(self.HoldType)
	self:DrawShadow(false)
end

function SWEP:SetupDataTables()
	self:NetworkVar( "Float", 0, "Battery" )

	if ( SERVER ) then
		self:SetBattery( 100 )
	end
end