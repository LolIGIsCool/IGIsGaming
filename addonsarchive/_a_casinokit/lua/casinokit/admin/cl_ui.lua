
local function OpenUI(data)
	local fr = vgui.Create("DFrame")
	fr:SetTitle("CasinoKit Config")
	fr:SetSkin("CasinoKit")

	local p = fr:Add("DForm")
	p:Dock(FILL)

	local dc = p:TextEntry("Disabled currencies (separate by comma)")
	dc:SetText(data["currency.disabled"] or "")

	local pc = p:TextEntry("Primary currency:")
	pc:SetText(data["currency.primary"] or "")

	p:Button("Save").DoClick = function()
		net.Start("casinokit_admin")

		data["currency.disabled"] = dc:GetText()
		data["currency.primary"] = pc:GetText()

		net.WriteTable(data)
		net.SendToServer()

		fr:Close()
	end

	fr:SetSize(800, 600)
	fr:Center()
	fr:MakePopup()
end

net.Receive("casinokit_admin", function()
	OpenUI(net.ReadTable())
end)