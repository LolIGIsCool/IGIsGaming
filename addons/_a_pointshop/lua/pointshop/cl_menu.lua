local easynet = SH_POINTSHOP.easynet

local function L(...) return SH_POINTSHOP:L(...) end

local matPossessed = Material("shenesis/pointshop/suitcase.png")
local matEquipped = Material("shenesis/pointshop/equipped.png")
local matAdjust = Material("shenesis/pointshop/controls.png")

local simple_icons = CreateClientConVar("sh_pointshop_interface_simple_icons", "0", true, false)

local function draw_displaydata(ent, data, class, ply)
	for name, prop in pairs (data.props) do
		SH_POINTSHOP:RenderDisplayData(ent, ply, name, prop.model, prop, data.props, class) -- 76561198006360138
	end
end

local preview_ent = nil
local previewing_2d = nil
local draw_localplayer = nil

function SH_POINTSHOP:FlushPreview2D()
	local old = previewing_2d
	if (IsValid(preview_ent) and old and old.DisplayData and old.DisplayData.is_pac and preview_ent.RemovePACPart) then
		preview_ent:RemovePACPart(old.DisplayData.props)
	end

	previewing_2d = nil
end

-- We want to be able to draw PAC3 and DisplayData props simultaneously so we NEED this function
function SH_POINTSHOP:DrawPreview2D(me, ent, skip_pac, prev_item)
	local pr, old = prev_item, previewing_2d
	local is_pac = false

	preview_ent = ent

	if (pac and !skip_pac) then
		if (draw_localplayer == nil) then
			hook.Add("ShouldDrawLocalPlayer", "pac_draw_2d_entity", function()
				if (draw_localplayer) then
					return true
				end
			end)
		end

		local x, y = me:LocalToScreen(0, 0)
		local w, h = me:GetSize()

		local ang = me.aLookAngle
		if (!ang) then
			ang = (me.vLookatPos - me.vCamPos):Angle()
		end

		cam.Start2D()
			cam.Start3D(me:GetCamPos(), ang, me:GetFOV(), x, y, w, h, 5, 4096)
				cam.IgnoreZ(true)
					pac.FlashlightDisable(true)
						draw_localplayer = true

							pac.RenderOverride(ent, "opaque")
							pac.RenderOverride(ent, "translucent", true)
							ent:DrawModel()
							self:DrawPreview2D(me, ent, true, preview_data)

						draw_localplayer = false
					pac.FlashlightDisable(false)
				cam.IgnoreZ(false)
			cam.End3D()
		cam.End2D()
	else
		if (old) then
			if (!old.DisplayData.is_pac) then
				draw_displaydata(ent, old.DisplayData, old.ClassName, LocalPlayer())
			end
		else
			self:RenderEquippedModels(ent, LocalPlayer())
		end
	end

	-- Handle previews
	if (pr) then
		if (old ~= pr) then
			-- Flush previous previewed PAC outfit
			if (old and old.DisplayData.is_pac) then
				for id, outfit in pairs (old.DisplayData.props) do
					ent:RemovePACPart(outfit)
				end
			end

			previewing_2d = pr

			-- Create PAC outfit
			if (pr.DisplayData.is_pac) and (!LocalPlayer():SH_HasEquipped(pr.ClassName)) then
				for id, outfit in pairs (pr.DisplayData.props) do
					outfit = self:SilentPACOutfit(outfit)
					ent:AttachPACPart(outfit, LocalPlayer())
				end
			end
		end
	end

	return is_pac
end

function SH_POINTSHOP:HidePreview(b)
	if (!IsValid(_SH_POINTSHOP)) then
		return end

	_SH_POINTSHOP.m_Preview:SetVisible(not b)
	_SH_POINTSHOP:InvalidateChildren()
end

