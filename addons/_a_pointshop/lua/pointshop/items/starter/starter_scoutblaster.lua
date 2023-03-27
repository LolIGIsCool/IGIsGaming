ITEM = {}

ITEM.ClassName = "starter_scoutblaster"

ITEM.Name = "EC-17 - Starter"
ITEM.Model = "models/bf2017/w_scoutblaster.mdl"
ITEM.AutoCameraAdjust = true

ITEM.PointsCost = 0
ITEM.PremiumPointsCost = 1000
ITEM.FullRefund = true

ITEM.AddToInventory = true

ITEM.BuySound = "weapons/shotgun/shotgun_cock.wav"

-- This is a custom field used by the functions,
-- it doesn't do anything by itself!
ITEM.WeaponName = "rw_sw_scoutblaster_st"

function ITEM:CanBuy(ply)
	return !ply:HasWeapon(self.WeaponName), SH_POINTSHOP:LangFormat("you_have_already_purchased_x", {item = self.Name})
end

SH_POINTSHOP:RegisterItem(ITEM)