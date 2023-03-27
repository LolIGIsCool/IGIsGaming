local easynet = SH_POINTSHOP.easynet

hook.Add("Think", "SH_POINTSHOP.PlayerReady", function()
	if (IsValid(LocalPlayer())) then
		hook.Remove("Think", "SH_POINTSHOP.PlayerReady")
		easynet.SendToServer("SH_POINTSHOP.PlayerReady")

		SH_POINTSHOP:PlayerReady()
	end
end)

function SH_POINTSHOP:PlayerReady()
	hook.Run("SH_POINTSHOP.PlayerReady")

	-- Setup the config folder for this server
	local ip = game.GetIPAddress()
	ip = ip:Replace(".", "_"):Replace(":", "_")

	SH_POINTSHOP:SetWorkFolder("sh_pointshop/" .. ip)

	-- Load adjustments and 76561198006360138
	LocalPlayer().SH_POINTSHOP_ADJUSTS = LocalPlayer().SH_POINTSHOP_ADJUSTS or {}

	for cls, adj in pairs (self:ReadJSON("adjustments.txt")) do
		local px, py, pz = adj.px or 0, adj.py or 0, adj.pz or 0
		local ax, ay, az = adj.ax or 0, adj.ay or 0, adj.az or 0
		local sx, sy, sz = adj.sx or 1, adj.sy or 1, adj.sz or 1

		local pos, ang, scale = Vector(px, py, pz), Angle(ax, ay, az), Vector(sx, sy, sz)
		LocalPlayer().SH_POINTSHOP_ADJUSTS[cls] = {pos, ang, scale}
	end
end

function SH_POINTSHOP:SendEquippedAdjustments()
	local adjustments = self:ReadJSON("adjustments.txt")
	for _, eq in pairs (LocalPlayer():SH_GetEquipped()) do
		local adj = adjustments[eq.class]
		if (adj) then
			easynet.SendToServer("SH_POINTSHOP.ApplyAdjustment", {
				class = eq.class,
				px = adj.px or 0,
				py = adj.py or 0,
				pz = adj.pz or 0,
				ax = adj.ax or 0,
				ay = adj.ay or 0,
				az = adj.az or 0,
				sx = adj.sx or 1,
				sy = adj.sy or 1,
				sz = adj.sz or 1, -- 76561198006360138
			})
		end
	end
end

function SH_POINTSHOP:OnItemBought(itm)
	local item
	if (itm and itm.class) then
		item = self.Items[itm.class]
		hook.Run("SH_POINTSHOP.OnItemBought", LocalPlayer(), item, itm)
	end

	if (item and item.BuySound and item.BuySound ~= "") then
		surface.PlaySound(item.BuySound)
	end
end

function SH_POINTSHOP:OnItemSold(itm)
	local item = self.Items[itm.class]
	hook.Run("SH_POINTSHOP.OnItemSold", LocalPlayer(), item, itm)

	if (item and item.SellSound and item.SellSound ~= "") then
		surface.PlaySound(item.SellSound)
	end
end

function SH_POINTSHOP:OnItemEquipped(itm)
	local item = self.Items[itm.class]
	hook.Run("SH_POINTSHOP.OnItemEquipped", LocalPlayer(), item, itm)

	if (item and item.EquipSound and item.EquipSound ~= "") then
		surface.PlaySound(item.EquipSound)
	end
end

function SH_POINTSHOP:OnItemUnequipped(itm)
	local item = self.Items[itm.class]
	hook.Run("SH_POINTSHOP.OnItemUnequipped", LocalPlayer(), item, itm)

	if (item and item.UnequipSound and item.UnequipSound ~= "") then
		surface.PlaySound(item.UnequipSound)
	end
end

hook.Add("PlayerButtonDown", "SH_POINTSHOP.PlayerButtonDown", function(ply, btn)
	if (IsFirstTimePredicted() and SH_POINTSHOP.MenuKey == btn) then
		SH_POINTSHOP:OpenMenu()
	end
end)

easynet.Callback("SH_POINTSHOP.OpenMenu", function(data)
	SH_POINTSHOP:OpenMenu()
end)

