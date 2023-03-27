net.Receive("Armory_SyncWeapons", function()
	local tbl = {}
	local tblLength = net.ReadUInt(8)
	for _ = 1, tblLength do
		tbl[net.ReadString()] = true
	end
	LocalPlayer().ArmoryWeapons = {}
	LocalPlayer().ArmoryWeapons = tbl
end)



surface.CreateFont( "StarHUDFontTitle", {
	font = "Laconic",
	weight = 400,
	bold = true,
	shadow = true,
	size = ScreenScale(10)
} )

surface.CreateFont( "StarHUDFontWeapon", {
	font = "Laconic",
	weight = 400,
	bold = true,
	shadow = true,
	size = 24,
} )

surface.CreateFont( "StarHUDFontWeapon2", {
	font = "Laconic",
	weight = 400,
	bold = true,
	shadow = true,
	size = 18,
} )

surface.CreateFont( "StarHUDFontWeapon3", {
	font = "Laconic",
	weight = 400,
	bold = true,
	shadow = true,
	size = 14,
})

net.Receive("Armory_OpenMenu", function()
	if mainFrame then mainFrame:Remove() end

	local bar_text = ""
	local selected_weapon = ""
	local price = 0
	mainFrame = vgui.Create("DFrame")
	mainFrame:SetSize(900,600)
	mainFrame:SetTitle("")
	mainFrame:Center()
	mainFrame:MakePopup()
	mainFrame.Models = {}
	mainFrame.Selected = 1
	mainFrame.Paint = function(self, w,h)
		surface.SetDrawColor(38, 38, 38)
		surface.DrawRect(0,0,w,h)
		surface.SetTextColor(255,255,255)
		surface.SetTextPos(w * 0.42,h * 0.01)
		surface.SetFont("StarHUDFontWeapon2")
		surface.DrawText("Imperial Armory")
	end

	local scrollPanel = vgui.Create("DScrollPanel", mainFrame)
	scrollPanel:SetSize(mainFrame:GetWide() * 0.685,mainFrame:GetTall())
	scrollPanel:Dock(LEFT)

	local infoPanel = vgui.Create("DPanel", mainFrame)
	infoPanel:SetWide(mainFrame:GetWide() * 0.30)
	infoPanel:Dock(RIGHT)
	infoPanel.Paint = function(self,w,h)
		surface.SetDrawColor(80, 80, 80)
		surface.DrawRect(0,0,w,h)

		draw.DrawText( bar_text, "GModToolSubtitle", w * 0.5, h * 0.1, Color( 255, 255, 255), TEXT_ALIGN_CENTER )
		if price > 0 then
			draw.DrawText( "Cost: " .. price, "StarHUDFontWeapon3", w * 0.5, h * 0.225, Color( 255, 255, 255), TEXT_ALIGN_CENTER )
		end
	end

	local purchaseButton = vgui.Create("DButton",infoPanel)
	purchaseButton:SetText("")
	purchaseButton:SetPos(infoPanel:GetWide() * 0.21,mainFrame:GetTall() * 0.3)
	purchaseButton:SetSize(infoPanel:GetWide() * 0.6,mainFrame:GetTall() * 0.07)
	purchaseButton.Paint = function(self,w,h)
		if price > 0 then
			surface.SetDrawColor(200,200,200)
			surface.DrawRect(0,0,w,h)

			draw.DrawText( "PURCHASE", "GModToolHelp", w * 0.5, h * 0.32, Color( 80,80,80), TEXT_ALIGN_CENTER)
		end
	end
	purchaseButton.DoClick = function()
		if price > 0 then
			net.Start("Armory_BuyWeapons")
			net.WriteString(selected_weapon)
			net.SendToServer()
			mainFrame:Close()
			LocalPlayer().InArmory = false
			print(selected_weapon)
		end
	end

	local sdsdtable = table.GetKeys(SArmory.Database)
	
	for i = 1, table.Count(SArmory.Database) do
		local DImageButton = scrollPanel:Add( "DImageButton" )
		DImageButton:Dock( TOP )
		DImageButton:SetTall(mainFrame:GetTall() * 0.2)
		DImageButton:DockMargin( 0, 0, 5, 5 )
		DImageButton:SetText(sdsdtable[i])
		local material = Material("vanilla/armory/" .. sdsdtable[i] .. ".png")
		if material:IsError() then
			material = Material("vanilla/armory/dartgun.png")
		end
		DImageButton:SetMaterial(material)
		DImageButton.DoClick = function()
			for k, v in pairs(SArmory.Database) do
				if k == sdsdtable[i] then
					bar_text = v.Name
					selected_weapon = v.ID
					price = v.Cost
					break
				end
			end
		end
	end
end)