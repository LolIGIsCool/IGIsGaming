include("shared.lua")

surface.CreateFont("TextScreenFontScoreNumber", {
	font = "Arial",
	extended = false,
	size = 85,
	weight = 500,
	blursize = 0,
	antialias = true,
	outline = false,
})

surface.CreateFont("TextScreenFontScoreText", {
	font = "Arial",
	extended = false,
	size = 100,
	weight = 500,
	blursize = 0,
	antialias = true,
	outline = false,
})

local board = {
	first = "Twist's Regiment",
	firstcolor = Color(255, 255, 255),
	second = "Death Troopers",
	secondcolor = Color(255, 255, 255),
	third = "Dead Trooper",
	thirdcolor = Color(255, 255, 255),
}

net.Receive("igEliteScoreInitialize", function()
	board.first = net.ReadString()
	board.firstcolor = net.ReadTable()
	board.second = net.ReadString()
	board.secondcolor = net.ReadTable()
	board.third = net.ReadString()
	board.thirdcolor = net.ReadTable()
end)

function ENT:Initialize()
    self:SetMaterial("models/lordtrilobite/imp_metalwall2_mat")
    self:SetRenderMode(RENDERMODE_NORMAL)
end

function ENT:Draw()
	self:DrawModel()
	local pos = self:LocalToWorld(Vector(1.5, -0.5, 1.55))
	local ang = self:LocalToWorldAngles(Angle(0, 90, 0))

	cam.Start3D2D(pos, ang, 0.1)
		draw.RoundedBox(0, -470, 460, 900, -950, Color(255, 255, 255,0))

		draw.SimpleText("Elite Regiment", "TextScreenFontScoreText", 10, -400, Color(255,255,255),1,1)
		draw.SimpleText("Score Board", "TextScreenFontScoreText", 10, -300, Color(255,255,255) ,1,1)

		draw.SimpleText("1.", "TextScreenFontScoreText", -850, -120, Color(255,0,0) ,1,1)
		draw.SimpleText(board.first, "TextScreenFontScoreText", -800, -120, board.firstcolor ,3,1)

		draw.SimpleText("2.", "TextScreenFontScoreText", -850, 110, Color(255,0,0) ,1,1)
		draw.SimpleText(board.second, "TextScreenFontScoreText", -800, 110, board.secondcolor ,3,1)

		draw.SimpleText("3.", "TextScreenFontScoreText", -850, 350, Color(255,0,0) ,1,1)
		draw.SimpleText(board.third, "TextScreenFontScoreText", -800, 350, board.thirdcolor ,3,1)
	cam.End3D2D()
end

net.Receive("igEliteScore", function()

	local tempfirst = ""
	local tempfirstcolor = Color(255, 255, 255)
	local tempsecond = ""
	local tempsecondcolor = Color(255, 255, 255)
	local tempthird = ""
	local tempthirdcolor = Color(255, 255, 255)
	local regtable = net.ReadTable()


	local frame = vgui.Create("DFrame")
		frame:SetSize(420,480)
		frame:MakePopup()
		frame:Center()
		frame:SetTitle("Elite Regiment Scoreboard")

	local firstcombo = vgui.Create("DComboBox", frame)
		firstcombo:SetSize(250,40)
		firstcombo:SetPos(10,80)
		firstcombo:SetValue("Select First Place")
		for k, v in pairs(regtable) do
			firstcombo:AddChoice(v)
		end
		firstcombo.OnSelect = function(self, index, value)
			tempfirst = value
		end

	local firstcolor = vgui.Create( "DColorMixer", frame )
		firstcolor:SetSize( 100, 100 )
		firstcolor:SetPos(300, 50)
		firstcolor:SetPalette( false )
		firstcolor:SetAlphaBar( false ) 
		firstcolor:SetWangs( false )
		firstcolor:SetColor( Color( 255, 255, 255 ) )

	local secondcombo = vgui.Create("DComboBox", frame)
		secondcombo:SetSize(250,40)
		secondcombo:SetPos(10,200)
		secondcombo:SetValue("Select Second Place")
		for k, v in pairs(regtable) do
			secondcombo:AddChoice(v)
		end
		secondcombo.OnSelect = function(self, index, value)
			tempsecond = value
		end

	local secondcolor = vgui.Create( "DColorMixer", frame )
		secondcolor:SetSize( 100, 100 )
		secondcolor:SetPos(300, 175)
		secondcolor:SetPalette( false )
		secondcolor:SetAlphaBar( false ) 
		secondcolor:SetWangs( false )
		secondcolor:SetColor( Color( 255, 255, 255 ) )

	local thirdcombo = vgui.Create("DComboBox", frame)
		thirdcombo:SetSize(250,40)
		thirdcombo:SetPos(10,320)
		thirdcombo:SetValue("Select Third Place")
		for k, v in pairs(regtable) do
			thirdcombo:AddChoice(v)
		end
		thirdcombo.OnSelect = function(self, index, value)
			tempthird = value
		end

	local thirdcolor = vgui.Create( "DColorMixer", frame )
		thirdcolor:SetSize( 100, 100 )
		thirdcolor:SetPos(300, 300)
		thirdcolor:SetPalette( false )
		thirdcolor:SetAlphaBar( false ) 
		thirdcolor:SetWangs( false )
		thirdcolor:SetColor( Color( 255, 255, 255 ) )
		
	local confirm =	vgui.Create("DButton", frame)
		confirm:SetSize(250,30)
		confirm:SetPos(10,420)
		confirm:SetText("Confirm Placings")
		confirm.DoClick = function()
			if tempfirst == "" or tempsecond == "" or tempthird == "" then
				print("Put shit in fella")
			else
				net.Start("igEliteScoreData")
					net.WriteString(tempfirst)
					net.WriteTable(firstcolor:GetColor())
					net.WriteString(tempsecond)
					net.WriteTable(secondcolor:GetColor())
					net.WriteString(tempthird)
					net.WriteTable(thirdcolor:GetColor())
				net.SendToServer()
			end
		end
end)