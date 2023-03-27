local easynet = SH_POINTSHOP.easynet

--
if (!SH_POINTSHOP.Categories) then
	SH_POINTSHOP.Categories = {}
	SH_POINTSHOP.Items = {}
	SH_POINTSHOP.Modules = {}
end

function SH_POINTSHOP:IsAdmin(ply)
	local b = hook.Run("SH_POINTSHOP.IsAdmin", ply)
	if (b ~= nil) then
		return b
	end

	return self.AdminUsergroups[ply:GetUserGroup()] ~= nil
end

function SH_POINTSHOP:Assert(b, ply, message)
	if (!b) then
		if (ply and message) then
			self:SendNotification(ply, message, false)
		end

		return false
	end

	return true
end

function SH_POINTSHOP:SendNotification(to, message, positive)
	if (SERVER) then
		easynet.Send(to, "SH_POINTSHOP.SendNotification", {message = message, positive = positive})
	else
		if (self.NotificationType == 1) then
			self:Notify(message, 5, self.Style[positive and "success" or "failure"])
		elseif (self.NotificationType == 2) then
			notification.AddLegacy(message, positive and NOTIFY_GENERIC or NOTIFY_ERROR, 5)
		elseif (self.NotificationType == 3) then
			chat.AddText(self.Style[positive and "success" or "failure"], message)
		end
	end
end

function SH_POINTSHOP:GetPriceString(a, b, ply, sell)
	if (istable(a) and a.PointsCost) then
		return self:GetPriceString(a.PointsCost, a.PremiumPointsCost, ply, sell)
	end

	local mult = 1
	if (IsValid(ply)) then
		mult = ply:SH_GetPriceMultiplier()

		if (sell) then
			mult = mult * ply:SH_GetSellMultiplier()
		end
	end

	local t = {}
	if (a and a > 0) then table.insert(t, self:LangFormat("x_standard_points", {amount = string.Comma(a * mult)})) end
	if (b and b > 0) then table.insert(t, self:LangFormat("x_premium_points", {amount = string.Comma(b * mult)})) end

	if (#t > 0) then
		return table.concat(t, ", ")
	else
		return self.Language.free
	end
end

function SH_POINTSHOP:LangFormat(str, args)
	str = self.Language[str] or str
	args = args or {}

	for k, v in pairs (args) do
		str = str:Replace("{" .. k .. "}", tostring(v))
	end

	return str
end

function SH_POINTSHOP:NewItem(class, data)
	local itm = util.JSONToTable(self:NewItemTable(class, data))
	if (SERVER) then
		itm.id = self:IncrementItemID()
	end

	return itm
end

function SH_POINTSHOP:NewItemTable(class, data)
	return {class = class, data = data or {}, id = self:IncrementItemID()}
end

-- Creates a ItemInstance from a table or string.
function SH_POINTSHOP:ParseItem(o)
	local itm, item
	if (isstring(o)) then
		itm = util.JSONToTable(o)
		item = self.Items[itm.class]
	else
		itm = o
		item = self.Items[o.class]
	end

	return itm, item
end

function SH_POINTSHOP:ParseItemData(data, encode)
	return encode and util.TableToJSON(data) or util.JSONToTable(data)
end

function SH_POINTSHOP:ParseInventory(inv)
	if (istable(inv)) then
		return util.TableToJSON(inv)
	else
		return util.JSONToTable(inv)
	end
end

-- Gets rid of empty stuff, renames to 1-char keys
function SH_POINTSHOP:OptimizeInventory(otbl)
	local tbl = {}
	for i, itm in pairs (otbl) do
		tbl[i] = {}

		for k, v in pairs (itm) do
			if (k == "data" and table.Count(v) == 0) then
				continue end

			tbl[i][k[1]] = v
		end
	end

	return tbl
end

-- Restores them
local idx = {i = "id", e = "equipped", d = "data", c = "class"}
function SH_POINTSHOP:UnoptimizeInventory(otbl)
	local tbl = {}
	for i, itm in pairs (otbl) do
		tbl[i] = {data = {}}

		for k, v in pairs (itm) do
			if (!idx[k]) then
				continue end

			tbl[i][idx[k]] = v
		end
	end

	return tbl
end

-- Utility print function
local cs = {
	[SH_POINTSHOP.TYPE_SUCCESS] = Color(0, 200, 0),
	[SH_POINTSHOP.TYPE_ERROR] = Color(255, 0, 0),
}
function SH_POINTSHOP:Print(s, c)
	MsgC(Color(0, 200, 255), "[SH Pointshop" .. (SERVER and "SV" or "CL") .. "] ", cs[c or -1] or color_white, s .. "\n")
end