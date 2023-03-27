local easynet = SH_POINTSHOP.easynet

function SH_POINTSHOP:PurchaseItem(ply, class)
	if not (self:Assert(!ply:SH_IsInventoryFull(), ply, self:LangFormat("your_inventory_is_full"))) then
		return end

	local item = self.Items[class]
	if (!item) then
		return end

	-- Do we even have access to the item's category?
	local category = self.Categories[item.Category]
	if (category.CanAccess and category:CanAccess(ply) == false) then
		return end

	if not (self:Assert(ply:SH_CanAfford(item), ply, self:LangFormat("you_cannot_afford_x", {item = item.Name, cost = self:GetPriceString(item, nil, ply)}))) then
		return end

	if not (self:Assert(!ply:SH_HasItem(class), ply, self:LangFormat("you_have_already_purchased_x", {item = item.Name}))) then
		return end

	local allowed, why = self:CanBuyItem(ply, item)
	if (allowed == false) then
		ply:SH_SendNotification(self.Language[why] or why, false)
		return
	end

	local itm
	if (item.AddToInventory ~= false) then
		itm = self:NewItemTable(class)
		ply:SH_AddItem(itm, true, true)
	end

	item:OnBuy(ply, itm)

	if (item.PointsCost > 0) then ply:SH_AddStandardPoints(math.Round(-item.PointsCost * ply:SH_GetPriceMultiplier()), nil, true, true) end
	if (item.PremiumPointsCost > 0) then ply:SH_AddPremiumPoints(math.Round(-item.PremiumPointsCost * ply:SH_GetPriceMultiplier()), nil, true, true) end

	ply:SH_TransmitPointshop()
	ply:SH_SavePointshop()

	ply:SH_SendNotification(self:LangFormat("you_have_purchased_x_for_y", {item = item.Name, spent = self:GetPriceString(item, nil, ply)}), true)

	self:OnItemBought(ply, item, itm)
end

function SH_POINTSHOP:SellItem(ply, id)
	local has, itm = ply:SH_HasItemID(id)
	if not (self:Assert(has and self.Items[itm.class] ~= nil, ply, self:LangFormat("you_dont_possess_item"))) then
		return end

	local item = self.Items[itm.class]

	local allowed, why = self:CanSellItem(ply, item, itm)
	if (allowed == false) then
		ply:SH_SendNotification(self.Language[why] or why, false)
		return
	end
    
	-- Unequip before selling!
	ply:SH_UnequipItem(itm, true, true)
	if (ply:SH_RemoveItemID(id, true, true)) then
        local sp, pp
        if (item.FullRefund) then
            sp, pp = math.Round(item.PointsCost * ply:SH_GetPriceMultiplier()), math.Round(item.PremiumPointsCost * ply:SH_GetPriceMultiplier())
        else    
            -- Give sell cash
            local mult = ply:SH_GetSellMultiplier()
            sp, pp = math.Round(item.PointsCost * ply:SH_GetPriceMultiplier() * mult), math.Round(item.PremiumPointsCost * ply:SH_GetPriceMultiplier() * mult)
		end
        
		if (item.PointsCost > 0) then ply:SH_AddStandardPoints(sp, nil, true, true) end
		if (item.PremiumPointsCost > 0) then ply:SH_AddPremiumPoints(pp, nil, true, true) end

		ply:SH_SavePointshop()
		ply:SH_TransmitInventory()
		ply:SH_TransmitPoints()
		ply:SH_TransmitEquipped(player.GetAll())
		ply:SH_SendNotification(self:LangFormat("you_have_sold_x_for_y", {item = item.Name, gain = self:GetPriceString(sp, pp)}), true)

		self:OnItemSold(ply, item, itm)
	else
		ply:SH_SendNotification(self:LangFormat("action_failed_try_again"), false)
	end
end

function SH_POINTSHOP:EquipItem(ply, id, equip)
	-- TODO? cooldown

	local has, itm = ply:SH_HasItemID(id)
	if not (self:Assert(has and self.Items[itm.class] ~= nil, ply, self:LangFormat("you_dont_possess_item"))) then
		return end

	local item = self.Items[itm.class]

	if (equip) then
		local allowed, why = self:CanEquipItem(ply, item, itm)
		if (allowed == false) then
			ply:SH_SendNotification(self.Language[why] or why, false)
			return
		end

		ply:SH_EquipItem(itm, item.Category, true, true)
		ply:SH_SendNotification(self:LangFormat("equipped_x", {item = item.Name}), true)
	else
		local allowed, why = self:CanUnequipItem(ply, item, itm)
		if (allowed == false) then
			ply:SH_SendNotification(self.Language[why] or why, false)
			return
		end

		ply:SH_UnequipItem(itm, true, true)
		ply:SH_SendNotification(self:LangFormat("unequipped_x", {item = item.Name}), true)
	end

	ply:SH_SavePointshop()
	ply:SH_TransmitEquipped(player.GetAll())
end

local function ClampAdjust(obj, fact, fct, def)
	def = def or 0

	obj[1] = math.Clamp(obj[1], def + -fact * fct, def + fact * fct)
	obj[2] = math.Clamp(obj[2], def + -fact * fct, def + fact * fct)
	obj[3] = math.Clamp(obj[3], def + -fact * fct, def + fact * fct)
end

function SH_POINTSHOP:AdjustItem(ply, class, pos, ang, scale)
	if (ply.SH_POINTSHOP_ADJUST_CD and ply.SH_POINTSHOP_ADJUST_CD[class] and ply.SH_POINTSHOP_ADJUST_CD[class] > CurTime()) then
		return end

	if not (self:Assert(ply:SH_CanAdjust(), ply, self:LangFormat("no_permission"))) then
		return end

	local item = self.Items[class]
	if (!item or !item.Adjustable) then
		return end

	local has, itm = ply:SH_HasItem(class)
	if not (self:Assert(has, ply, self:LangFormat("you_dont_possess_item"))) then
		return end

	-- no point adjusting something we aren't wearing!
	if (!ply:SH_HasEquipped(class)) then
		return end

	local fact = ply:SH_GetAdjustFactor()
	ClampAdjust(pos, fact, self.AdjustFactorIndividual.translate)
	ClampAdjust(ang, fact, self.AdjustFactorIndividual.rotate)
	ClampAdjust(scale, fact, self.AdjustFactorIndividual.scale, 1)

	local filter = RecipientFilter()
	filter:AddAllPlayers()
	filter:RemovePlayer(ply)

	easynet.Send(filter, "SH_POINTSHOP.SendAdjustment", {
		entity = ply,
		class = class,
		pos = pos,
		ang = ang,
		scale = scale,
	})

	ply.SH_POINTSHOP_ADJUSTS[class] = {pos, ang, scale}

	if (!ply.SH_POINTSHOP_ADJUST_CD) then
		ply.SH_POINTSHOP_ADJUST_CD = {}
	end

	ply.SH_POINTSHOP_ADJUST_CD[class] = CurTime() + self.AdjustSendTime
end