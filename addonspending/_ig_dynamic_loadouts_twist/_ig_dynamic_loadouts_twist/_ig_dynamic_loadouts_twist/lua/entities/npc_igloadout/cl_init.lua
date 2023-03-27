include("shared.lua")

surface.CreateFont("IG_Dynamic_Title", {
	font = "Arial",
	extended = false,
	size = 40,
	weight = 500,
	blursize = 0,
	antialias = true,
	outline = false,
})

surface.CreateFont("IG_Dynamic_Sub", {
	font = "Arial",
	extended = false,
	size = 25,
	weight = 500,
	blursize = 0,
	antialias = true,
	outline = false,
})

surface.CreateFont("IG_Dynamic_Text", {
	font = "Arial",
	extended = false,
	size = 15,
	weight = 500,
	blursize = 0,
	antialias = true,
	outline = false,
})

function ENT:Draw()
	self:DrawModel()
	local pos = self:LocalToWorld(Vector(0, 0, 0))
	local ang = self:LocalToWorldAngles(Angle(0, 90, 90))

	cam.Start3D2D(pos, ang, 0.1)
		surface.SetDrawColor(24, 31, 41,220)
    	surface.DrawRect(-200, -650, 400, 100)
    	draw.SimpleText("Dynamic Loadout Gonk", "IG_Dynamic_Title", 0, -600, Color(255,255,255), 1, 1)
	cam.End3D2D()
end

