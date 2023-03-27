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

net.Receive("ig_hyp_terminal_open", function()
	local hypcheck = net.ReadBool()
	local ply = LocalPlayer()
	local temp = {
		num = 0,
		planet = -1,
		position = "Medium",
		inf = "false",
		left = "Right",
	}
	local frame = vgui.Create("DFrame")
		frame:SetSize(230, 500)
		frame:Center()
		frame:SetVisible(true)
		frame:MakePopup()
		frame:ShowCloseButton(true)
		frame:SetTitle("")

		frame.Paint = function( self, w, h )	
			draw.RoundedBox(0, 0, 0, w, h, Color(74, 100, 133))
			draw.RoundedBox(0, 0, 0, w, 40, Color(46, 52, 64))
			draw.RoundedBox(0,10,80,210,410,Color(67, 76, 94))
			draw.DrawText("Hyperspace Console", "IG_Dynamic_Sub", w/2,50, Color(255,255,255,255), TEXT_ALIGN_CENTER)
			if hypcheck == false then
				draw.DrawText("Time (In Seconds, 0 = Infinite):", "IG_Dynamic_Text", 16,245, Color(255,255,255,255), TEXT_ALIGN_LEFT)
			end
			draw.DrawText("Hyperspace Options:", "IG_Dynamic_Sub", 15,95, Color(255,255,255,255), TEXT_ALIGN_LEFT)
		end

	if hypcheck == false then
		local Wang = vgui.Create("DNumberWang", frame)
			Wang:SetPos(15,265)
			Wang:SetSize(200, 30)
			Wang:SetMin(0)
			Wang:SetMax(100)
			Wang.OnValueChanged = function(self)
				temp.num = self:GetValue()
			end

		local comboplanet = vgui.Create("DComboBox", frame)
			comboplanet:SetSize(200,30)
			comboplanet:SetPos(15,130)
			comboplanet:SetValue("Select Object (Optional)")
				comboplanet:AddChoice("N/A")
				comboplanet:AddChoice("Coruscant")
				comboplanet:AddChoice("Desert")
				comboplanet:AddChoice("Lava")
				comboplanet:AddChoice("Earth Cloudy")
				comboplanet:AddChoice("Swamp")
				comboplanet:AddChoice("Ocean")
				comboplanet:AddChoice("Earth")
				comboplanet:AddChoice("Green Ocean")
				comboplanet:AddChoice("Geonosis")
				comboplanet:AddChoice("Destroyed ISD")
			comboplanet.OnSelect = function( self, index, value )
				temp.planet = index - 2
			end

		local comboposition = vgui.Create("DComboBox", frame)
			comboposition:SetSize(200,30)
			comboposition:SetPos(15,170)
			comboposition:SetValue("Select Object Proximity")
				comboposition:AddChoice("N/A")
				comboposition:AddChoice("Close")
				comboposition:AddChoice("Medium")
				comboposition:AddChoice("Far")
			comboposition.OnSelect = function( self, index, value )
				temp.position = value
			end

		local comboinf = vgui.Create("DComboBox", frame)
			comboinf:SetSize(200,30)
			comboinf:SetPos(15,210)
			comboinf:SetValue("Select Object Position")
				comboinf:AddChoice("Right")
				comboinf:AddChoice("Left")
			comboinf.OnSelect = function( self, index, value )
				temp.left = value
			end

		local ButtonConfirm = vgui.Create("DButton", frame)
			ButtonConfirm:SetText("Confirm Hyperspace Jump")
			ButtonConfirm:SetPos(15,310)
			ButtonConfirm:SetSize(200, 30)
			ButtonConfirm:SetTextColor( Color( 236, 239, 244) )
			ButtonConfirm.Paint = function( self, w, h )
				draw.RoundedBox(0, 0, 0, w, 40, Color(46, 52, 64))
			end
			ButtonConfirm.DoClick = function()
				if temp.num == 0 then
					temp.inf = "true"
				end
				if temp.num > 0 or temp.inf == "true" then
					net.Start("ig_hyp_terminal_recieve")
						net.WriteTable(temp)
						net.WriteEntity(ply)
					net.SendToServer()
					frame:Close()
				else
					ply:PrintMessage( HUD_PRINTTALK, "Timer must be greater than 0" )
				end
			end
	elseif hypcheck == true then

		local ButtonConfirm = vgui.Create("DButton", frame)
			ButtonConfirm:SetText("Exit Hyperspace")
			ButtonConfirm:SetPos(15,310)
			ButtonConfirm:SetSize(200, 30)
			ButtonConfirm:SetTextColor( Color( 236, 239, 244) )
			ButtonConfirm.Paint = function( self, w, h )
				draw.RoundedBox(0, 0, 0, w, 40, Color(46, 52, 64))
			end
			ButtonConfirm.DoClick = function()
				net.Start("ig_hyp_terminal_cancel")
				net.SendToServer()
				frame:Close()
			end

	end
end)