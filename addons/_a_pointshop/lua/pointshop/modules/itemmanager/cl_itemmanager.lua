local ps = SH_POINTSHOP
local easynet = ps.easynet
local MODULE = MODULE or ps.Modules.itemmanager

MODULE.OriginalItems = MODULE.OriginalItems or {}

function MODULE:DoModelSelect(cb)
	local m = ps:GetMargin()
	local m2 = m * 0.5
	local ss = ps:GetScreenScale()
	local styl = ps.Style

	local cancel = vgui.Create("DPanel")
	cancel:SetDrawBackground(false)
	cancel:StretchToParent(0, 0, 0, 0)
	cancel:MoveToFront()
	cancel:MakePopup()

	local frm, bod = ps:MakeWindow(ps:LangFormat("im_model"), m2)
	frm:SetSize(400 * ss, 300 * ss)
	frm:Center()
	frm:MakePopup()
	frm.m_fCreateTime = SysTime()

	cancel.OnMouseReleased = function(me, mc)
		if (mc == MOUSE_LEFT) then
			frm:Close()
		end
	end
	cancel.Think = function(me)
		if (!IsValid(frm)) then
			me:Remove()
		end
	end

	local scr = vgui.Create("DScrollPanel", bod)
	scr:Dock(FILL)
	ps:PaintScroll(scr)
	
		local ic = vgui.Create("DIconLayout", scr)
		ic:Dock(FILL)

		for k, v in pairs (player_manager.AllValidModels()) do
			local sp = vgui.Create("SpawnIcon", ic)
			sp:SetModel(v)
			sp:SetToolTip(k)
			sp:SetSize(64 * ss, 64 * ss)
			sp.DoClick = function()
				frm:Close()
				cb(v)
			end
		end
end

function MODULE:LoadItem(fn, code)
	local err = RunString(code, nil, false)
	if (err) then
		ps:Print(ps:LangFormat("im_failed_loading_item", {class = fn, errorcode = "failed to parse file"}), ps.TYPE_ERROR)
		return false
	end

	if (!self.OriginalItems[fn]) then
		self.OriginalItems[fn] = table.Copy(ps.Items[fn])
	end

	local item = ps.Items[fn]

	local template = self.Templates[item.TemplateName]
	if (template and template.BaseItemVars) then
		for k, v in pairs (template.BaseItemVars) do
			if (item[k] == nil or ps:IsEmptyFunction(item[v])) then
				item[k] = v
			end
		end
	end

	item.HasThink = not ps:IsEmptyFunction(item.Think)
	item.HasPrePlayerDraw = not ps:IsEmptyFunction(item.PrePlayerDraw)
	item.HasPostPlayerDraw = not ps:IsEmptyFunction(item.PostPlayerDraw)
	item.HasCustomItemIcon = not ps:IsEmptyFunction(item.CustomItemIcon)

	ps:Print("Loaded custom item " .. fn .. "!", ps.TYPE_SUCCESS)
	ps:CallPanelHook("ItemManager.OnItemLoaded", class, item)

	for _, v in ipairs (player.GetAll()) do
		if (v:SH_HasEquipped(fn)) then
			ps:RebuildEquippedModels(v)
			ps:RebuildDrawCalls(v)
		end
	end
end

function MODULE:LoadOverride(class, changes)
	local item = ps.Items[class]
	if (!item) then
		ps:Print("Couldn't load override for '" .. class .. "': item doesn't exist!", ps.TYPE_ERROR)
		return false
	end

	if (!self.OriginalItems[class]) then
		self.OriginalItems = table.Copy(item)
	end

	for k, v in pairs (changes) do
		item[k] = v
	end

	-- did we change the category?
	local new = changes.Category
	if (new) then
		local old = self.OriginalItems[class].Category
		self.OriginalItems[class].Category = new

		ps.Categories[old].Items[class] = nil
		ps.Categories[new].Items[class] = item
	end

	ps:Print("Loaded item override " .. class .. "!", ps.TYPE_SUCCESS)
	ps:CallPanelHook("ItemManager.OnOverrideApplied", item)

	if (item.OnModified) then
		item:OnModified()
	end
