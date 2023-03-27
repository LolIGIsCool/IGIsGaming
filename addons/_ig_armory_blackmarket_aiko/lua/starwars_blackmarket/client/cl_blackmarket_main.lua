

--[[ Nykez 2017. Do not edit ]]--
net.Receive("Blackmarket_SyncWeapons", function()
	local tbl = {}
	local tblLength = net.ReadUInt(8)
	for _ = 1, tblLength do
		tbl[net.ReadString()] = true
	end
	LocalPlayer().BlackmarketWeapons = {}
	LocalPlayer().BlackmarketWeapons = tbl
end)

net.Receive("Blackmarket_OpenMenu", function()
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
		surface.DrawText("Imperial Blackmarket")
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
			net.Start("Blackmarket_BuyWeapons")
			net.WriteString(selected_weapon)
			net.SendToServer()
			mainFrame:Close()
			LocalPlayer().InArmory = false
		end
	end

	local sdsdtable = table.GetKeys(SBlackmarket.Database)

	for i = 1, table.Count(SBlackmarket.Database) do
		local DImageButton = scrollPanel:Add( "DImageButton" )
		DImageButton:Dock( TOP )
		DImageButton:SetTall(mainFrame:GetTall() * 0.2)
		DImageButton:DockMargin( 0, 0, 5, 5 )
		DImageButton:SetText(sdsdtable[i])
		DImageButton:SetMaterial(Material("vanilla/armory/" .. sdsdtable[i] .. ".png"))
		DImageButton.DoClick = function()
			for k, v in pairs(SBlackmarket.Database) do
				if k == sdsdtable[i] then
					bar_text = v.Name
					price = v.Cost
					selected_weapon = v.ID
					break
				end
			end
		end
	end
end)

hook.Add( "PhysgunPickup", "NoTouchingBlackmarket", function( ply, ent )
	if IsValid( ent ) and ent:GetClass() == "starwars_blackmarket" then
		-- ply:ChatPrint(ply:IsDeveloper() and "You cannot edit the blackmarket. Use !blackmarketmenu to edit the location." or "You cannot edit the blackmarket. Contact a SuperAdmin if there is an issue.")
		return false
	end
end )

local function EditBlackmarketLocation(index, type, name, description, pos, ang)
	net.Start("Blackmarket_EditLocation")
	net.WriteUInt(index, 8)
	net.WriteString(type)
	net.WriteString(name or "")
	net.WriteString(description or "")
	net.WriteVector(pos or Vector(0,0,0))
	net.WriteAngle(ang or Angle(0,0,0))
	net.SendToServer()
