include( 'shared.lua' )

local xpos = 110
local ypos = 99

local letter = ""
local number = ""


function movebox()
	-- Setting Numbers
		if number == "2" then
			ypos = 99
		elseif number == "3" then
			ypos = 87
		elseif number == "4" then
			ypos = 76
		elseif number == "5" then
			ypos = 64
		elseif number == "6" then
			ypos = 52
		elseif number == "7" then
			ypos = 41
		elseif number == "8" then
			ypos = 29
		elseif number == "9" then
			ypos = 17
		elseif number == "10" then
			ypos = 6
		elseif number == "11" then
			ypos = -6
		elseif number == "12" then
			ypos = -18
		elseif number == "13" then
			ypos = -29
		elseif number == "14" then
			ypos = -41
		elseif number == "15" then
			ypos = -52
		elseif number == "16" then
			ypos = -64
		elseif number == "17" then
			ypos = -76
		elseif number == "18" then
			ypos = -87
		elseif number == "19" then
			ypos = -99
		elseif number == "20" then
			ypos = -111
		elseif number == "21" then
			ypos = -122
		end

	-- Setting Letters
		if letter == "A" then
			xpos = 110
		elseif letter == "B" then
			xpos = 99
		elseif letter == "C" then
			xpos = 89
		elseif letter == "D" then
			xpos = 78
		elseif letter == "E" then
			xpos = 68
		elseif letter == "F" then
			xpos = 58
		elseif letter == "G" then
			xpos = 47
		elseif letter == "H" then
			xpos = 37
		elseif letter == "I" then
			xpos = 26
		elseif letter == "J" then
			xpos = 16
		elseif letter == "K" then
			xpos = 5
		elseif letter == "L" then
			xpos = -5
		elseif letter == "M" then
			xpos = -16
		elseif letter == "N" then
			xpos = -26
		elseif letter == "O" then
			xpos = -36
		elseif letter == "P" then
			xpos = -47
		elseif letter == "Q" then
			xpos = -57
		elseif letter == "R" then
			xpos = -68
		elseif letter == "S" then
			xpos = -78
		elseif letter == "T" then
			xpos = -89
		elseif letter == "U" then
			xpos = -99
		elseif letter == "V" then
			xpos = -110
		elseif letter == "W" then
			xpos = -120
		end
end

function GalaxyMapSpawn(data)

	letter = data:ReadString()
	number = data:ReadString()

	movebox()

end

usermessage.Hook( "GalaxyMapInitData", GalaxyMapSpawn );

function ENT:Draw()
	self:DrawModel()

	--local ang = self:GetAngles()

	--ang:RotateAroundAxis(self:GetAngles():Right(), 90)
	local pos = self:LocalToWorld(Vector(1.15, 0, 2.5))
	local ang = self:LocalToWorldAngles(Angle(-90, 0, 0))

	cam.Start3D2D(pos, ang, 1)

		draw.RoundedBox(0, ypos, xpos, 11, 10, Color(223, 227, 24, 60))

	cam.End3D2D()
end

net.Receive("igGalaxyMap", function()
	local templetter = ""
	local tempnumber = ""

	local frame = vgui.Create("DFrame")
		frame:SetSize(270,120)
		frame:MakePopup()
		frame:Center()
		frame:SetTitle("Set Fleet Position")

	local lettercombo = vgui.Create("DComboBox", frame)
		lettercombo:SetSize(150,40)
		lettercombo:SetPos(10,30)
		lettercombo:SetValue("Letter Position")
			lettercombo:AddChoice("A")
			lettercombo:AddChoice("B")
			lettercombo:AddChoice("C")
			lettercombo:AddChoice("D")
			lettercombo:AddChoice("E")
			lettercombo:AddChoice("F")
			lettercombo:AddChoice("G")
			lettercombo:AddChoice("H")
			lettercombo:AddChoice("I")
			lettercombo:AddChoice("J")
			lettercombo:AddChoice("K")
			lettercombo:AddChoice("L")
			lettercombo:AddChoice("M")
			lettercombo:AddChoice("N")
			lettercombo:AddChoice("O")
			lettercombo:AddChoice("P")
			lettercombo:AddChoice("Q")
			lettercombo:AddChoice("R")
			lettercombo:AddChoice("S")
			lettercombo:AddChoice("T")
			lettercombo:AddChoice("U")
			lettercombo:AddChoice("V")
			lettercombo:AddChoice("W")

		lettercombo.OnSelect = function(self, index, value)
			templetter = value
		end

	--[[local numbercombo = vgui.Create("DComboBox", frame)
		numbercombo:SetSize(250,20)
		numbercombo:SetPos(10,60)
		numbercombo:SetValue("Number Combo Boxes")
			numbercombo:AddChoice("2")
			numbercombo:AddChoice("3")
			numbercombo:AddChoice("4")
			numbercombo:AddChoice("5")
			numbercombo:AddChoice("6")
			numbercombo:AddChoice("7")
			numbercombo:AddChoice("8")
			numbercombo:AddChoice("9")
			numbercombo:AddChoice("10")
			numbercombo:AddChoice("11")
			numbercombo:AddChoice("12")
			numbercombo:AddChoice("13")
			numbercombo:AddChoice("14")
			numbercombo:AddChoice("15")
			numbercombo:AddChoice("16")
			numbercombo:AddChoice("17")
			numbercombo:AddChoice("18")
			numbercombo:AddChoice("19")
			numbercombo:AddChoice("20")
			numbercombo:AddChoice("21")

		numbercombo.OnSelect = function(self, index, value)]]--
		local numbercombo = vgui.Create("DNumberWang", frame)
		numbercombo:SetSize(80,40)
		numbercombo:SetPos(170,30)
		numbercombo:SetMinMax(2,21)

		numbercombo.OnValueChanged = function(self, value)
			tempnumber = value
		end

	local confirm =	vgui.Create("DButton", frame)
		confirm:SetSize(250,30)
		confirm:SetPos(10,80)
		confirm:SetText("Confirm Position")
		confirm.DoClick = function()
			if LocalPlayer():IsAdmin() or LocalPlayer():GetRegiment() == "Imperial Navy" then
			if templetter == "" or tempnumber == "" then
				EmitSound( Sound( "buttons/button10.wav" ), Entity(1):GetPos(), 1, CHAN_AUTO, 1, 75, 0, 100 )
			else
				letter = templetter
				number = tempnumber

				net.Start("igGalaxyMapData")
					net.WriteString(letter)
					net.WriteString(number)
				net.SendToServer()

				movebox()
				EmitSound( Sound( "buttons/button14.wav" ), Entity(1):GetPos(), 1, CHAN_AUTO, 1, 75, 0, 100 )
				frame:Close()
			end
			end
		end
end)