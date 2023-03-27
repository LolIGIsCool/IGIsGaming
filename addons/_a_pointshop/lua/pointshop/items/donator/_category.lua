CATEGORY = {}

CATEGORY.Name = "Donator"
CATEGORY.Description = "Donator Shop."
CATEGORY.Icon = "shenesis/pointshop/igdonate.png"
CATEGORY.Color = "text"
CATEGORY.EquipLimit = 2
CATEGORY.Index = 6

function CATEGORY:CanAccess(ply)
	if ply:IsDonator() then
		return true
	else
		return false
	end
end

SH_POINTSHOP:RegisterCategory(CATEGORY, "donator")	