ITEM = {}

ITEM.ClassName = "e11_atom"

ITEM.Name = "E11 Atom"
ITEM.Model = "models/bailey/e11/e11_epicallycoolskin.mdl"
ITEM.Skin = 2
ITEM.AutoCameraAdjust = true

ITEM.PointsCost = 0
ITEM.PremiumPointsCost = 50000

ITEM.AddToInventory = true

ITEM.BuySound = "weapons/shotgun/shotgun_cock.wav"

-- This is a custom field used by the functions,
-- it doesn't do anything by itself!
ITEM.WeaponName = "rw_sw_e11_atom"

function ITEM:CanBuy(ply)
	--if ply:GetUserGroup() ~= "Donator" or !ply:IsAdmin() then return end
	return !ply:HasWeapon(self.WeaponName), SH_POINTSHOP:LangFormat("you_have_already_purchased_x", {item = self.Name})
end

SH_POINTSHOP:RegisterItem(ITEM)