function SH_POINTSHOP:ShowAdjustMenu(class)
	if (IsValid(_SH_POINTSHOP_ADJUST)) then
		_SH_POINTSHOP_ADJUST:Close()
		return
	end

	--
	local m = self:GetMargin()
	local m2 = m * 0.5
	local ss = self:GetScreenScale()
	local wi, he = 300 * self.WidthMultiplier * ss, 600 * self.HeightMultiplier * ss
	local styl = self.Style

	local mdlname = LocalPlayer():GetModel()
	local fact = LocalPlayer():SH_GetAdjustFactor()
	--

	_SH_POINTSHOP:Stop()
	_SH_POINTSHOP:Center()
	local cx, cy = _SH_POINTSHOP:GetPos()
	_SH_POINTSHOP:MoveTo(_SH_POINTSHOP.x - wi * 0.5, _SH_POINTSHOP.y, 0.3)

	local adjustments = self:ReadJSON("adjustments.txt")
	local savein

	local wnd, body = self:MakeWindow(L"adjust", m)
	wnd:SetVisible(false)
	wnd:SetAlpha(0)
	wnd:SetSize(wi, he)
	wnd:MoveRightOf(_SH_POINTSHOP, -wi * 0.5 + m)
	wnd:MoveBelow(_SH_POINTSHOP, -wnd:GetTall())
	wnd:MakePopup()
	wnd.Think = function(me)
		if (savein and CurTime() >= savein) then
			savein = nil
			self:SaveJSON("adjustments.txt", adjustments)

			local adj = adjustments[class]
			if (adj and LocalPlayer():SH_HasItem(class)) then
				easynet.SendToServer("SH_POINTSHOP.ApplyAdjustment", {
					class = class,
					px = adj.px or 0,
					py = adj.py or 0,
					pz = adj.pz or 0,
					ax = adj.ax or 0,
					ay = adj.ay or 0,
					az = adj.az or 0,
					sx = adj.sx or 1,
					sy = adj.sy or 1,
					sz = adj.sz or 1,
				})
			end
		end
	end
	wnd.OnClose = function(me)
		if (IsValid(_SH_POINTSHOP) and !_SH_POINTSHOP.m_bClosing) then
			_SH_POINTSHOP:Stop()
			_SH_POINTSHOP:MoveTo(cx, cy, 0.3)
		end
	end
	_SH_POINTSHOP_ADJUST = wnd

		local grp = self:CreateGroup("", body)
		grp:SetTall(48 * ss)
		grp:Dock(TOP)
		grp:DockMargin(0, 0, 0, m2)

			local lbl = self:QuickLabel(L"adjust_tooltip", "{prefix}Medium", styl.text, grp)
			lbl:Dock(FILL)
			lbl:SetWrap(true)

		local scroll = vgui.Create("DScrollPanel", body)
		scroll:Dock(FILL)
		self:PaintScroll(scroll)

		local sliders = {}
		local function AddAdjustMenu(tx, ad, fc, de)
			tx = L(tx)
			fc = fc or 1
			de = de or 0

			local adj = self:CreateGroup("", scroll)
			adj:SetTall(64 * ss)
			adj:Dock(TOP)
			adj:DockMargin(0, 0, 0, m2)
			adj:DockPadding(m2, m2, m2, m2)

			for _, c in ipairs ({"x", "y", "z"}) do
				local id = ad .. c

				local lbl = self:QuickLabel(tx .. " " .. c:upper(), "{prefix}Large", styl.text, adj)
				lbl:Dock(TOP)

				local slider = self:NumSlider(adj)
				slider:Dock(TOP)
				slider:SetMinMax(de + -fact * fc, de + fact * fc)
				slider.m_fDefault = de
				table.insert(sliders, slider)

				slider.UpdateValue = function(me)
					if (adjustments and adjustments[class]) then
						me:SetValue(adjustments[class][id] or de)
					else
						me:SetValue(de)
					end
				end
				slider:UpdateValue()

				slider.OnValueChanged = function(me, val)
					val = math.Clamp(val, -fact, fact)

					if (!adjustments[class]) then
						adjustments[class] = {}
					end
					adjustments[class][id] = val

					savein = CurTime() + 0.5

					-- Apply adjustment to ourselves immediately
					local adj = adjustments[class]
					if (adj) then
						local px, py, pz = adj.px or 0, adj.py or 0, adj.pz or 0
						local ax, ay, az = adj.ax or 0, adj.ay or 0, adj.az or 0
						local sx, sy, sz = adj.sx or 1, adj.sy or 1, adj.sz or 1

						local pos, ang, scale = Vector(px, py, pz), Angle(ax, ay, az), Vector(sx, sy, sz)
						LocalPlayer().SH_POINTSHOP_ADJUSTS[class] = {pos, ang, scale}
					end
				end
			end

			timer.Simple(0, function()
				if (!IsValid(adj)) then
					return end

				adj:SizeToChildren(true, true)
			end)
		end

		local function ShowAdjustElements()
			AddAdjustMenu("position", "p", self.AdjustFactorIndividual.translate)
			AddAdjustMenu("angle", "a", self.AdjustFactorIndividual.rotate)
			AddAdjustMenu("scale", "s", self.AdjustFactorIndividual.scale, 1)
		end

		ShowAdjustElements()

		self:AddPanelHook("OnItemSelected", wnd, function(me, item, itm, olditem, olditm)
			if (!item.Adjustable) then
				wnd:Close()
				return
			end

			class = item.ClassName

			for _, v in pairs (sliders) do
				v:UpdateValue()
			end
		end)

		local reset = self:QuickButton(L"reset_adjustments", function()
			for _, sl in pairs (sliders) do
				sl:SetValue(sl.m_fDefault)
			end
		end, body)
		reset:SetZPos(5)
		reset:Dock(BOTTOM)
		reset:DockMargin(0, m2, 0, 0)

		-- local psave = vgui.Create("DPanel", body)
		-- psave:SetDrawBackground(false)
		-- psave:Dock(BOTTOM)
		-- psave:DockMargin(0, m2, 0, 0)

			-- local save = self:QuickButton(L"save", function()
				-- self:SaveJSON("adjustments.txt", adjustments) -- 76561198006360138
			-- end, psave)
			-- save:SetWide(wi * 0.5 - m - m2)
			-- save:Dock(LEFT)
			-- save:DockMargin(0, 0, m2, 0)

			-- local saveall = self:QuickButton(L"save_for_all_models", function()
			-- end, psave)
			-- saveall:Dock(FILL)

	wnd:SetVisible(true)
	wnd:AlphaTo(255, 0.1, 0.3)
