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
    	draw.SimpleText("Pointshop Withdrawal", "IG_Dynamic_Title", 0, -600, Color(255,255,255), 1, 1)
	cam.End3D2D()
end

net.Receive("igSquadMenuPoint", function()
	local ply = LocalPlayer()
	local pointshop = net.ReadTable()
	local temp = {
		first = "",
		second = "",
	}

	local frame = vgui.Create("DFrame")
		frame:SetSize(530, 250)
		frame:Center()
		frame:SetVisible(true)
		frame:MakePopup()
		frame:ShowCloseButton(false)
		frame:SetTitle("")

		frame.Paint = function( self, w, h )
			draw.RoundedBox(0, 0, 0, w, h, Color(74, 100, 133))
			draw.RoundedBox(0, 0, 0, w, 40, Color(46, 52, 64))
			draw.RoundedBox(0,10,80,510,160,Color(67, 76, 94))
			draw.DrawText("DYNAMIC LOADOUT", "IG_Dynamic_Title", 265,40, Color(255,255,255,255), TEXT_ALIGN_CENTER)
		end

		local sheet = vgui.Create("DColumnSheet",frame)
			sheet:SetPos(10,90)
			sheet:SetSize(600,140)

			local SelectMenu = vgui.Create("DPanel")
				sheet:AddSheet("Select Weapon",SelectMenu)
				SelectMenu:SetSize(380,390)
				SelectMenu.Paint = function( self, w, h )
					draw.RoundedBox( 4, 0, 0, w, h, Color( 76, 86, 106 ) )
					draw.RoundedBox(0,10,40,360,75,Color(67, 76, 94))
					draw.DrawText("Select up to two weapons", "IG_Dynamic_Sub", 190,10, Color(255,255,255,255), TEXT_ALIGN_CENTER)
				end
					local firstspeccombo = vgui.Create("DComboBox", SelectMenu)
						firstspeccombo:SetSize(250,30)
						firstspeccombo:SetPos(15,45)
						firstspeccombo:SetValue("Select Pointshop Weapon")
						for k,v in pairs(pointshop) do
							firstspeccombo:AddChoice(v)
						end
						firstspeccombo.OnSelect = function( self, index, value )
							temp.first = value
						end

					local secspeccombo = vgui.Create("DComboBox", SelectMenu)
						secspeccombo:SetSize(250,30)
						secspeccombo:SetPos(15,80)
						secspeccombo:SetValue("Select Pointshop Weapon")
						for k,v in pairs(pointshop) do
							secspeccombo:AddChoice(v)
						end
						secspeccombo.OnSelect = function( self, index, value )
							temp.second = value
						end

					local selectloadout1 = vgui.Create("DButton", SelectMenu)
						selectloadout1:SetSize(95,65)
						selectloadout1:SetText("Confirm Selection")
						selectloadout1:SetPos(270,45)
						selectloadout1:SetTextColor( Color( 236, 239, 244) )
						selectloadout1.Paint = function( self, w, h )
							draw.RoundedBox(0, 0, 0, w, h, Color(46, 52, 64))
						end
						selectloadout1.DoClick = function()
							if ply:SH_CanAffordPremium(500) then
								local selected = temp
								net.Start("igSquadMenuPointSelect")
									net.WriteTable(temp)
									net.WriteTable(pointshop)
								net.SendToServer()
								frame:Close()
							else
								ply:PrintMessage( HUD_PRINTTALK, "Not enough credits." )
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
			buttonmainclose:SetPos(20, 125)
			buttonmainclose.DoClick = function()
				frame:Close()
			end

end)
