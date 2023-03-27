ITEM = {}

ITEM.ClassName = "boo_crew"
ITEM.Name = "Halloween Victor 2019/2020 (Boo! Crew)"
ITEM.Model = "models/bailey/boocrew_dc17/boocrew_dc17.mdl"
ITEM.AutoCameraAdjust = true

ITEM.PointsCost = 1
ITEM.PremiumPointsCost = 0

ITEM.AddToInventory = true

ITEM.BuySound = "weapons/shotgun/shotgun_cock.wav"


ITEM.WeaponName = "boocrew_dc17"

function ITEM:CanBuy(ply)
	return false, "This is a special event item only"
end

function ITEM:CanSell(ply)
	return false, "This is a special event item only"
end

SH_POINTSHOP:RegisterItem(ITEM)