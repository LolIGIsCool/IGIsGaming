AddCSLuaFile()

--Main Derma Panel--
--------------------
surface.CreateFont("epicfont", {
    font = "Roboto",
    size = 18,
    weight = 500,
    blursize = 0,
    scanlines = 0,
    antialias = true,
    underline = false,
    italic = false,
    strikeout = false,
    symbol = false,
    rotary = false,
    shadow = false,
    additive = false,
    outline = false
})

surface.CreateFont("RANKSTitle", {
    font = "Roboto",
    size = 40
})

surface.CreateFont("RANKSBranch", {
    font = "Roboto",
    size = 30
})

surface.CreateFont("RANKSMain", {
    font = "Roboto",
    size = 22
})

surface.CreateFont("RANKSMini", {
    font = "Roboto",
    size = 15
})

rolecolor = Color(255, 255, 0)
roleuser = Color(255, 255, 255)
branch = Color(180, 0, 0)
branchtext = Color(0, 0, 0)
--[[ this might fix it breaking  - untested
local IGNOTICES.notice1title = "contactstryker"
local IGNOTICES.notice1 = "contactstryker"
local IGNOTICES.notice12 = "contactstryker"
local IGNOTICES.notice13 = "contactstryker"
local IGNOTICES.notice14 = "contactstryker"
local IGNOTICES.notice2title = "contactstryker"
local IGNOTICES.notice2 = "contactstryker"
local IGNOTICES.notice22 = "contactstryker"
local IGNOTICES.notice23 = "contactstryker"
local IGNOTICES.notice24 = "contactstryker"
local IGNOTICES.notice3title = "contactstryker"
local IGNOTICES.notice3 = "contactstryker"
local IGNOTICES.notice32 = "contactstryker"
local IGNOTICES.notice33 = "contactstryker"
local IGNOTICES.notice34 = "contactstryker"
local IGNOTICES.notice4title = "contactstryker"
local IGNOTICES.notice4 = "contactstryker"
local IGNOTICES.notice42 = "contactstryker"
local IGNOTICES.notice43 = "contactstryker"
local IGNOTICES.notice44 = "contactstryker"
local IGNOTICES.notice5title = "contactstryker"
local IGNOTICES.notice5 = "contactstryker"
local IGNOTICES.notice52 = "contactstryker"
local IGNOTICES.notice53 = "contactstryker"
local IGNOTICES.notice54 = "contactstryker"
local IGNOTICES.notice6title = "contactstryker"
local IGNOTICES.notice6 = "contactstryker"
local IGNOTICES.notice62 = "contactstryker"
local IGNOTICES.notice63 = "contactstryker"
local IGNOTICES.notice64 = "contactstryker"
local IGNOTICES.notice7title = "contactstryker"
local IGNOTICES.notice7 = "contactstryker"
local IGNOTICES.notice72 = "contactstryker"
local IGNOTICES.notice73 = "contactstryker"
local IGNOTICES.notice74 = "contactstryker"
local IGNOTICES.notice8title = "contactstryker"
local IGNOTICES.notice8 = "contactstryker"
local IGNOTICES.notice82 = "contactstryker"
local IGNOTICES.notice83 = "contactstryker"
local IGNOTICES.notice84 = "contactstryker"
local IGNOTICES.notice9title = "contactstryker"
local IGNOTICES.notice9 = "contactstryker"
local IGNOTICES.notice92 = "contactstryker"
local IGNOTICES.notice93 = "contactstryker"
local IGNOTICES.notice94 = "contactstryker"
local IGNOTICES.notice10title = "contactstryker"
local IGNOTICES.notice10 = "contactstryker"
local IGNOTICES.notice102 = "contactstryker"
local IGNOTICES.notice103 = "contactstryker"
local IGNOTICES.notice104 = "contactstryker"
]]--
function NOTICEMenuOpen()
    local NOTICEFrame = vgui.Create("DFrame")
    NOTICEFrame:SetSize(1200, 800)
    NOTICEFrame:SetPos(ScrW() / 2 - 600, ScrH() / 2 - 400)
    NOTICEFrame:SetTitle("")
    NOTICEFrame:SetBackgroundBlur(true)
    NOTICEFrame:ShowCloseButton(false)
	NOTICEFrame:SetDraggable( true )
    NOTICEFrame:SetVisible(true)
    NOTICEFrame:MakePopup()

    NOTICEFrame.Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(25, 122, 248, 255))
    end

	local DScrollPanel = vgui.Create( "DScrollPanel", NOTICEFrame )
	DScrollPanel:SetSize( 1180, 750 )
	DScrollPanel:SetPos(10,40)
	
	local sbar = DScrollPanel:GetVBar()
	function sbar:Paint( w, h )
	draw.RoundedBox( 0, 0, 0, w, h, Color( 200, 0, 0 ) )
	end
	function sbar.btnUp:Paint( w, h )
	draw.RoundedBox( 0, 0, 0, w, h, Color( 255, 255, 255 ) )
	end
	function sbar.btnDown:Paint( w, h )
	draw.RoundedBox( 0, 0, 0, w, h, Color( 255, 255, 255 ) )
	end
	function sbar.btnGrip:Paint( w, h )
	draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 0, 100 ) )
	end

    local CenterPanel = vgui.Create("DPanel", DScrollPanel)
    CenterPanel:SetSize(1200, 1000)
	
    CenterPanel.Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(60, 60, 60, 255))
    end
	
    local header = vgui.Create("DLabel", NOTICEFrame)
    header:SetPos(NOTICEFrame:GetWide() / 3 - 0, 0)
    header:SetFont("RANKSTitle")
    header:SetText("Imperial Gaming Noticeboard")
    header:SizeToContents()
    header:SetTextColor(Color(255, 255, 255, 255))
	local imp_img = vgui.Create( "DImage", NOTICEFrame)
	imp_img:SetPos( 10,3 )
	imp_img:SetSize( 35, 35)
	imp_img:SetImage("materials/shared/implogo.png")
	
	local ig_img = vgui.Create( "DImageButton", CenterPanel)
	ig_img:SetPos( 0,0 )
	ig_img:SetSize( 50, 50)
	ig_img:SetImage("materials/shared/igicon.png")
	ig_img:SetColor(Color(255, 255, 255, 255))
	ig_img.Paint = function(self)
	ig_img:SetColor(Color(255, 255, 255, 255))
	if ig_img:IsHovered() then
        ig_img:SetColor(Color(25, 122, 248, 140))
		if ig_img:IsDown() then
		ig_img:SetColor(Color(0, 255, 0, 180))
    end
