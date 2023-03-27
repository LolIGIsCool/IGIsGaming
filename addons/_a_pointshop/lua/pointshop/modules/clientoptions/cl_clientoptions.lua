local ps = SH_POINTSHOP
local MODULE = MODULE or ps.Modules.clientoptions

function MODULE:BuildTab(body, contents)
	ps:HidePreview(true)

	local m = ps:GetMargin()
	local m2 = m * 0.5
	local ss = ps:GetScreenScale()
	local styl = ps.Style

	local cont = ps:CreateGroup(ps:LangFormat("opt_options"), body)

		local scroll = vgui.Create("DScrollPanel", cont)
		scroll:Dock(FILL)
		ps:PaintScroll(scroll)

	for _, cat in pairs (self.Options) do
		local lbl = ps:QuickLabel(ps:LangFormat(cat.catname), "{prefix}Large", styl.text, scroll)
		lbl:Dock(TOP)

		for __, opt in pairs (cat.opts) do
			local o
			if (opt.type == TYPE_BOOL) then
				o = ps:CheckboxLabel(ps:LangFormat(opt.text), opt.cvar, scroll)
				o.m_bDrawBackground = true
			elseif (opt.type == TYPE_NUMBER) then
				o = ps:QuickLabel(ps:LangFormat(opt.text), "{prefix}Medium", styl.text, scroll)
				o:SetMouseInputEnabled(true)
				o:SetKeyboardInputEnabled(true)

					local num = vgui.Create("DNumberWang", o)
					num:SetMinMax(opt.min, opt.max)
					num:SetDecimals(opt.decimals)
					num:SetValue(GetConVarNumber(opt.cvar) or 0)
					num:SetConVar(opt.cvar)
					num:Dock(RIGHT)
					num:SetWide(contents:GetWide() * 0.25)
					ps:EntryStyle(num, true)
			end

			if (o) then
				o:Dock(TOP)
			end
		end

		local sep = vgui.Create("DPanel", scroll)
		sep:SetDrawBackground(false)
		sep:SetTall(m)
		sep:Dock(TOP)
	end

	contents:DisplayCustom(cont)
end

hook.Add("SH_POINTSHOP.BuildNavBarBottom", "SH_POINTSHOP.ClientOptions", function(bottomtabs, body, contents, admin_mode)
	if (admin_mode) then
		return end

	table.insert(bottomtabs, {
		text = ps.Language.opt_options,
		desc = ps.Language.opt_options .. " - " .. ps.Language.opt_options_desc,
		icon = Material("shenesis/general/options.png"),
		func = function(me)
			MODULE:BuildTab(body, contents)
		end,
		dock = BOTTOM,
		order = 1.5,
	})
end)