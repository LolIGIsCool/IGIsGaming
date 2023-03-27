ITEM = {}

ITEM.ClassName = "dualdc17s"

ITEM.Name = "Dual DC-17S"
ITEM.Model = "models/fisher/dc17s/dc17s.mdl"
ITEM.AutoCameraAdjust = true

ITEM.PointsCost = 0
ITEM.PremiumPointsCost = 475000

ITEM.AddToInventory = true

ITEM.BuySound = "weapons/shotgun/shotgun_cock.wav"

-- This is a custom field used by the functions,
-- it doesn't do anything by itself!
ITEM.WeaponName = "rw_sw_dual_dc17s"

function ITEM:CanBuy(ply)
	return !ply:HasWeapon(self.WeaponName), SH_POINTSHOP:LangFormat("you_have_already_purchased_x", {item = self.Name})
end

SH_POINTSHOP:RegisterItem(ITEM)