end
net.Receive("Blackmarket_ConfigMenu", function()
	local locationData = net.ReadTable()
	local isEnabled = net.ReadBool()
	local blackmarket = net.ReadEntity()
	local selectedIndex

	local ConfigFrame = vgui.Create("DFrame")
	ConfigFrame:SetSize(900,600)
	ConfigFrame:SetTitle("")
	ConfigFrame:Center()
	ConfigFrame:MakePopup()
	ConfigFrame.Selected = 1
	ConfigFrame.Paint = function(self, w,h)
		surface.SetDrawColor(38, 38, 38)
		surface.DrawRect(0,0,w,h)
		surface.SetTextColor(255,255,255)
		surface.SetTextPos(w * 0.42,h * 0.01)
		surface.SetFont("StarHUDFontWeapon2")
		surface.DrawText("Imperial Blackmarket Config")
	end

	local scrollPanel = vgui.Create("DCategoryList", ConfigFrame)
	scrollPanel:Dock( LEFT )
	scrollPanel:SetSize(300)

	local editPanel = vgui.Create("DPanel", ConfigFrame)
	editPanel:Dock(FILL)
	editPanel.Paint = function(s, w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(200,200,230, 200))
		draw.SimpleText("To create new locations easier, use !bmcreate in chat or blackmarketcreate in console", "DermaDefault", 5, 260, Color(11,11,11), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
	end

	local TEName = vgui.Create( "DTextEntry", editPanel )
	TEName:Dock( TOP )
	TEName:DockMargin( 5, 5, 5, 0 )
	TEName:SetPlaceholderText( "Location Name" )
	TEName.OnEnter = function( self )
		chat.AddText( self:GetValue() )
	end

	local TEDescription = vgui.Create( "DTextEntry", editPanel )
	TEDescription:Dock( TOP )
	TEDescription:DockMargin( 5, 5, 5, 0 )
	TEDescription:SetPlaceholderText( "Location Description" )
	TEDescription.OnEnter = function( self )
		chat.AddText( self:GetValue() )
	end

	local TEPosition = vgui.Create( "DTextEntry", editPanel )
	TEPosition:Dock( TOP )
	TEPosition:DockMargin( 5, 5, 5, 0 )
	TEPosition:SetPlaceholderText( "Location Position" )
	TEPosition.OnEnter = function( self )
		chat.AddText( self:GetValue() )
	end
	TEPosition.AllowInput = function( self, stringValue )
		return true
	end


	local TEAngle = vgui.Create( "DTextEntry", editPanel )
	TEAngle:Dock( TOP )
	TEAngle:DockMargin( 5, 5, 5, 0 )
	TEAngle:SetPlaceholderText( "Location Angle" )
	TEAngle.OnEnter = function( self )
		chat.AddText( self:GetValue() )
	end
	TEAngle.AllowInput = function( self, stringValue )
		return true
	end

	local DBPos = vgui.Create("DButton", editPanel)
	DBPos:SetPos(5, 140)
	DBPos:SetSize(250, 30)
	DBPos:SetText("Set Location Position to current position")
	DBPos.DoClick = function()
		TEPosition:SetValue(tostring(LocalPlayer():GetPos()))
	end

	local DBAngle = vgui.Create("DButton", editPanel)
	DBAngle:SetPos(5, 180)
	DBAngle:SetSize(250, 30)
	DBAngle:SetText("Set Location Looking Angle to current eye angle")
	DBAngle.DoClick = function()
		TEAngle:SetValue(tostring(LocalPlayer():GetAngles()))
	end

	local DBSave = vgui.Create("DButton", editPanel)
	DBSave:SetPos(265, 140)
	DBSave:SetSize(250, 30)
	DBSave:SetText("Save Changes / Create New Location")
	DBSave.DoClick = function()
		EditBlackmarketLocation(
			selectedIndex or 0,
			selectedIndex and "edit" or "add",
			TEName:GetValue(),
			TEDescription:GetValue(),
			Vector(TEPosition:GetValue()),
			Angle(TEAngle:GetValue())
		)
	end

	local DBDelete = vgui.Create("DButton", editPanel)
	DBDelete:SetPos(5, 220)
	DBDelete:SetSize(510, 30)
	DBDelete:SetColor(Color(200,50,50))
	DBDelete:SetText("Delete Location")
	DBDelete.DoClick = function()
		EditBlackmarketLocation( selectedIndex, "delete", nil, nil, nil, nil )
	end

	local DBGoto = vgui.Create("DButton", editPanel)
	DBGoto:SetPos(265, 180)
	DBGoto:SetSize(250, 30)
	DBGoto:SetText("Goto Location")
	DBGoto.DoClick = function()
		if not selectedIndex then return end
		net.Start("Blackmarket_GotoLocation")
		net.WriteUInt(selectedIndex, 8)
		net.SendToServer()
	end

	local DBToggle = vgui.Create( "DButton", editPanel )
	DBToggle:SetPos( 5, 500 )
	DBToggle:SetSize( 250, 30 )
	if isEnabled then
		DBToggle:SetText("Blackmarket Dealer Enabled (Click to Toggle)")
	else
		DBToggle:SetText("Blackmarket Dealer Disabled (Click to Toggle)")
	end
	DBToggle.DoClick = function(s)
		if s:GetText() == "Blackmarket Dealer Enabled (Click to Toggle)" then
			DBToggle:SetText("Blackmarket Dealer Disabled (Click to Toggle)")
		else
			DBToggle:SetText("Blackmarket Dealer Enabled (Click to Toggle)")
		end
		net.Start("Blackmarket_Toggle")
		net.SendToServer()
	end

	local DBRefresh = vgui.Create("DButton", editPanel)
	DBRefresh:SetPos(265, 500)
	DBRefresh:SetSize(250, 30)
	DBRefresh:SetText("Refesh Blackmarker Dealer (Re/spawn BMD)")
	DBRefresh.DoClick = function()
		net.Start("Blackmarket_Refresh")
		net.SendToServer()
	end

	local function LoadPanel(data)
		TEName:SetValue(data.data.name)
		TEDescription:SetValue(data.data.description)
		TEPosition:SetValue(tostring(data.data.pos))
		TEAngle:SetValue(tostring(data.data.angle))
	end

	local function populate(locationdata)

		scrollPanel:Clear()

		local mapCharatogry = scrollPanel:Add(game.GetMap())
		for k, ldata in ipairs(locationdata) do
			location = mapCharatogry:Add(ldata.name != "" and ldata.name or k)
			location.pos = ldata.pos
			location.Paint = function(s, w, h)
				if IsValid(blackmarket) and s.pos == blackmarket:GetPos() then
					draw.RoundedBox(0, 0, 0, w, h, Color(50, 135, 200))
				else
					draw.RoundedBox(0, 0, 0, w, h, Color(250, 250, 250))
				end
			end
			location.data = {data = ldata, index = k}
			location.DoClick = function(s)
				selectedIndex = k
				LoadPanel(s.data)
			end
		end
	end
	populate(locationData)
	net.Receive("Blackmarket_UpdateConfigMenu", function()
		if ConfigFrame then
			populate(net.ReadTable())
		end
	end)
	net.Receive("Blackmarket_UpdateBlackmarketPosition", function()
		if ConfigFrame then
			blackmarketPos = net.ReadVector()
		end
	end)
end)

local function createLocationPopup()
	local PopupFrame = vgui.Create("DFrame")
	PopupFrame:SetSize(300,115)
	PopupFrame:SetTitle("")
	PopupFrame:Center()
	PopupFrame:MakePopup()
	PopupFrame.Selected = 1
	PopupFrame.Paint = function(self, w,h)
		surface.SetDrawColor(38, 38, 38)
		surface.DrawRect(0,0,w,h)
		surface.SetTextColor(255,255,255)
		surface.SetTextPos(w * 0.05,h * 0.01)
		surface.SetFont("StarHUDFontWeapon2")
		surface.DrawText("New Blackmarket Location")
	end

	local editPanel = vgui.Create("DPanel", PopupFrame)
	editPanel:Dock(FILL)
	editPanel.Paint = function(s, w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(200,200,230, 200))
		draw.SimpleText("To create new locations easier, use !bmcreate in chat or blackmarketcreate in console", "DermaDefault", 5, 260, Color(11,11,11), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
	end

	local TEName = vgui.Create( "DTextEntry", editPanel )
	TEName:Dock( TOP )
	TEName:DockMargin( 5, 5, 5, 0 )
	TEName:SetPlaceholderText( "Location Name" )
	TEName.OnEnter = function( self )
		chat.AddText( self:GetValue() )
	end

	local TEDescription = vgui.Create( "DTextEntry", editPanel )
	TEDescription:Dock( TOP )
	TEDescription:DockMargin( 5, 5, 5, 0 )
	TEDescription:SetPlaceholderText( "Location Description" )
	TEDescription.OnEnter = function( self )
		chat.AddText( self:GetValue() )
	end

	local DBSave = vgui.Create("DButton", editPanel)
	DBSave:Dock( TOP )
	DBSave:DockMargin( 5, 5, 5, 0 )
	DBSave:SetText("Create New Location")
	DBSave.DoClick = function()
		EditBlackmarketLocation( 0, "add", TEName:GetValue(), TEDescription:GetValue(), LocalPlayer():GetPos(), LocalPlayer():GetAngles() )
		PopupFrame:Close()
	end
end

hook.Add( "OnPlayerChat", "LocationCreationCommand", function( ply, strText, bTeam, bDead )
	if ( string.lower( strText ) == "!bmcreate" ) then
		createLocationPopup()
		return true
	end
end )

concommand.Add("blackmarketcreate", createLocationPopup, nil, "Create new Blackmarket Dealer Location", FCVAR_NONE)
