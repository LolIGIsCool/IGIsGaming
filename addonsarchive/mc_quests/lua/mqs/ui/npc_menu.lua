local NpcMenu

function MQS.OpenNPCMenu(npc)
	local npc_table
	local simple_npc = false
	if NpcMenu then return end

	if npc:GetClass() == "mqs_npc" then
		npc_table = MQS.Config.NPC.list[npc:GetUID()]
		if not npc_table then return end
	end

	if npc:GetClass() == "mcs_npc" then
		simple_npc = true
	end

	local tasks = MQS.ActiveQuestLists(npc:GetUID())
	local sw, sh = ScrW(), ScrH()
	NpcMenu = vgui.Create("MSDSimpleFrame")
	NpcMenu:SetSize(sw, sh)
	NpcMenu:SetDraggable(false)
	NpcMenu:Center()
	NpcMenu:MakePopup()

	NpcMenu.OnClose = function()
		NpcMenu = nil
	end

	NpcMenu:SetAlpha(1)
	NpcMenu:AlphaTo(255, 0.4)
	NpcMenu.Page = 1
	NpcMenu.Pages = {}

	NpcMenu.Paint = function(self, w, h)
		Derma_DrawBackgroundBlur(self, self.startTime)

		if not npc.GetNamer then
			NpcMenu:Close()

			return
		end

		NpcMenu.Pages[NpcMenu.Page].paint(self, w, h)
	end

	local OpenPage = function(id)
		if not NpcMenu.Pages[id] then return end
		NpcMenu.Page = id
		NpcMenu.Pages[id].onOpne()
	end

	NpcMenu.clsBut = MSD.IconButton(NpcMenu, MSD.Icons48.cross, NpcMenu:GetWide() - 34, 10, 25, nil, MSD.Config.MainColor.p, function()
		if NpcMenu.OnPress then
			NpcMenu.OnPress()

			return
		end

		NpcMenu:AlphaTo(0, 0.4, 0, function()
			NpcMenu:Close()
		end)
	end)

	NpcMenu.Pages[1] = {
		paint = function(self, w, h)
			draw.RoundedBox(8, w / 8, h / 2 - 10, w - w / 4, h / 4 - 10, MQS.Config.UI.BgrColor)
			draw.RoundedBox(8, w / 8, h / 2 - 10, w - w / 4, h / 4 - 10, MSD.Theme["l"])
			draw.SimpleText(npc:GetNamer() .. ":", "MSDFont.32", w / 8 + 12, h / 2 + 12, color_white, TEXT_ALIGN_LEFT, 1)
			local text = MSD.TextWrap(npc_table.text, "MSDFont.28", w - w / 4 - 24)
			draw.DrawText(text, "MSDFont.28", w / 8 + 12, h / 2 + 50, color_white, TEXT_ALIGN_LEFT, 1)
		end,
		onOpne = function()
			if NpcMenu.Paneler then
				NpcMenu.Paneler:Remove()
			end

			NpcMenu.Paneler = vgui.Create("DPanel", NpcMenu)
			NpcMenu.Paneler:SetSize(sw, sh - 100)
			NpcMenu.Paneler:SetPos(0, 100)
			NpcMenu.Paneler.Paint = function(self, w, h) end
			local bs = (sw - sw / 4) / 2 - 15
			local by = sh / 2 + sh / 4 - 180

			MSD.Button(NpcMenu.Paneler, sw / 8 + 10, by, bs, 50, npc_table.answer_yes, function()
				NpcMenu:AlphaTo(1, 0.4, 0, function()
					OpenPage(2)
					NpcMenu:AlphaTo(255, 0.4)
				end)
			end)

			MSD.Button(NpcMenu.Paneler, sw / 8 + bs + 20, by, bs, 50, npc_table.answer_no, function()
				NpcMenu:AlphaTo(0, 0.4, 0, function()
					NpcMenu:Close()
				end)
			end)
		end,
	}

	NpcMenu.Pages[2] = {
		paint = function() end,
		onOpne = function()
			if NpcMenu.Paneler then
				NpcMenu.Paneler:Remove()
			end

			NpcMenu.Paneler = vgui.Create("DPanel", NpcMenu)
			NpcMenu.Paneler:SetSize(sw, sh - 100)
			NpcMenu.Paneler:SetPos(0, 100)
			NpcMenu.Paneler.Paint = function(self, w, h) end
			NpcMenu.Paneler = vgui.Create("MSDPanelList", NpcMenu)
			NpcMenu.Paneler:SetSize(sw - (sw / 6) * 2, sh - (sh / 8) * 2)
			NpcMenu.Paneler:SetPos(sw / 6, sh / 8)
			NpcMenu.Paneler:EnableVerticalScrollbar()
			NpcMenu.Paneler:EnableHorizontal(true)
			NpcMenu.Paneler:SetSpacing(5)
			NpcMenu.Paneler.IgnoreVbar = true

			for k, v in pairs(MQS.Quests) do
				if not tasks[k] then continue end
				local qpnl = vgui.Create("DButton")
				qpnl:SetText("")
				qpnl.alpha = 0

				qpnl.StaticScale = {
					w = 1,
					h = 6,
					minw = 200,
					minh = 120
				}

				qpnl.Paint = function(self, w, h)
					if self.hover then
						self.alpha = Lerp(FrameTime() * 5, self.alpha, 1)
					else
						self.alpha = Lerp(FrameTime() * 5, self.alpha, 0)
					end

					draw.RoundedBox(0, 0, 0, w, h, MQS.Config.UI.BgrColor)
					draw.RoundedBox(0, 0, 0, w, h, MSD.Theme["d"])
					MSD.DrawTexturedRect(0, 0, w, h, MSD.Materials.gradient_right, MSD.ColorAlpha(MSD.Config.MainColor["p"], self.alpha * 55))
					MSD.DrawTexturedRect(0, 0, w, h, MSD.Materials.gradient_right, MSD.ColorAlpha(MSD.Theme["d"], 255 - self.alpha * 255))
					draw.DrawText(v.name, "MSDFont.25", 10, 10, color_white, TEXT_ALIGN_LEFT)
					local text = MSD.TextWrap(v.desc, "MSDFont.28", w - 20)
					draw.DrawText(text, "MSDFont.22", 10, 35, MSD.Text["d"], TEXT_ALIGN_LEFT)
					draw.DrawText(MSD.GetPhrase("q_start"), "MSDFont.25", 10, h - 30, MSD.ColorAlpha(MSD.Config.MainColor["p"], self.alpha * 255), TEXT_ALIGN_LEFT)
					draw.DrawText(MSD.GetPhrase("q_start"), "MSDFont.25", 10, h - 30, MSD.ColorAlpha(MSD.Text["d"], 255 - self.alpha * 255), TEXT_ALIGN_LEFT)

					return true
				end

				qpnl.OnCursorEntered = function(self)
					self.hover = true
				end

				qpnl.OnCursorExited = function(self)
					self.hover = false
				end

				qpnl.DoClick = function(self)
					NpcMenu:Close()
					net.Start("MQS.StartTask")
					net.WriteString(k)
					net.WriteBool(simple_npc)
					if simple_npc then
						net.WriteString(npc:GetUID())
					else
						net.WriteInt(npc:GetUID(), 16)
					end

					net.SendToServer()
				end

				NpcMenu.Paneler:AddItem(qpnl)
			end

			if table.IsEmpty(tasks) then
				local pnl = vgui.Create("DPanel")

				pnl.StaticScale = {
					w = 1,
					h = 1,
					minw = 150,
					minh = 150
				}

				pnl.Paint = function(self, w, h)
					MSD.DrawTexturedRect(w / 2 - 24, h / 2 - 50, 48, 48, MSD.Icons48.account, MSD.Text["n"])
					draw.DrawText(MSD.GetPhrase("There is no quests avalible"), "MSDFont.25", w / 2, h / 2 + 10, MSD.Text["n"], TEXT_ALIGN_CENTER)
				end

				NpcMenu.Paneler:AddItem(pnl)
			end
		end,
	}

	NpcMenu.Pages[3] = {
		paint = function(self, w, h)
			draw.RoundedBox(8, w / 8, h / 2 - 10, w - w / 4, h / 4 - 10, MQS.Config.UI.BgrColor)
			draw.RoundedBox(8, w / 8, h / 2 - 10, w - w / 4, h / 4 - 10, MSD.Theme["l"])
			draw.SimpleText(npc:GetNamer() .. ":", "MSDFont.32", w / 8 + 12, h / 2 + 12, color_white, TEXT_ALIGN_LEFT, 1)
			local text = MSD.TextWrap(npc_table.text_notask, "MSDFont.28", w - w / 4 - 24)
			draw.DrawText(text, "MSDFont.28", w / 8 + 12, h / 2 + 50, color_white, TEXT_ALIGN_LEFT, 1)
		end,
		onOpne = function()
			if NpcMenu.Paneler then
				NpcMenu.Paneler:Remove()
			end

			NpcMenu.Paneler = vgui.Create("DPanel", NpcMenu)
			NpcMenu.Paneler:SetSize(sw, sh - 100)
			NpcMenu.Paneler:SetPos(0, 100)
			NpcMenu.Paneler.Paint = function(self, w, h) end

			MSD.Button(NpcMenu.Paneler, sw / 8 + 10, sh / 2 + sh / 4 - 180, (sw - sw / 4) - 20, 50, npc_table.answer_notask, function()
				NpcMenu:AlphaTo(0, 0.4, 0, function()
					NpcMenu:Close()
				end)
			end)
		end,
	}

	if simple_npc then
		OpenPage(2)
	else
		if table.IsEmpty(tasks) then
			OpenPage(3)
		else
			OpenPage(1)
		end
	end
end

net.Receive("MQS.OpenNPCMenu", function()
	local npc = net.ReadEntity()
	MQS.OpenNPCMenu(npc)
end)