end

function MODULE:DeleteItem(class)
	local item = ps.Items[class]
	if (!item) then
		ps:Print("Failed to delete item " .. class .. " (not found)", ps.TYPE_ERROR)
		return
	end

	self.OriginalItems[class] = nil

	ps.Categories[item.Category].Items[class] = nil
	ps.Items[class] = nil

	ps:Print("Deleted item " .. class .. "!", ps.TYPE_SUCCESS)
	ps:CallPanelHook("ItemManager.OnItemDeleted", class)
end

function MODULE:ShowExistingSection(cont)
	local m = ps:GetMargin()
	local m2 = m * 0.5
	local ss = ps:GetScreenScale()
	local styl = ps.Style

	local pw = cont:GetParent():GetWide()

	local curitem
	local vars = {}

	local listgroup = ps:CreateGroup("", cont)
	listgroup:Dock(FILL)

		local ilist = vgui.Create("DListView", listgroup)
		ilist:SetDataHeight(32)
		ilist:SetMultiSelect(false)
		ilist:SetDrawBackground(false)
		ilist:AddColumn(ps:LangFormat("im_list_category")):SetMaxWidth(pw * 0.5)
		ilist:AddColumn(ps:LangFormat("im_list_name"))
		ilist:Dock(FILL)

	local edititem = vgui.Create("DPanel", cont)
	edititem:SetDrawBackground(false)
	edititem:SetVisible(false)
	edititem:Dock(FILL)

		local group = ps:CreateGroup("", edititem)
		group:Dock(FILL)

			local scroll = vgui.Create("DScrollPanel", group)
			scroll:Dock(FILL)
			ps:PaintScroll(scroll)

			local buttons = vgui.Create("DPanel", group)
			buttons:SetDrawBackground(false)
			buttons:Dock(BOTTOM)
			buttons:DockMargin(0, m2, 0, 0)

				local delete = ps:QuickButton(ps:LangFormat("im_delete"), function()
					local m = ps:Menu()
					m:AddOption("im_confirm", function()
						easynet.SendToServer("SH_POINTSHOP.ItemManager.Delete", {class = curitem.ClassName})
					end)
					m:Open()
				end, buttons)
				delete:SetZPos(2)
				delete:SetWide(pw * 0.25)
				delete:Dock(LEFT)
				delete:DockMargin(0, 0, m2, 0)
				delete.m_Background = styl.failure

				local reset = ps:QuickButton(ps:LangFormat("im_reset_changes"), function()
					for id, inpt in pairs (vars) do
						inpt:ResetOriginal()
					end
				end, buttons)
				reset:SetZPos(2)
				reset:SetWide(pw * 0.25)
				reset:Dock(RIGHT)
				reset:DockMargin(0, 0, m2, 0)
				reset.m_Background = styl.bg

				local apply = ps:QuickButton(ps:LangFormat("im_apply_changes"), function()
					local changes = {}
					for id, inpt in pairs (vars) do
						local val = inpt:GetRealValue()
						local def = inpt.m_Original
						if (val ~= def) then
							changes[id] = val
						end
					end

					if (table.Count(changes) <= 0) then
						return end

					easynet.SendToServer("SH_POINTSHOP.ItemManager.Change", {class = curitem.ClassName, changes = changes})
				end, buttons)
				apply:SetWide(reset:GetWide())
				apply:Dock(RIGHT)
				apply.m_Background = styl.bg

		local goback = ps:QuickButton(ps:LangFormat("im_go_back"), function()
			curitem = nil
			vars = {}
			scroll:Clear()

			listgroup:SetMouseInputEnabled(true)
			edititem:SetMouseInputEnabled(false)
			edititem:AlphaTo(0, 0.1, nil, function()
				edititem:SetVisible(false)
				listgroup:SetVisible(true)
				listgroup:SetAlpha(0)
				listgroup:AlphaTo(255, 0.1)
			end)
		end, edititem)
		goback:SetTall(24)
		goback:Dock(TOP)
		goback:DockMargin(0, 0, 0, m2)

	ps:AddPanelHook("ItemManager.OnOverrideApplied", ilist, function(me, item)
		local class = item.ClassName
		if (curitem and curitem.ClassName == class) then
			curitem = item

			for id, inpt in pairs (vars) do
				inpt.m_Original = nil
			end
		end
	end)
	ps:AddPanelHook("ItemManager.OnItemDeleted", ilist, function(me, class)
		if (curitem and curitem.ClassName == class) then
			goback:DoClick()
		end

		me:Clear()
		for class, item in SortedPairsByMemberValue (ps.Items, "Category") do
			if (!item.IsCustom) then
				continue end

			local line = ilist:AddLine(ps:LangFormat(ps.Categories[item.Category].Name), item.Name)
			line.m_Item = item
			ps:LineStyle(line)
		end
	end, true)
	ilist.OnRowSelected = function(me, id, line)
		edititem:SetMouseInputEnabled(true)
		me:ClearSelection()
		listgroup:SetMouseInputEnabled(false)
		listgroup:AlphaTo(0, 0.1, nil, function()
			listgroup:SetVisible(false)
			edititem:SetVisible(true)
			edititem:SetAlpha(0)
			edititem:AlphaTo(255, 0.1)
		end)

		curitem = line.m_Item
		group:SetLabel(ps:LangFormat("im_editing_x", {itemname = curitem.Name .. " (" .. curitem.ClassName .. ")"}))

		scroll:Clear()

		local template = self.Templates[curitem.TemplateName]

		for _, var in pairs (template.Variables) do
			local varname = template.Editable and template.Editable[var.id]
			if (!varname) then
				continue end

			local lbl = ps:QuickLabel(var.name and ps:LangFormat(var.name) or var.id, "{prefix}Medium", styl.text, scroll)
			lbl:Dock(TOP)

			local inpt, docked
			if (var.type == TYPE_STRING) then
				local par = scroll
				-- if (var.playermodel) then
					par = vgui.Create("DPanel", scroll)
					par:Dock(TOP)
					par:DockMargin(0, 0, 0, m2)
				
					docked = true
				-- end
			
				inpt = ps:QuickEntry("", par, true)
			elseif (var.type == TYPE_NUMBER) then
				inpt = vgui.Create("DNumberWang", scroll)
				inpt:SetMinMax(var.min, var.max)
				inpt:SetDecimals(var.decimals or 0)
				inpt:SetValue(var.value or 0)
				ps:EntryStyle(inpt, true)
			elseif (var.type == TYPE_BOOL) then
				lbl:SetTall(16)

				inpt = ps:Checkbox(function()
				end, lbl)
				inpt:SetSize(16, 16)
				inpt:Dock(LEFT)
				inpt:DockMargin(lbl:GetWide() + m2, 0, 0, 0)
				inpt.m_bDrawBackground = true
				inpt.ResetOriginal = function(me)
					me:SetChecked(me.m_Original)
				end
				inpt.GetRealValue = function(me)
					return tostring(me:GetChecked())
				end

				docked = true
			elseif (var.type == "select") then
				inpt = ps:QuickComboBox(scroll, true)

				for i, ch in pairs (isfunction(var.vars) and var.vars() or var.vars) do
					inpt:AddChoice(ch, nil, i == 1)
				end
			elseif (var.type == "color") then
				inpt = vgui.Create("DColorMixer", scroll)
				inpt:SetColor(curitem[varname] or Color(255, 0, 0))
				inpt.ResetOriginal = function(me)
					me:SetColor(string.ToColor(me.m_Original))
				end
				inpt.GetRealValue = function(me)
					local c = me:GetColor()
					return c.r .. " " .. c.g .. " " .. c.b .. " " .. c.a
				end
			end

			if (inpt and !docked) then
				inpt:Dock(TOP)
				inpt:DockMargin(0, 0, 0, m2)
			end

			if (var.separator) then
				local sep = vgui.Create("DPanel", scroll)
				sep:SetTall(ps:GetPadding() * 0.5)
				sep:SetDrawBackground(false)
				sep:Dock(TOP)
			end

			if (inpt) then
				if (inpt.GetChecked) then
					inpt:SetChecked(curitem[varname] or false)
				elseif (inpt.SetValue) then
					inpt:SetValue(curitem[varname] or inpt:GetValue())
				end

				inpt.ResetOriginal = inpt.ResetOriginal or function(me)
					me:SetValue(me.m_Original)
				end
				inpt.GetRealValue = inpt.GetRealValue or function(me)
					return me:GetValue()
				end
				lbl.Think = function(me)
					local val = inpt:GetRealValue()
					if (inpt.m_Original == nil) then
						inpt.m_Original = val
					end

					if (val ~= inpt.m_Original) then
						me:SetColor(styl.header)
					else
						me:SetColor(styl.text)
					end
				end

				inpt.m_Label = lbl
				vars[var.id] = inpt
			end
		end
	end

	ps:PaintList(ilist, true)
