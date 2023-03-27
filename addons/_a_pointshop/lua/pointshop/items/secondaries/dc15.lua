ITEM = {}

ITEM.ClassName = "dc15"

ITEM.Name = "DC-15 Side Arm"
ITEM.Model = "models/cs574/weapons/dc15sa.mdl"
ITEM.AutoCameraAdjust = true

ITEM.PointsCost = 0
ITEM.PremiumPointsCost = 515000

ITEM.AddToInventory = true

ITEM.BuySound = "weapons/shotgun/shotgun_cock.wav"

-- This is a custom field used by the functions,
-- it doesn't do anything by itself!
ITEM.WeaponName = "at_sw_dc15sa_original"

function ITEM:CanBuy(ply)
	return !ply:HasWeapon(self.WeaponName), SH_POINTSHOP:LangFormat("you_have_already_purchased_x", {item = self.Name})
end

SH_POINTSHOP:RegisterItem(ITEM)