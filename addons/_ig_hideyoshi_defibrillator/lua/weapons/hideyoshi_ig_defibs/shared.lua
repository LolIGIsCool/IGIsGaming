local debug = false

SWEP.Author             = "Hideyoshi Kinoshita"
SWEP.Contact            = "Mahiro Kinoshita#0014"
SWEP.Purpose            = "To revive!~ For the Community of Imperial Gaming"
SWEP.Instructions       = "Left Click on a Dead Player to Revive them!"

SWEP.Spawnable = true
SWEP.AdminSpawnable = true

SWEP.ViewModel = Model("models/weapons/v_defibbackstabber.mdl")
SWEP.WorldModel = Model("models/weapons/w_defibbackstabber.mdl")

SWEP.Primary.Clipsize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"
SWEP.Secondary.Clipsize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

function SWEP:Initialize()
	self:SetHoldType("knife")
end

function SWEP:SetupDataTables()
	self:NetworkVar("Int", 0, "DefibState")
end