end

function MODULE:ShowCreateSection(cont)
	local m = ps:GetMargin()
	local m2 = m * 0.5
	local ss = ps:GetScreenScale()
	local styl = ps.Style

	local g1 = ps:CreateGroup("", cont)
	g1:Dock(TOP)
	g1:SetTall(24 * ss + m)

		local lbl = ps:QuickLabel(ps.Language.im_template, "{prefix}Large", styl.text, g1)
		lbl:SetTall(24 * ss)
		lbl:Dock(TOP)
		lbl:DockMargin(0, 0, 0, m)

			local tmpid = ps:QuickComboBox(lbl)
			tmpid:Dock(FILL)
			tmpid:DockMargin(lbl:GetWide() + m2, 0, 0, 0)
			tmpid.m_Background = styl.bg

	local g2 = ps:CreateGroup("", cont)
	g2:Dock(FILL)
	g2:DockMargin(0, m2, 0, 0)

		local vars = {}

		local scroll = vgui.Create("DScrollPanel", g2)
		scroll:Dock(FILL)
		ps:PaintScroll(scroll)

		local btn_add = ps:QuickButton(ps.Language.im_registeritem, function()
			local inpts = {}
			for id, inpt in SortedPairs (vars) do
				inpts[id] = inpt:GetRealValue()
				inpt.m_Label:SetColor(styl.text)
			end

			local template = self.Templates[tmpid:GetValue()]
			if (template.Processors) then
				for id, func in pairs (template.Processors) do
					local result, why = func(inpts[id])
					if (result == false) then
						LocalPlayer():SH_SendNotification(ps.Language[why] or why, false)
						if (id) then
							vars[id].m_Label:SetColor(styl.failure)
						end

						return
					end

					inpts[id] = result or inpts[id]
				end
			end

			local ok, why, where = self:ValidateInput(inpts, tmpid:GetValue())
			if (!ok) then
				if (where) then
					vars[where].m_Label:SetColor(styl.failure)
				end
				if (why) then
					LocalPlayer():SH_SendNotification(ps.Language[why] or why, false)
				end

				return
			end

			easynet.SendToServer("SH_POINTSHOP.ItemManager.Create", {tmpid = tmpid:GetValue(), inputs = inpts})
		end, g2)
		btn_add:Dock(BOTTOM)
		btn_add:DockMargin(0, m2, 0, 0)
		btn_add.m_Background = styl.bg

	tmpid.OnSelect = function(me, index, value, data)
		scroll:Clear()
		vars = {}

		for _, var in pairs (data.Variables) do
			local lbl = ps:QuickLabel(var.name and ps:LangFormat(var.name) or var.id, "{prefix}Medium", styl.text, scroll)
			lbl:Dock(TOP)

				local inpt, docked
				if (var.type == TYPE_STRING) then
					local par = scroll
					if (var.playermodel) then
						par = vgui.Create("DPanel", scroll)
						par:SetDrawBackground(false)
						par:SetTall(20)
						par:Dock(TOP)
						par:DockMargin(0, 0, 0, m2)
					
						docked = true
					end
				
					inpt = ps:QuickEntry("", par, true)
					
					if (var.playermodel) then
						local selbtn = ps:QuickButton("...", function()
							self:DoModelSelect(function(val)
								inpt:SetValue(val)
							end)
						end, par)
						selbtn:Dock(RIGHT)
						selbtn:DockMargin(m2, 0, 0, 0)
						selbtn.m_Background = styl.bg

						inpt:Dock(FILL)
					end
				elseif (var.type == TYPE_NUMBER) then
					inpt = vgui.Create("DNumberWang", scroll)
					inpt:SetMinMax(var.min, var.max)
					inpt:SetDecimals(var.decimals or 0)
					inpt:SetValue(var.value or 0)
					ps:EntryStyle(inpt, true)
				elseif (var.type == TYPE_BOOL) then
					lbl:SetTall(16)

					inpt = ps:Checkbox(function()
					end, lbl)
					inpt:SetSize(16, 16)
					inpt:Dock(LEFT)
					inpt:DockMargin(lbl:GetWide() + m2, 0, 0, 0)
					inpt.m_bDrawBackground = true
					inpt.GetRealValue = function(me)
						return tostring(me:GetChecked())
					end

					docked = true
				elseif (var.type == "select") then
					inpt = ps:QuickComboBox(scroll, true)

					for i, ch in pairs (isfunction(var.vars) and var.vars() or var.vars) do
						inpt:AddChoice(ch, nil, i == 1)
					end
				elseif (var.type == "color") then
					inpt = vgui.Create("DColorMixer", scroll)
					inpt.GetRealValue = function(me)
						local c = me:GetColor()
						return c.r .. " " .. c.g .. " " .. c.b .. " " .. c.a
					end
				end

				if (inpt) then
					if (inpt.GetChecked) then
						inpt:SetChecked(var.default or false)
					elseif (inpt.SetValue) then
						inpt:SetValue(var.default or inpt:GetValue())
					end

					if (!docked) then
						inpt:Dock(TOP)
						inpt:DockMargin(0, 0, 0, m2)
					end
				end

				if (var.separator) then
					local sep = vgui.Create("DPanel", scroll)
					sep:SetTall(ps:GetPadding() * 0.5)
					sep:SetDrawBackground(false)
					sep:Dock(TOP)
				end

				if (inpt) then
					inpt.GetRealValue = inpt.GetRealValue or function(me)
						return me:GetValue()
					end
					inpt.m_Label = lbl
					vars[var.id] = inpt
				end
		end
	end

	for id, tmp in pairs (self.Templates) do
		tmpid:AddChoice(id, tmp, id == "item_basic")
	end
