local easynet = SH_POINTSHOP.easynet

local meta = FindMetaTable("Player")

function meta:SH_OpenPointShop()
	if (SERVER) then
		print("opening wtf")
		self:ProgressQuest("Extra",2)
		easynet.Send(self, "SH_POINTSHOP.OpenMenu")
	else
		SH_POINTSHOP:OpenMenu()
	end
end

function meta:SH_SendNotification(message, positive)
	SH_POINTSHOP:SendNotification(self, message, positive)
end

function meta:SH_GetStandardPoints()
	if (!self.SH_POINTSHOP) then
		return 0
	end

	return self.SH_POINTSHOP.standard_points
end

function meta:SH_GetPremiumPoints()
	if (!self.SH_POINTSHOP) then
		return 0
	end

	return self.SH_POINTSHOP.premium_points
end

function meta:SH_GetInventory()
	if (!self.SH_POINTSHOP) then
		return {}
	end

	return self.SH_POINTSHOP.inventory
end

function meta:SH_GetEquipped()
	if (!self.SH_POINTSHOP) then
		return {}
	end

	return self.SH_POINTSHOP.equipped
end

function meta:SH_CanAffordStandard(amt)
	return self:SH_GetStandardPoints() >= amt
end

function meta:SH_CanAffordPremium(amt)
	local amt2 = tonumber(amt)
	return self:SH_GetPremiumPoints() >= amt2
end

function meta:SH_CanAfford(std, prm)
	if (istable(std) and std.PointsCost) then
		local mult = self:SH_GetPriceMultiplier()
		return self:SH_CanAfford((std.PointsCost or 0) * mult, (std.PremiumPointsCost or 0) * mult)
	end

	return self:SH_CanAffordStandard(std) and self:SH_CanAffordPremium(prm)
end

function meta:SH_GetInventorySize()
	return SH_POINTSHOP.MaxInventorySize(self) or 512
end

function meta:SH_IsInventoryFull()
	return #self:SH_GetInventory() >= self:SH_GetInventorySize()
end

function meta:SH_HasItem(class)
	-- todo optimize
	for _, itm in pairs (self:SH_GetInventory()) do
		if (itm.class == class) then
			return true, itm
		end
	end

	return false
end

function meta:SH_HasItemID(id)
	-- todo optimize
	for _, itm in pairs (self:SH_GetInventory()) do
		if (itm.id == id) then
			return true, itm
		end
	end

	return false
end

function meta:SH_HasEquipped(class)
	-- todo optimize
	for _, itm in pairs (self:SH_GetEquipped()) do
		if (itm.class == class) then
			return true, itm
		end
	end

	return false
end

function meta:SH_HasEquippedID(id)
	-- todo optimize
	for _, itm in pairs (self:SH_GetEquipped()) do
		if (itm.id == id) then
			return true, itm
		end
	end

	return false
end

function meta:SH_LimitStandardPoints(amt)
	local i = SH_POINTSHOP.MaxStandardPoints(self) or 0
	if (i > 0) then
		return math.Clamp(amt, 0, i)
	end

	return amt
end

function meta:SH_LimitPremiumPoints(amt)
	local i = SH_POINTSHOP.MaxPremiumPoints(self) or 0
	if (i > 0) then
		return math.Clamp(amt, 0, i)
	end

	return amt
end

function meta:SH_CanAdjust()
	local b = SH_POINTSHOP.AdjustCheck(self)
	if (b == false) then
		return false
	end

	return true
end

function meta:SH_GetAdjustFactor()
	return SH_POINTSHOP.AdjustFactor(self) or 1
end

function meta:SH_CallItemFunction(name, ...)
	for _, eq in pairs (self:SH_GetEquipped()) do
		local item = SH_POINTSHOP.Items[eq.class]
		if (!item or !item[name]) then
			continue end

		item[name](item, self, eq, ...)
	end
end

function meta:SH_GetPriceMultiplier()
	local val = hook.Run("SH_POINTSHOP.GetPriceMultiplier", self)
	if (val ~= nil) then
		return val
	end

	return SH_POINTSHOP.PriceMultiplier(self)
end

function meta:SH_GetSellMultiplier()
	local val = hook.Run("SH_POINTSHOP.GetSellMultiplier", self)
	if (val ~= nil) then
		return val
	end

	return SH_POINTSHOP.SellMultiplier(self)
end