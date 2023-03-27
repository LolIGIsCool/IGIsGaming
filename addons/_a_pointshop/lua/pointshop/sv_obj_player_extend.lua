local easynet = SH_POINTSHOP.easynet

local meta = FindMetaTable("Player")

function meta:SH_SetupHands()
	local short = player_manager.TranslateToPlayerModelName(self:GetModel())
	local info = player_manager.TranslatePlayerHands(short)
	if (info) then
		local hands = self:GetHands()
		if (IsValid(hands)) then
			hands:SetModel(info.model)
			hands:SetSkin(info.skin)
			hands:SetBodyGroups(info.body)
		end
	end
end

function meta:SH_AddStandardPoints(points, message, notransmit, nosave)
	self:SH_SetStandardPoints(self:SH_GetStandardPoints() + points, notransmit, nosave)

	if (message) then
		SH_POINTSHOP:SendNotification(self, message, true)
	end
end

function meta:SH_AddPremiumPoints(points, message, notransmit, nosave)
	self:SH_SetPremiumPoints(self:SH_GetPremiumPoints() + points, notransmit, nosave)
	
    if (tonumber(points) > 30000) then
    	ulx.fancyLogAdmin(self, "#A recieved #s credits", points)
    end
    
	if (message) then
		SH_POINTSHOP:SendNotification(self, message, true)
	end
end

function meta:SH_SetStandardPoints(points, notransmit, nosave)
	local data = self.SH_POINTSHOP
	if (!data) then
		return end

	points = self:SH_LimitStandardPoints(points)
	data.standard_points = points

	if (!notransmit) then self:SH_TransmitPoints() end
	if (!nosave) then self:SH_SavePointshop() end
end

function meta:SH_SetPremiumPoints(points, notransmit, nosave)
	local data = self.SH_POINTSHOP
	if (!data) then
		return end

	points = self:SH_LimitPremiumPoints(points)
	data.premium_points = points

	if (!notransmit) then self:SH_TransmitPoints() end
	if (!nosave) then self:SH_SavePointshop() end
end

function meta:SH_AddItem(o, notransmit, nosave)
	local data = self.SH_POINTSHOP
	if (!data) then
		return false, "not loaded"
	end

	if (self:SH_IsInventoryFull()) then
		return false, "inventory full"
	end

	-- Adding item class?
	if (isstring(o)) then
		local item = SH_POINTSHOP.Items[o]
		if (item) then
			o = SH_POINTSHOP:NewItemTable(o)
		end
	end

	itm, item = SH_POINTSHOP:ParseItem(o)
	if (!item) then
		return false, "invalid item"
	end

	table.insert(data.inventory, itm)

	if (!notransmit) then self:SH_TransmitInventory() end
	if (!nosave) then self:SH_SavePointshop() end

	return true
end

function meta:SH_RemoveItemID(id, notransmit, nosave)
	local data = self.SH_POINTSHOP
	if (!data) then
		return false, "not loaded"
	end

	local new_inv = {}
	local found = false
	for _, itm in pairs (self:SH_GetInventory()) do
		if (itm.id == id) then
			found = true
			continue
		end

		table.insert(new_inv, itm)
	end

	if (found) then
		self.SH_POINTSHOP.inventory = new_inv

		if (!notransmit) then self:SH_TransmitInventory() end
		if (!nosave) then self:SH_SavePointshop() end

		return true
	else
		return false, "not found"
	end
end

function meta:SH_EquipItem(itm, notransmit, nosave)
	if (self:SH_HasEquippedID(itm.id)) then
		return end

	local item = SH_POINTSHOP.Items[itm.class]
	if (!item) then
		return end

	local catname = item.Category
	local category = catname and SH_POINTSHOP.Categories[catname]
	local num = 1

	local new_equip = {}
	table.insert(new_equip, itm)
	for _, eq in pairs (self:SH_GetEquipped()) do
		local eqitem = SH_POINTSHOP.Items[eq.class]
		if (eqitem and category and eqitem.Category == catname and category.EquipLimit > 0) then
			num = num + 1
			if (num > category.EquipLimit) then
				self.SH_POINTSHOP_ADJUSTS[eq.class] = nil
				eqitem:OnUnequip(self, eq)
				SH_POINTSHOP:OnItemUnequipped(self, eqitem, eq)

				continue
			end
		end

		table.insert(new_equip, eq)
	end

	self.SH_POINTSHOP.equipped = new_equip

	item:OnEquip(self, itm)
	SH_POINTSHOP:OnItemEquipped(self, item, itm)

	if (!notransmit) then self:SH_TransmitEquipped(player.GetAll()) end
	if (!nosave) then self:SH_SavePointshop() end
end

function meta:SH_UnequipItem(itm, notransmit, nosave)
	if (!self:SH_HasEquippedID(itm.id)) then
		return end

	local item = SH_POINTSHOP.Items[itm.class]
	if (!item) then
		return end

	local new_equip = {}
	for _, eq in pairs (self:SH_GetEquipped()) do
		if (eq.id == itm.id) then
			continue end

		table.insert(new_equip, eq)
	end

	self.SH_POINTSHOP.equipped = new_equip

	self.SH_POINTSHOP_ADJUSTS[itm.class] = nil
	item:OnUnequip(self, itm)
	SH_POINTSHOP:OnItemUnequipped(self, item, itm)

	if (!notransmit) then self:SH_TransmitEquipped(player.GetAll()) end
	if (!nosave) then self:SH_SavePointshop() end
end

function meta:SH_TransmitPointshop()
	easynet.Send(self, "SH_POINTSHOP.SendFull", {
		entity = self,
		inventory = SH_POINTSHOP:OptimizeInventory(self:SH_GetInventory()),
		equipped = SH_POINTSHOP:OptimizeInventory(self:SH_GetEquipped()),
		standard = self:SH_GetStandardPoints(),
		premium = self:SH_GetPremiumPoints(),
	})
end

function meta:SH_TransmitPoints()
	easynet.Send(self, "SH_POINTSHOP.SendPoints", {
		entity = self,
		standard = self:SH_GetStandardPoints(),
		premium = self:SH_GetPremiumPoints(),
	})
end

function meta:SH_TransmitInventory()
	easynet.Send(self, "SH_POINTSHOP.SendInventory", {
		entity = self,
		inventory = SH_POINTSHOP:OptimizeInventory(self:SH_GetInventory()),
	})
end

function meta:SH_TransmitEquipped(targ)
	easynet.Send(targ or self, "SH_POINTSHOP.SendEquipped", {
		entity = self,
		equipped = SH_POINTSHOP:OptimizeInventory(self:SH_GetEquipped()),
	})
end

function meta:SH_SavePointshop()
	SH_POINTSHOP:SavePlayerData(self)
end