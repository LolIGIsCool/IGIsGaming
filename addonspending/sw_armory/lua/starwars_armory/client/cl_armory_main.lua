

--[[ Nykez 2017. Do not edit ]]--
net.Receive("Armory_SyncWeapons", function()
	local tbl = net.ReadTable()
	if not tbl then return end
	LocalPlayer().ArmoryWeapons = {}
	LocalPlayer().ArmoryWeapons = tbl
end)


local mat_draw = Material("sw_n_gui/right_plate.png")
local mat_bg = Material("starhud/derma/description_body.png")
local mg_bg_hover = Material("starhud/derma/item_hovered_event.png")
local button_n = Material("sw_n_gui/button_n.png")
local button_h = Material("sw_n_gui/button_h.png")
local header = Material("sw_n_gui/description_head.png")
print("wuh")
net.Receive("Armory_OpenMenu", function()
	print("wuh")
	if frame then frame:Remove() end
	
	local bar_text = nil;
	local price = nil;
	frame = vgui.Create( "DStarFrame_Armory" )
	frame:SetSize( 800, 600 )
	frame:SetTitle(SArmory.Config.Header or 'Armory')
	frame:Center()
	frame:MakePopup()
	frame.Models = {}
	frame.Selected = 1

	local sheet = vgui.Create( "SW_DColumnSheet", frame )
	sheet:SetSize(frame:GetWide()*.95, frame:GetTall()*.8)
	sheet:SetPos(0, frame:GetTall()*.12)
	sheet:CenterHorizontal()

	local panel1 = vgui.Create( "DPanel", sheet )
	panel1:Dock( FILL )
	panel1.Paint = function( self, w, h ) 
		surface.SetDrawColor( 255, 255, 255, 255 )
		surface.SetMaterial( mat_draw	)
		surface.DrawTexturedRect( 0, 0, w, h )
		
		surface.SetDrawColor( 255, 255, 255, 255 )
		surface.SetMaterial(header)
		surface.DrawTexturedRect( w/2-115, 10, 200, 35 )
		
		
		if bar_text !=nil then
			draw.SimpleText(bar_text, "AurebeshReadable", w/2-23, 16, color_white, TEXT_ALIGN_CENTER)
			draw.SimpleText("$" .. price, "AurebeshUnreadable", w/2-23, 30, color_white, TEXT_ALIGN_CENTER)
		end
		
	end
	
	
	local DScrollPanel = StarWars_CreateList(panel1)
	DScrollPanel:Dock( FILL )


	local DPanel = DScrollPanel:Add( "DPanel" )
	DPanel:SetTall(480)
	DPanel:SetWide(590)
	DPanel.extraX = 0
	DPanel.Selected = 1
	DPanel.Models = {}
	DPanel.Paint = function (self, w, h)
		surface.SetDrawColor( 255, 255, 255, 255 )
		surface.SetMaterial(mat_bg)
		surface.DrawTexturedRect( 0, 0, w, h )	
		self.extraX = Lerp(FrameTime() * 3.5, self.extraX, self.Selected)

		for k, v in pairs(self.Models) do
			if (ValidPanel(v)) then
				v:SetPos((k - self.extraX ) * (512+50) + 60, 40)
			end
		end
		
	end
	
	local space = 0
	for k, v in SortedPairsByMemberValue(SArmory.Database, "Price", false) do
		if SArmory.Database[k].Usergroup and SArmory.Config.ShowGroups == true then
			if not table.HasValue(SArmory.Database[k].Usergroup, LocalPlayer():GetUserGroup()) then continue end
		end
		
		if (SArmory.Config.ShowedOwned == true) then
			if LocalPlayer().ArmoryWeapons[k] then
				continue
			end
		end

		if SArmory.Config.ShowBlacklist == true and SArmory.Database[k].Blacklist then
			local blacklist = SArmory.Database[k].Blacklist
			if table.HasValue(SArmory.Database[k].Blacklist, LocalPlayer():Team()) then
				continue
			end
		end
		
		if v.Job and SArmory.Config.ShowJobs == true then
			local found = false
			for i, _data in pairs(v.Job) do
				if _data == LocalPlayer():Team() then
					found = true
				end
			end
			if found == false then continue end
		end
		
		if SArmory.Config.ShowCantAfford == true then
			if not LocalPlayer():SH_CanAffordPremium(v.Price) then continue end
		end
		
		local icon = vgui.Create( "DModelPanel", DPanel )
		icon:SetSize(512 - 64, 400)
		icon:SetPos((space - 1) * (512+50) + 60, 40)
		icon:SetModel(v.Model)
		local mn, mx = icon.Entity:GetRenderBounds()
		local size = 0
		size = math.max( size, math.abs( mn.x ) + math.abs( mx.x ) )
		size = math.max( size, math.abs( mn.y ) + math.abs( mx.y ) )
		size = math.max( size, math.abs( mn.z ) + math.abs( mx.z ) )

		icon:SetFOV( 45 )
		icon:SetCamPos( Vector( size, size, size ) )
		icon:SetLookAt( ( mn + mx ) * 0.5 )
		
		icon.Name = k
		icon.RealName = v.Name
		icon.Price = v.Price
		
		table.insert(DPanel.Models, icon)

	end
	
	local DermaButton = vgui.Create( "DButton", DPanel )
	DermaButton:SetText( "" )
	DermaButton.Paint = function(me)
		local mat = button_n
		
		if me.hovered == true then
			mat = button_h
		end
		surface.SetDrawColor(255,255,255)
		surface.SetMaterial(mat)
		surface.DrawTexturedRect(0,0,me:GetWide(), me:GetTall())
		
		local offset = me:GetWide()*.3
		local iw = offset*.4
		
		draw.SimpleText("Back", "StarHUDFontWeapon2", offset + offset*.1, me:GetTall()/2, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
	end
	DermaButton:SetPos( 10, 440 )
	DermaButton:SetSize( 140, 30 )
	DermaButton.DoClick = function()
		if (#DPanel.Models > 0 and DPanel.Selected > 1) then
			DPanel.Selected = DPanel.Selected - 1
			bar_text = DPanel.Models[DPanel.Selected or 1].RealName
			price = DPanel.Models[DPanel.Selected or 1].Price
			
		end
	end
	
	DermaButton.OnCursorEntered = function(me)
		me.hovered = true
	end
	DermaButton.OnCursorExited = function(me)
		me.hovered = false
	end

	local DermaButton2 = vgui.Create( "DButton", DPanel )
	DermaButton2:SetText( "" )
	DermaButton2:SetPos( 440, 440 )
	DermaButton2:SetSize( 140, 30 )
	DermaButton2.Paint = function(me)
		local mat = button_n
		
		if me.hovered == true then
			mat = button_h
		end
		surface.SetDrawColor(255,255,255)
		surface.SetMaterial(mat)
		surface.DrawTexturedRect(0,0,me:GetWide(), me:GetTall())
		
		local offset = me:GetWide()*.35
		local iw = offset*.4
		
		draw.SimpleText("Next", "StarHUDFontWeapon2", offset + offset*.1, me:GetTall()/2, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
	end
	DermaButton2.DoClick = function()
		if (#DPanel.Models > 0 and DPanel.Selected < #DPanel.Models) then
			DPanel.Selected = DPanel.Selected + 1
			bar_text = DPanel.Models[DPanel.Selected or 1].RealName
			price = DPanel.Models[DPanel.Selected or 1].Price
		end
	end
	DermaButton2.OnCursorEntered = function(me)
		me.hovered = true
	end
	DermaButton2.OnCursorExited = function(me)
		me.hovered = false
	end
	
	local DermaButton3 = vgui.Create( "DButton", DPanel )
	DermaButton3:SetText( "" )
	DermaButton3:SetPos( 205, 440 )
	DermaButton3:SetSize( 180, 30 )
	DermaButton3.DoClick = function()
		if not DPanel.Models[DPanel.Selected].Name then return end
		net.Start("Armory_BuyWeapons")
			net.WriteString(DPanel.Models[DPanel.Selected].Name)
		net.SendToServer()
		frame:Close()
		LocalPlayer().InArmory = false
	end
	DermaButton3.OnCursorEntered = function(me)
		me.hovered = true
	end
	DermaButton3.OnCursorExited = function(me)
		me.hovered = false
	end
	DermaButton3.Paint = function(me)
		local mat = button_n
		
		if me.hovered == true then
			mat = button_h
		end
		surface.SetDrawColor(255,255,255)
		surface.SetMaterial(mat)
		surface.DrawTexturedRect(0,0,me:GetWide(), me:GetTall())
		
		local offset = me:GetWide()*.27
		local iw = offset*.4
		
		draw.SimpleText("Purchase", "StarHUDFontWeapon2", offset + offset*.1, me:GetTall()/2, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
	end
	
	--[[ start inventory here ]]--
	
	local bar_text2 = "No Weapons"
	local deployPrice = 0
	local panel2 = vgui.Create( "DPanel", sheet )
	panel2:Dock( FILL )
	panel2.Paint = function( self, w, h ) 
		surface.SetDrawColor( 255, 255, 255, 255 )
		surface.SetMaterial( mat_draw	)
		surface.DrawTexturedRect( 0, 0, w, h )
		
		surface.SetDrawColor( 255, 255, 255, 255 )
		surface.SetMaterial(header)
		surface.DrawTexturedRect( w/2-115, 10, 200, 35 )
		
		

			draw.SimpleText(bar_text2, "AurebeshReadable", w/2-23, 16, color_white, TEXT_ALIGN_CENTER)
			draw.SimpleText("$"..deployPrice, "AurebeshUnreadable", w/2-23, 30, color_white, TEXT_ALIGN_CENTER)

	end
	


	local DScrollPanel2 = StarWars_CreateList(panel2)
	DScrollPanel2:Dock( FILL )


	local DPanel2 = DScrollPanel2:Add( "DPanel" )
	DPanel2:SetTall(480)
	DPanel2:SetWide(590)
	DPanel2.extraX = 0
	DPanel2.Selected = 1
	DPanel2.Models = {}
	DPanel2.Paint = function (self, w, h)
		surface.SetDrawColor( 255, 255, 255, 255 )
		surface.SetMaterial(mat_bg)
		surface.DrawTexturedRect( 0, 0, w, h )	
		
		self.extraX = Lerp(FrameTime() * 3.5, self.extraX, self.Selected)

		for k, v in pairs(self.Models) do
			if (ValidPanel(v)) then
				v:SetPos((k - self.extraX ) * (512+50) + 60, 40)
			end
		end
	end
	
	local space = 0
	local tbl = LocalPlayer().ArmoryWeapons or {}
	for k, v in pairs(SArmory.Database) do
		if not tbl[k] then continue end
		local icon = vgui.Create( "DModelPanel", DPanel2 )
		icon:SetSize(512 - 64, 400)
		icon:SetPos((space - 1) * (512+50) + 60, 40)
		icon:SetModel(v.Model)
		local mn, mx = icon.Entity:GetRenderBounds()
		local size = 0
		size = math.max( size, math.abs( mn.x ) + math.abs( mx.x ) )
		size = math.max( size, math.abs( mn.y ) + math.abs( mx.y ) )
		size = math.max( size, math.abs( mn.z ) + math.abs( mx.z ) )

		icon:SetFOV( 45 )
		icon:SetCamPos( Vector( size, size, size ) )
		icon:SetLookAt( ( mn + mx ) * 0.5 )
		
		icon.Name = k
		icon.RealName = v.Name
		icon.Price = v.Price
		icon.DeployCost = v.DeployCost
		
		table.insert(DPanel2.Models, icon)
	end
	
	local DermaButton_1 = vgui.Create( "DButton", DPanel2 )
	DermaButton_1:SetText( "" )
	DermaButton_1.Paint = function(me)
		local mat = button_n
		
		if me.hovered == true then
			mat = button_h
		end
		surface.SetDrawColor(255,255,255)
		surface.SetMaterial(mat)
		surface.DrawTexturedRect(0,0,me:GetWide(), me:GetTall())
		
		local offset = me:GetWide()*.3
		local iw = offset*.4
		
		draw.SimpleText("Back", "StarHUDFontWeapon2", offset + offset*.1, me:GetTall()/2, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
	end
	
	DermaButton_1:SetPos( 10, 440 )
	DermaButton_1:SetSize( 140, 30 )
	DermaButton_1.DoClick = function()
		if (#DPanel2.Models > 0 and DPanel2.Selected > 1) then
			DPanel2.Selected = DPanel2.Selected - 1
			bar_text2 = DPanel2.Models[DPanel2.Selected or 1].RealName
		end
	end
	
	DermaButton_1.OnCursorEntered = function(me)
		me.hovered = true
	end
	DermaButton_1.OnCursorExited = function(me)
		me.hovered = false
	end
	
	local DermaButton_2 = vgui.Create( "DButton", DPanel2 )
	DermaButton_2:SetText( "" )
	DermaButton_2:SetPos( 440, 440 )
	DermaButton_2:SetSize( 140, 30 )
	DermaButton_2.Paint = function(me)
		local mat = button_n
		
		if me.hovered == true then
			mat = button_h
		end
		surface.SetDrawColor(255,255,255)
		surface.SetMaterial(mat)
		surface.DrawTexturedRect(0,0,me:GetWide(), me:GetTall())
		
		local offset = me:GetWide()*.35
		local iw = offset*.4
		
		draw.SimpleText("Next", "StarHUDFontWeapon2", offset + offset*.1, me:GetTall()/2, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
	end
	DermaButton_2.DoClick = function()
		if (#DPanel2.Models > 0 and DPanel2.Selected < #DPanel2.Models) then
			DPanel2.Selected = DPanel2.Selected + 1
			bar_text2 = DPanel2.Models[DPanel2.Selected or 1].RealName
		end
	end
	DermaButton_2.OnCursorEntered = function(me)
		me.hovered = true
	end
	DermaButton_2.OnCursorExited = function(me)
		me.hovered = false
	end
	
	local DermaButton_3 = vgui.Create( "DButton", DPanel2 )
	DermaButton_3:SetText( "" )
	DermaButton_3:SetPos( 205, 440 )
	DermaButton_3:SetSize( 180, 30 )
	DermaButton_3.DoClick = function()
		if not DPanel2.Models[DPanel2.Selected].Name then return end
		net.Start("Armory_DeployWeapons")
			net.WriteString(DPanel2.Models[DPanel2.Selected].Name)
		net.SendToServer()
		frame:Close()
		LocalPlayer().InArmory = false
	end
	DermaButton_3.OnCursorEntered = function(me)
		me.hovered = true
	end
	DermaButton_3.OnCursorExited = function(me)
		me.hovered = false
	end
	DermaButton_3.Paint = function(me)
		local mat = button_n
		
		if me.hovered == true then
			mat = button_h
		end
		surface.SetDrawColor(255,255,255)
		surface.SetMaterial(mat)
		surface.DrawTexturedRect(0,0,me:GetWide(), me:GetTall())
		
		local offset = me:GetWide()*.32
		local iw = offset*.4
		
		draw.SimpleText("Deploy", "StarHUDFontWeapon2", offset + offset*.1, me:GetTall()/2, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
	end
	
	//bar_text2 = DPanel2.Models[DPanel2.Selected or 1].RealName or "No Weapons"
	
	
	sheet:AddSheet( "Purchase", panel1, "sw_n_gui/weapons_select.png")
	sheet:AddSheet( "Inventory", panel2, "sw_n_gui/all_pass.png")
	
	if #DPanel.Models > 0 and DPanel.Models[DPanel.Selected].RealName then
		bar_text = DPanel.Models[DPanel.Selected].RealName
		price = DPanel.Models[DPanel.Selected].Price
	else
		bar_text = "No Weapons"
		price = ""
	end
	
	if #DPanel2.Models > 0 and DPanel2.Models[DPanel2.Selected].RealName then
		bar_text2 = DPanel2.Models[DPanel2.Selected].RealName
		deployPrice = DPanel2.Models[DPanel2.Selected].DeployCost
	else
		bar_text2 = "No Weapons"
	end
end)