include("shared.lua")

surface.CreateFont("DL2_Title", {
	font = "Arial",
	extended = false,
	size = 25,
	weight = 500,
	blursize = 0,
	antialias = true,
	outline = false,
})

surface.CreateFont("DL2_Text1", {
	font = "Arial",
	extended = false,
	size = 20,
	weight = 700,
	blursize = 0,
	antialias = true,
	outline = false,
})

surface.CreateFont("DL2_Text2", {
	font = "Arial",
	extended = false,
	size = 18,
	weight = 700,
	blursize = 0,
	antialias = true,
	outline = false,
})

local delay = CurTime()


function ENT:Draw()
	self:DrawModel()
	local pos = self:LocalToWorld(Vector(0, 0, 0))
	local ang = self:LocalToWorldAngles(Angle(0, 90, 90))

	cam.Start3D2D(pos, ang, 0.1)
		surface.SetDrawColor(24, 31, 41,220)
    	surface.DrawRect(-200, -650, 400, 100)
    	draw.SimpleText("Dynamic Loadout Gonk", "DL2_Title", 0, -600, Color(255,255,255), 1, 1)
	cam.End3D2D()
end

net.Receive("igSquadMenu", function()
	local weapontable = net.ReadTable()
	local current = net.ReadTable()
	local aceupsleeve = net.ReadString()
	local ply = LocalPlayer()

	local framenumber = 1
	local ColorTable = {
		["Page1"] = {
			["Text"] = Color(26,205,182),
			["Line"] = Color(26,205,182),
		},
		["Page2"] = {
			["Text"] = Color(240,240,240),
			["Line"] = Color(47,49,50),
		},
		["Page3"] = {
			["Text"] = Color(240,240,240),
			["Line"] = Color(47,49,50),
		},
	}

	local temp = {
		["First"] = {
			["Primary"] = "",
			["Secondary"] = "",
			["Spec"] = "",
			["Ace"] = "",
		},
		["Second"] = {
			["Primary"] = "",
			["Secondary"] = "",
			["Spec"] = "",
			["Ace"] = "",
		},
		["Third"] = {
			["Primary"] = "",
			["Secondary"] = "",
			["Spec"] = "",
			["Ace"] = "",
		},
	}

	local frame = vgui.Create("DFrame")
		frame:SetSize(1000, 680)
		frame:Center()
		frame:SetVisible(true)
		frame:MakePopup()
		frame:ShowCloseButton(false)
		frame:SetTitle("")
		frame.Paint = function( self, w, h )
			draw.RoundedBox(0, 0, 0, w, h, Color(34,36,37))
			draw.RoundedBox(0, 0, 98, w, 2, Color(47,49,50))
			draw.DrawText("Dynamic Loadouts v2", "DL2_Text1", 985,75, Color(240,240,240,255), TEXT_ALIGN_RIGHT)

			draw.RoundedBox(0, 0, 95, 150, 5, ColorTable["Page1"]["Line"])
			draw.DrawText("Select", "DL2_Title", 75,60, ColorTable["Page1"]["Text"], TEXT_ALIGN_CENTER)

			draw.RoundedBox(0, 150, 95, 150, 5, ColorTable["Page2"]["Line"])
			draw.DrawText("Edit", "DL2_Title", 225,60, ColorTable["Page2"]["Text"], TEXT_ALIGN_CENTER)

			--draw.RoundedBox(0, 300, 95, 150, 5, ColorTable["Page3"]["Line"])
			--draw.DrawText("Available", "DL2_Title", 375,60, ColorTable["Page3"]["Text"], TEXT_ALIGN_CENTER)

			draw.RoundedBox(0, 0, 600, w, 80, Color(20, 20, 20))
		end

	local function DrawFramePage()
		local selectbuttononehover = false
		local menuframe1 = vgui.Create("DPanel",frame)
			menuframe1:SetSize(1000, 500)
			menuframe1:SetPos(0,100)
			menuframe1.Paint = function( self, w, h )
				draw.RoundedBox(0, 0, 0, w, h, Color(34,36,37,255))
				if aceupsleeve == "false" then
					draw.DrawText("Ace Up the Sleeve [DISABLED]", "DL2_Text1", 985,5, Color(204, 61, 61), TEXT_ALIGN_RIGHT)
				elseif aceupsleeve == "primary" then
					draw.DrawText("Ace Up the Sleeve [PRIMARY]", "DL2_Text1", 985,5, Color(26,205,182), TEXT_ALIGN_RIGHT)
				elseif aceupsleeve == "spec" then
					draw.DrawText("Ace Up the Sleeve [SPECIALIST]", "DL2_Text1", 985,5, Color(26,205,182), TEXT_ALIGN_RIGHT)
				end

				if current["First"]["Active"] == true then
					draw.RoundedBox(0, 50, 40, 250, 440, Color(25, 25, 25))
					draw.DrawText("Loadout Slot #1", "DL2_Title", 170,50, Color(26,205,182), TEXT_ALIGN_CENTER)
					draw.DrawText("Equipped Primary:", "DL2_Text1", 60,100, Color(26,205,182), TEXT_ALIGN_LEFT)
					draw.DrawText(current["First"]["Loadout"]["Primary"], "DL2_Text2", 60,120, Color(240,240,240), TEXT_ALIGN_LEFT)

					draw.DrawText("Equipped Secondary:", "DL2_Text1", 60,170, Color(26,205,182), TEXT_ALIGN_LEFT)
					draw.DrawText(current["First"]["Loadout"]["Secondary"], "DL2_Text2", 60,190, Color(240,240,240), TEXT_ALIGN_LEFT)

					draw.DrawText("Equipped Specialist:", "DL2_Text1", 60,240, Color(26,205,182), TEXT_ALIGN_LEFT)
					draw.DrawText(current["First"]["Loadout"]["Spec"], "DL2_Text2", 60,260, Color(240,240,240), TEXT_ALIGN_LEFT)

					draw.DrawText("Ace up the Sleeve:", "DL2_Text1", 60,310, Color(26,205,182), TEXT_ALIGN_LEFT)
					draw.DrawText(current["First"]["Loadout"]["Ace"], "DL2_Text2", 60,330, Color(240,240,240), TEXT_ALIGN_LEFT)
					if selectbuttononehover == true then
						draw.RoundedBox(0, 87, 380, 175, 35, Color(26,205,182))
						draw.DrawText("Already Equipped", "DL2_Text2", 175,388, Color(240,240,240), TEXT_ALIGN_CENTER)
					end
				else
					draw.RoundedBox(0, 50, 40, 250, 440, Color(25, 25, 25))
					draw.DrawText("Loadout Slot #1", "DL2_Title", 170,50, Color(122, 126, 128), TEXT_ALIGN_CENTER)
					draw.DrawText("Equipped Primary:", "DL2_Text1", 60,100, Color(122, 126, 128), TEXT_ALIGN_LEFT)
					draw.DrawText(current["First"]["Loadout"]["Primary"], "DL2_Text2", 60,120, Color(240,240,240), TEXT_ALIGN_LEFT)

					draw.DrawText("Equipped Secondary:", "DL2_Text1", 60,170, Color(122, 126, 128), TEXT_ALIGN_LEFT)
					draw.DrawText(current["First"]["Loadout"]["Secondary"], "DL2_Text2", 60,190, Color(240,240,240), TEXT_ALIGN_LEFT)

					draw.DrawText("Equipped Specialist:", "DL2_Text1", 60,240, Color(122, 126, 128), TEXT_ALIGN_LEFT)
					draw.DrawText(current["First"]["Loadout"]["Spec"], "DL2_Text2", 60,260, Color(240,240,240), TEXT_ALIGN_LEFT)

					draw.DrawText("Ace up the Sleeve:", "DL2_Text1", 60,310, Color(122, 126, 128), TEXT_ALIGN_LEFT)
					draw.DrawText(current["First"]["Loadout"]["Ace"], "DL2_Text2", 60,330, Color(240,240,240), TEXT_ALIGN_LEFT)
					if selectbuttononehover == true then
						draw.RoundedBox(0, 87, 380, 175, 35, Color(26,205,182))
						draw.DrawText("Already Equipped", "DL2_Text2", 175,388, Color(240,240,240), TEXT_ALIGN_CENTER)
					end
				end
				if current["Second"]["Active"] == true then
					draw.RoundedBox(0, 375, 40, 250, 440, Color(25, 25, 25))
					draw.DrawText("Loadout Slot #2", "DL2_Title", 495,50, Color(26,205,182), TEXT_ALIGN_CENTER)
					draw.DrawText("Equipped Primary:", "DL2_Text1", 385,100, Color(26,205,182), TEXT_ALIGN_LEFT)
					draw.DrawText(current["Second"]["Loadout"]["Primary"], "DL2_Text2", 385,120, Color(240,240,240), TEXT_ALIGN_LEFT)

					draw.DrawText("Equipped Secondary:", "DL2_Text1", 385,170, Color(26,205,182), TEXT_ALIGN_LEFT)
					draw.DrawText(current["Second"]["Loadout"]["Secondary"], "DL2_Text2", 385,190, Color(240,240,240), TEXT_ALIGN_LEFT)

					draw.DrawText("Equipped Specialist:", "DL2_Text1", 385,240, Color(26,205,182), TEXT_ALIGN_LEFT)
					draw.DrawText(current["Second"]["Loadout"]["Spec"], "DL2_Text2", 385,260, Color(240,240,240), TEXT_ALIGN_LEFT)

					draw.DrawText("Ace up the Sleeve:", "DL2_Text1", 385,310, Color(26,205,182), TEXT_ALIGN_LEFT)
					draw.DrawText(current["Second"]["Loadout"]["Ace"], "DL2_Text2", 385,330, Color(240,240,240), TEXT_ALIGN_LEFT)
				else
					draw.RoundedBox(0, 375, 40, 250, 440, Color(25, 25, 25))
					draw.DrawText("Loadout Slot #2", "DL2_Title", 495,50, Color(122, 126, 128), TEXT_ALIGN_CENTER)
					draw.DrawText("Equipped Primary:", "DL2_Text1", 385,100, Color(122, 126, 128), TEXT_ALIGN_LEFT)
					draw.DrawText(current["Second"]["Loadout"]["Primary"], "DL2_Text2", 385,120, Color(240,240,240), TEXT_ALIGN_LEFT)

					draw.DrawText("Equipped Secondary:", "DL2_Text1", 385,170, Color(122, 126, 128), TEXT_ALIGN_LEFT)
					draw.DrawText(current["Second"]["Loadout"]["Secondary"], "DL2_Text2", 385,190, Color(240,240,240), TEXT_ALIGN_LEFT)

					draw.DrawText("Equipped Specialist:", "DL2_Text1", 385,240, Color(122, 126, 128), TEXT_ALIGN_LEFT)
					draw.DrawText(current["Second"]["Loadout"]["Spec"], "DL2_Text2", 385,260, Color(240,240,240), TEXT_ALIGN_LEFT)

					draw.DrawText("Ace up the Sleeve:", "DL2_Text1", 385,310, Color(122, 126, 128), TEXT_ALIGN_LEFT)
					draw.DrawText(current["Second"]["Loadout"]["Ace"], "DL2_Text2", 385,330, Color(240,240,240), TEXT_ALIGN_LEFT)
				end

				if current["Third"]["Active"] == true then
					draw.RoundedBox(0, 700, 40, 250, 440, Color(25, 25, 25))
					draw.DrawText("Loadout Slot #3", "DL2_Title", 820,50, Color(26,205,182), TEXT_ALIGN_CENTER)
					draw.DrawText("Equipped Primary:", "DL2_Text1", 710,100, Color(26,205,182), TEXT_ALIGN_LEFT)
					draw.DrawText(current["Third"]["Loadout"]["Primary"], "DL2_Text2", 710,120, Color(240,240,240), TEXT_ALIGN_LEFT)

					draw.DrawText("Equipped Secondary:", "DL2_Text1", 710,170, Color(26,205,182), TEXT_ALIGN_LEFT)
					draw.DrawText(current["Third"]["Loadout"]["Secondary"], "DL2_Text2", 710,190, Color(240,240,240), TEXT_ALIGN_LEFT)

					draw.DrawText("Equipped Specialist:", "DL2_Text1", 710,240, Color(26,205,182), TEXT_ALIGN_LEFT)
					draw.DrawText(current["Third"]["Loadout"]["Spec"], "DL2_Text2", 710,260, Color(240,240,240), TEXT_ALIGN_LEFT)

					draw.DrawText("Ace up the Sleeve:", "DL2_Text1", 710,310, Color(26,205,182), TEXT_ALIGN_LEFT)
					draw.DrawText(current["Third"]["Loadout"]["Ace"], "DL2_Text2", 710,330, Color(240,240,240), TEXT_ALIGN_LEFT)
				else
					draw.RoundedBox(0, 700, 40, 250, 440, Color(25, 25, 25))
					draw.DrawText("Loadout Slot #3", "DL2_Title", 820,50, Color(122, 126, 128), TEXT_ALIGN_CENTER)
					draw.DrawText("Equipped Primary:", "DL2_Text1", 710,100, Color(122, 126, 128), TEXT_ALIGN_LEFT)
					draw.DrawText(current["Third"]["Loadout"]["Primary"], "DL2_Text2", 710,120, Color(240,240,240), TEXT_ALIGN_LEFT)

					draw.DrawText("Equipped Secondary:", "DL2_Text1", 710,170, Color(122, 126, 128), TEXT_ALIGN_LEFT)
					draw.DrawText(current["Third"]["Loadout"]["Secondary"], "DL2_Text2", 710,190, Color(240,240,240), TEXT_ALIGN_LEFT)

					draw.DrawText("Equipped Specialist:", "DL2_Text1", 710,240, Color(122, 126, 128), TEXT_ALIGN_LEFT)
					draw.DrawText(current["Third"]["Loadout"]["Spec"], "DL2_Text2", 710,260, Color(240,240,240), TEXT_ALIGN_LEFT)

					draw.DrawText("Ace up the Sleeve:", "DL2_Text1", 710,310, Color(122, 126, 128), TEXT_ALIGN_LEFT)
					draw.DrawText(current["Third"]["Loadout"]["Ace"], "DL2_Text2", 710,330, Color(240,240,240), TEXT_ALIGN_LEFT)
				end
			end
		local menuframe2 = vgui.Create("DPanel",frame)
			menuframe2:SetSize(1000, 500)
			menuframe2:SetPos(0,100)
			menuframe2.Paint = function( self, w, h )
				draw.RoundedBox(0, 0, 0, w, h, Color(34,36,37,255))
				if aceupsleeve == "false" then
					draw.DrawText("Ace Up the Sleeve [DISABLED]", "DL2_Text1", 985,5, Color(204, 61, 61), TEXT_ALIGN_RIGHT)
				elseif aceupsleeve == "primary" then
					draw.DrawText("Ace Up the Sleeve [PRIMARY]", "DL2_Text1", 985,5, Color(26,205,182), TEXT_ALIGN_RIGHT)
				elseif aceupsleeve == "spec" then
					draw.DrawText("Ace Up the Sleeve [SPECIALIST]", "DL2_Text1", 985,5, Color(26,205,182), TEXT_ALIGN_RIGHT)
				end

				draw.RoundedBox(0, 50, 40, 250, 440, Color(25, 25, 25))
					draw.DrawText("Loadout Slot #1", "DL2_Title", 170,50, Color(240,240,240), TEXT_ALIGN_CENTER)
					draw.DrawText("Equipped Primary:", "DL2_Text1", 60,100, Color(240,240,240), TEXT_ALIGN_LEFT)

					draw.DrawText("Equipped Secondary:", "DL2_Text1", 60,170, Color(240,240,240), TEXT_ALIGN_LEFT)

					draw.DrawText("Equipped Specialist:", "DL2_Text1", 60,240, Color(240,240,240), TEXT_ALIGN_LEFT)

					draw.DrawText("Ace up the Sleeve:", "DL2_Text1", 60,310, Color(240,240,240), TEXT_ALIGN_LEFT)

					if selectbuttononehover == true then
						draw.RoundedBox(0, 87, 380, 175, 35, Color(26,205,182))
						draw.DrawText("Already Equipped", "DL2_Text2", 175,388, Color(240,240,240), TEXT_ALIGN_CENTER)
					end

				draw.RoundedBox(0, 375, 40, 250, 440, Color(25, 25, 25))
					draw.DrawText("Loadout Slot #2", "DL2_Title", 495,50, Color(240,240,240), TEXT_ALIGN_CENTER)
					draw.DrawText("Equipped Primary:", "DL2_Text1", 385,100, Color(240,240,240), TEXT_ALIGN_LEFT)

					draw.DrawText("Equipped Secondary:", "DL2_Text1", 385,170, Color(240,240,240), TEXT_ALIGN_LEFT)

					draw.DrawText("Equipped Specialist:", "DL2_Text1", 385,240, Color(240,240,240), TEXT_ALIGN_LEFT)

					draw.DrawText("Ace up the Sleeve:", "DL2_Text1", 385,310, Color(240,240,240), TEXT_ALIGN_LEFT)

				draw.RoundedBox(0, 700, 40, 250, 440, Color(25, 25, 25))
					draw.DrawText("Loadout Slot #3", "DL2_Title", 820,50, Color(240,240,240), TEXT_ALIGN_CENTER)
					draw.DrawText("Equipped Primary:", "DL2_Text1", 710,100, Color(240,240,240), TEXT_ALIGN_LEFT)

					draw.DrawText("Equipped Secondary:", "DL2_Text1", 710,170, Color(240,240,240), TEXT_ALIGN_LEFT)

					draw.DrawText("Equipped Specialist:", "DL2_Text1", 710,240, Color(240,240,240), TEXT_ALIGN_LEFT)

					draw.DrawText("Ace up the Sleeve:", "DL2_Text1", 710,310, Color(240,240,240), TEXT_ALIGN_LEFT)
			end
		local menuframe3 = vgui.Create("DPanel",frame)
			menuframe3:SetSize(1000, 500)
			menuframe3:SetPos(0,100)
			menuframe3.Paint = function( self, w, h )
				draw.RoundedBox(0, 0, 0, w, h, Color(34,36,37,255))
			end
		menuframe1:Hide()
		menuframe2:Hide()
		menuframe3:Hide()
		if framenumber == 1 then
			menuframe1:Hide()
			menuframe2:Hide()
			menuframe3:Hide()
			menuframe1:Show()
		elseif framenumber == 2 then
			menuframe1:Hide()
			menuframe2:Hide()
			menuframe3:Hide()
			menuframe2:Show()
		elseif framenumber == 3 then
			menuframe1:Hide()
			menuframe2:Hide()
			menuframe3:Hide()
			menuframe3:Show()
		end

		-- Menu Frame 1
			-- Select 1
				if current["First"]["Purchased"] == true then
					local SelectLoadout1 = vgui.Create("DButton", menuframe1)
						SelectLoadout1:SetSize(230,50)
						SelectLoadout1:SetText("")
						SelectLoadout1:SetPos(60, 420)
						SelectLoadout1:SetTextColor( Color( 236, 239, 244) )
						SelectLoadout1.Paint = function( self, w, h )
							if current["First"]["Active"] == true then
								draw.RoundedBox(0, 0, 0, w, h, Color(26,205,182))
							else
								draw.RoundedBox(0, 0, 0, w, h, Color(47,49,50))
							end
							draw.DrawText("Selected Loadout", "DL2_Text1", w/2,17, Color(240,240,240,255), TEXT_ALIGN_CENTER)
						end
						SelectLoadout1.DoClick = function()
                    		if (delay <= CurTime()) then
                        		delay = CurTime() + 5;
                                net.Start("igSquadMenuSelect")
                                    net.WriteString("1")
                                net.SendToServer()
                                frame:Close()
                        	end
						end
				else
					local SelectLoadout1 = vgui.Create("DButton", menuframe1)
						SelectLoadout1:SetSize(230,50)
						SelectLoadout1:SetText("")
						SelectLoadout1:SetPos(60, 420)
						SelectLoadout1:SetTextColor( Color( 236, 239, 244) )
						SelectLoadout1.Paint = function( self, w, h )
							draw.RoundedBox(0, 0, 0, w, h, Color(204, 61, 61))
							draw.DrawText("Purchase Loadout", "DL2_Text1", w/2,17, Color(240,240,240,255), TEXT_ALIGN_CENTER)
						end
						SelectLoadout1.DoClick = function()
							if ply:SH_CanAffordPremium(0) then
								net.Start("igSquadMenuPurchase")
									net.WriteString("1")
								net.SendToServer()
								frame:Close()
							else
								ply:PrintMessage( HUD_PRINTTALK, "Not enough credits or points." )
							end
						end
				end
			-- Select 2
				if current["Second"]["Purchased"] == true then
					local SelectLoadout2 = vgui.Create("DButton", menuframe1)
						SelectLoadout2:SetSize(230,50)
						SelectLoadout2:SetText("")
						SelectLoadout2:SetPos(385, 420)
						SelectLoadout2:SetTextColor( Color( 236, 239, 244) )
						SelectLoadout2.Paint = function( self, w, h )
							if current["Second"]["Active"] == true then
								draw.RoundedBox(0, 0, 0, w, h, Color(26,205,182))
							else
								draw.RoundedBox(0, 0, 0, w, h, Color(47,49,50))
							end
							draw.DrawText("Select Loadout", "DL2_Text1", w/2,17, Color(240,240,240,255), TEXT_ALIGN_CENTER)
						end
						SelectLoadout2.DoClick = function()
                    		if (delay <= CurTime()) then
                        		delay = CurTime() + 5;
                                net.Start("igSquadMenuSelect")
                                    net.WriteString("2")
                                net.SendToServer()
                                frame:Close()
                        	end
						end
				else
					local SelectLoadout2 = vgui.Create("DButton", menuframe1)
						SelectLoadout2:SetSize(230,50)
						SelectLoadout2:SetText("")
						SelectLoadout2:SetPos(385, 420)
						SelectLoadout2:SetTextColor( Color( 236, 239, 244) )
						SelectLoadout2.Paint = function( self, w, h )
							draw.RoundedBox(0, 0, 0, w, h, Color(204, 61, 61))
							draw.DrawText("Purchase Loadout (25k)", "DL2_Text1", w/2,17, Color(240,240,240,255), TEXT_ALIGN_CENTER)
						end
						SelectLoadout2.DoClick = function()
							if ply:SH_CanAffordPremium(25000) then
								net.Start("igSquadMenuPurchase")
									net.WriteString("2")
								net.SendToServer()
								frame:Close()
							else
								ply:PrintMessage( HUD_PRINTTALK, "Not enough credits or points." )
							end
						end
				end
			-- Select 3
				if current["Third"]["Purchased"] == true then
					local SelectLoadout3 = vgui.Create("DButton", menuframe1)
						SelectLoadout3:SetSize(230,50)
						SelectLoadout3:SetText("")
						SelectLoadout3:SetPos(710, 420)
						SelectLoadout3:SetTextColor( Color( 236, 239, 244) )
						SelectLoadout3.Paint = function( self, w, h )
							if current["Third"]["Active"] == true then
								draw.RoundedBox(0, 0, 0, w, h, Color(26,205,182))
							else
								draw.RoundedBox(0, 0, 0, w, h, Color(47,49,50))
							end
							draw.DrawText("Select Loadout", "DL2_Text1", w/2,17, Color(240,240,240,255), TEXT_ALIGN_CENTER)
						end
						local delay = CurTime()
						SelectLoadout3.DoClick = function()
                    		if (delay <= CurTime()) then
                        		delay = CurTime() + 5;
                                net.Start("igSquadMenuSelect")
                                    net.WriteString("3")
                                net.SendToServer()
                                frame:Close()
                        	end
						end
				else
					local SelectLoadout3 = vgui.Create("DButton", menuframe1)
						SelectLoadout3:SetSize(230,50)
						SelectLoadout3:SetText("")
						SelectLoadout3:SetPos(710, 420)
						SelectLoadout3:SetTextColor( Color( 236, 239, 244) )
						SelectLoadout3.Paint = function( self, w, h )
							draw.RoundedBox(0, 0, 0, w, h, Color(204, 61, 61))
							draw.DrawText("Purchase Loadout (75k)", "DL2_Text1", w/2,17, Color(240,240,240,255), TEXT_ALIGN_CENTER)
						end
						SelectLoadout3.DoClick = function()
							if ply:SH_CanAffordPremium(75000) then
								net.Start("igSquadMenuPurchase")
									net.WriteString("3")
								net.SendToServer()
								frame:Close()
							else
								ply:PrintMessage( HUD_PRINTTALK, "Not enough credits or points." )
							end
						end
				end

		-- Menu Frame 2
			--Combo Boxes
				--First Loadout
					local firstprimarycombo = vgui.Create("DComboBox", menuframe2)
						firstprimarycombo:SetSize(230,20)
						firstprimarycombo:SetPos(60,125)
						firstprimarycombo:SetValue("Select Primary Weapon")
						firstprimarycombo.Paint = function( self, w, h )
							draw.RoundedBox(0, 0, 0, w, h, Color(240,240,240))
						end
						for k,v in pairs(weapontable["Primary"]) do
							firstprimarycombo:AddChoice(v)
						end
						firstprimarycombo.OnSelect = function( self, index, value )
							temp["First"]["Primary"] = value
						end
					local firstsecondarycombo = vgui.Create("DComboBox", menuframe2)
						firstsecondarycombo:SetSize(230,20)
						firstsecondarycombo:SetPos(60,195)
						firstsecondarycombo:SetValue("Select Secondary Weapon")
						firstsecondarycombo.Paint = function( self, w, h )
							draw.RoundedBox(0, 0, 0, w, h, Color(240,240,240))
						end
						for k,v in pairs(weapontable["Secondary"]) do
							firstsecondarycombo:AddChoice(v)
						end
						firstsecondarycombo.OnSelect = function( self, index, value )
							temp["First"]["Secondary"] = value
						end
					local firstspeccombo = vgui.Create("DComboBox", menuframe2)
						firstspeccombo:SetSize(230,20)
						firstspeccombo:SetPos(60,265)
						firstspeccombo:SetValue("Select Specialist Weapon")
						firstspeccombo.Paint = function( self, w, h )
							draw.RoundedBox(0, 0, 0, w, h, Color(240,240,240))
						end
						for k,v in pairs(weapontable["Specialist"]) do
							firstspeccombo:AddChoice(v)
						end
						firstspeccombo.OnSelect = function( self, index, value )
							temp["First"]["Spec"] = value
						end
					local firstacecombo = vgui.Create("DComboBox", menuframe2)
						firstacecombo:SetSize(230,20)
						firstacecombo:SetPos(60,335)
						firstacecombo:SetValue("Select Extra Weapon")
						firstacecombo.Paint = function( self, w, h )
							draw.RoundedBox(0, 0, 0, w, h, Color(240,240,240))
						end
						if aceupsleeve == "false" then
							
						elseif aceupsleeve == "primary" then
							for k,v in pairs(weapontable["Primary"]) do
								firstacecombo:AddChoice(v)
							end
						elseif aceupsleeve == "spec" then
							for k,v in pairs(weapontable["Specialist"]) do
								firstacecombo:AddChoice(v)
							end
						end
						firstacecombo.OnSelect = function( self, index, value )
							temp["First"]["Ace"] = value
						end
				
				--Second Loadout
					local secondprimarycombo = vgui.Create("DComboBox", menuframe2)
						secondprimarycombo:SetSize(230,20)
						secondprimarycombo:SetPos(385,125)
						secondprimarycombo:SetValue("Select Primary Weapon")
						secondprimarycombo.Paint = function( self, w, h )
							draw.RoundedBox(0, 0, 0, w, h, Color(240,240,240))
						end
						for k,v in pairs(weapontable["Primary"]) do
							secondprimarycombo:AddChoice(v)
						end
						secondprimarycombo.OnSelect = function( self, index, value )
							temp["Second"]["Primary"] = value
						end
					local secondsecondarycombo = vgui.Create("DComboBox", menuframe2)
						secondsecondarycombo:SetSize(230,20)
						secondsecondarycombo:SetPos(385,195)
						secondsecondarycombo:SetValue("Select Secondary Weapon")
						secondsecondarycombo.Paint = function( self, w, h )
							draw.RoundedBox(0, 0, 0, w, h, Color(240,240,240))
						end
						for k,v in pairs(weapontable["Secondary"]) do
							secondsecondarycombo:AddChoice(v)
						end
						secondsecondarycombo.OnSelect = function( self, index, value )
							temp["Second"]["Secondary"] = value
						end
					local secondspeccombo = vgui.Create("DComboBox", menuframe2)
						secondspeccombo:SetSize(230,20)
						secondspeccombo:SetPos(385,265)
						secondspeccombo:SetValue("Select Specialist Weapon")
						secondspeccombo.Paint = function( self, w, h )
							draw.RoundedBox(0, 0, 0, w, h, Color(240,240,240))
						end
						for k,v in pairs(weapontable["Specialist"]) do
							secondspeccombo:AddChoice(v)
						end
						secondspeccombo.OnSelect = function( self, index, value )
							temp["Second"]["Spec"] = value
						end
					local secondacecombo = vgui.Create("DComboBox", menuframe2)
						secondacecombo:SetSize(230,20)
						secondacecombo:SetPos(385,335)
						secondacecombo:SetValue("Select Extra Weapon")
						secondacecombo.Paint = function( self, w, h )
							draw.RoundedBox(0, 0, 0, w, h, Color(240,240,240))
						end
						if aceupsleeve == "false" then
							
						elseif aceupsleeve == "primary" then
							for k,v in pairs(weapontable["Primary"]) do
								secondacecombo:AddChoice(v)
							end
						elseif aceupsleeve == "spec" then
							for k,v in pairs(weapontable["Specialist"]) do
								secondacecombo:AddChoice(v)
							end
						end
						secondacecombo.OnSelect = function( self, index, value )
							temp["Second"]["Ace"] = value
						end
				
				--Third Loadout
					local thirdprimarycombo = vgui.Create("DComboBox", menuframe2)
						thirdprimarycombo:SetSize(230,20)
						thirdprimarycombo:SetPos(710,125)
						thirdprimarycombo:SetValue("Select Primary Weapon")
						thirdprimarycombo.Paint = function( self, w, h )
							draw.RoundedBox(0, 0, 0, w, h, Color(240,240,240))
						end
						for k,v in pairs(weapontable["Primary"]) do
							thirdprimarycombo:AddChoice(v)
						end
						thirdprimarycombo.OnSelect = function( self, index, value )
							temp["Third"]["Primary"] = value
						end
					local thirdsecondarycombo = vgui.Create("DComboBox", menuframe2)
						thirdsecondarycombo:SetSize(230,20)
						thirdsecondarycombo:SetPos(710,195)
						thirdsecondarycombo:SetValue("Select Secondary Weapon")
						thirdsecondarycombo.Paint = function( self, w, h )
							draw.RoundedBox(0, 0, 0, w, h, Color(240,240,240))
						end
						for k,v in pairs(weapontable["Secondary"]) do
							thirdsecondarycombo:AddChoice(v)
						end
						thirdsecondarycombo.OnSelect = function( self, index, value )
							temp["Third"]["Secondary"] = value
						end
					local thirdspeccombo = vgui.Create("DComboBox", menuframe2)
						thirdspeccombo:SetSize(230,20)
						thirdspeccombo:SetPos(710,265)
						thirdspeccombo:SetValue("Select Specialist Weapon")
						thirdspeccombo.Paint = function( self, w, h )
							draw.RoundedBox(0, 0, 0, w, h, Color(240,240,240))
						end
						for k,v in pairs(weapontable["Specialist"]) do
							thirdspeccombo:AddChoice(v)
						end
						thirdspeccombo.OnSelect = function( self, index, value )
							temp["Third"]["Spec"] = value
						end
					local thirdacecombo = vgui.Create("DComboBox", menuframe2)
						thirdacecombo:SetSize(230,20)
						thirdacecombo:SetPos(710,335)
						thirdacecombo:SetValue("Select Extra Weapon")
						thirdacecombo.Paint = function( self, w, h )
							draw.RoundedBox(0, 0, 0, w, h, Color(240,240,240))
						end
						if aceupsleeve == "false" then
							
						elseif aceupsleeve == "primary" then
							for k,v in pairs(weapontable["Primary"]) do
								thirdacecombo:AddChoice(v)
							end
						elseif aceupsleeve == "spec" then
							for k,v in pairs(weapontable["Specialist"]) do
								thirdacecombo:AddChoice(v)
							end
						end
						thirdacecombo.OnSelect = function( self, index, value )
							temp["Third"]["Ace"] = value
						end
			-- Buttons
				-- Edit 1
					if current["First"]["Purchased"] == true then
						local SaveLoadout1 = vgui.Create("DButton", menuframe2)
							SaveLoadout1:SetSize(230,50)
							SaveLoadout1:SetText("")
							SaveLoadout1:SetPos(60, 420)
							SaveLoadout1:SetTextColor( Color( 236, 239, 244) )
							SaveLoadout1.Paint = function( self, w, h )
								draw.RoundedBox(0, 0, 0, w, h, Color(26,205,182))
								draw.DrawText("Save Loadout", "DL2_Text1", w/2,17, Color(240,240,240,255), TEXT_ALIGN_CENTER)
							end
							SaveLoadout1.DoClick = function()
								local selected = temp["First"]
								net.Start("igSquadMenuEdit")
									net.WriteString("1")
									net.WriteTable(selected)
								net.SendToServer()
								frame:Close()
							end
					else
						local SaveLoadout1 = vgui.Create("DButton", menuframe2)
							SaveLoadout1:SetSize(230,50)
							SaveLoadout1:SetText("")
							SaveLoadout1:SetPos(60, 420)
							SaveLoadout1:SetTextColor( Color( 236, 239, 244) )
							SaveLoadout1.Paint = function( self, w, h )
								draw.RoundedBox(0, 0, 0, w, h, Color(204, 61, 61))
								draw.DrawText("[DISABLED]", "DL2_Text1", w/2,17, Color(240,240,240,255), TEXT_ALIGN_CENTER)
							end
							SaveLoadout1.DoClick = function()

							end
					end
				-- Edit 2
					if current["Second"]["Purchased"] == true then
						local SaveLoadout2 = vgui.Create("DButton", menuframe2)
							SaveLoadout2:SetSize(230,50)
							SaveLoadout2:SetText("")
							SaveLoadout2:SetPos(385, 420)
							SaveLoadout2:SetTextColor( Color( 236, 239, 244) )
							SaveLoadout2.Paint = function( self, w, h )
								draw.RoundedBox(0, 0, 0, w, h, Color(47,49,50))
								draw.DrawText("Save Loadout", "DL2_Text1", w/2,17, Color(240,240,240,255), TEXT_ALIGN_CENTER)
							end
							SaveLoadout2.DoClick = function()
								local selected = temp["Second"]
								net.Start("igSquadMenuEdit")
									net.WriteString("2")
									net.WriteTable(selected)
								net.SendToServer()
								frame:Close()
							end
					else
						local SaveLoadout2 = vgui.Create("DButton", menuframe2)
							SaveLoadout2:SetSize(230,50)
							SaveLoadout2:SetText("")
							SaveLoadout2:SetPos(385, 420)
							SaveLoadout2:SetTextColor( Color( 236, 239, 244) )
							SaveLoadout2.Paint = function( self, w, h )
								draw.RoundedBox(0, 0, 0, w, h, Color(204, 61, 61))
								draw.DrawText("[DISABLED]", "DL2_Text1", w/2,17, Color(240,240,240,255), TEXT_ALIGN_CENTER)
							end
							SaveLoadout2.DoClick = function()

							end
					end
				-- Edit 3
					if current["Third"]["Purchased"] == true then
						local SaveLoadout3 = vgui.Create("DButton", menuframe2)
							SaveLoadout3:SetSize(230,50)
							SaveLoadout3:SetText("")
							SaveLoadout3:SetPos(710, 420)
							SaveLoadout3:SetTextColor( Color( 236, 239, 244) )
							SaveLoadout3.Paint = function( self, w, h )
								draw.RoundedBox(0, 0, 0, w, h, Color(47,49,50))
								draw.DrawText("Save Loadout", "DL2_Text1", w/2,17, Color(240,240,240,255), TEXT_ALIGN_CENTER)
							end
							SaveLoadout3.DoClick = function()
								local selected = temp["Third"]
								net.Start("igSquadMenuEdit")
									net.WriteString("3")
									net.WriteTable(selected)
								net.SendToServer()
								frame:Close()
							end
					else
						local SaveLoadout3 = vgui.Create("DButton", menuframe2)
							SaveLoadout3:SetSize(230,50)
							SaveLoadout3:SetText("")
							SaveLoadout3:SetPos(710, 420)
							SaveLoadout3:SetTextColor( Color( 236, 239, 244) )
							SaveLoadout3.Paint = function( self, w, h )
								draw.RoundedBox(0, 0, 0, w, h, Color(204, 61, 61))
								draw.DrawText("[DISABLED]", "DL2_Text1", w/2,17, Color(240,240,240,255), TEXT_ALIGN_CENTER)
							end
							SaveLoadout3.DoClick = function()

							end
					end
	end

	DrawFramePage()

	local selectframe1 = vgui.Create("DButton", frame)
		selectframe1:SetSize(150,50)
		selectframe1:SetText("")
		selectframe1:SetPos(0, 50)
		selectframe1:SetTextColor( Color( 236, 239, 244) )
		selectframe1.Paint = function( self, w, h )
			draw.RoundedBox(0, 0, 0, w, h, Color(129,161,193,0))
		end
		selectframe1.DoClick = function()
			if framenumber == 1 then else
				framenumber = 1
				DrawFramePage()
				ColorTable = {
					["Page1"] = {
						["Text"] = Color(26,205,182),
						["Line"] = Color(26,205,182),
					},
					["Page2"] = {
						["Text"] = Color(240,240,240),
						["Line"] = Color(47,49,50),
					},
					["Page3"] = {
						["Text"] = Color(240,240,240),
						["Line"] = Color(47,49,50),
					},
				}
			end
		end

	local selectframe2 = vgui.Create("DButton", frame)
		selectframe2:SetSize(150,50)
		selectframe2:SetText("")
		selectframe2:SetPos(150, 50)
		selectframe2:SetTextColor( Color( 236, 239, 244) )
		selectframe2.Paint = function( self, w, h )
			draw.RoundedBox(0, 0, 0, w, h, Color(129,161,193,0))
		end
		selectframe2.DoClick = function()
			if framenumber == 2 then else
				framenumber = 2
				DrawFramePage()
				ColorTable = {
					["Page1"] = {
						["Text"] = Color(240,240,240),
						["Line"] = Color(47,49,50),
					},
					["Page2"] = {
						["Text"] = Color(26,205,182),
						["Line"] = Color(26,205,182),
					},
					["Page3"] = {
						["Text"] = Color(240,240,240),
						["Line"] = Color(47,49,50),
					},
				}
			end
		end
	--[[
	local selectframe3 = vgui.Create("DButton", frame)
		selectframe3:SetSize(150,50)
		selectframe3:SetText("")
		selectframe3:SetPos(300, 50)
		selectframe3:SetTextColor( Color( 236, 239, 244) )
		selectframe3.Paint = function( self, w, h )
			draw.RoundedBox(0, 0, 0, w, h, Color(129,161,193,0))
		end
		selectframe3.DoClick = function()
			if framenumber == 3 then else
				framenumber = 3
				DrawFramePage()
				ColorTable = {
					["Page1"] = {
						["Text"] = Color(240,240,240),
						["Line"] = Color(47,49,50),
					},
					["Page2"] = {
						["Text"] = Color(240,240,240),
						["Line"] = Color(47,49,50),
					},
					["Page3"] = {
						["Text"] = Color(26,205,182),
						["Line"] = Color(26,205,182),
					},
				}
			end
		end
	]]

	local DermaImageButton = vgui.Create( "DImageButton", frame )
	DermaImageButton:SetPos( 970, 10 )
	DermaImageButton:SetSize( 20, 20 )
	DermaImageButton:SetImage( "/twist/dynamicloadouts_v2/close_icon.png" )
	DermaImageButton.DoClick = function()
		frame:Close()
	end
end)