easynet.Callback("SH_POINTSHOP.SendNotification", function(data)
	SH_POINTSHOP:SendNotification(nil, data.message, data.positive)
end)

easynet.Callback("SH_POINTSHOP.SendFull", function(rcv)
	local ent = rcv.entity
	if (!IsValid(ent)) then
		return end

	local data = {
		standard_points = rcv.standard,
		premium_points = rcv.premium,
		inventory = SH_POINTSHOP:UnoptimizeInventory(rcv.inventory),
		equipped = SH_POINTSHOP:UnoptimizeInventory(rcv.equipped),
	}

	ent.SH_POINTSHOP = data
	SH_POINTSHOP:RebuildEquippedModels(ent)
	SH_POINTSHOP:RebuildDrawCalls(ent)

	if (LocalPlayer() == ent) then
		SH_POINTSHOP:CallPanelHook("OnPointsUpdated", rcv.standard, rcv.premium) -- 76561198006360147
		SH_POINTSHOP:CallPanelHook("OnInventoryUpdated", rcv.inventory)
		SH_POINTSHOP:CallPanelHook("OnEquippedUpdated", rcv.equipped)

		SH_POINTSHOP:SendEquippedAdjustments()
	end
end)

easynet.Callback("SH_POINTSHOP.SendPoints", function(rcv)
	local ent = rcv.entity
	if (!IsValid(ent)) then
		return end

	local data = ent.SH_POINTSHOP
	if (!data) then
		return end

	data.standard_points = rcv.standard
	data.premium_points = rcv.premium

	if (LocalPlayer() == ent) then
		SH_POINTSHOP:CallPanelHook("OnPointsUpdated", rcv.standard, rcv.premium)
	end
end)

easynet.Callback("SH_POINTSHOP.SendInventory", function(rcv)
	local ent = rcv.entity
	if (!IsValid(ent)) then
		return end

	local data = ent.SH_POINTSHOP
	if (!data) then
		return end

	data.inventory = SH_POINTSHOP:UnoptimizeInventory(rcv.inventory)

	if (LocalPlayer() == ent) then
		SH_POINTSHOP:CallPanelHook("OnInventoryUpdated", rcv.inventory)
	end
end)

easynet.Callback("SH_POINTSHOP.SendEquipped", function(rcv)
	local ent = rcv.entity
	if (!IsValid(ent)) then
		return end

	local data = ent.SH_POINTSHOP
	if (!data) then
		if (ent == LocalPlayer()) then
			return
		else
			ent.SH_POINTSHOP = {
				standard_points = "",
				premium_points = "",
				inventory = {},
				equipped = {},
			}
			data = ent.SH_POINTSHOP
		end
	end

	data.equipped = SH_POINTSHOP:UnoptimizeInventory(rcv.equipped)
	SH_POINTSHOP:RebuildEquippedModels(ent)
	SH_POINTSHOP:RebuildDrawCalls(ent)

	if (LocalPlayer() == ent) then
		SH_POINTSHOP:CallPanelHook("OnEquippedUpdated", rcv.equipped)

		SH_POINTSHOP:SendEquippedAdjustments()
	end
end)

easynet.Callback("SH_POINTSHOP.SendAdjustment", function(rcv)
	local ent = rcv.entity
	if (!IsValid(ent)) then
		return end

	if (!ent.SH_POINTSHOP_ADJUSTS) then
		ent.SH_POINTSHOP_ADJUSTS = {} -- 76561198006360134
	end

	ent.SH_POINTSHOP_ADJUSTS[rcv.class] = {rcv.pos, rcv.ang, rcv.scale}
end)

easynet.Callback("SH_POINTSHOP.ItemBought", function(rcv)
	SH_POINTSHOP:OnItemBought(rcv.itm)
end)

easynet.Callback("SH_POINTSHOP.ItemSold", function(rcv)
	SH_POINTSHOP:OnItemSold(rcv.itm)
end)

easynet.Callback("SH_POINTSHOP.ItemEquipped", function(rcv)
	SH_POINTSHOP:OnItemEquipped(rcv.itm)
end)

easynet.Callback("SH_POINTSHOP.ItemUnequipped", function(rcv)
	SH_POINTSHOP:OnItemUnequipped(rcv.itm)
end)