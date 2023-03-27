ITEM = {}

ITEM.ClassName = "dlt19s_rain"

ITEM.Name = "DLT-19s Rainbow"
ITEM.Model = "models/sw_battlefront/weapons/dlt19_heavy_rifle_ext.mdl"
ITEM.Material = "models/rainbow/hull_gay.vmt"
ITEM.AutoCameraAdjust = true

ITEM.PointsCost = 0
ITEM.PremiumPointsCost = 250000

ITEM.AddToInventory = true

ITEM.BuySound = "weapons/shotgun/shotgun_cock.wav"

-- This is a custom field used by the functions,
-- it doesn't do anything by itself!
ITEM.WeaponName = "rw_sw_rain_dlt19s"

function ITEM:CanBuy(ply)
	--if ply:GetUserGroup() ~= "Donator" or !ply:IsAdmin() then return end
	return !ply:HasWeapon(self.WeaponName), SH_POINTSHOP:LangFormat("you_have_already_purchased_x", {item = self.Name})
end

SH_POINTSHOP:RegisterItem(ITEM)