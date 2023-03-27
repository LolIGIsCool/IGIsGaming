ITEM = {}

ITEM.ClassName = "dc17"
ITEM.Name = "DC-17"
ITEM.Model = "models/sw_battlefront/weapons/dc17_blaster.mdl"
ITEM.AutoCameraAdjust = true

ITEM.PointsCost = 0
ITEM.PremiumPointsCost = 155000

ITEM.AddToInventory = true

ITEM.BuySound = "weapons/shotgun/shotgun_cock.wav"

-- This is a custom field used by the functions,
-- it doesn't do anything by itself!
ITEM.WeaponName = "rw_sw_dc17"

function ITEM:CanBuy(ply)
	return !ply:HasWeapon(self.WeaponName), SH_POINTSHOP:LangFormat("you_have_already_purchased_x", {item = self.Name})
end

SH_POINTSHOP:RegisterItem(ITEM)