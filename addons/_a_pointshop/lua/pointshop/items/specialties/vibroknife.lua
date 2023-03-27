ITEM = {}

ITEM.ClassName = "vibroknife"
ITEM.Name = "Vibro Knife"
ITEM.Model = "models/props/ig/knife/vibro_blade/vibro_blade.mdl"
ITEM.AutoCameraAdjust = true

ITEM.PointsCost = 0 
ITEM.PremiumPointsCost = 400000

ITEM.AddToInventory = true

ITEM.BuySound = "weapons/shotgun/shotgun_cock.wav"

-- This is a custom field used by the functions,
-- it doesn't do anything by itself!
ITEM.WeaponName = "imperialarts_knife_electroknife"

function ITEM:CanBuy(ply)
	return !ply:HasWeapon(self.WeaponName), SH_POINTSHOP:LangFormat("you_have_already_purchased_x", {item = self.Name})
end

SH_POINTSHOP:RegisterItem(ITEM)
