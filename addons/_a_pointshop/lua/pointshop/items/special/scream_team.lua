ITEM = {}

ITEM.ClassName = "scream_team"
ITEM.Name = "Halloween Victor 2019/2020 (Scream Team)"
ITEM.Model = "models/bailey/screamteam_dc17/screamteam_dc17.mdl"
ITEM.AutoCameraAdjust = true

ITEM.PointsCost = 1
ITEM.PremiumPointsCost = 0

ITEM.AddToInventory = true

ITEM.BuySound = "weapons/shotgun/shotgun_cock.wav"


ITEM.WeaponName = "screamteam_dc17"

function ITEM:CanBuy(ply)
	return false, "This is a special event item only"
end

function ITEM:CanSell(ply)
	return false, "This is a special event item only"
end

SH_POINTSHOP:RegisterItem(ITEM)