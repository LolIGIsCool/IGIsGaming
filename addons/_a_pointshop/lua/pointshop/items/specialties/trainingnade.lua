ITEM = {}

ITEM.ClassName = "trainingnade"
ITEM.Name = "Training Grenade"
ITEM.Model = "models/cs574/explosif/grenade_train.mdl"
ITEM.AutoCameraAdjust = true

ITEM.PointsCost = 0 
ITEM.PremiumPointsCost = 100000

ITEM.AddToInventory = true

ITEM.BuySound = "weapons/shotgun/shotgun_cock.wav"

-- This is a custom field used by the functions,
-- it doesn't do anything by itself!
ITEM.WeaponName = "rw_sw_nade_training"

function ITEM:CanBuy(ply)
	return !ply:HasWeapon(self.WeaponName), SH_POINTSHOP:LangFormat("you_have_already_purchased_x", {item = self.Name})
end

SH_POINTSHOP:RegisterItem(ITEM)
