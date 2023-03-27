ITEM = {}

ITEM.ClassName = "dlt19training"
ITEM.Name = "Training DLT19"
ITEM.Model = "models/kuro/sw_battlefront/weapons/bf1/dlt19.mdl"
ITEM.AutoCameraAdjust = true

ITEM.PointsCost = 0 
ITEM.PremiumPointsCost = 125000

ITEM.AddToInventory = true

ITEM.BuySound = "weapons/shotgun/shotgun_cock.wav"

-- This is a custom field used by the functions,
-- it doesn't do anything by itself!
ITEM.WeaponName = "rw_sw_trd_dlt19"

function ITEM:CanBuy(ply)
	return !ply:HasWeapon(self.WeaponName), SH_POINTSHOP:LangFormat("you_have_already_purchased_x", {item = self.Name})
end

SH_POINTSHOP:RegisterItem(ITEM)