net.Receive("igSquadMenu", function()
	local weapontable = net.ReadTable()
	local currentloadouts = net.ReadTable()
	local ply = LocalPlayer()
	local clweps = {}

	local temp = {
		["First"] = {
			["Primary"] = "",
			["Secondary"] = "",
			["Spec"] = "",
		},
		["Second"] = {
			["Primary"] = "",
			["Secondary"] = "",
			["Spec"] = "",
		},
		["Third"] = {
			["Primary"] = "",
			["Secondary"] = "",
			["Spec"] = "",
		},
	}

	local frame = vgui.Create("DFrame")
		frame:SetSize(530, 500)
		frame:Center()
		frame:SetVisible(true)
		frame:MakePopup()
		frame:ShowCloseButton(false)
		frame:SetTitle("")

		frame.Paint = function( self, w, h )
			draw.RoundedBox(0, 0, 0, w, h, Color(74, 100, 133))
			draw.RoundedBox(0, 0, 0, w, 40, Color(46, 52, 64))
			draw.RoundedBox(0,10,80,510,410,Color(67, 76, 94))
			draw.DrawText("DYNAMIC LOADOUT", "IG_Dynamic_Title", 265,40, Color(255,255,255,255), TEXT_ALIGN_CENTER)
		end

		local sheet = vgui.Create("DColumnSheet",frame)
			sheet:SetPos(10,90)
			sheet:SetSize(600,600)

			local SelectMenu = vgui.Create("DPanel")
				sheet:AddSheet("Select Loadouts",SelectMenu)
				SelectMenu:SetSize(380,390)
				SelectMenu.Paint = function( self, w, h )
					draw.RoundedBox( 4, 0, 0, w, h, Color( 76, 86, 106 ) )
					draw.RoundedBox(0,10,40,360,100,Color(67, 76, 94))
					draw.RoundedBox(0,10,150,360,100,Color(67, 76, 94))
					draw.RoundedBox(0,10,260,360,100,Color(67, 76, 94))
					draw.DrawText("Select Loadout", "IG_Dynamic_Sub", 190,10, Color(255,255,255,255), TEXT_ALIGN_CENTER)

					draw.DrawText("Loadout #1", "IG_Dynamic_Sub", 15,45, Color(255,255,255,255), TEXT_ALIGN_LEFT)
					draw.DrawText("Primary: "..currentloadouts["First"]["Loadout"]["Primary"] , "IG_Dynamic_Text", 15,70, Color(255,255,255,255), TEXT_ALIGN_LEFT)
					draw.DrawText("Secondary: "..currentloadouts["First"]["Loadout"]["Secondary"] , "IG_Dynamic_Text", 15,85, Color(255,255,255,255), TEXT_ALIGN_LEFT)
					draw.DrawText("Specialist: "..currentloadouts["First"]["Loadout"]["Spec"] , "IG_Dynamic_Text", 15,100, Color(255,255,255,255), TEXT_ALIGN_LEFT)

					draw.DrawText("Loadout #2", "IG_Dynamic_Sub", 15,155, Color(255,255,255,255), TEXT_ALIGN_LEFT)
					draw.DrawText("Primary: "..currentloadouts["Second"]["Loadout"]["Primary"] , "IG_Dynamic_Text", 15,180, Color(255,255,255,255), TEXT_ALIGN_LEFT)
					draw.DrawText("Secondary: "..currentloadouts["Second"]["Loadout"]["Secondary"] , "IG_Dynamic_Text", 15,195, Color(255,255,255,255), TEXT_ALIGN_LEFT)
					draw.DrawText("Specialist: "..currentloadouts["Second"]["Loadout"]["Spec"] , "IG_Dynamic_Text", 15,210, Color(255,255,255,255), TEXT_ALIGN_LEFT)

					draw.DrawText("Loadout #3", "IG_Dynamic_Sub", 15,265, Color(255,255,255,255), TEXT_ALIGN_LEFT)
					draw.DrawText("Primary: "..currentloadouts["Third"]["Loadout"]["Primary"] , "IG_Dynamic_Text", 15,290, Color(255,255,255,255), TEXT_ALIGN_LEFT)
					draw.DrawText("Secondary: "..currentloadouts["Third"]["Loadout"]["Secondary"] , "IG_Dynamic_Text", 15,305, Color(255,255,255,255), TEXT_ALIGN_LEFT)
					draw.DrawText("Specialist: "..currentloadouts["Third"]["Loadout"]["Spec"] , "IG_Dynamic_Text", 15,320, Color(255,255,255,255), TEXT_ALIGN_LEFT)
				end
				// First Loadout
					if currentloadouts["First"]["Active"] == true then
						local selectloadout1 = vgui.Create("DButton", SelectMenu)
							selectloadout1:SetSize(350,20)
							selectloadout1:SetText("Equipped Loadout")
							selectloadout1:SetPos(15, 116)
							selectloadout1:SetTextColor( Color( 236, 239, 244) )
							selectloadout1.Paint = function( self, w, h )
								draw.RoundedBox(0, 0, 0, w, 40, Color(129,161,193))
							end
							selectloadout1.DoClick = function()
								ply:PrintMessage( HUD_PRINTTALK, "Already Equipped!" )
							end
					elseif currentloadouts["First"]["Purchased"] == true then
						local selectloadout1 = vgui.Create("DButton", SelectMenu)
							selectloadout1:SetSize(350,20)
							selectloadout1:SetText("Select Loadout | 500 Credits")
							selectloadout1:SetPos(15, 116)
							selectloadout1:SetTextColor( Color( 236, 239, 244) )
							selectloadout1.Paint = function( self, w, h )
								draw.RoundedBox(0, 0, 0, w, 40, Color(46, 52, 64))
							end
							selectloadout1.DoClick = function()
								if ply:SH_CanAffordPremium(500) then
									net.Start("igSquadMenuSelect")
										net.WriteString("1")
									net.SendToServer()
									frame:Close()
								else
									ply:PrintMessage( HUD_PRINTTALK, "Not enough credits." )
								end
							end
					else
						local selectloadout1 = vgui.Create("DButton", SelectMenu)
							selectloadout1:SetSize(350,20)
							selectloadout1:SetText("Purchase Loadout for: 0 Credits")
							selectloadout1:SetPos(15, 116)
							selectloadout1:SetTextColor( Color( 236, 239, 244) )
							selectloadout1.Paint = function( self, w, h )
								draw.RoundedBox(0, 0, 0, w, 40, Color(191, 97, 106))
							end
							selectloadout1.DoClick = function()
								if ply:SH_CanAffordPremium(0) then
									net.Start("igSquadMenuPurchase")
										net.WriteString("1")
									net.SendToServer()
									ply:PrintMessage( HUD_PRINTTALK, "You have purchased the first loadout slot despite it given by default. How did you do that?" )
									frame:Close()
								else
									ply:PrintMessage( HUD_PRINTTALK, "Not enough credits." )
								end
							end
					end
				// Second Loadout
					if currentloadouts["Second"]["Active"] == true then
						local selectloadout1 = vgui.Create("DButton", SelectMenu)
							selectloadout1:SetSize(350,20)
							selectloadout1:SetText("Equipped Loadout")
							selectloadout1:SetPos(15, 226)
							selectloadout1:SetTextColor( Color( 236, 239, 244) )
							selectloadout1.Paint = function( self, w, h )
								draw.RoundedBox(0, 0, 0, w, 40, Color(129,161,193))
							end
							selectloadout1.DoClick = function()
								ply:PrintMessage( HUD_PRINTTALK, "Already Equipped!" )
							end
					elseif currentloadouts["Second"]["Purchased"] == true then
						local selectloadout1 = vgui.Create("DButton", SelectMenu)
							selectloadout1:SetSize(350,20)
							selectloadout1:SetText("Select Loadout | 500 Credits")
							selectloadout1:SetPos(15, 226)
							selectloadout1:SetTextColor( Color( 236, 239, 244) )
							selectloadout1.Paint = function( self, w, h )
								draw.RoundedBox(0, 0, 0, w, 40, Color(46, 52, 64))
							end
							selectloadout1.DoClick = function()
								if ply:SH_CanAffordPremium(500) then
									net.Start("igSquadMenuSelect")
										net.WriteString("2")
									net.SendToServer()
									frame:Close()
								else
									ply:PrintMessage( HUD_PRINTTALK, "Not enough credits." )
								end
							end
					else
						local selectloadout1 = vgui.Create("DButton", SelectMenu)
							selectloadout1:SetSize(350,20)
							selectloadout1:SetText("Purchase Loadout for: 10,000 Credits")
							selectloadout1:SetPos(15, 226)
							selectloadout1:SetTextColor( Color( 236, 239, 244) )
							selectloadout1.Paint = function( self, w, h )
								draw.RoundedBox(0, 0, 0, w, 40, Color(191, 97, 106))
							end
							selectloadout1.DoClick = function()
								if ply:SH_CanAffordPremium(10000) then
									net.Start("igSquadMenuPurchase")
										net.WriteString("2")
									net.SendToServer()
									ply:PrintMessage( HUD_PRINTTALK, "You have purchased a second loadout slot." )
									frame:Close()
								else
									ply:PrintMessage( HUD_PRINTTALK, "Not enough credits." )
								end
							end
					end
				// Third Loadout
					if currentloadouts["Third"]["Active"] == true then
						local selectloadout1 = vgui.Create("DButton", SelectMenu)
							selectloadout1:SetSize(350,20)
							selectloadout1:SetText("Equipped Loadout")
							selectloadout1:SetPos(15, 336)
							selectloadout1:SetTextColor( Color( 236, 239, 244) )
							selectloadout1.Paint = function( self, w, h )
								draw.RoundedBox(0, 0, 0, w, 40, Color(129,161,193))
							end
							selectloadout1.DoClick = function()
								ply:PrintMessage( HUD_PRINTTALK, "Already Equipped!" )
							end
					elseif currentloadouts["Third"]["Purchased"] == true then
						local selectloadout1 = vgui.Create("DButton", SelectMenu)
							selectloadout1:SetSize(350,20)
							selectloadout1:SetText("Select Loadout | 500 Credits")
							selectloadout1:SetPos(15, 336)
							selectloadout1:SetTextColor( Color( 236, 239, 244) )
							selectloadout1.Paint = function( self, w, h )
								draw.RoundedBox(0, 0, 0, w, 40, Color(46, 52, 64))
							end
							selectloadout1.DoClick = function()
								if ply:SH_CanAffordPremium(500) then
									net.Start("igSquadMenuSelect")
										net.WriteString("3")
									net.SendToServer()
									frame:Close()
								else
									ply:PrintMessage( HUD_PRINTTALK, "Not enough credits." )
								end
							end
					else
						local selectloadout1 = vgui.Create("DButton", SelectMenu)
							selectloadout1:SetSize(350,20)
							selectloadout1:SetText("Purchase Loadout for: 50,000 Credits")
							selectloadout1:SetPos(15, 336)
							selectloadout1:SetTextColor( Color( 236, 239, 244) )
							selectloadout1.Paint = function( self, w, h )
								draw.RoundedBox(0, 0, 0, w, 40, Color(191, 97, 106))
							end
							selectloadout1.DoClick = function()
								if ply:SH_CanAffordPremium(50000) then
									net.Start("igSquadMenuPurchase")
										net.WriteString("3")
									net.SendToServer()
									ply:PrintMessage( HUD_PRINTTALK, "You have purchased a third loadout slot." )
									frame:Close()
								else
									ply:PrintMessage( HUD_PRINTTALK, "Not enough credits." )
								end
							end
					end

			local EditMenu = vgui.Create("DPanel")
				sheet:AddSheet("Edit Loadouts",EditMenu)
				EditMenu:SetSize(380,390)
				EditMenu.Paint = function( self, w, h )
					draw.RoundedBox( 4, 0, 0, w, h, Color( 76, 86, 106 ) )
					draw.RoundedBox(0,10,40,360,100,Color(67, 76, 94))
					draw.RoundedBox(0,10,150,360,100,Color(67, 76, 94))
					draw.RoundedBox(0,10,260,360,100,Color(67, 76, 94))
					draw.DrawText("Select Loadout", "IG_Dynamic_Sub", 190,10, Color(255,255,255,255), TEXT_ALIGN_CENTER)
					draw.DrawText("Loadout #1", "IG_Dynamic_Sub", 15,40, Color(255,255,255,255), TEXT_ALIGN_LEFT)
					draw.DrawText("Loadout #2", "IG_Dynamic_Sub", 15,150, Color(255,255,255,255), TEXT_ALIGN_LEFT)
					draw.DrawText("Loadout #3", "IG_Dynamic_Sub", 15,260, Color(255,255,255,255), TEXT_ALIGN_LEFT)
				end
				// First
					local firstprimarycombo = vgui.Create("DComboBox", EditMenu)
						firstprimarycombo:SetSize(250,20)
						firstprimarycombo:SetPos(15,65)
						firstprimarycombo:SetValue("Select Primary Weapon")
						for k,v in pairs(weapontable.primary) do
							firstprimarycombo:AddChoice(v)
						end
						firstprimarycombo.OnSelect = function( self, index, value )
							temp["First"]["Primary"] = value
						end
					local firstsecondarycombo = vgui.Create("DComboBox", EditMenu)
						firstsecondarycombo:SetSize(250,20)
						firstsecondarycombo:SetPos(15,90)
						firstsecondarycombo:SetValue("Select Secondary Weapon")
						for k,v in pairs(weapontable.secondary) do
							firstsecondarycombo:AddChoice(v)
						end
						firstsecondarycombo.OnSelect = function( self, index, value )
							temp["First"]["Secondary"] = value
						end
					local firstspeccombo = vgui.Create("DComboBox", EditMenu)
						firstspeccombo:SetSize(250,20)
						firstspeccombo:SetPos(15,115)
						firstspeccombo:SetValue("Select Specialist Weapon")
						for k,v in pairs(weapontable.spec) do
							firstspeccombo:AddChoice(v)
						end
						firstspeccombo.OnSelect = function( self, index, value )
							temp["First"]["Spec"] = value
						end
				// Second
					local secondprimarycombo = vgui.Create("DComboBox", EditMenu)
						secondprimarycombo:SetSize(250,20)
						secondprimarycombo:SetPos(15,175)
						secondprimarycombo:SetValue("Select Primary Weapon")

						for k,v in pairs(weapontable.primary) do
							secondprimarycombo:AddChoice(v)
						end
						secondprimarycombo.OnSelect = function( self, index, value )
							temp["Second"]["Primary"] = value
						end
					local secondsecondarycombo = vgui.Create("DComboBox", EditMenu)
						secondsecondarycombo:SetSize(250,20)
						secondsecondarycombo:SetPos(15,200)
						secondsecondarycombo:SetValue("Select Secondary Weapon")
						for k,v in pairs(weapontable.secondary) do
							secondsecondarycombo:AddChoice(v)
						end
						secondsecondarycombo.OnSelect = function( self, index, value )
							temp["Second"]["Secondary"] = value
						end
					local secondspeccombo = vgui.Create("DComboBox", EditMenu)
						secondspeccombo:SetSize(250,20)
						secondspeccombo:SetPos(15,225)
						secondspeccombo:SetValue("Select Specialist Weapon")
						for k,v in pairs(weapontable.spec) do
							secondspeccombo:AddChoice(v)
						end
						secondspeccombo.OnSelect = function( self, index, value )
							temp["Second"]["Spec"] = value
						end
				// Third
					local thirdprimarycombo = vgui.Create("DComboBox", EditMenu)
						thirdprimarycombo:SetSize(250,20)
						thirdprimarycombo:SetPos(15,285)
						thirdprimarycombo:SetValue("Select Primary Weapon")
						for k,v in pairs(weapontable.primary) do
							thirdprimarycombo:AddChoice(v)
						end
						thirdprimarycombo.OnSelect = function( self, index, value )
							temp["Third"]["Primary"] = value
						end
					local thirdsecondarycombo = vgui.Create("DComboBox", EditMenu)
						thirdsecondarycombo:SetSize(250,20)
						thirdsecondarycombo:SetPos(15,310)
						thirdsecondarycombo:SetValue("Select Secondary Weapon")
						for k,v in pairs(weapontable.secondary) do
							thirdsecondarycombo:AddChoice(v)
						end
						thirdsecondarycombo.OnSelect = function( self, index, value )
							temp["Third"]["Secondary"] = value
						end
					local thirdspeccombo = vgui.Create("DComboBox", EditMenu)
						thirdspeccombo:SetSize(250,20)
						thirdspeccombo:SetPos(15,335)
						thirdspeccombo:SetValue("Select Specialist Weapon")
						for k,v in pairs(weapontable.spec) do
							thirdspeccombo:AddChoice(v)
						end
						thirdspeccombo.OnSelect = function( self, index, value )
							temp["Third"]["Spec"] = value
						end

				// First Loadout
					if currentloadouts["First"]["Purchased"] == true then
						local selectloadout1 = vgui.Create("DButton", EditMenu)
							selectloadout1:SetSize(95,70)
							selectloadout1:SetText("Confirm Selection")
							selectloadout1:SetPos(270, 65)
							selectloadout1:SetTextColor( Color( 236, 239, 244) )
							selectloadout1.Paint = function( self, w, h )
								draw.RoundedBox(0, 0, 0, w, h, Color(46, 52, 64))
							end
							selectloadout1.DoClick = function()
								local selected = temp["First"]
								net.Start("igSquadMenuEdit")
									net.WriteString("1")
									net.WriteTable(selected)
								net.SendToServer()
								frame:Close()
							end
					else
						local selectloadout1 = vgui.Create("DButton", EditMenu)
							selectloadout1:SetSize(95,70)
							selectloadout1:SetText("Disabled")
							selectloadout1:SetPos(270,65)
							selectloadout1:SetTextColor( Color( 236, 239, 244) )
							selectloadout1.Paint = function( self, w, h )
								draw.RoundedBox(0, 0, 0, w, h, Color(191, 97, 106))
							end
							selectloadout1.DoClick = function()

							end
					end
				// Second Loadout
					if currentloadouts["Second"]["Purchased"] == true then
						local selectloadout1 = vgui.Create("DButton", EditMenu)
							selectloadout1:SetSize(95,70)
							selectloadout1:SetText("Confirm Selection")
							selectloadout1:SetPos(270,175)
							selectloadout1:SetTextColor( Color( 236, 239, 244) )
							selectloadout1.Paint = function( self, w, h )
								draw.RoundedBox(0, 0, 0, w, h, Color(46, 52, 64))
							end
							selectloadout1.DoClick = function()
								local selected = temp["Second"]
								net.Start("igSquadMenuEdit")
									net.WriteString("2")
									net.WriteTable(selected)
								net.SendToServer()
								frame:Close()
							end
					else
						local selectloadout1 = vgui.Create("DButton", EditMenu)
							selectloadout1:SetSize(95,70)
							selectloadout1:SetText("Disabled")
							selectloadout1:SetPos(270, 175)
							selectloadout1:SetTextColor( Color( 236, 239, 244) )
							selectloadout1.Paint = function( self, w, h )
								draw.RoundedBox(0, 0, 0, w, h, Color(191, 97, 106))
							end
							selectloadout1.DoClick = function()

							end
					end
				// Third Loadout
					if currentloadouts["Third"]["Purchased"] == true then
						local selectloadout1 = vgui.Create("DButton", EditMenu)
							selectloadout1:SetSize(95,70)
							selectloadout1:SetText("Confirm Selection")
							selectloadout1:SetPos(270, 285)
							selectloadout1:SetTextColor( Color( 236, 239, 244) )
							selectloadout1.Paint = function( self, w, h )
								draw.RoundedBox(0, 0, 0, w, h, Color(46, 52, 64))
							end
							selectloadout1.DoClick = function()
								local selected = temp["Third"]
								net.Start("igSquadMenuEdit")
									net.WriteString("3")
									net.WriteTable(selected)
								net.SendToServer()
								frame:Close()
							end
					else
						local selectloadout1 = vgui.Create("DButton", EditMenu)
							selectloadout1:SetSize(95,70)
							selectloadout1:SetText("Disabled")
							selectloadout1:SetPos(270, 285)
							selectloadout1:SetTextColor( Color( 236, 239, 244) )
							selectloadout1.Paint = function( self, w, h )
								draw.RoundedBox(0, 0, 0, w, h, Color(191, 97, 106))
							end
							selectloadout1.DoClick = function()

							end
					end

		local frameheader = vgui.Create("DLabel", frame)
			frameheader:SetPos(15,0)
			frameheader:SetSize(350,40)
			frameheader:SetText("Imperial Gaming | Loadout System")
			frameheader:SetColor(Color(255, 255, 255))

		local buttonmainclose = vgui.Create("DButton", frame)
			buttonmainclose:SetSize(100,20)
			buttonmainclose:SetText("Close Menu")
			buttonmainclose:SetPos(20, 147)

			buttonmainclose.DoClick = function()
				frame:Close()
			end

end)
