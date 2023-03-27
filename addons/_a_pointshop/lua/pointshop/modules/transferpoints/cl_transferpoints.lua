local ps = SH_POINTSHOP
local easynet = ps.easynet
local MODULE = MODULE or ps.Modules.transferpoints

function MODULE:BuildTab(body, contents)
	ps:HidePreview(true)

	local m = ps:GetMargin()
	local m2 = m * 0.5
	local ss = ps:GetScreenScale()
	local styl = ps.Style

	local cont = vgui.Create("DPanel", body)
	cont:SetDrawBackground(false)

		-- Target
		local grp_targ = ps:CreateGroup(ps.Language.target, cont)
		grp_targ:Dock(TOP)

			local p = vgui.Create("DPanel", grp_targ)
			p:SetDrawBackground(false)
			p:SetTall(24)
			p:Dock(TOP)

				local avi = ps:Avatar(0, 24, p)
				avi:Dock(LEFT)

				local choice = ps:QuickComboBox(p)
				choice:Dock(FILL)
				choice:DockMargin(m2, 0, 0, 0)
				choice.m_Background = styl.bg
				choice.OnSelect = function(me, index, value, data)
					if (!IsValid(data)) then
						me:SetValue("")
						return
					end

					avi:SetPlayer(data)
					me.m_Target = data
				end

				for _, v in ipairs (player.GetAll()) do
					if (v == LocalPlayer()) then
						continue end

					choice:AddChoice(v:Nick(), v)
				end

		grp_targ:InvalidateLayout(true)
		grp_targ:SizeToChildren(false, true)

		-- Standard Points
		local amt_std
		if (self:CanStandardTransfer(LocalPlayer())) then
			local grp_std = ps:CreateGroup(ps.Language.standard_points .. " (" .. string.Comma(self.Config.MinimumStandardPoints) .. " - " .. string.Comma(self.Config.MaximumStandardPoints) .. ")", cont)
			grp_std:Dock(TOP)
			grp_std:DockMargin(0, m2, 0, 0)

				amt_std = ps:QuickEntry("0", grp_std, true)
				amt_std:SetNumeric(true)
				amt_std:SetTall(24)
				amt_std:Dock(TOP)

			grp_std:InvalidateLayout(true)
			grp_std:SizeToChildren(false, true)
		end

		-- Premium Points
		local amt_prm
		if (self:CanPremiumTransfer(LocalPlayer())) then
			local grp_prm = ps:CreateGroup(ps.Language.premium_points .. " (" .. string.Comma(self.Config.MinimumPremiumPoints) .. " - " .. string.Comma(self.Config.MaximumPremiumPoints) .. ")", cont)
			grp_prm:Dock(TOP)
			grp_prm:DockMargin(0, m2, 0, 0)

				amt_prm = ps:QuickEntry("0", grp_prm, true)
				amt_prm:SetNumeric(true)
				amt_prm:SetTall(24)
				amt_prm:Dock(TOP)

			grp_prm:InvalidateLayout(true)
			grp_prm:SizeToChildren(false, true)
		end

		local submit = ps:QuickButton("Transfer Credits", function()
			if (!IsValid(choice.m_Target)) then
				return end

			local std, prm = IsValid(amt_std) and tonumber(amt_std:GetValue()) or 0, IsValid(amt_prm) and tonumber(amt_prm:GetValue()) or 0
			if (std <= 0 and prm <= 99) then
			chat.AddText("100 Credit Limit not met.")
				return end

			easynet.SendToServer("SH_POINTSHOP.TransferPoints", {
				target = choice.m_Target,
				standard = std,
				premium = prm,
			})
		end, cont)
		submit:Dock(TOP)
		submit:DockMargin(0, m2, 0, 0)

	contents:DisplayCustom(cont)
end

hook.Add("SH_POINTSHOP.BuildNavBarBottom", "SH_POINTSHOP.TransferPoints", function(bottomtabs, body, contents, admin_mode)
	if (admin_mode) or (!MODULE.Config.Enable) or (!MODULE:CanStandardTransfer(LocalPlayer()) and !MODULE:CanPremiumTransfer(LocalPlayer())) then
		return end

	table.insert(bottomtabs, {
		text = ps.Language.transfer_points,
		desc = ps.Language.transfer_points .. " - " .. ps.Language.transfer_points_desc,
		icon = Material("shenesis/pointshop/transfer.png"),
		func = function(me)
			MODULE:BuildTab(body, contents)
		end,
		dock = BOTTOM,
		order = 2,
	})
end)