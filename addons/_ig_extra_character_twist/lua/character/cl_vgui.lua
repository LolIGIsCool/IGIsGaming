if SERVER then
	return
else
	surface.CreateFont("IG_Character_Title", {
		font = "Arial",
		extended = false,
		size = 40,
		weight = 500,
		blursize = 0,
		antialias = true,
		outline = false,
	})

	surface.CreateFont("IG_Character_Title2", {
		font = "Arial",
		extended = false,
		size = 60,
		weight = 500,
		blursize = 0,
		antialias = true,
		outline = false,
	})

	surface.CreateFont("IG_Character_Sub", {
		font = "Arial",
		extended = false,
		size = 25,
		weight = 500,
		blursize = 0,
		antialias = true,
		outline = false,
	})

	surface.CreateFont("IG_Character_Text", {
		font = "Arial",
		extended = false,
		size = 20,
		weight = 500,
		blursize = 0,
		antialias = true,
		outline = false,
	})

	net.Receive("IG_EXTRAC_CHAT", function()
		local text = net.ReadString()
		chat.AddText(Color(52, 235, 104), "[CHARACTER] ", Color(255,255,255), text)
	end)

	net.Receive("IG_EXTRAC_INIT_SPAWN", function()
		local playerdata = net.ReadTable()
		local x = ScrW()
	    local y = ScrH()
		local frame = vgui.Create("DFrame")
			frame:SetSize(x,y)
			frame:MakePopup()
			frame:Center()
			frame:SetDraggable( false ) 
			frame:ShowCloseButton( false )
			frame:SetTitle("")
			frame.Paint = function ()
				surface.SetDrawColor(Color(32, 32, 32, 200))
				surface.DrawRect(0, 0, frame:GetWide(), frame:GetTall())
				surface.SetDrawColor(Color(32, 32, 32, 200))
				draw.DrawText("IMPERIAL GAMING", "IG_Character_Title2", x/2,45, Color(255,255,255,255), TEXT_ALIGN_CENTER)
				draw.DrawText("CHARACTER SELECT", "IG_Character_Title2", x/2,95, Color(255,255,255,255), TEXT_ALIGN_CENTER)
				draw.DrawText("Select a character to play as", "IG_Character_Title", x/2,145, Color(255,255,255,255), TEXT_ALIGN_CENTER)
			end

		local frame2 = vgui.Create("DFrame", frame)
			frame2:SetSize(450,600)
			frame2:SetPos((frame:GetWide()/2)-500,(frame:GetTall()/2)-300)
			frame2:SetDraggable( false ) 
			frame2:ShowCloseButton( false )
			frame2:SetTitle("")
			frame2.Paint = function ()
				surface.SetDrawColor(Color(34,36,37, 255))
				surface.DrawRect(0, 0, frame2:GetWide(), frame2:GetTall())
				surface.SetDrawColor(Color(47,49,50, 255))
				surface.DrawRect(25, 25, 400, 400)
				draw.DrawText("Name: ", "IG_Character_Text", 25,435, Color(255,255,255,255), TEXT_ALIGN_LEFT)
				draw.DrawText(playerdata["First"]["Name"], "IG_Character_Text", 105,435, Color(255,255,255,255), TEXT_ALIGN_LEFT)
				draw.DrawText("Regiment: ", "IG_Character_Text", 25,460, Color(255,255,255,255), TEXT_ALIGN_LEFT)
				draw.DrawText(playerdata["First"]["Regiment"], "IG_Character_Text", 105,460, Color(255,255,255,255), TEXT_ALIGN_LEFT)
				draw.DrawText("Rank: ", "IG_Character_Text", 25,485, Color(255,255,255,255), TEXT_ALIGN_LEFT)
				draw.DrawText(playerdata["First"]["Rank"], "IG_Character_Text", 105,485, Color(255,255,255,255), TEXT_ALIGN_LEFT)
			end

			local Model1 = vgui.Create( "DModelPanel", frame2 )
				Model1:SetSize(450,450)
				Model1:SetPos(0,-10)
				Model1:SetModel( playerdata["First"]["Model"] )
				function Model1:LayoutEntity( Entity ) return end

			local Button1 =	vgui.Create("DButton", frame2)
				Button1:SetSize(400,40)
				Button1:SetPos((frame2:GetWide()/2)-200,frame2:GetTall()-50)
				Button1:SetTextColor( Color(255,255,255) )
				Button1:SetText("")
				if playerdata["First"]["Active"] then
					Button1.Paint = function( self, w, h )
						draw.RoundedBox(0, 0, 0, w, 40, Color(87,125,161, 255))
						draw.DrawText("Selected", "IG_Character_Text", w/2,11, Color(255,255,255,255), TEXT_ALIGN_CENTER)
					end
				else
					Button1.Paint = function( self, w, h )
						draw.RoundedBox(0, 0, 0, w, 40, Color(47,49,50, 255))
						draw.DrawText("Select Character", "IG_Character_Text", w/2,11, Color(255,255,255,255), TEXT_ALIGN_CENTER)
					end
				end
				Button1.DoClick = function()
					net.Start("IG_EXTRAC_SELECT")
						net.WriteString("1")
					net.SendToServer()
					frame:Close()
				end

		local frame3 = vgui.Create("DFrame", frame)
			frame3:SetSize(450,600)
			frame3:SetPos((frame:GetWide()/2)+50,(frame:GetTall()/2)-300)
			frame3:SetDraggable( false ) 
			frame3:ShowCloseButton( false )
			frame3:SetTitle("")
			frame3.Paint = function ()
				surface.SetDrawColor(Color(34,36,37, 255))
				surface.DrawRect(0, 0, frame3:GetWide(), frame3:GetTall())
				surface.SetDrawColor(Color(47,49,50, 255))
				surface.DrawRect(25, 25, 400, 400)
				draw.DrawText("Name: ", "IG_Character_Text", 25,435, Color(255,255,255,255), TEXT_ALIGN_LEFT)
				draw.DrawText(playerdata["Second"]["Name"], "IG_Character_Text", 105,435, Color(255,255,255,255), TEXT_ALIGN_LEFT)
				draw.DrawText("Regiment: ", "IG_Character_Text", 25,460, Color(255,255,255,255), TEXT_ALIGN_LEFT)
				draw.DrawText(playerdata["Second"]["Regiment"], "IG_Character_Text", 105,460, Color(255,255,255,255), TEXT_ALIGN_LEFT)
				draw.DrawText("Rank: ", "IG_Character_Text", 25,485, Color(255,255,255,255), TEXT_ALIGN_LEFT)
				draw.DrawText(playerdata["Second"]["Rank"], "IG_Character_Text", 105,485, Color(255,255,255,255), TEXT_ALIGN_LEFT)
			end

			local Model2 = vgui.Create( "DModelPanel", frame3 )
				Model2:SetSize(450,450)
				Model2:SetPos(0,-10)
				Model2:SetModel( playerdata["Second"]["Model"] )
				function Model2:LayoutEntity( Entity ) return end

			local Button2 =	vgui.Create("DButton", frame3)
				Button2:SetSize(400,50)
				Button2:SetPos((frame3:GetWide()/2)-200,frame3:GetTall()-50)
				Button2:SetTextColor( Color(255,255,255) )
				Button2:SetText("")
				if playerdata["Second"]["Active"] then
					Button2.Paint = function( self, w, h )
						draw.RoundedBox(0, 0, 0, w, 40, Color(87,125,161, 255))
						draw.DrawText("Selected", "IG_Character_Text", w/2,11, Color(255,255,255,255), TEXT_ALIGN_CENTER)
					end
				else
					Button2.Paint = function( self, w, h )
						draw.RoundedBox(0, 0, 0, w, 40, Color(47,49,50, 255))
						draw.DrawText("Select Character", "IG_Character_Text", w/2,11, Color(255,255,255,255), TEXT_ALIGN_CENTER)
					end
				end
				Button2.DoClick = function()
					net.Start("IG_EXTRAC_SELECT")
						net.WriteString("2")
					net.SendToServer()
					frame:Close()
				end
	end)

	surface.CreateFont("subtitle", {size = 16, weight = 500})
	local colours = {
		primary = Color(32, 32, 32, 255),
		secondary = Color(150, 150, 150, 255),
		highlight = Color(110, 0, 227, 255),
		bracket = Color(0, 0, 0, 255),
		msgColor = Color(255, 255, 255, 255)
	}

	net.Receive("IG_EXTRAC_ADMIN", function()		
		local IG_CHARACTER_PURCHASED = net.ReadTable()

		local targetSID = ""
		local targetSID64 = ""

		local w = ScrW()
		local h = ScrH()

		local frame = vgui.Create("DFrame")
		frame:SetSize(0.5 * w, 0.5 * h)
		frame:SetTitle("Second Character Admin Menu")
		frame:Center()
		frame:MakePopup()
		frame.Paint = function ()
			surface.SetDrawColor(colours.primary)
			surface.DrawRect(0, 0, frame:GetWide(), frame:GetTall())
		end

		local sheet = vgui.Create("DPropertySheet", frame)
		sheet:Dock(FILL)

		local addUserTab = vgui.Create("DPanel", sheet, "nil", false, false, "Grant a user AWR Clearance")
			sheet:AddSheet("Add Users", addUserTab)
			addUserTab.Paint = function()
				surface.SetDrawColor(colours.secondary)
				surface.DrawRect(0, 0, addUserTab:GetWide(), addUserTab:GetTall())
			end

		local onlinePlayersList = vgui.Create("DListView", addUserTab)
			onlinePlayersList:Dock(LEFT)
			onlinePlayersList:SetSize(0.75 * frame:GetWide(), sheet:GetTall())
			onlinePlayersList:SetMultiSelect(false)
			onlinePlayersList:AddColumn("Name")
			onlinePlayersList:AddColumn("SteamID")
			onlinePlayersList:AddColumn("SteamID64")
			onlinePlayersList:AddColumn("Second Character")
			for k, v in pairs(player.GetAll()) do
				onlinePlayersList:AddLine(v:Nick(), v:SteamID(),v:SteamID64(), IG_CHARACTER_PURCHASED[v:SteamID()])
			end
			onlinePlayersList.OnRowSelected = function(lst, index, pnl)
				targetSID = pnl:GetColumnText(2)
				targetSID64 = pnl:GetColumnText(3)
			end

		local grantClearanceBtn = vgui.Create("DButton", addUserTab)
			grantClearanceBtn:SetSize(0.15 * frame:GetWide(), 0.05 * frame:GetTall())
			local desiredX = 0.875 * frame:GetWide() - 0.5 * grantClearanceBtn:GetWide() - 0.01 * frame:GetWide()
			grantClearanceBtn:SetPos(desiredX, 0.1 * frame:GetTall() - 0.5 * grantClearanceBtn:GetTall())
			grantClearanceBtn:SetText("Add/Remove")
			grantClearanceBtn.DoClick = function ()
				net.Start("IG_EXTRAC_ADMIN_ADD")
					net.WriteString(targetSID)
					net.WriteString(targetSID64)
				net.SendToServer()
				frame:Close()
			end

		local grantAccessTxt = vgui.Create("DLabel", addUserTab)
			grantAccessTxt:SetFont("subtitle")
			grantAccessTxt:SetTextColor(colours.primary)
			grantAccessTxt:SetText("Give Second Character to user")
			grantAccessTxt:SizeToContents()
			grantAccessTxt:SetPos(0.865 * frame:GetWide() - 0.5 * grantAccessTxt:GetWide(), 0.04 * frame:GetTall())

		local addSteamIDBtn = vgui.Create("DButton", addUserTab)
			addSteamIDBtn:SetText("Grant SteamID Access")
			addSteamIDBtn:SetSize(0.15 * frame:GetWide(), 0.05 * frame:GetTall())
			addSteamIDBtn:SetPos(desiredX, 0.81 * frame:GetTall() - 0.5 * addSteamIDBtn:GetTall())

		local nameInput = vgui.Create("DTextEntry", addUserTab)
			nameInput:SetPlaceholderText("Name...")
			nameInput:SetSize(0.2 * frame:GetWide(), 0.05 * frame:GetTall())
			desiredX = 0.875 * frame:GetWide() - 0.5 * nameInput:GetWide() - 0.01 * frame:GetWide()
			nameInput:SetPos(desiredX, 0.69 * frame:GetTall() - 0.5 * nameInput:GetTall())

		local steamIDInput = vgui.Create("DTextEntry", addUserTab)
			steamIDInput:SetPlaceholderText("Steam ID32...")
			steamIDInput:SetSize(0.2 * frame:GetWide(), 0.05 * frame:GetTall())
			steamIDInput:SetPos(desiredX, 0.75 * frame:GetTall() - 0.5 * steamIDInput:GetTall())
			addSteamIDBtn.DoClick = function ()
				net.Start("awrc_AddOfflineUser")
					net.WriteString(nameInput:GetText())
					net.WriteString(steamIDInput:GetText())
				net.SendToServer()
				frame:Close()
			end

		local grantSteamIDAccessTxt = vgui.Create("DLabel", addUserTab)
			grantSteamIDAccessTxt:SetFont("subtitle")
			grantSteamIDAccessTxt:SetTextColor(colours.primary)
			grantSteamIDAccessTxt:SetText("Grant Steam ID AWR Access")
			grantSteamIDAccessTxt:SizeToContents()
			grantSteamIDAccessTxt:SetPos(0.865 * frame:GetWide() - 0.5 * grantSteamIDAccessTxt:GetWide(), 0.63 * frame:GetTall())
		end)
end