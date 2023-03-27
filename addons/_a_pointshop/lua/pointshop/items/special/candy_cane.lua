ITEM = {}

ITEM.ClassName = "candy_cane"
ITEM.Name = "Christmas 2019 Present E-11"
ITEM.Model = "models/bailey/e11/e11_epicallycoolskin.mdl"
ITEM.AutoCameraAdjust = true

ITEM.PointsCost = 1
ITEM.PremiumPointsCost = 0

ITEM.AddToInventory = true

ITEM.BuySound = "weapons/shotgun/shotgun_cock.wav"


ITEM.WeaponName = "rw_sw_e11_candycane"

function ITEM:CanBuy(ply)
	return false, "This is a special event item only"
end

function ITEM:CanSell(ply)
	return false, "This is a special event item only"
end

SH_POINTSHOP:RegisterItem(ITEM)