end
end
    ig_img.DoClick = function()
	 gui.OpenURL("https://imperialgamingau.invisionzone.com/")
end
	local CButton = vgui.Create("DButton", NOTICEFrame)
    CButton:SetTextColor(Color(255, 255, 255))
    CButton:SetText("X")
    CButton:SetFont("CloseCaption_Normal")
    CButton:SetSize(34, 24)
    CButton:SetPos(NOTICEFrame:GetWide() - 40, 3)

    CButton.Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(60, 60, 60))
    end

    CButton.DoClick = function()
        NOTICEFrame:Close()
    end
	
	local USEFULCHARS = vgui.Create("DTextEntry", CenterPanel)
    USEFULCHARS:SetPos(572, 300)
    USEFULCHARS:SetTall(360)
	USEFULCHARS:SetWide(28)
	USEFULCHARS:SetFont("RANKSMain")
    USEFULCHARS:SetText("• ☑ ☒ ♦ ♢ ☉ ⚐ ⛋ ⛉ ⛛ ⛨ ⦾ ⦿ ⁌  ⁍")
	USEFULCHARS:SetMultiline(true)

	local NOTICE1T = vgui.Create("DTextEntry", CenterPanel)
    NOTICE1T:SetPos(160, 180)
    NOTICE1T:SetTall(25)
	NOTICE1T:SetWide(220)
	NOTICE1T:SetFont("RANKSMain")
    NOTICE1T:SetText(IGNOTICES.notice1title)
	
	local disclaimer = vgui.Create("DLabel", CenterPanel)
    disclaimer:SetPos(200, 20)
    disclaimer:SetFont("RANKSTitle")
    disclaimer:SetText("[!!!] Read me [!!!]")
    disclaimer:SizeToContents()
    disclaimer:SetTextColor(Color(255, 0, 0, 255))
	
	local disclaimertext = vgui.Create("DLabel", CenterPanel)
    disclaimertext:SetPos(200, 60)
    disclaimertext:SetFont("RANKSMain")
    disclaimertext:SetText("• Useful Characters to help with text formatting located between the notices.\n• If you are editing a notice make sure you press [-ENTER-] to confirm the change and update it to the server.\n• Keep the text inside the text entry boxes if your text starts scrolling it won't fit!\n• READ THE 3 POINTS ABOVE!!!")
    disclaimertext:SizeToContents()
    disclaimertext:SetTextColor(Color(255, 255, 255, 255))
	
    NOTICE1T.OnEnter = function(self)
	notice1title1 = self:GetValue()
		if LocalPlayer():IsAdmin() then
        net.Start("networknoticeboard")
		net.WriteString("notice1title")
		net.WriteString(notice1title1)
        net.SendToServer()
		else 
		chat.AddText("Permission Denied!")
    end
    end
	local NOTICE1 = vgui.Create("DTextEntry", CenterPanel)
    NOTICE1:SetPos(40, 210)
    NOTICE1:SetTall(25)
	NOTICE1:SetWide(460)
	NOTICE1:SetFont("RANKSMain")
    NOTICE1:SetText(IGNOTICES.notice1)
	
	
    NOTICE1.OnEnter = function(self)
        notice11 = self:GetValue()
		if LocalPlayer():IsAdmin() then
        net.Start("networknoticeboard")
		net.WriteString("notice1")
		net.WriteString(notice11)
        net.SendToServer()
		else 
		chat.AddText("Permission Denied!")
    end
    end
	local NOTICE12 = vgui.Create("DTextEntry", CenterPanel)
    NOTICE12:SetPos(40, 240)
    NOTICE12:SetTall(25)
	NOTICE12:SetWide(460)
	NOTICE12:SetFont("RANKSMain")
    NOTICE12:SetText(IGNOTICES.notice12)
	
	
    NOTICE12.OnEnter = function(self)
        notice121 = self:GetValue()
		if LocalPlayer():IsAdmin() then
        net.Start("networknoticeboard")
		net.WriteString("notice12")
		net.WriteString(notice121)
        net.SendToServer()
		else 
		chat.AddText("Permission Denied!")
    end
    end
	local NOTICE13 = vgui.Create("DTextEntry", CenterPanel)
    NOTICE13:SetPos(40, 270)
    NOTICE13:SetTall(25)
	NOTICE13:SetWide(460)
	NOTICE13:SetFont("RANKSMain")
    NOTICE13:SetText(IGNOTICES.notice13)
	
	
    NOTICE13.OnEnter = function(self)
        notice131 = self:GetValue()
		if LocalPlayer():IsAdmin() then
        net.Start("networknoticeboard")
		net.WriteString("notice13")
		net.WriteString(notice131)
        net.SendToServer()
		else 
		chat.AddText("Permission Denied!")
    end
    end
	local NOTICE14 = vgui.Create("DTextEntry", CenterPanel)
    NOTICE14:SetPos(40, 300)
    NOTICE14:SetTall(25)
	NOTICE14:SetWide(460)
	NOTICE14:SetFont("RANKSMain")
    NOTICE14:SetText(IGNOTICES.notice14)
	
	
    NOTICE14.OnEnter = function(self)
        notice141 = self:GetValue()
		if LocalPlayer():IsAdmin() then
        net.Start("networknoticeboard")
		net.WriteString("notice14")
		net.WriteString(notice141)
        net.SendToServer()
		else 
		chat.AddText("Permission Denied!")
    end
    end
	
	local NOTICE2T = vgui.Create("DTextEntry", CenterPanel)
    NOTICE2T:SetPos(780, 180)
    NOTICE2T:SetTall(25)
	NOTICE2T:SetWide(220)
	NOTICE2T:SetFont("RANKSMain")
    NOTICE2T:SetText(IGNOTICES.notice2title)
	
	
    NOTICE2T.OnEnter = function(self)
	notice2title1 = self:GetValue()
		if LocalPlayer():IsAdmin() then
        net.Start("networknoticeboard")
		net.WriteString("notice2title")
		net.WriteString(notice2title1)
        net.SendToServer()
		else 
		chat.AddText("Permission Denied!")
    end
    end
	local NOTICE2 = vgui.Create("DTextEntry", CenterPanel)
    NOTICE2:SetPos(660, 210)
    NOTICE2:SetTall(25)
	NOTICE2:SetWide(460)
	NOTICE2:SetFont("RANKSMain")
    NOTICE2:SetText(IGNOTICES.notice2)
	
	
    NOTICE2.OnEnter = function(self)
        notice21 = self:GetValue()
		if LocalPlayer():IsAdmin() then
        net.Start("networknoticeboard")
		net.WriteString("notice2")
		net.WriteString(notice21)
        net.SendToServer()
		else 
		chat.AddText("Permission Denied!")
    end
    end
	local NOTICE22 = vgui.Create("DTextEntry", CenterPanel)
    NOTICE22:SetPos(660, 240)
    NOTICE22:SetTall(25)
	NOTICE22:SetWide(460)
	NOTICE22:SetFont("RANKSMain")
    NOTICE22:SetText(IGNOTICES.notice22)
	
	
    NOTICE22.OnEnter = function(self)
        notice221 = self:GetValue()
		if LocalPlayer():IsAdmin() then
        net.Start("networknoticeboard")
		net.WriteString("notice22")
		net.WriteString(notice221)
        net.SendToServer()
		else 
		chat.AddText("Permission Denied!")
    end
    end
	local NOTICE23 = vgui.Create("DTextEntry", CenterPanel)
    NOTICE23:SetPos(660, 270)
    NOTICE23:SetTall(25)
	NOTICE23:SetWide(460)
	NOTICE23:SetFont("RANKSMain")
    NOTICE23:SetText(IGNOTICES.notice23)
	
	
    NOTICE23.OnEnter = function(self)
        notice231 = self:GetValue()
		if LocalPlayer():IsAdmin() then
        net.Start("networknoticeboard")
		net.WriteString("notice23")
		net.WriteString(notice231)
        net.SendToServer()
		else 
		chat.AddText("Permission Denied!")
    end
    end
	local NOTICE24 = vgui.Create("DTextEntry", CenterPanel)
    NOTICE24:SetPos(660, 300)
    NOTICE24:SetTall(25)
	NOTICE24:SetWide(460)
	NOTICE24:SetFont("RANKSMain")
    NOTICE24:SetText(IGNOTICES.notice24)
	
	
    NOTICE24.OnEnter = function(self)
        notice241 = self:GetValue()
		if LocalPlayer():IsAdmin() then
        net.Start("networknoticeboard")
		net.WriteString("notice24")
		net.WriteString(notice241)
        net.SendToServer()
		else 
		chat.AddText("Permission Denied!")
    end
    end
	
	local NOTICE3T = vgui.Create("DTextEntry", CenterPanel)
    NOTICE3T:SetPos(160, 340)
    NOTICE3T:SetTall(25)
	NOTICE3T:SetWide(220)
	NOTICE3T:SetFont("RANKSMain")
    NOTICE3T:SetText(IGNOTICES.notice3title)
	
	
    NOTICE3T.OnEnter = function(self)
	notice3title1 = self:GetValue()
		if LocalPlayer():IsAdmin() then
        net.Start("networknoticeboard")
		net.WriteString("notice3title")
		net.WriteString(notice3title1)
        net.SendToServer()
		else 
		chat.AddText("Permission Denied!")
    end
    end
	local NOTICE3 = vgui.Create("DTextEntry", CenterPanel)
    NOTICE3:SetPos(40, 370)
    NOTICE3:SetTall(25)
	NOTICE3:SetWide(460)
	NOTICE3:SetFont("RANKSMain")
    NOTICE3:SetText(IGNOTICES.notice3)
	
	
    NOTICE3.OnEnter = function(self)
        notice31 = self:GetValue()
		if LocalPlayer():IsAdmin() then
        net.Start("networknoticeboard")
		net.WriteString("notice3")
		net.WriteString(notice31)
        net.SendToServer()
		else 
		chat.AddText("Permission Denied!")
    end
    end
	local NOTICE32 = vgui.Create("DTextEntry", CenterPanel)
    NOTICE32:SetPos(40, 400)
    NOTICE32:SetTall(25)
	NOTICE32:SetWide(460)
	NOTICE32:SetFont("RANKSMain")
    NOTICE32:SetText(IGNOTICES.notice32)
	
	
    NOTICE32.OnEnter = function(self)
        notice321 = self:GetValue()
		if LocalPlayer():IsAdmin() then
        net.Start("networknoticeboard")
		net.WriteString("notice32")
		net.WriteString(notice321)
        net.SendToServer()
		else 
		chat.AddText("Permission Denied!")
    end
    end
	local NOTICE33 = vgui.Create("DTextEntry", CenterPanel)
    NOTICE33:SetPos(40, 430)
    NOTICE33:SetTall(25)
	NOTICE33:SetWide(460)
	NOTICE33:SetFont("RANKSMain")
    NOTICE33:SetText(IGNOTICES.notice33)
	
	
    NOTICE33.OnEnter = function(self)
        notice331 = self:GetValue()
		if LocalPlayer():IsAdmin() then
        net.Start("networknoticeboard")
		net.WriteString("notice33")
		net.WriteString(notice331)
        net.SendToServer()
		else 
		chat.AddText("Permission Denied!")
    end
    end
	local NOTICE34 = vgui.Create("DTextEntry", CenterPanel)
    NOTICE34:SetPos(40, 460)
    NOTICE34:SetTall(25)
	NOTICE34:SetWide(460)
	NOTICE34:SetFont("RANKSMain")
    NOTICE34:SetText(IGNOTICES.notice34)
	
	
    NOTICE34.OnEnter = function(self)
        notice341 = self:GetValue()
		if LocalPlayer():IsAdmin() then
        net.Start("networknoticeboard")
		net.WriteString("notice34")
		net.WriteString(notice341)
        net.SendToServer()
		else 
		chat.AddText("Permission Denied!")
    end
    end
	
	local NOTICE4T = vgui.Create("DTextEntry", CenterPanel)
    NOTICE4T:SetPos(780, 340)
    NOTICE4T:SetTall(25)
	NOTICE4T:SetWide(220)
	NOTICE4T:SetFont("RANKSMain")
    NOTICE4T:SetText(IGNOTICES.notice4title)
	
	
    NOTICE4T.OnEnter = function(self)
	notice4title1 = self:GetValue()
		if LocalPlayer():IsAdmin() then
        net.Start("networknoticeboard")
		net.WriteString("notice4title")
		net.WriteString(notice4title1)
        net.SendToServer()
		else 
		chat.AddText("Permission Denied!")
    end
    end
	local NOTICE4 = vgui.Create("DTextEntry", CenterPanel)
    NOTICE4:SetPos(660, 370)
    NOTICE4:SetTall(25)
	NOTICE4:SetWide(460)
	NOTICE4:SetFont("RANKSMain")
    NOTICE4:SetText(IGNOTICES.notice4)
	
	
    NOTICE4.OnEnter = function(self)
        notice41 = self:GetValue()
		if LocalPlayer():IsAdmin() then
        net.Start("networknoticeboard")
		net.WriteString("notice4")
		net.WriteString(notice41)
        net.SendToServer()
		else 
		chat.AddText("Permission Denied!")
    end
    end
	local NOTICE42 = vgui.Create("DTextEntry", CenterPanel)
    NOTICE42:SetPos(660, 400)
    NOTICE42:SetTall(25)
	NOTICE42:SetWide(460)
	NOTICE42:SetFont("RANKSMain")
    NOTICE42:SetText(IGNOTICES.notice42)
	
	
    NOTICE42.OnEnter = function(self)
        notice421 = self:GetValue()
		if LocalPlayer():IsAdmin() then
        net.Start("networknoticeboard")
		net.WriteString("notice42")
		net.WriteString(notice421)
        net.SendToServer()
		else 
		chat.AddText("Permission Denied!")
    end
    end
	local NOTICE43 = vgui.Create("DTextEntry", CenterPanel)
    NOTICE43:SetPos(660, 430)
    NOTICE43:SetTall(25)
	NOTICE43:SetWide(460)
	NOTICE43:SetFont("RANKSMain")
    NOTICE43:SetText(IGNOTICES.notice43)
	
	
    NOTICE43.OnEnter = function(self)
        notice431 = self:GetValue()
		if LocalPlayer():IsAdmin() then
        net.Start("networknoticeboard")
		net.WriteString("notice43")
		net.WriteString(notice431)
        net.SendToServer()
		else 
		chat.AddText("Permission Denied!")
    end
    end
	local NOTICE44 = vgui.Create("DTextEntry", CenterPanel)
    NOTICE44:SetPos(660, 460)
    NOTICE44:SetTall(25)
	NOTICE44:SetWide(460)
	NOTICE44:SetFont("RANKSMain")
    NOTICE44:SetText(IGNOTICES.notice44)
	
	
    NOTICE44.OnEnter = function(self)
        notice441 = self:GetValue()
		if LocalPlayer():IsAdmin() then
        net.Start("networknoticeboard")
		net.WriteString("notice44")
		net.WriteString(notice441)
        net.SendToServer()
		else 
		chat.AddText("Permission Denied!")
    end
    end
	
	local NOTICE5T = vgui.Create("DTextEntry", CenterPanel)
    NOTICE5T:SetPos(160, 500)
    NOTICE5T:SetTall(25)
	NOTICE5T:SetWide(220)
	NOTICE5T:SetFont("RANKSMain")
    NOTICE5T:SetText(IGNOTICES.notice5title)
	
	
    NOTICE5T.OnEnter = function(self)
	notice5title1 = self:GetValue()
		if LocalPlayer():IsAdmin() then
        net.Start("networknoticeboard")
		net.WriteString("notice5title")
		net.WriteString(notice5title1)
        net.SendToServer()
		else 
		chat.AddText("Permission Denied!")
    end
    end
	local NOTICE5 = vgui.Create("DTextEntry", CenterPanel)
    NOTICE5:SetPos(40, 530)
    NOTICE5:SetTall(25)
	NOTICE5:SetWide(460)
	NOTICE5:SetFont("RANKSMain")
    NOTICE5:SetText(IGNOTICES.notice5)
	
	
    NOTICE5.OnEnter = function(self)
        notice51 = self:GetValue()
		if LocalPlayer():IsAdmin() then
        net.Start("networknoticeboard")
		net.WriteString("notice5")
		net.WriteString(notice51)
        net.SendToServer()
		else 
		chat.AddText("Permission Denied!")
    end
    end
	local NOTICE52 = vgui.Create("DTextEntry", CenterPanel)
    NOTICE52:SetPos(40, 560)
    NOTICE52:SetTall(25)
	NOTICE52:SetWide(460)
	NOTICE52:SetFont("RANKSMain")
    NOTICE52:SetText(IGNOTICES.notice52)
	
	
    NOTICE52.OnEnter = function(self)
        notice521 = self:GetValue()
		if LocalPlayer():IsAdmin() then
        net.Start("networknoticeboard")
		net.WriteString("notice52")
		net.WriteString(notice521)
        net.SendToServer()
		else 
		chat.AddText("Permission Denied!")
    end
    end
	local NOTICE53 = vgui.Create("DTextEntry", CenterPanel)
    NOTICE53:SetPos(40, 590)
    NOTICE53:SetTall(25)
	NOTICE53:SetWide(460)
	NOTICE53:SetFont("RANKSMain")
    NOTICE53:SetText(IGNOTICES.notice53)
	
	
    NOTICE53.OnEnter = function(self)
        notice531 = self:GetValue()
		if LocalPlayer():IsAdmin() then
        net.Start("networknoticeboard")
		net.WriteString("notice53")
		net.WriteString(notice531)
        net.SendToServer()
		else 
		chat.AddText("Permission Denied!")
    end
    end
	local NOTICE54 = vgui.Create("DTextEntry", CenterPanel)
    NOTICE54:SetPos(40, 620)
    NOTICE54:SetTall(25)
	NOTICE54:SetWide(460)
	NOTICE54:SetFont("RANKSMain")
    NOTICE54:SetText(IGNOTICES.notice54)
	
	
    NOTICE54.OnEnter = function(self)
        notice541 = self:GetValue()
		if LocalPlayer():IsAdmin() then
        net.Start("networknoticeboard")
		net.WriteString("notice54")
		net.WriteString(notice541)
        net.SendToServer()
		else 
		chat.AddText("Permission Denied!")
    end
    end
	
	local NOTICE6T = vgui.Create("DTextEntry", CenterPanel)
    NOTICE6T:SetPos(780, 500)
    NOTICE6T:SetTall(25)
	NOTICE6T:SetWide(220)
	NOTICE6T:SetFont("RANKSMain")
    NOTICE6T:SetText(IGNOTICES.notice6title)
	
	
    NOTICE6T.OnEnter = function(self)
	notice6title1 = self:GetValue()
		if LocalPlayer():IsAdmin() then
        net.Start("networknoticeboard")
		net.WriteString("notice6title")
		net.WriteString(notice6title1)
        net.SendToServer()
		else 
		chat.AddText("Permission Denied!")
    end
    end
	local NOTICE6 = vgui.Create("DTextEntry", CenterPanel)
    NOTICE6:SetPos(660, 530)
    NOTICE6:SetTall(25)
	NOTICE6:SetWide(460)
	NOTICE6:SetFont("RANKSMain")
    NOTICE6:SetText(IGNOTICES.notice6)
	
	
    NOTICE6.OnEnter = function(self)
        notice61 = self:GetValue()
		if LocalPlayer():IsAdmin() then
        net.Start("networknoticeboard")
		net.WriteString("notice6")
		net.WriteString(notice61)
        net.SendToServer()
		else 
		chat.AddText("Permission Denied!")
    end
    end
	local NOTICE62 = vgui.Create("DTextEntry", CenterPanel)
    NOTICE62:SetPos(660, 560)
    NOTICE62:SetTall(25)
	NOTICE62:SetWide(460)
	NOTICE62:SetFont("RANKSMain")
    NOTICE62:SetText(IGNOTICES.notice62)
	
	
    NOTICE62.OnEnter = function(self)
        notice621 = self:GetValue()
		if LocalPlayer():IsAdmin() then
        net.Start("networknoticeboard")
		net.WriteString("notice62")
		net.WriteString(notice621)
        net.SendToServer()
		else 
		chat.AddText("Permission Denied!")
    end
    end
	local NOTICE63 = vgui.Create("DTextEntry", CenterPanel)
    NOTICE63:SetPos(660, 590)
    NOTICE63:SetTall(25)
	NOTICE63:SetWide(460)
	NOTICE63:SetFont("RANKSMain")
    NOTICE63:SetText(IGNOTICES.notice63)
	
	
    NOTICE63.OnEnter = function(self)
        notice631 = self:GetValue()
		if LocalPlayer():IsAdmin() then
        net.Start("networknoticeboard")
		net.WriteString("notice63")
		net.WriteString(notice631)
        net.SendToServer()
		else 
		chat.AddText("Permission Denied!")
    end
    end
	local NOTICE64 = vgui.Create("DTextEntry", CenterPanel)
    NOTICE64:SetPos(660, 620)
    NOTICE64:SetTall(25)
	NOTICE64:SetWide(460)
	NOTICE64:SetFont("RANKSMain")
    NOTICE64:SetText(IGNOTICES.notice64)
	
	
    NOTICE64.OnEnter = function(self)
        notice641 = self:GetValue()
		if LocalPlayer():IsAdmin() then
        net.Start("networknoticeboard")
		net.WriteString("notice64")
		net.WriteString(notice641)
        net.SendToServer()
		else 
		chat.AddText("Permission Denied!")
    end
    end
	
	local NOTICE7T = vgui.Create("DTextEntry", CenterPanel)
    NOTICE7T:SetPos(160, 660)
    NOTICE7T:SetTall(25)
	NOTICE7T:SetWide(220)
	NOTICE7T:SetFont("RANKSMain")
    NOTICE7T:SetText(IGNOTICES.notice7title)
	
	
    NOTICE7T.OnEnter = function(self)
	notice7title1 = self:GetValue()
		if LocalPlayer():IsAdmin() then
        net.Start("networknoticeboard")
		net.WriteString("notice7title")
		net.WriteString(notice7title1)
        net.SendToServer()
		else 
		chat.AddText("Permission Denied!")
    end
    end
	local NOTICE7 = vgui.Create("DTextEntry", CenterPanel)
    NOTICE7:SetPos(40, 690)
    NOTICE7:SetTall(25)
	NOTICE7:SetWide(460)
	NOTICE7:SetFont("RANKSMain")
    NOTICE7:SetText(IGNOTICES.notice7)
	
	
    NOTICE7.OnEnter = function(self)
        notice71 = self:GetValue()
		if LocalPlayer():IsAdmin() then
        net.Start("networknoticeboard")
		net.WriteString("notice7")
		net.WriteString(notice71)
        net.SendToServer()
		else 
		chat.AddText("Permission Denied!")
    end
    end
	local NOTICE72 = vgui.Create("DTextEntry", CenterPanel)
    NOTICE72:SetPos(40, 720)
    NOTICE72:SetTall(25)
	NOTICE72:SetWide(460)
	NOTICE72:SetFont("RANKSMain")
    NOTICE72:SetText(IGNOTICES.notice72)
	
	
    NOTICE72.OnEnter = function(self)
        notice721 = self:GetValue()
		if LocalPlayer():IsAdmin() then
        net.Start("networknoticeboard")
		net.WriteString("notice72")
		net.WriteString(notice721)
        net.SendToServer()
		else 
		chat.AddText("Permission Denied!")
    end
    end
	local NOTICE73 = vgui.Create("DTextEntry", CenterPanel)
    NOTICE73:SetPos(40, 750)
    NOTICE73:SetTall(25)
	NOTICE73:SetWide(460)
	NOTICE73:SetFont("RANKSMain")
    NOTICE73:SetText(IGNOTICES.notice73)
	
	
    NOTICE73.OnEnter = function(self)
        notice731 = self:GetValue()
		if LocalPlayer():IsAdmin() then
        net.Start("networknoticeboard")
		net.WriteString("notice73")
		net.WriteString(notice731)
        net.SendToServer()
		else 
		chat.AddText("Permission Denied!")
    end
    end
	local NOTICE74 = vgui.Create("DTextEntry", CenterPanel)
    NOTICE74:SetPos(40, 780)
    NOTICE74:SetTall(25)
	NOTICE74:SetWide(460)
	NOTICE74:SetFont("RANKSMain")
    NOTICE74:SetText(IGNOTICES.notice74)
	
	
    NOTICE74.OnEnter = function(self)
        notice741 = self:GetValue()
		if LocalPlayer():IsAdmin() then
        net.Start("networknoticeboard")
		net.WriteString("notice74")
		net.WriteString(notice741)
        net.SendToServer()
		else 
		chat.AddText("Permission Denied!")
    end
    end
	
	local NOTICE8T = vgui.Create("DTextEntry", CenterPanel)
    NOTICE8T:SetPos(780, 660)
    NOTICE8T:SetTall(25)
	NOTICE8T:SetWide(220)
	NOTICE8T:SetFont("RANKSMain")
    NOTICE8T:SetText(IGNOTICES.notice8title)
	
	
    NOTICE8T.OnEnter = function(self)
	notice8title1 = self:GetValue()
		if LocalPlayer():IsAdmin() then
        net.Start("networknoticeboard")
		net.WriteString("notice8title")
		net.WriteString(notice8title1)
        net.SendToServer()
		else 
		chat.AddText("Permission Denied!")
    end
    end
	local NOTICE8 = vgui.Create("DTextEntry", CenterPanel)
    NOTICE8:SetPos(660, 690)
    NOTICE8:SetTall(25)
	NOTICE8:SetWide(460)
	NOTICE8:SetFont("RANKSMain")
    NOTICE8:SetText(IGNOTICES.notice8)
	
	
    NOTICE8.OnEnter = function(self)
        notice81 = self:GetValue()
		if LocalPlayer():IsAdmin() then
        net.Start("networknoticeboard")
		net.WriteString("notice8")
		net.WriteString(notice81)
        net.SendToServer()
		else 
		chat.AddText("Permission Denied!")
    end
    end
	local NOTICE82 = vgui.Create("DTextEntry", CenterPanel)
    NOTICE82:SetPos(660, 720)
    NOTICE82:SetTall(25)
	NOTICE82:SetWide(460)
	NOTICE82:SetFont("RANKSMain")
    NOTICE82:SetText(IGNOTICES.notice82)
	
	
    NOTICE82.OnEnter = function(self)
        notice821 = self:GetValue()
		if LocalPlayer():IsAdmin() then
        net.Start("networknoticeboard")
		net.WriteString("notice82")
		net.WriteString(notice821)
        net.SendToServer()
		else 
		chat.AddText("Permission Denied!")
    end
    end
	local NOTICE83 = vgui.Create("DTextEntry", CenterPanel)
    NOTICE83:SetPos(660, 750)
    NOTICE83:SetTall(25)
	NOTICE83:SetWide(460)
	NOTICE83:SetFont("RANKSMain")
    NOTICE83:SetText(IGNOTICES.notice83)
	
	
    NOTICE83.OnEnter = function(self)
        notice831 = self:GetValue()
		if LocalPlayer():IsAdmin() then
        net.Start("networknoticeboard")
		net.WriteString("notice83")
		net.WriteString(notice831)
        net.SendToServer()
		else 
		chat.AddText("Permission Denied!")
    end
    end
	local NOTICE84 = vgui.Create("DTextEntry", CenterPanel)
    NOTICE84:SetPos(660, 780)
    NOTICE84:SetTall(25)
	NOTICE84:SetWide(460)
	NOTICE84:SetFont("RANKSMain")
    NOTICE84:SetText(IGNOTICES.notice84)
	
	
    NOTICE84.OnEnter = function(self)
        notice841 = self:GetValue()
		if LocalPlayer():IsAdmin() then
        net.Start("networknoticeboard")
		net.WriteString("notice84")
		net.WriteString(notice841)
        net.SendToServer()
		else 
		chat.AddText("Permission Denied!")
    end
    end
	
	local NOTICE9T = vgui.Create("DTextEntry", CenterPanel)
    NOTICE9T:SetPos(160, 820)
    NOTICE9T:SetTall(25)
	NOTICE9T:SetWide(220)
	NOTICE9T:SetFont("RANKSMain")
    NOTICE9T:SetText(IGNOTICES.notice9title)
	
	
    NOTICE9T.OnEnter = function(self)
	notice9title1 = self:GetValue()
		if LocalPlayer():IsAdmin() then
        net.Start("networknoticeboard")
		net.WriteString("notice9title")
		net.WriteString(notice9title1)
        net.SendToServer()
		else 
		chat.AddText("Permission Denied!")
    end
    end
	local NOTICE9 = vgui.Create("DTextEntry", CenterPanel)
    NOTICE9:SetPos(40, 850)
    NOTICE9:SetTall(25)
	NOTICE9:SetWide(460)
	NOTICE9:SetFont("RANKSMain")
    NOTICE9:SetText(IGNOTICES.notice9)
	
	
    NOTICE9.OnEnter = function(self)
        notice91 = self:GetValue()
		if LocalPlayer():IsAdmin() then
        net.Start("networknoticeboard")
		net.WriteString("notice9")
		net.WriteString(notice91)
        net.SendToServer()
		else 
		chat.AddText("Permission Denied!")
    end
    end
	local NOTICE92 = vgui.Create("DTextEntry", CenterPanel)
    NOTICE92:SetPos(40, 880)
    NOTICE92:SetTall(25)
	NOTICE92:SetWide(460)
	NOTICE92:SetFont("RANKSMain")
    NOTICE92:SetText(IGNOTICES.notice92)
	
	
    NOTICE92.OnEnter = function(self)
        notice921 = self:GetValue()
		if LocalPlayer():IsAdmin() then
        net.Start("networknoticeboard")
		net.WriteString("notice92")
		net.WriteString(notice921)
        net.SendToServer()
		else 
		chat.AddText("Permission Denied!")
    end
    end
	local NOTICE93 = vgui.Create("DTextEntry", CenterPanel)
    NOTICE93:SetPos(40, 910)
    NOTICE93:SetTall(25)
	NOTICE93:SetWide(460)
	NOTICE93:SetFont("RANKSMain")
    NOTICE93:SetText(IGNOTICES.notice93)
	
	
    NOTICE93.OnEnter = function(self)
        notice931 = self:GetValue()
		if LocalPlayer():IsAdmin() then
        net.Start("networknoticeboard")
		net.WriteString("notice93")
		net.WriteString(notice931)
        net.SendToServer()
		else 
		chat.AddText("Permission Denied!")
    end
    end
	local NOTICE94 = vgui.Create("DTextEntry", CenterPanel)
    NOTICE94:SetPos(40, 940)
    NOTICE94:SetTall(25)
	NOTICE94:SetWide(460)
	NOTICE94:SetFont("RANKSMain")
    NOTICE94:SetText(IGNOTICES.notice94)
	
	
    NOTICE94.OnEnter = function(self)
        notice941 = self:GetValue()
		if LocalPlayer():IsAdmin() then
        net.Start("networknoticeboard")
		net.WriteString("notice94")
		net.WriteString(notice941)
        net.SendToServer()
		else 
		chat.AddText("Permission Denied!")
    end
    end
	
	local NOTICE10T = vgui.Create("DTextEntry", CenterPanel)
    NOTICE10T:SetPos(780, 820)
    NOTICE10T:SetTall(25)
	NOTICE10T:SetWide(220)
	NOTICE10T:SetFont("RANKSMain")
    NOTICE10T:SetText(IGNOTICES.notice10title)
	
	
    NOTICE10T.OnEnter = function(self)
	notice10title1 = self:GetValue()
		if LocalPlayer():IsAdmin() then
        net.Start("networknoticeboard")
		net.WriteString("notice10title")
		net.WriteString(notice10title1)
        net.SendToServer()
		else 
		chat.AddText("Permission Denied!")
    end
    end
	local NOTICE10 = vgui.Create("DTextEntry", CenterPanel)
    NOTICE10:SetPos(660, 850)
    NOTICE10:SetTall(25)
	NOTICE10:SetWide(460)
	NOTICE10:SetFont("RANKSMain")
    NOTICE10:SetText(IGNOTICES.notice10)
	
	
    NOTICE10.OnEnter = function(self)
        notice101 = self:GetValue()
		if LocalPlayer():IsAdmin() then
        net.Start("networknoticeboard")
		net.WriteString("notice10")
		net.WriteString(notice101)
        net.SendToServer()
		else 
		chat.AddText("Permission Denied!")
    end
    end
	local NOTICE102 = vgui.Create("DTextEntry", CenterPanel)
    NOTICE102:SetPos(660, 880)
    NOTICE102:SetTall(25)
	NOTICE102:SetWide(460)
	NOTICE102:SetFont("RANKSMain")
    NOTICE102:SetText(IGNOTICES.notice102)
	
	
    NOTICE102.OnEnter = function(self)
        notice1021 = self:GetValue()
		if LocalPlayer():IsAdmin() then
        net.Start("networknoticeboard")
		net.WriteString("notice102")
		net.WriteString(notice1021)
        net.SendToServer()
		else 
		chat.AddText("Permission Denied!")
    end
    end
	local NOTICE103 = vgui.Create("DTextEntry", CenterPanel)
    NOTICE103:SetPos(660, 910)
    NOTICE103:SetTall(25)
	NOTICE103:SetWide(460)
	NOTICE103:SetFont("RANKSMain")
    NOTICE103:SetText(IGNOTICES.notice103)
	
	
    NOTICE103.OnEnter = function(self)
        notice1031 = self:GetValue()
		if LocalPlayer():IsAdmin() then
        net.Start("networknoticeboard")
		net.WriteString("notice103")
		net.WriteString(notice1031)
        net.SendToServer()
		else 
		chat.AddText("Permission Denied!")
    end
    end
	local NOTICE104 = vgui.Create("DTextEntry", CenterPanel)
    NOTICE104:SetPos(660, 940)
    NOTICE104:SetTall(25)
	NOTICE104:SetWide(460)
	NOTICE104:SetFont("RANKSMain")
    NOTICE104:SetText(IGNOTICES.notice104)
	
	
    NOTICE104.OnEnter = function(self)
        notice1041 = self:GetValue()
		if LocalPlayer():IsAdmin() then
        net.Start("networknoticeboard")
		net.WriteString("notice104")
		net.WriteString(notice1041)
        net.SendToServer()
		else 
		chat.AddText("Permission Denied!")
    end
    end
	--[[
    local NOTICEButton1 = vgui.Create("DButton", CenterPanel)
    NOTICEButton1:SetText("Notice 1 Apply")
	NOTICEButton1:SetTextColor(Color(255, 255, 255))
    NOTICEButton1:SetSize(160, 50)
    NOTICEButton1:SetFont("RANKSMain")
    NOTICEButton1:SetPos(1015, 735)

    NOTICEButton1.Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(25, 122, 248, 170))
		if NOTICEButton1:IsHovered() then
        draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 255, 170))
		if NOTICEButton1:IsDown() then
		draw.RoundedBox(0, 0, 0, w, h, Color(0, 140, 0, 170))
    end
	end
    end

    NOTICEButton1.DoClick = function()
	if LocalPlayer():IsAdmin() then
        net.Start("networknoticeboard")
		net.WriteString("notice1title")
		net.WriteString(notice1title1)
		net.WriteString("notice1")
        net.WriteString(notice11)
		net.WriteString("notice12")
		net.WriteString(notice121)
		net.WriteString("notice13")
		net.WriteString(notice131)
		net.WriteString("notice14")
		net.WriteString(notice141)
        net.SendToServer()
		else 
		chat.AddText("Permission Denied!")
    end]]--

end
--end

net.Receive("NETONOTICEMenu", NOTICEMenuOpen)