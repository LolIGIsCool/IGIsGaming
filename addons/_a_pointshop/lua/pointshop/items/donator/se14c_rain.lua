ITEM = {}

ITEM.ClassName = "se14c_rain"

ITEM.Name = "SE-14c Rainbow"
ITEM.Model = "models/hauptmann/star wars/weapons/se14c.mdl"
ITEM.Material = "models/rainbow/hull_gay.vmt"
ITEM.AutoCameraAdjust = true

ITEM.PointsCost = 0
ITEM.PremiumPointsCost = 250000

ITEM.AddToInventory = true

ITEM.BuySound = "weapons/shotgun/shotgun_cock.wav"

-- This is a custom field used by the functions,
-- it doesn't do anything by itself!
ITEM.WeaponName = "rw_sw_rain_se14c"

function ITEM:CanBuy(ply)
	--if ply:GetUserGroup() ~= "Donator" or !ply:IsAdmin() then return end
	return !ply:HasWeapon(self.WeaponName), SH_POINTSHOP:LangFormat("you_have_already_purchased_x", {item = self.Name})
end

SH_POINTSHOP:RegisterItem(ITEM)