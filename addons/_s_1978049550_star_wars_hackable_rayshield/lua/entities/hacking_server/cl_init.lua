include('shared.lua')
function ENT:Draw()
    -- self.BaseClass.Draw(self) -- Overrides Draw
    self:DrawModel() -- Draws Model Client Side
end
net.Receive("openhackingmenu", function()
	local nround = 1
	local inputcode = ""
	local firstdig = math.random(1,9)
	local secdig = math.random(1,9)
	local thirdig = math.random(1,9)
	local fourdig = math.random(1,9)
	local key = math.random(2, 8)
	local encrypted = firstdig..secdig..thirdig..fourdig
	local firstdiga = firstdig + key
	if (firstdiga > 9) then
		firstdiga = firstdiga - 10
	end
	local secdiga = secdig + key
	if (secdiga > 9) then
		secdiga = secdiga - 10
	end
	local thirdiga = thirdig + key
	if (thirdiga > 9) then
		thirdiga = thirdiga - 10
	end
	local fourdiga = fourdig + key
	if (fourdiga > 9) then
		fourdiga = fourdiga - 10
	end
	local decrypted = firstdiga..secdiga..thirdiga..fourdiga
	local perc = 0
	local materialff = Material("materials/eternals_ui.png")
	local frame = vgui.Create("DFrame")
	frame:SetSize(800, 300)
	frame:Center()
	frame:SetVisible( true )
	frame:SetDraggable( true )
	frame:ShowCloseButton( true )
	frame:SetTitle("Server Terminal")
	function frame:Paint( w, h )
    	surface.SetMaterial(materialff)
    	surface.SetDrawColor( 255, 255, 255, 150 )
		surface.DrawTexturedRect(0,0,w,h)
	end
	frame:MakePopup()
	local Testoperc = vgui.Create("DLabel", frame)
	Testoperc:SetPos( 40, 40 )
	Testoperc:SetSize(725, 50)
	Testoperc:SetText("Powering up: "..perc.."%")
	Testoperc:SetFont("CloseCaption_Bold")
	Testoperc:SetColor(Color(255, 0, 0))
	Testoperc:SetContentAlignment("8")
	local Rounds = vgui.Create("DLabel", frame)
	Rounds:SetPos( 115, 40 )
	Rounds:SetSize(725, 70)
	Rounds:SetColor(Color(255,255,255))
	Rounds:SetText("-Firewall "..nround.."/5-")
	Rounds:SetFont("CloseCaption_Bold")
	Rounds:SetContentAlignment("1")
	Rounds:Hide()
	local Codes = vgui.Create("DLabel", frame)
	Codes:SetPos( 115, 40 )
	Codes:SetSize(725, 100)
	Codes:SetColor(Color(255,255,255))
	Codes:SetText("..Code:    "..encrypted)
	Codes:SetFont("CloseCaption_Bold")
	Codes:SetContentAlignment("1")
	Codes:Hide()
	local Codeshow = vgui.Create("DLabel", frame)
	Codeshow:SetPos( 38, 62 )
	Codeshow:SetSize(725, 100)
	Codeshow:SetColor(Color(255,165,0))
	Codeshow:SetText(inputcode)
	Codeshow:SetFont("CloseCaption_Bold")
	Codeshow:SetContentAlignment("2")
	Codeshow:Hide()
	local Cc = vgui.Create( "DButton", frame )
	Cc:SetPos( 600,200 )
	Cc:SetSize(90,25)
	Cc:SetText("Clear")
	Cc:SetFont("CloseCaption_Bold")
	Cc.DoClick = function()
		inputcode = ""
		Codeshow:SetText(inputcode)
	end
	Cc:Hide()
	local B1 = vgui.Create("DButton", frame)
	B1:SetPos(600,75)
	B1:SetSize(30,30)
	B1:SetText("1")
	B1:SetFont("CloseCaption_Bold")
	B1.DoClick = function()
		inputcode = inputcode..1
		Codeshow:SetText(inputcode)
	end
	B1:Hide()
	local B2 = vgui.Create("DButton", frame)
	B2:SetPos(630,75)
	B2:SetSize(30,30)
	B2:SetText("2")
	B2:SetFont("CloseCaption_Bold")
	B2.DoClick = function()
		inputcode = inputcode..2
		Codeshow:SetText(inputcode)
	end
	B2:Hide()	
	local B3 = vgui.Create("DButton", frame)
	B3:SetPos(660,75)
	B3:SetSize(30,30)
	B3:SetText("3")
	B3:SetFont("CloseCaption_Bold")
	B3.DoClick = function()
		inputcode = inputcode..3
		Codeshow:SetText(inputcode)
	end
	B3:Hide()
	local B4 = vgui.Create("DButton", frame)
	B4:SetPos(600,105)
	B4:SetSize(30,30)
	B4:SetText("4")
	B4:SetFont("CloseCaption_Bold")
	B4.DoClick = function()
		inputcode = inputcode..4
		Codeshow:SetText(inputcode)
	end
	B4:Hide()
	local B5 = vgui.Create("DButton", frame)
	B5:SetPos(630,105)
	B5:SetSize(30,30)
	B5:SetText("5")
	B5:SetFont("CloseCaption_Bold")
	B5.DoClick = function()
		inputcode = inputcode..5
		Codeshow:SetText(inputcode)
	end
	B5:Hide()	
	local B6 = vgui.Create("DButton", frame)
	B6:SetPos(660,105)
	B6:SetSize(30,30)
	B6:SetText("6")
	B6:SetFont("CloseCaption_Bold")
	B6.DoClick = function()
		inputcode = inputcode..6
		Codeshow:SetText(inputcode)
	end
	B6:Hide()
	local B7 = vgui.Create("DButton", frame)
	B7:SetPos(600,135)
	B7:SetSize(30,30)
	B7:SetText("7")
	B7:SetFont("CloseCaption_Bold")
	B7.DoClick = function()
		inputcode = inputcode..7
		Codeshow:SetText(inputcode)
	end
	B7:Hide()
	local B8 = vgui.Create("DButton", frame)
	B8:SetPos(630,135)
	B8:SetSize(30,30)
	B8:SetText("8")
	B8:SetFont("CloseCaption_Bold")
	B8.DoClick = function()
		inputcode = inputcode..8
		Codeshow:SetText(inputcode)
	end
	B8:Hide()	
	local B9 = vgui.Create("DButton", frame)
	B9:SetPos(660,135)
	B9:SetSize(30,30)
	B9:SetText("9")
	B9:SetFont("CloseCaption_Bold")
	B9.DoClick = function()
		inputcode = inputcode..9
		Codeshow:SetText(inputcode)
	end
	B9:Hide()
	local B0 = vgui.Create("DButton", frame)
	B0:SetPos(630,165)
	B0:SetSize(30,30)
	B0:SetText("0")
	B0:SetFont("CloseCaption_Bold")
	B0.DoClick = function()
		inputcode = inputcode..0
		Codeshow:SetText(inputcode)
	end
	B0:Hide()				
	local keytext = vgui.Create("DLabel", frame)
	keytext:SetPos( 115, 40 )
	keytext:SetSize(725, 130)
	keytext:SetColor(Color(255,255,255))
	keytext:SetText("..Key:      "..key)
	keytext:SetFont("CloseCaption_Bold")
	keytext:SetContentAlignment("1")
	keytext:Hide()
	local nbutton = vgui.Create("DButton", frame)
	nbutton:SetText("Deactivate Now")
	nbutton:SetPos(300,100)
	nbutton:SetSize(200,50)
	nbutton.DoClick = function()
		net.Start("normalchoice")
		net.WriteBool(true)
		net.SendToServer()
		frame:Remove()
	end
	nbutton:Hide()
	local rbutton = vgui.Create("DButton", frame)
	rbutton:SetText("Rig For Remote Control")
	rbutton:SetPos(300,200)
	rbutton:SetSize(200,50)
	rbutton.DoClick = function()
		net.Start("remotechoice")
		net.WriteBool(true)
		net.SendToServer()
		frame:Remove()
	end
	rbutton:Hide()
	local Cb = vgui.Create( "DButton", frame )
	Cb:SetPos( 115,200 )
	Cb:SetSize(100,25)
	Cb:SetText("Hack")
	Cb:SetFont("CloseCaption_Bold")
	Cb:SetTextColor(Color(255,255,255))
	function Cb:Paint(w,h)
		draw.RoundedBox(1,0,0,w,h,Color(255, 77, 77))
	end
	Cb.DoClick = function()
		if (inputcode == decrypted) then
			inputcode = ""
			Codeshow:SetText(inputcode)
			if (nround == 5) then
				function frame:Paint( w, h )
    				surface.SetMaterial(materialff)
    				surface.SetDrawColor( 255, 255, 255, 150 )
					surface.DrawTexturedRect(0,0,w,h)
				end
				Codes:Remove()
				Cc:Remove()
				Cb:Remove()
				keytext:Remove()
				Rounds:Remove()
				Codeshow:Remove()
				B1:Remove()
				B2:Remove()
				B3:Remove()
				B4:Remove()
				B5:Remove()
				B6:Remove()
				B7:Remove()
				B8:Remove()
				B9:Remove()
				B0:Remove()
				nbutton:Show()
				rbutton:Show()
			else
				nround = nround + 1
				firstdig = math.random(1,9)
				secdig = math.random(1,9)
				thirdig = math.random(1,9)
				fourdig = math.random(1,9)
				key = math.random(2, 8)
				encrypted = firstdig..secdig..thirdig..fourdig
				firstdiga = firstdig + key
				if (firstdiga > 9) then
					firstdiga = firstdiga - 10
				end
				secdiga = secdig + key
				if (secdiga > 9) then
					secdiga = secdiga - 10
				end
				thirdiga = thirdig + key
				if (thirdiga > 9) then
					thirdiga = thirdiga - 10
				end
				fourdiga = fourdig + key
				if (fourdiga > 9) then
					fourdiga = fourdiga - 10
				end
				decrypted = firstdiga..secdiga..thirdiga..fourdiga
				Rounds:SetText("-Firewall "..nround.."/5-")
				Codes:SetText("..Code:    "..encrypted)
				keytext:SetText("..Key:      "..key)
			end
		else
			nround = 1
			firstdig = math.random(1,9)
			secdig = math.random(1,9)
			thirdig = math.random(1,9)
			fourdig = math.random(1,9)
			key = math.random(2, 8)
			encrypted = firstdig..secdig..thirdig..fourdig
			firstdiga = firstdig + key
			if (firstdiga > 9) then
				firstdiga = firstdiga - 10
			end
			secdiga = secdig + key
			if (secdiga > 9) then
				secdiga = secdiga - 10
			end
			thirdiga = thirdig + key
			if (thirdiga > 9) then
				thirdiga = thirdiga - 10
			end
			fourdiga = fourdig + key
			if (fourdiga > 9) then
				fourdiga = fourdiga - 10
			end
			decrypted = firstdiga..secdiga..thirdiga..fourdiga
			Rounds:SetText("-Firewall "..nround.."/5-")
			Codes:SetText("..Code:    "..encrypted)
			keytext:SetText("..Key:      "..key)
		end
	end
	Cb:Hide()
	timer.Create("progressup", 1, 10, function()
		perc = perc + 10
		Testoperc:SetText("Powering up: "..perc.."%")
		if (timer.RepsLeft("progressup") == 0) then
			Testoperc:SetColor(Color(255, 255, 0))
			Testoperc:SetText("Successfully Powered up")
			function frame:Paint(w,h)
				surface.SetMaterial(materialff)
    			surface.SetDrawColor( 255, 255, 255, 150 )
				surface.DrawTexturedRect(0,0,w,h)
				surface.SetDrawColor(25,25,25,150)
				surface.DrawRect(105, 75, 170, 105)
				surface.SetDrawColor(50,50,50,150)
				surface.DrawRect(110, 80, 160, 95)
			end
			Codes:Show()
			Cc:Show()
			Cb:Show()
			keytext:Show()
			Rounds:Show()
			Codeshow:Show()
			B1:Show()
			B2:Show()
			B3:Show()
			B4:Show()
			B5:Show()
			B6:Show()
			B7:Show()
			B8:Show()
			B9:Show()
			B0:Show()
		end
	end)
	net.Receive("playerdied", function()
		timer.Remove("progressup")
		frame:Remove()
	end)
	function frame:OnRemove()
		timer.Remove("progressup")
	end
	net.Receive("playerdead", function()
		timer.Remove("progressup")
		frame:Remove()
	end)
end)