end

function MODULE:BuildTab(body, contents)
	ps:HidePreview(true)

	local cont = vgui.Create("DPanel", body)
	cont:SetDrawBackground(false)

	contents:DisplayCustom(cont)
	return cont
end

hook.Add("SH_POINTSHOP.BuildNavBarBottom", "SH_POINTSHOP.ItemManager", function(bottomtabs, body, contents, admin_mode)
	if (!admin_mode or !MODULE.Config.Enable or !MODULE:IsAllowed(LocalPlayer())) then
		return end

	table.insert(bottomtabs, {
		text = ps.Language.item_manager,
		desc = ps.Language.item_manager .. " - " .. ps.Language.item_manager_desc,
		icon = Material("shenesis/pointshop/manager.png"),
		children = {
			{text = "im_manage_items", func = function(me)
				MODULE:ShowExistingSection(MODULE:BuildTab(body, contents))
			end},
			{text = "im_create_items", func = function(me)
				MODULE:ShowCreateSection(MODULE:BuildTab(body, contents))
			end},
		},
		dock = admin_mode and TOP or BOTTOM,
		order = 1,
	})
end)

easynet.Callback("SH_POINTSHOP.ItemManager.Network", function(data)
	MODULE:LoadItem(data.fn, data.code)
end)

easynet.Callback("SH_POINTSHOP.ItemManager.NetworkCompressed", function(data)
	MODULE:LoadItem(data.fn, util.Decompress(data.code))
end)

easynet.Callback("SH_POINTSHOP.ItemManager.NetworkOverride", function(data)
	MODULE:LoadOverride(data.class, data.changes)
end)

easynet.Callback("SH_POINTSHOP.ItemManager.NetworkDeletion", function(data)
	MODULE:DeleteItem(data.class)
end)