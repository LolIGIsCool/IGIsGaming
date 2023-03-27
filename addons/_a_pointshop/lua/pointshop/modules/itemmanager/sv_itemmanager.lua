local ps = SH_POINTSHOP
local easynet = ps.easynet
local MODULE = MODULE or ps.Modules.itemmanager

MODULE.OriginalItems = MODULE.OriginalItems or {}
MODULE.ItemCodes = MODULE.ItemCodes or {}
MODULE.ItemOverrides = MODULE.ItemOverrides or {}

-- Create data folders
ps:CreateFolder("itemmanager")
ps:CreateFolder("itemmanager/items")
ps:CreateFolder("itemmanager/overrides")

local function output(msg, ply, c)
	ps:Print(msg, c)
	if (ply) then
		ply:ChatPrint(msg)
	end
end

function MODULE:LoadItems()
	local fi = ps:FileList("itemmanager/items/*")
	for _, fn in pairs (fi) do
		self:LoadItem(fn)
	end
end

function MODULE:NetworkItem(target, fn)
	local code = self.ItemCodes[fn]
	if (!code) then
		return end

	local compressed = false
	local cp = util.Compress(code)
	if (cp:len() < code:len()) then
		compressed = true
	end

	easynet.Send(target, compressed and "SH_POINTSHOP.ItemManager.NetworkCompressed" or "SH_POINTSHOP.ItemManager.Network", {
		fn = fn,
		code = compressed and cp or code
	})

	-- Do we have an override (that isn't empty)?
	local ovr = self.ItemOverrides[fn]
	if (ovr and table.Count(ovr) > 0) then
		easynet.Send(target, "SH_POINTSHOP.ItemManager.NetworkOverride", {
			class = fn,
			changes = ovr
		})
	end
end

function MODULE:LoadItem(fn, ply)
	fn = fn:StripExtension()

	local path = "itemmanager/items/" .. fn .. ".txt"
	if (!ps:FileExists(path)) then
		output(ps:LangFormat("im_failed_loading_item", {class = fn, errorcode = "file not found"}), ply, ps.TYPE_ERROR)
		return false
	end

	local r = ps:Read(path)
	local err = RunString(r, nil, false)
	if (err) then
		output(ps:LangFormat("im_failed_loading_item", {class = fn, errorcode = "failed to parse file"}), ply, ps.TYPE_ERROR)
		return false
	end

	local item = ps.Items[fn]

	local template = self.Templates[item.TemplateName]
	if (template and template.BaseItemVars) then
		for k, v in pairs (template.BaseItemVars) do
			if (item[k] == nil) or (isfunction(v) and ps:IsEmptyFunction(v)) then
				item[k] = v
			end
		end
	end

	item.HasThink = not ps:IsEmptyFunction(item.Think)

	self.OriginalItems[fn] = table.Copy(item)
	self.ItemCodes[fn] = r
	output("Loaded custom item " .. path .. "!", nil, ps.TYPE_SUCCESS)

	self:LoadOverride(fn, true)

	return true
end

function MODULE:LoadOverride(class, initial)
	local item = ps.Items[class]
	if (!item) then
		output("Couldn't load override for '" .. class .. "': item doesn't exist!", nil, ps.TYPE_ERROR)
		return
	end

	local path = "itemmanager/overrides/" .. class .. ".txt"
	if (!ps:FileExists(path)) then
		return end

	local changes = ps:ReadJSON(path)
	for k, v in pairs (changes) do
		item[k] = v
	end

	-- did we change the category?
	local new = changes.Category
	if (new) then
		local old = self.OriginalItems[class].Category
		if (old ~= new) then
			self.OriginalItems[class].Category = new

			ps.Categories[old].Items[class] = nil
			ps.Categories[new].Items[class] = item

			-- Unequip it from anyone wearing it, even offline!
			if (!initial) then
				self:UnequipItemGlobal(class)
			end
		end
	end

	if (item.OnModified) then
		item:OnModified()
	end

	self.ItemOverrides[class] = changes
	self:NetworkItem(player.GetAll(), fn)

	output("Loaded item override " .. path .. "!", nil, ps.TYPE_SUCCESS)
end

function MODULE:CreateItem(tmpid, inputs, ply)
	if (ply) then
		local allowed, why = self:IsAllowed(ply)
		if (allowed == false) then
			if (why) then
				ply:SH_SendNotification(ps:LangFormat(why), false)
			end

			return
		end
	end

	local template = self.Templates[tmpid]
	if (!template) then
		return end

	local ok, why = self:ValidateInput(inputs, tmpid)
	if (!ok) then
		if (why) then
			ply:SH_SendNotification(ps:LangFormat(why), false)
		end

		return
	end

	local code = template.Code
	code = code:Replace("{TemplateName}", tmpid)

	-- Replace user input variables
	for _, var in pairs (template.Variables) do
		local inpt = tostring(inputs[var.id] or "")
		inpt = self:Sanitize(inpt)

		code = code:Replace("{" .. var.id .. "}", inpt)
	end

	-- Apply processors
	if (template.Processors) then
		for id in pairs (template.Processors) do
			local inpt = tostring(inputs[id] or "")
			inpt = self:Unsanitize(inpt)

			code = code:Replace("{Processor:" .. id .. "}", inpt)
		end
	end

	-- Prepare to write!
	local fn = inputs.classname
	local fn2 = fn .. ".txt"
	local path = "itemmanager/items/" .. fn2
	if (!ps:Assert(!ps:FileExists(path), ply, "im_file_already_exists")) then
		return end

	ps:Write(path, code)

	if (self:LoadItem(fn, ply)) then
		self:NetworkItem(player.GetAll(), fn)
		ply:SH_SendNotification(ps:LangFormat("im_successfully_created", {class = fn}), true)
	else
		ps:Delete(path)
		ps:Delete("itemmanager/overrides/" .. fn2)
	end
end

function MODULE:ChangeItem(class, changes, ply)
	if (ply) then
		local allowed, why = self:IsAllowed(ply)
		if (allowed == false) then
			if (why) then
				ply:SH_SendNotification(ps:LangFormat(why), false)
			end

			return
		end
	end

	local item = ps.Items[class]
	if (!ps:Assert(item ~= nil, ply, "im_item_doesnt_exist")) then
		return end

	-- TODO?
	if (!ps:Assert(item.IsCustom, ply, "im_hardcoded_file")) then
		return end

	local template = self.Templates[item.TemplateName]
	if (!template.Editable) then
		return end

	local validchanges = self.ItemOverrides[class] or {}

	for id in pairs (changes) do
		local varname = template.Editable[id]
		if (varname) then
			validchanges[varname] = changes[id]
		end
	end

	-- Write & load
	local fn = class
	local fn2 = fn .. ".txt"
	local path = "itemmanager/overrides/" .. fn2

	ps:SaveJSON(path, validchanges)
	self:LoadOverride(class)
	self:NetworkItem(player.GetAll(), fn)

	ply:SH_SendNotification(ps:LangFormat("im_changes_applied", {class = class}), true)
end

function MODULE:DeleteItem(class, ply)
	if (ply) then
		local allowed, why = self:IsAllowed(ply)
		if (allowed == false) then
			if (why) then
				ply:SH_SendNotification(ps:LangFormat(why), false)
			end

			return
		end
	end

	local item = ps.Items[class]
	if (!ps:Assert(item ~= nil, ply, "im_item_doesnt_exist")) then
		return end

	if (!ps:Assert(item.IsCustom, ply, "im_hardcoded_file")) then
		return end

	local fn = class
	local fn2 = fn .. ".txt"
	local path = "itemmanager/items/" .. fn2
	if (!ps:FileExists(path)) then
		output(ps:LangFormat("im_failed_loading_item", {class = fn, errorcode = "file not found"}), ply, ps.TYPE_ERROR)
		return false
	end

	ps:Delete(path)
	ps:Delete("itemmanager/overrides/" .. fn2)

	self:DeleteItemGlobal(class)

	self.OriginalItems[class] = nil
	self.ItemCodes[class] = nil
	self.ItemOverrides[class] = nil

	ps.Categories[item.Category].Items[class] = nil
	ps.Items[class] = nil

	ply:SH_SendNotification(ps:LangFormat("im_item_deleted", {class = class}), true)

	easynet.Send(player.GetAll(), "SH_POINTSHOP.ItemManager.NetworkDeletion", {class = class})
end

-- potentially performance heavy so yeah
function MODULE:UnequipItemGlobal(class)
	local ignore = {}
	for _, v in pairs (player.GetAll()) do
		local yes, itm = v:SH_HasEquipped(class)
		if (yes) then
			ignore[v:SteamID()] = true
			v:SH_UnequipItem(itm)
		end
	end

	ps:BetterQuery([[
		SELECT steamid, equipped
		FROM sh_pointshop_player
	]], {}, function(q, ok, data)
		if (!ok) then
			return end

		for _, entry in pairs (data) do
			if (ignore[entry.steamid]) then
				continue end

			local found, without = false, {}
			for __, v in pairs (util.JSONToTable(entry.equipped)) do
				if (v.c == class) then
					found = true
				else
					table.insert(without, v)
				end
			end

			if (found) then
				ps:BetterQuery([[
					UPDATE sh_pointshop_player
					SET equipped = {equipped}
					WHERE steamid = {steamid}
				]], {steamid = entry.steamid, equipped = util.TableToJSON(without)})
			end
		end
	end)
end

-- same
function MODULE:DeleteItemGlobal(class)
	local ignore = {}
	for _, v in pairs (player.GetAll()) do
		local update = false
		local yes, itm = v:SH_HasEquipped(class)
		if (yes) then
			v:SH_UnequipItem(itm, true, true)
			update = true
		end

		local yes2, itm = v:SH_HasItem(class)
		while (itm) do
			v:SH_RemoveItemID(itm.id, true, true)

			yes2, itm = v:SH_HasItem(class)
			update = true
		end

		if (update) then
			v:SH_TransmitInventory()
			v:SH_TransmitEquipped(player.GetAll())
			v:SH_SavePointshop()

			ignore[v:SteamID()] = true
		end
	end

	ps:BetterQuery([[
		SELECT steamid, inventory, equipped
		FROM sh_pointshop_player
	]], {}, function(q, ok, data)
		if (!ok) then
			return end

		for _, entry in pairs (data) do
			if (ignore[entry.steamid]) then
				continue end

			local found, newinv, neweq = false, {}, {}
			for __, v in pairs (util.JSONToTable(entry.inventory)) do
				if (v.c == class) then
					found = true
				else
					table.insert(newinv, v)
				end
			end
			for __, v in pairs (util.JSONToTable(entry.equipped)) do
				if (v.c == class) then
					found = true
				else
					table.insert(neweq, v)
				end
			end

			if (found) then
				ps:BetterQuery([[
					UPDATE sh_pointshop_player
					SET inventory = {inventory}, equipped = {equipped}
					WHERE steamid = {steamid}
				]], {steamid = entry.steamid, inventory = util.TableToJSON(newinv), equipped = util.TableToJSON(neweq)})
			end
		end
	end)
end

function MODULE:ResetEconomy(class)
	local ignore = {}
	local toKeep = {["boo_crew"]=true, ["candy_cane"]=true, ["scream_team"]=true, ["spooky_skeletons"]=true}
	local newPremium = 100000
	local newPoints = 0

	ps:BetterQuery([[
		SELECT steamid, inventory, equipped
		FROM sh_pointshop_player
	]], {}, function(q, ok, data)
		if (!ok) then
			return end

		for _, entry in pairs (data) do
			if (ignore[entry.steamid]) then
				continue end

			local found, newinv, neweq = false, {}, {}
			for __, v in pairs (util.JSONToTable(entry.inventory)) do
				if (toKeep[v.c]) then
					table.insert(newinv, v)
				end
			end
			for __, v in pairs (util.JSONToTable(entry.equipped)) do
				if (toKeep[v.c]) then
					table.insert(neweq, v)
				end
			end

			ps:BetterQuery([[
				UPDATE sh_pointshop_player
				SET standard_points = {standard}, premium_points = {premium}, inventory = {inventory}, equipped = {equipped}
				WHERE steamid = {steamid}
			]], {steamid = entry.steamid, standard = newPoints, premium = newPremium, inventory = util.TableToJSON(newinv), equipped = util.TableToJSON(neweq)})
		end
	end)
end

function MODULE:NetworkItems(ply)
	for k in pairs (MODULE.ItemCodes) do
		MODULE:NetworkItem(ply, k)
	end
end

hook.Add("SH_POINTSHOP.PlayerReady", "SH_POINTSHOP.ItemManager", function(ply)
	MODULE:NetworkItems(ply)
end)

easynet.Callback("SH_POINTSHOP.ItemManager.Create", function(data, ply)
	MODULE:CreateItem(data.tmpid, data.inputs, ply)
end)

easynet.Callback("SH_POINTSHOP.ItemManager.Change", function(data, ply)
	MODULE:ChangeItem(data.class, data.changes, ply)
end)

easynet.Callback("SH_POINTSHOP.ItemManager.Delete", function(data, ply)
	MODULE:DeleteItem(data.class, ply)
end)

MODULE:LoadItems()