end

function SH_POINTSHOP:OpenMenu()
	self:RemoveIfValid(_SH_POINTSHOP)

	--
	local m = self:GetMargin()
	local m2 = m * 0.5
	local ss = self:GetScreenScale()
	local wi, he = 800 * self.WidthMultiplier * ss, 600 * self.HeightMultiplier * ss
	local styl = self.Style

	local sel_item, sel_cat, sel_cat_tbl
	local closing = false

	--
	local wnd, body = self:MakeWindow(self.Title, m)
	-- wnd:SetEscapeToClose(true)
	wnd:SetSize(wi, he)
	wnd:Center()
	wnd:MakePopup()
	wnd.OnClose = function(me)
		self:RemoveIfValid(_SH_POINTSHOP_ADJUST)
		self:FlushPreview2D()
		closing = true
	end
	_SH_POINTSHOP = wnd

		-- FILL: contents
		local contents = vgui.Create("DPanel", body)
		contents:SetDrawBackground(false)
		contents:Dock(FILL)
		contents:DockMargin(0, 0, m2, 0)
			
			-- BOTTOM: search
			local psearch = vgui.Create("DPanel", contents)
			psearch:SetTall(m + 20 * ss)
			psearch:Dock(BOTTOM)
			psearch:DockMargin(0, m2, 0, 0)
			psearch:DockPadding(m2, m2, m2, m2)
			psearch.Paint = function(me, w, h)
				draw.RoundedBox(4, 0, 0, w, h, styl.inbg)
			end

				local searchinpt = self:QuickEntry("", psearch, true)
				searchinpt:Dock(FILL)
				searchinpt.Think = function(me)
					if (input.IsKeyDown(KEY_LCONTROL) or input.IsKeyDown(KEY_RCONTROL)) and (input.IsKeyDown(KEY_F)) then
						if (me:HasFocus()) then
							me:SelectAllText()
						else
							me:RequestFocus()
						end
					end
				end
				searchinpt.m_Placeholder = L"search"
				
				local sort = self:QuickComboBox(psearch, true)
				sort:AddChoice(L"sort", nil, true)
				sort:AddChoice(L"name" .. " (▼)", function(a, b) return a.Name > b.Name end)
				sort:AddChoice(L"name" .. " (▲)", function(a, b) return a.Name < b.Name end)
				sort:AddChoice(L"price" .. " (▼)", function(a, b) return a.PointsCost + a.PremiumPointsCost > b.PointsCost + b.PremiumPointsCost end)
				sort:AddChoice(L"price" .. " (▲)", function(a, b) return a.PointsCost + a.PremiumPointsCost < b.PointsCost + b.PremiumPointsCost end)
				sort:SetWide(wi * 0.1)
				sort:Dock(RIGHT)
				sort:DockMargin(m2, 0, 0, 0)
				
				sort.GetFilter = function(me)
					return select(2, me:GetSelected())
				end
				sort.OnSelect = function(me, index, value, data)
					contents:DisplayItems(sel_cat, sel_cat.__key, searchinpt:GetFilter(), data)
				end
				
				searchinpt.GetFilter = function(me)
					local tx = me:GetValue():lower():Trim()
					return function(item)
						return string.find(item.Name:lower(), tx, 1, true)
					end
				end
				searchinpt.OnChange = function(me)
					local fil = me:GetFilter()
					contents:DisplayItems(sel_cat, sel_cat.__key, fil, sort:GetFilter())
				end

			local scroll = vgui.Create("DScrollPanel", contents)
			scroll:Dock(FILL)
			self:PaintScroll(scroll)

				local list_tile = vgui.Create("DIconLayout", scroll)
				list_tile:SetVisible(false)
				list_tile:SetSpaceX(m2)
				list_tile:SetSpaceY(m2)
				body.m_ListTile = list_tile

				local list_list = vgui.Create("DPanel", scroll)
				list_list:SetDrawBackground(false)
				list_list:SetVisible(false)
				body.m_ListList = list_list

		local prevcont
		contents.DisplayCustom = function(me, cont)
			self:RemoveIfValid(prevcont)

			sel_cat = nil
			sel_item = nil

			list_tile:Clear()
			list_tile:SetVisible(false)
			list_list:Clear()
			list_list:SetVisible(false)
			psearch:SetVisible(false)

			cont:SetParent(contents)
			cont:Dock(FILL)
			prevcont = cont
		end
		contents.DisplayItems = function(me, category, catid, filter, sort)
			local is_tile = category.ListType == 0
			local is_list = category.ListType == 1

			list_tile:Clear()
			list_list:Clear()
			
			local items = SH_POINTSHOP.Categories[catid].Items
			if (sort) then
				items = {}
				for class, item in pairs (SH_POINTSHOP.Categories[catid].Items) do
					table.insert(items, item)
				end

				table.sort(items, sort)
			end

			for class, item in pairs (items) do
				if (filter and !filter(item)) then
					continue end
			
				local p = self:QuickButton("", function()
					if (sel_item == item.ClassName) then
						return end

					local olditem
					local oldhas, olditm
					if (sel_item) then
						oldhas, olditm = LocalPlayer():SH_HasItem(sel_item)
						olditem = self.Items[sel_item]
					end

					sel_item = item.ClassName
					local has, itm = LocalPlayer():SH_HasItem(sel_item)

					self:CallPanelHook("OnItemSelected", item, itm, olditem, olditm)
				end, is_list and list_list or list_tile)
				p:DockPadding(m2, m2, m2, m2)

					local lbl = self:QuickLabel(item.Name, "{prefix}Medium", styl.text, p)
					self:AddPanelHook("OnItemSelected", lbl, function(me, selitem)
						me:SetColor((selitem.ClassName == item.ClassName) and styl.header or styl.text) -- 76561198006360147
					end)

					local prev = vgui.Create("DPanel", p)
					prev:SetMouseInputEnabled(false)
					prev:Dock(FILL)
					prev.Paint = function(me, w, h)
						draw.RoundedBox(4, 0, 0, w, h, styl.bg)
					end

						local cust
						if (item.HasCustomItemIcon) then
							cust = item:CustomItemIcon(prev)
						end

						if (cust) then
							cust:SetParent(prev)
						elseif (simple_icons:GetBool()) or ((!item.Material or item.Material == "") and (!item.Model or item.Model == "")) then
							local s = ""
							for _, v in pairs (string.Explode(" ", item.Name)) do
								if (v == "") then
									continue end

								s = s .. v[1]:upper()
							end

							local lbl = self:QuickLabel(item.SimpleName or s, "{prefix}Largest", styl.text, prev)
							lbl:SetContentAlignment(5)
							lbl:Dock(FILL)
						elseif (item.Model and item.Model ~= "") or (item.DisplayData and item.DisplayData.display) then
							local mdl = vgui.Create("DModelPanel", prev)
							mdl:Dock(FILL)
							mdl.LayoutEntity = function() end

							-- Is this a hat or anything applied on a playermodel?
							if (item.DisplayData and item.DisplayData.display) then
								-- Modify entity appearance
								mdl:SetModel(self.PreviewModel)

								mdl.Entity:SetMaterial("models/debug/debugwhite")
								mdl:SetColor(Color(200, 200, 200))
								mdl.DirectionalLight = {}
								mdl:SetDirectionalLight(BOX_RIGHT, Color(255, 255, 255))
								mdl:SetDirectionalLight(BOX_FRONT, Color(255, 255, 255))
								mdl:SetDirectionalLight(BOX_TOP, Color(255, 255, 255))

								-- Proper freeze the entity
								local matrixes = {}

								mdl.Entity:AddCallback("BuildBonePositions", function(ent, numbones)
									for i, m in pairs (matrixes) do
										local b = ent:GetBoneName(i)
										if (b ~= "__INVALIDBONE__") then
											local mat = Matrix()
											mat:SetTranslation(m[1])
											mat:SetAngles(m[2])
											ent:SetBoneMatrix(i, mat)
										end
									end
								end)

								-- Apply focus part
								local focus = self.FocusParts[item.FocusPart]
								if (focus) then
									if (focus.campos) then mdl:SetCamPos(focus.campos) end
									if (focus.lookat) then mdl:SetLookAt(focus.lookat) end
									if (focus.fov) then mdl:SetFOV(focus.fov) end
									if (focus.angle) then mdl.Entity:SetAngles(focus.angle) end
								end

								mdl.Entity:SetupBones()
								for i = 0, mdl.Entity:GetBoneCount() - 1 do
									local bn = mdl.Entity:GetBoneName(i)
									if (bn == "__INVALIDBONE__") then
										continue end

									local mat = mdl.Entity:GetBoneMatrix(i)
									if (!mat) then
										continue end

									matrixes[i] = {mat:GetTranslation(), mat:GetAngles()}
								end

								-- Draw cosmetic(s)
								local a = item
								if (a and a.DisplayData) then
									if (a.DisplayData.is_pac) then
										local pac_setup = pac_setup

										mdl.PreDrawModel = function(me, ent)
											if (!pac) then
												return end

											if (!pac_setup) then
												pac_setup = true
												pac.SetupENT(ent)

												for id, outfit in pairs (a.DisplayData.props) do
													outfit = self:SilentPACOutfit(outfit)
													ent:AttachPACPart(outfit, LocalPlayer())
												end
											else
												local x, y = me:LocalToScreen(0, 0)
												local w, h = me:GetSize()

												local ang = me.aLookAngle
												if (!ang) then
													ang = (me.vLookatPos - me.vCamPos):Angle()
												end

												pac.DrawEntity2D(ent, x, y, w, h, me:GetCamPos(), ang, me:GetFOV())
											end

											return false
										end
									else
										mdl.PostDrawModel = function(me, ent)
											draw_displaydata(ent, a.DisplayData, class, nil)
										end
									end
								end
							else
								-- easy
								mdl:SetModel(item.Model)
								if item.Skin then
									mdl:SetSkin(item.Skin)
								end

								if (item.AutoCameraAdjust) then
									local mins, maxs = mdl.Entity:GetRenderBounds()
									mdl:SetCamPos(mins:Distance(maxs) * Vector(0.5, 0.5, 0.5))
									mdl:SetLookAt((maxs + mins) * 0.5)
								end

								mdl.LayoutEntity = function(me, ent)
									if (p.Hovered) then
										ent:SetAngles(Angle(0, ent:GetAngles().y + 0.5, 0))
									end
								end
							end
						elseif (item.Material and item.Material ~= "") then
							local img = vgui.Create("DImage", prev)
							img:SetImage(item.Material)
							img:Dock(FILL)
						end

						local indicator = vgui.Create("DImage", prev)
						indicator:SetMaterial(matPossessed)
						indicator:SetPos(m2, m2)
						indicator:SetSize(16, 16)
						indicator.Update = function(me)
							local mat
							if (LocalPlayer():SH_HasEquipped(class)) then
								mat = matEquipped
							elseif (LocalPlayer():SH_HasItem(class)) then
								mat = matPossessed
							end

							if (mat) then
								me:SetMaterial(mat)
								me:SetVisible(true)
							else
								me:SetVisible(false)
							end
						end
						self:AddPanelHook("OnInventoryUpdated", indicator, function(me)
							me:Update()
						end)
						self:AddPanelHook("OnEquippedUpdated", indicator, function(me)
							me:Update()
						end)
						indicator:Update()

				if (is_tile) then
					p:SetSize(category.ItemDimensions.width * ss, category.ItemDimensions.height * ss + lbl:GetTall() + m2)

					lbl:SetContentAlignment(5)
					lbl:Dock(BOTTOM)
					lbl:DockMargin(0, m2, 0, 0)
				elseif (is_list) then
					p:SetTall(category.ItemDimensions.height * ss + m)
					p:Dock(TOP)
					p:DockMargin(0, 0, 0, m2)

					prev:Dock(LEFT)
					prev:SetSize(category.ItemDimensions.width * ss, category.ItemDimensions.height * ss)

					lbl:SetContentAlignment(5)
					lbl:Dock(FILL)
					lbl:DockMargin(m2, 0, 0, 0)
				end
			end
		end
		contents.DisplayCategory = function(me, category, catid)
			if (sel_cat and sel_cat.Name == category.Name) then
				return end

			if (sel_cat) then
				sel_cat:OnLeave(body)
			end

			self:HidePreview(false)
			self:RemoveIfValid(prevcont)

			sel_cat = category
			sel_item = nil

			category:OnEnter(body)

			local is_tile = category.ListType == 0
			local is_list = category.ListType == 1

			body:InvalidateParent(true)
			contents:InvalidateParent(true)
			scroll:InvalidateParent(true)

			list_tile:SetVisible(is_tile)
			list_tile:SetSize(scroll:GetSize())
			list_list:SetVisible(is_list)
			list_list:SetSize(scroll:GetSize())
			psearch:SetVisible(true)

			me:DisplayItems(category, catid, searchinpt:GetFilter(), sort:GetFilter())

			list_list:InvalidateLayout(true)
			list_list:SizeToChildren(false, true)
			self:CallPanelHook("OnCategorySelected", category)
		end

		-- RIGHT: preview
		local right = vgui.Create("DPanel", body)
		right:SetDrawBackground(false)
		right:SetWide(wi * 0.3)
		right:Dock(RIGHT)
		_SH_POINTSHOP.m_Preview = right

			local pw = right:GetWide() * 0.5 - m2 * 0.5
			local ph = m + 24 * ss
			local pd = (ph - 16 * ss) * 0.5

			local creds = vgui.Create("DPanel", right)
			creds:SetDrawBackground(false)
			creds:SetTall(ph)
			creds:Dock(TOP)

				local std = vgui.Create("DPanel", creds)
				std:SetTooltipLounge(L"Points", styl.inbg)
				std:SetWide(pw)
				std:Dock(LEFT)
				std:DockPadding(pd, pd, pd, pd)
				std.Paint = function(me, w, h)
					draw.RoundedBox(4, 0, 0, w, h, styl.inbg)
				end

					local ico = vgui.Create("DImage", std)
					ico:SetMaterial(self.StandardPointsIcon)
					ico:SetSize(16 * ss, 16 * ss)
					ico:Dock(LEFT)

					local std_lbl = self:QuickLabel(string.Comma(LocalPlayer():SH_GetStandardPoints()), "{prefix}Large", styl.text, std)
					std_lbl:SetContentAlignment(6)
					std_lbl:Dock(FILL)

				local prm = vgui.Create("DPanel", creds)
				prm:SetTooltipLounge(L"Credits", styl.inbg)
				prm:SetWide(pw)
				prm:Dock(RIGHT)
				prm:DockPadding(pd, pd, pd, pd)
				prm.Paint = function(me, w, h)
					draw.RoundedBox(4, 0, 0, w, h, styl.inbg)
				end

					local ico = vgui.Create("DImage", prm)
					ico:SetMaterial(self.PremiumPointsIcon)
					ico:SetSize(16 * ss, 16 * ss)
					ico:Dock(LEFT)

					local prm_lbl = self:QuickLabel(string.Comma(LocalPlayer():SH_GetPremiumPoints()), "{prefix}Large", styl.text, prm)
					prm_lbl:SetContentAlignment(6)
					prm_lbl:Dock(FILL)
					-- 76561198006360128

			self:AddPanelHook("OnPointsUpdated", creds, function(me, standard, premium)
				std_lbl:SetText(string.Comma(standard))
				prm_lbl:SetText(string.Comma(premium))
			end)

			local prev = vgui.Create("DPanel", right)
			prev:SetDrawBackground(false)
			prev:Dock(FILL)
			prev:DockMargin(0, m2, 0, 0)

				local pac_setup = false

				local prevmdl = vgui.Create("DModelPanel", prev)
				prevmdl:SetFOV(45)
				prevmdl:Dock(FILL)
				prevmdl.LayoutEntity = function() end
				prevmdl.OldPaint = prevmdl.Paint
				prevmdl.Paint = function(me, w, h)
					draw.RoundedBox(4, 0, 0, w, h, styl.inbg)
					me:OldPaint(w, h)
					me:UpdateModel()
				end
				prevmdl.PreDrawModel = function(me, ent)
					if (closing) then
						return end

					if (pac and !pac_setup) then
						pac_setup = true
						pac.SetupENT(ent)
					end

					local prev_item
					if (sel_item) then
						prev_item = self.Items[sel_item]
						if (prev_item) and (!prev_item.DisplayData or !prev_item.DisplayData.display) then
							prev_item = nil
						end
					end

					local stop = self:DrawPreview2D(me, ent, false, prev_item)
					if (stop) then
						return false
					end
				end
				prevmdl.m_bPreviewing = false
				prevmdl.UpdateModel = function(me)
					if (me.m_bPreviewing) then
						return end

					local mdl = LocalPlayer():GetModel()
					if (mdl == "models/player.mdl") then
						mdl = player_manager.TranslatePlayerModel(GetConVarString("cl_playermodel"))
					end

					if (me:GetModel() ~= mdl) then
						me:SetModel(mdl)
						self:RebuildEquippedModels(me.Entity, LocalPlayer())
					end
				end
				self:InstallModelControls(prevmdl)

				self:AddPanelHook("OnEquippedUpdated", prevmdl, function(me)
					me:UpdateModel()
				end, true)

				local previtem = vgui.Create("DPanel", prev)
				previtem:SetTall(he * 0.20)
				previtem:Dock(BOTTOM)
				previtem:DockPadding(m2, m2, m2, m2)
				previtem:DockMargin(0, m2, 0, 0)
				previtem.Paint = function(me, w, h)
					draw.RoundedBox(4, 0, 0, w, h, styl.inbg)
				end

					local prevname = self:QuickLabel("", "{prefix}Large", styl.text, previtem)
					prevname:SetMouseInputEnabled(true)
					prevname:Dock(TOP)

						local adjustbtn = vgui.Create("DButton", prevname)
						adjustbtn.DoClick = function(me)
							self:ShowAdjustMenu(me.m_sItemClass)
						end
						adjustbtn:SetText("")
						adjustbtn:SetTooltipLounge(L"adjust_tooltip")
						adjustbtn:SetVisible(false)
						adjustbtn:SetSize(prevname:GetTall(), prevname:GetTall())
						adjustbtn:Dock(RIGHT)
						adjustbtn.Paint = function(me, w, h)
							surface.SetMaterial(matAdjust)
							surface.SetDrawColor(styl.text)
							surface.DrawTexturedRect(w * 0.5 - 8, h * 0.5 - 8, 16, 16)
						end
						adjustbtn.Update = function(me)
							-- makes more sense to adjust per class than iD
							local item = self.Items[me.m_sItemClass]
							me:SetVisible(LocalPlayer():SH_CanAdjust() and LocalPlayer():SH_HasEquipped(me.m_sItemClass) and item.DisplayData and item.DisplayData.display)
						end

					local prevscroll = vgui.Create("DScrollPanel", previtem)
					prevscroll:Dock(FILL)
					self:PaintScroll(prevscroll)

						local prevdesc = self:QuickLabel("", "{prefix}Medium", styl.text, prevscroll)
						prevdesc:SetWrap(true)
						prevdesc:SetAutoStretchVertical(true)
						prevdesc:SetWide(right:GetWide() - m)

					local prevprice = self:QuickLabel("", "{prefix}Large", styl.text, previtem)
					prevprice:SetZPos(10)
					prevprice:Dock(BOTTOM)

					local buttons = vgui.Create("DPanel", previtem)
					buttons:SetDrawBackground(false)
					buttons:SetVisible(false)
					buttons:SetTall(24 * ss)
					buttons:Dock(BOTTOM)
					buttons:DockMargin(0, m2, 0, 0)

						local buysell = self:QuickButton("", function(me)
							if (!me.m_sItemClass and !me.m_iItemID) then
								return end
							Derma_Query("Are you sure?  ".. me.m_sItemClass .. "  ", "Buying/Selling "..me.m_sItemClass,"Yes", function()
								easynet.SendToServer(me.m_bSell and "SH_POINTSHOP.SellItem" or "SH_POINTSHOP.PurchaseItem", {class = me.m_sItemClass, id = me.m_iItemID})
							end, "No", function() return end )
							 -- 76561198006360138
						end, buttons)
						buysell:SetWide((right:GetWide() - m * 1.5) * 0.5)
						buysell:Dock(LEFT)
						buysell.m_Background = styl.header
						buysell.m_sItemClass = nil
						buysell.m_iItemID = nil
						buysell.m_bSell = false
						buysell.Update = function(me)
							if (me.m_sItemClass) then
								local has, itm = LocalPlayer():SH_HasItem(me.m_sItemClass)

								me.m_bSell = has
								if (itm) then
									me.m_iItemID = itm.id
								end
							else
								me.m_bSell = false
							end

							me:SetText(me.m_bSell and L"Sell Now" or L"Purchase")
						end

						local equip = self:QuickButton("", function(me)
							local id = me.m_iItemID
							if (!id) then
								local has, itm = LocalPlayer():SH_HasItem(me.m_sItemClass)
								if (!has) then
									return end

								id = itm.id
							end

							easynet.SendToServer(me.m_bEquipped and "SH_POINTSHOP.UnequipItem" or "SH_POINTSHOP.EquipItem", {id = id})
						end, buttons, nil, nil, true)
						equip:SetVisible(false)
						equip:SetWide(buysell:GetWide())
						equip:Dock(RIGHT)
						equip.m_Background = styl.header
						equip.m_sItemClass = nil
						equip.m_iItemID = nil
						equip.Update = function(me)
							if (me.m_iItemID and LocalPlayer():SH_HasItemID(me.m_iItemID)) then -- In Inventory
								me:SetVisible(true)
							else
								local has, itm = LocalPlayer():SH_HasItem(me.m_sItemClass)

								me:SetVisible(has)
								if (itm) then
									me.m_iItemID = itm.id
								end
							end

							me.m_bEquipped = LocalPlayer():SH_HasEquipped(me.m_sItemClass)
							me:SetText(me.m_bEquipped and L"unequip" or L"equip")
						end

						self:AddPanelHook("OnInventoryUpdated", buttons, function(me)
							adjustbtn:Update()
							buysell:Update()
							equip:Update()
						end, true)
						self:AddPanelHook("OnEquippedUpdated", buttons, function(me)
							adjustbtn:Update()
							equip:Update()
						end)

				self:AddPanelHook("OnCategorySelected", previtem, function(me, category)
					prevmdl.m_bPreviewing = false
					prevmdl:UpdateModel()
					self:FlushPreview2D()

					local possessed = 0
					for class in pairs (category.Items) do
						if (LocalPlayer():SH_HasItem(class)) then
							possessed = possessed + 1
						end
					end

					prevname:SetText(L(category.Name))
					prevdesc:SetText(self:LangFormat("you_have_x_items_out_of_y_in_category", {amount = possessed, total = table.Count(category.Items)}))
					prevprice:SetText("")

					buttons:SetVisible(false)
					adjustbtn:SetVisible(false)
				end)
				self:AddPanelHook("OnItemSelected", previtem, function(me, item, itm, olditem, olditm)
					-- Clear previews
					if (olditem) then
						if (olditem.DisplayData and olditem.DisplayData.display) then
							self:RemoveFakeModel(prevmdl.Entity, olditem.ClassName)
						end

						if (olditem.IsPlayerModel) then
							prevmdl.m_bPreviewing = false
							prevmdl:UpdateModel()
						end
					end

					prevname:SetText(item.Name)
					prevdesc:SetText(item.Description)
					prevprice:SetText(self:GetPriceString(item, nil, LocalPlayer()))

					buttons:SetVisible(true)
					adjustbtn.m_sItemClass = item.ClassName
					adjustbtn:Update()
					buysell.m_iItemID = itm and itm.id or nil
					buysell.m_sItemClass = item.ClassName
					buysell:Update()
					equip.m_iItemID = itm and itm.id or nil
					equip.m_sItemClass = item.ClassName
					equip:Update()

					if (item.SelectSound and item.SelectSound ~= "") then
						surface.PlaySound(item.SelectSound)
					end

					-- Preview playermodel
					if (item.IsPlayerModel) then
						prevmdl.m_bPreviewing = true
						prevmdl:SetModel(item.Model)
						self:RebuildEquippedModels(prevmdl.Entity, LocalPlayer())
					end
				end)
				self:AddPanelHook("OnItemCleared", previtem, function(me, item, itm)
					prevname:SetText("")
					prevdesc:SetText("")
					prevprice:SetText("")

					buttons:SetVisible(false)
					adjustbtn.m_sItemClass = nil
					buysell.m_sItemClass = nil
					equip.m_iItemID = nil
					equip.m_sItemClass = nil
				end)

		-- LEFT: tabs
		local navbar

		local function BuildTabs(admin_mode)
			local tabs = {}

			if (!admin_mode) then
				local first = true
				for catid, cat in SortedPairsByMemberValue (self.Categories, "Index") do
					local name = L(cat.Name)

					if (cat.CanAccess and cat:CanAccess(LocalPlayer()) == false) then
						continue end

					table.insert(tabs, {
						text = name,
						desc = name .. " - " .. cat.Description,
						icon = cat.IconMaterial,
						func = function()
							contents:DisplayCategory(cat, catid)
						end,
						default = first,
					})
					first = false
				end
			end

			hook.Run("SH_POINTSHOP.BuildNavBar", tabs, body, contents, admin_mode)

			local bottomtabs = {
				{
					text = L"admin",
					desc = L"admin" .. " - " .. L"toggle_admin_actions",
					icon = Material("shenesis/pointshop/iglogo.png"),
					func = function()
						-- Delete the current tab
						if not (admin_mode) then
							self:HidePreview(true)
							self:RemoveIfValid(prevcont)

							sel_cat = category
							sel_item = nil

							list_tile:Clear()
							list_tile:SetVisible(false)
							list_tile:SetSize(scroll:GetSize())
							list_list:Clear()
							list_list:SetVisible(false)
							list_list:SetSize(scroll:GetSize())
						end

						--
						navbar:RebuildTabs(BuildTabs(!admin_mode))
						return false
					end,
					dock = BOTTOM,
					order = -9,
				}
			}
			hook.Run("SH_POINTSHOP.BuildNavBarBottom", bottomtabs, body, contents, admin_mode)

			for k, v in SortedPairsByMemberValue(bottomtabs, "order") do
				table.insert(tabs, v)
			end

			return tabs
		end

		navbar = self:NavBar(wnd, BuildTabs(false), true)
		navbar.OnToggle = function(me, b)
			body:InvalidateParent(true)
			contents:InvalidateParent(true)
			scroll:InvalidateParent(true)

			list_tile:SetSize(scroll:GetSize())
			list_tile:Layout()
		end

	wnd:SetAlpha(0)
	wnd:AlphaTo(255, 0.2)
end