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

function STRUCTMenuOpen()
    local STRUCTFrame = vgui.Create("DFrame")
    STRUCTFrame:SetSize(1200, 800)
    STRUCTFrame:SetPos(ScrW() / 2 - 600, ScrH() / 2 - 400)
    STRUCTFrame:SetTitle("")
    STRUCTFrame:SetBackgroundBlur(true)
    STRUCTFrame:ShowCloseButton(false)
	STRUCTFrame:SetDraggable( true )
    STRUCTFrame:SetVisible(true)
    STRUCTFrame:MakePopup()

    STRUCTFrame.Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(25, 122, 248, 255))
    end

    local CenterPanel = vgui.Create("DPanel", STRUCTFrame)
    CenterPanel:SetSize(STRUCTFrame:GetWide() - 20, STRUCTFrame:GetTall() - 50)
    CenterPanel:SetPos(10, 40)

    CenterPanel.Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(60, 60, 60, 255))
    end
	
    local header = vgui.Create("DLabel", STRUCTFrame)
    header:SetPos(STRUCTFrame:GetWide() / 3 - 0, 0)
    header:SetFont("RANKSTitle")
    header:SetText("Empire Command Structure")
    header:SizeToContents()
    header:SetTextColor(Color(255, 255, 255, 255))
	local imp_img = vgui.Create( "DImage", STRUCTFrame)
	imp_img:SetPos( 10,3 )
	imp_img:SetSize( 35, 35)
	imp_img:SetImage("materials/shared/implogo.png")
	
	local ig_img = vgui.Create( "DImageButton", STRUCTFrame)
	ig_img:SetPos( 945,735 )
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

local dbButton = vgui.Create("DButton", STRUCTFrame)
    dbButton:SetTextColor(Color(255, 255, 255))
    dbButton:SetText("IG Database Link")
    dbButton:SetFont("CloseCaption_Normal")
    dbButton:SetSize(180, 24)
    dbButton:SetPos(STRUCTFrame:GetWide() - 340, 10)

    dbButton.Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(60, 60, 60))
    end

    dbButton.DoClick = function()
	 gui.OpenURL("https://docs.google.com/spreadsheets/d/1uXcAv4Mggkl0VJPHZUSa8_ZhA8jXhE3s71ccw9Ln_Jo/edit#gid=1526107893")
end
	local CButton = vgui.Create("DButton", STRUCTFrame)
    CButton:SetTextColor(Color(255, 255, 255))
    CButton:SetText("X")
    CButton:SetFont("CloseCaption_Normal")
    CButton:SetSize(34, 24)
    CButton:SetPos(STRUCTFrame:GetWide() - 40, 3)

    CButton.Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(60, 60, 60))
    end

    CButton.DoClick = function()
        STRUCTFrame:Close()
    end
	
	local govpanel = vgui.Create("DPanel", STRUCTFrame)
    govpanel:SetSize(STRUCTFrame:GetWide() - 100, STRUCTFrame:GetTall() - 150)
    govpanel:SetPos(50, 60)

    govpanel.Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(120, 120, 120, 255))
		draw.RoundedBox(0, 540, 70, 5, 500, roleuser)
		draw.RoundedBox(0, 200, 27, 5, 100, roleuser)
		draw.RoundedBox(0, 200, 27, 200, 5, roleuser)
		
		draw.RoundedBox(15, 377, 27, 326, 56, roleuser)
		draw.RoundedBox(15, 380, 30, 320, 50, branch)
		
		draw.RoundedBox(15, 377, 137, 326, 56, roleuser)
		draw.RoundedBox(15, 380, 140, 320, 50, branch)
		
		draw.RoundedBox(15, 377, 337, 326, 56, roleuser)
		draw.RoundedBox(15, 380, 340, 320, 50, branch)
		
		draw.RoundedBox(15, 377, 567, 326, 56, roleuser)
		draw.RoundedBox(15, 380, 570, 320, 50, branch)
		
		draw.RoundedBox(0, 390, 210, 300, 50, rolecolor)
        draw.RoundedBox(0, 390, 260, 300, 50, roleuser)
        draw.RoundedBox(0, 390, 420, 300, 50, rolecolor)
        draw.RoundedBox(0, 390, 470, 300, 50, roleuser)
		draw.SimpleText(IGRANKS.govrank1, "RANKSBranch", 540, 240, branchtext, 1, 1)
		draw.SimpleText(IGRANKS.govname1, "RANKSBranch", 540, 290, branchtext, 1, 1)
		draw.SimpleText(IGRANKS.govrank2, "RANKSBranch", 540, 450, branchtext, 1, 1)
		draw.SimpleText(IGRANKS.govname2, "RANKSBranch", 540, 500, branchtext, 1, 1)
		draw.SimpleText("Regional Government", "RANKSBranch", 540, 40, branchtext, 1)
		draw.SimpleText("Regional Governors", "RANKSBranch", 540, 150, branchtext, 1)
		draw.SimpleText("Governors Office", "RANKSBranch", 540, 350, branchtext, 1)
		draw.SimpleText("Secretary Division", "RANKSBranch", 540, 580, branchtext, 1)
		draw.RoundedBox(0, 50, 110, 300, 50, rolecolor)
		draw.RoundedBox(0, 50, 140, 300, 50, rolecolor)
        draw.RoundedBox(0, 50, 190, 300, 50, roleuser)
		draw.SimpleText("Military Adjunct", "RANKSBranch", 195, 130, branchtext, 1, 1)
		draw.SimpleText(IGRANKS.tarkinadjutantrank, "RANKSBranch", 195, 170, branchtext, 1, 1)
		draw.SimpleText(IGRANKS.tarkinadjutantname, "RANKSBranch", 195, 220, branchtext, 1, 1)
    end
	
	local comppanel = vgui.Create("DPanel", STRUCTFrame)
    comppanel:SetSize(STRUCTFrame:GetWide() - 100, STRUCTFrame:GetTall() - 150)
    comppanel:SetPos(50, 60)

    comppanel.Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(120, 120, 120, 255))
		draw.RoundedBox(0, 0, 0, w, h, Color(120, 120, 120, 255))
		draw.RoundedBox(0, 200, 27, 5, 550, roleuser)
		draw.RoundedBox(0, 200, 27, 200, 5, roleuser)
		draw.RoundedBox(0, 680, 27, 40, 5, roleuser)
		draw.RoundedBox(0, 900, 60, 5, 220, roleuser)
		draw.RoundedBox(0, 720, 27, 5, 120, roleuser)
		draw.RoundedBox(0, 540, 147, 360, 5, roleuser)
		draw.RoundedBox(0, 540, 147, 5, 180, roleuser)
		draw.RoundedBox(0, 200, 27, 5, 550, roleuser)
		draw.RoundedBox(0, 200, 27, 200, 5, roleuser)
		draw.RoundedBox(15, 377, 7, 326, 56, roleuser)
		draw.RoundedBox(15, 380, 10, 320, 50, branch)
		draw.RoundedBox(15, 40, 567, 326, 56, roleuser)
		draw.RoundedBox(15, 43, 570, 320, 50, branch)
		draw.RoundedBox(15, 40, 37, 326, 56, roleuser)
		draw.RoundedBox(15, 43, 40, 320, 50, branch)
		draw.RoundedBox(15, 737, 57, 326, 56, roleuser)
		draw.RoundedBox(15, 740, 60, 320, 50, branch)
		draw.RoundedBox(15, 737, 177, 326, 56, roleuser)
		draw.RoundedBox(15, 740, 180, 320, 50, branch)
		draw.RoundedBox(15, 377, 177, 326, 56, roleuser)
		draw.RoundedBox(15, 380, 180, 320, 50, branch)
		draw.RoundedBox(0, 50, 130, 300, 50, rolecolor)
        draw.RoundedBox(0, 50, 180, 300, 50, roleuser)
		draw.RoundedBox(0, 50, 270, 300, 50, rolecolor)
        draw.RoundedBox(0, 50, 320, 300, 50, roleuser)
        draw.RoundedBox(0, 50, 410, 300, 50, rolecolor)
        draw.RoundedBox(0, 50, 460, 300, 50, roleuser)
		draw.SimpleText(IGRANKS.isbdirectorrank, "RANKSBranch", 200, 155, branchtext, 1, 1)
		draw.SimpleText(IGRANKS.isbdirectorname, "RANKSBranch", 200, 205, branchtext, 1, 1)
		draw.SimpleText(IGRANKS.isbrank1, "RANKSBranch", 200, 295, branchtext, 1, 1)
		draw.SimpleText(IGRANKS.isbname1, "RANKSBranch", 200, 345, branchtext, 1, 1)
		draw.SimpleText(IGRANKS.isbrank2, "RANKSBranch", 200, 435, branchtext, 1, 1)
		draw.SimpleText(IGRANKS.isbname2, "RANKSBranch", 200, 485, branchtext, 1, 1)
		--draw.RoundedBox(0, 50, 220, 300, 50, rolecolor)
        --draw.RoundedBox(0, 50, 270, 300, 50, roleuser)
		--draw.SimpleText(IGRANKS.isbadmiralrank, "RANKSBranch", 200, 245, branchtext, 1, 1)
		--draw.SimpleText(IGRANKS.isbadmiralname, "RANKSBranch", 200, 295, branchtext, 1, 1)
		draw.RoundedBox(0, 390, 270, 300, 50, rolecolor)
        draw.RoundedBox(0, 390, 320, 300, 50, roleuser)
		draw.SimpleText(IGRANKS.cfprank, "RANKSBranch", 540, 295, branchtext, 1, 1)
		draw.SimpleText(IGRANKS.cfpname, "RANKSBranch", 540, 345, branchtext, 1, 1)
		draw.RoundedBox(0, 750, 270, 300, 50, rolecolor)
        draw.RoundedBox(0, 750, 320, 300, 50, roleuser)
		draw.SimpleText(IGRANKS.cfrank, "RANKSBranch", 900, 295, branchtext, 1, 1)
		draw.SimpleText(IGRANKS.cfname, "RANKSBranch", 900, 345, branchtext, 1, 1)
		draw.SimpleText("COMPNOR", "RANKSBranch", 480, 20, branchtext)
		draw.SimpleText("Imperial Security Bureau", "RANKSBranch", 65, 50, branchtext)
		draw.SimpleText("Naval Intelligence Agency", "RANKSBranch", 765, 70, branchtext)
		draw.SimpleText("CompForce", "RANKSBranch", 840, 190, branchtext)
		draw.SimpleText("Coalition for Progress", "RANKSBranch", 420, 190, branchtext)
		draw.SimpleText("ISB Associated Regiments", "RANKSBranch", 60, 580, branchtext)
    end
	
	local armypanel = vgui.Create("DPanel", STRUCTFrame)
    armypanel:SetSize(STRUCTFrame:GetWide() - 100, STRUCTFrame:GetTall() - 150)
    armypanel:SetPos(50, 60)

    armypanel.Paint = function(self, w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(120, 120, 120, 255))
		draw.RoundedBox(0, 550, 70, 5, 170, roleuser)
		
		draw.RoundedBox(0, 215, 240, 5, 350, roleuser)
		draw.RoundedBox(0, 885, 240, 5, 350, roleuser)
		
		draw.RoundedBox(0, 215, 240, 670, 5, roleuser)
		draw.RoundedBox(0, 340, 460, 400, 5, roleuser)
		
		draw.RoundedBox(15, 377, 27, 326, 56, roleuser)
		draw.RoundedBox(15, 380, 30, 320, 50, branch)
		
		draw.RoundedBox(15, 57, 567, 326, 56, roleuser)
		draw.RoundedBox(15, 60, 570, 320, 50, branch)
		
		draw.RoundedBox(15, 717, 567, 326, 56, roleuser)
		draw.RoundedBox(15, 720, 570, 320, 50, branch)
		
		draw.RoundedBox(0, 400, 110, 300, 50, rolecolor)
        draw.RoundedBox(0, 400, 160, 300, 50, roleuser)
		
        draw.RoundedBox(0, 70, 260, 300, 50, rolecolor)
        draw.RoundedBox(0, 70, 310, 300, 50, roleuser)
		
        draw.RoundedBox(0, 70, 410, 300, 50, rolecolor)
        draw.RoundedBox(0, 70, 460, 300, 50, roleuser)
		
		draw.RoundedBox(0, 400, 410, 300, 50, rolecolor)
        draw.RoundedBox(0, 400, 460, 300, 50, roleuser)
		
        draw.RoundedBox(0, 730, 260, 300, 50, rolecolor)
        draw.RoundedBox(0, 730, 310, 300, 50, roleuser)
		
        draw.RoundedBox(0, 730, 410, 300, 50, rolecolor)
        draw.RoundedBox(0, 730, 460, 300, 50, roleuser)
		
		draw.SimpleText(IGRANKS.general1rank, "RANKSBranch", 550, 120, branchtext, 1)
		draw.SimpleText(IGRANKS.general1name, "RANKSBranch", 550, 180, branchtext, 1, 1)
		draw.SimpleText(IGRANKS.general3rank, "RANKSBranch", 215, 270, branchtext, 1)
		draw.SimpleText(IGRANKS.general3name, "RANKSBranch", 215, 330, branchtext, 1, 1)
		draw.SimpleText(IGRANKS.general5rank, "RANKSBranch", 215, 420, branchtext, 1)
		draw.SimpleText(IGRANKS.general5name, "RANKSBranch", 215, 480, branchtext, 1, 1)
		draw.SimpleText(IGRANKS.general2rank, "RANKSBranch", 550, 420, branchtext, 1)
		draw.SimpleText(IGRANKS.general2name, "RANKSBranch", 550, 480, branchtext, 1, 1)
		draw.SimpleText(IGRANKS.general4rank, "RANKSBranch", 885, 270, branchtext, 1)
		draw.SimpleText(IGRANKS.general4name, "RANKSBranch", 885, 330, branchtext, 1, 1)
		draw.SimpleText(IGRANKS.general6rank, "RANKSBranch", 885, 420, branchtext, 1)
		draw.SimpleText(IGRANKS.general6name, "RANKSBranch", 885, 480, branchtext, 1, 1)
		draw.SimpleText("Imperial Army Command", "RANKSBranch", 400, 40, branchtext)
		draw.SimpleText("501st & 275th Legions", "RANKSBranch", 215, 580, branchtext, 1)
		draw.SimpleText("439th & 107th Legions", "RANKSBranch", 885, 580, branchtext, 1)
    end
	
	local navypanel = vgui.Create("DPanel", STRUCTFrame)
    navypanel:SetSize(STRUCTFrame:GetWide() - 100, STRUCTFrame:GetTall() - 150)
    navypanel:SetPos(50, 60)

    navypanel.Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(120, 120, 120, 255))
		draw.RoundedBox(0, 540, 70, 5, 500, roleuser)
		draw.RoundedBox(15, 377, 27, 326, 56, roleuser)
		draw.RoundedBox(15, 380, 30, 320, 50, branch)
		draw.RoundedBox(15, 377, 567, 326, 56, roleuser)
		draw.RoundedBox(15, 380, 570, 320, 50, branch)
		draw.RoundedBox(0, 390, 120, 300, 50, rolecolor)
        draw.RoundedBox(0, 390, 170, 300, 50, roleuser)
        draw.RoundedBox(0, 390, 270, 300, 50, rolecolor)
        draw.RoundedBox(0, 390, 320, 300, 50, roleuser)
		--draw.RoundedBox(0, 390, 420, 300, 50, rolecolor)
        --draw.RoundedBox(0, 390, 470, 300, 50, roleuser)
		draw.SimpleText(IGRANKS.navy1rank, "RANKSBranch", 540, 130, branchtext, 1)
		draw.SimpleText(IGRANKS.navy1name, "RANKSBranch", 540, 195, branchtext, 1, 1)
		draw.SimpleText(IGRANKS.navy2rank, "RANKSBranch", 540, 280, branchtext, 1)
		draw.SimpleText(IGRANKS.navy2name, "RANKSBranch", 540, 345, branchtext, 1, 1)
		--draw.SimpleText(IGRANKS.navy3rank, "RANKSBranch", 540, 430, branchtext, 1)
		--draw.SimpleText(IGRANKS.navy3name, "RANKSBranch", 540, 495, branchtext, 1, 1)
		draw.SimpleText("Imperial Navy Command", "RANKSBranch", 400, 40, branchtext)
		draw.SimpleText("Navy Associated Regiments", "RANKSBranch", 390, 580, branchtext)
    end
	
	local snrpanel = vgui.Create("DPanel", STRUCTFrame)
    snrpanel:SetSize(STRUCTFrame:GetWide() - 100, STRUCTFrame:GetTall() - 150)
    snrpanel:SetPos(50, 60)

    snrpanel.Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(120, 120, 120, 255))
		draw.RoundedBox(0, 540, 70, 5, 330, roleuser)
		draw.RoundedBox(0, 300, 65, 600, 5, roleuser)
		draw.RoundedBox(0, 350, 65, 5, 60, roleuser)
		draw.RoundedBox(0, 150, 120, 5, 200, roleuser)
		draw.RoundedBox(0, 940, 65, 5, 250, roleuser)
		draw.RoundedBox(0, 150, 120, 200, 5, roleuser)
		draw.RoundedBox(0, 140, 400, 820, 5, roleuser)
		draw.RoundedBox(0, 140, 400, 5, 200, roleuser)
		draw.RoundedBox(0, 410, 400, 5, 200, roleuser)
		draw.RoundedBox(0, 680, 400, 5, 200, roleuser)
		draw.RoundedBox(0, 955, 400, 5, 200, roleuser)
		draw.RoundedBox(0, 275, 340, 550, 50, Color(25, 122, 248))
		draw.SimpleText("Imperial High Command / Regional Government", "RANKSBranch", 550, 350, roleuser, 1)
		draw.RoundedBox(0, 390, 15, 300, 50, rolecolor)
        draw.RoundedBox(0, 390, 65, 300, 50, roleuser)
		draw.SimpleText("Galactic Emperor", "RANKSBranch", 540, 30, branchtext, 1)
		draw.SimpleText("Sheev Palpatine", "RANKSBranch", 540, 90, branchtext, 1, 1)
		
		draw.RoundedBox(15, 42, 147, 226, 46, roleuser)
		draw.RoundedBox(15, 45, 150, 220, 40, branch)
		draw.SimpleText("Imperial Guard", "RANKSMain", 100, 160, branchtext)
		draw.RoundedBox(15, 42, 297, 226, 46, roleuser)
		draw.RoundedBox(15, 45, 300, 220, 40, branch)
		draw.SimpleText("Imperial Guard Division", "RANKSMain", 70, 310, branchtext)
		
		draw.RoundedBox(0, 10, 30, 300, 40, rolecolor)
        draw.RoundedBox(0, 10, 70, 300, 40, roleuser)
		draw.SimpleText(IGRANKS.counselorrank, "RANKSBranch", 150, 40, branchtext, 1)
		draw.SimpleText(IGRANKS.counselorname, "RANKSBranch", 150, 90, branchtext, 1, 1)
		
		draw.RoundedBox(0, 10, 200, 300, 40, rolecolor)
        draw.RoundedBox(0, 10, 240, 300, 40, roleuser)
		draw.SimpleText(IGRANKS.sovprotrank, "RANKSBranch", 160, 210, branchtext, 1)
		draw.SimpleText(IGRANKS.sovprotname, "RANKSBranch", 160, 260, branchtext, 1, 1)
		
		draw.RoundedBox(0, 790, 110, 300, 40, rolecolor)
        draw.RoundedBox(0, 790, 150, 300, 40, roleuser)
		draw.SimpleText("Imperial Enforcer", "RANKSBranch", 940, 120, branchtext, 1)
		draw.SimpleText("Darth Vader", "RANKSBranch", 940, 170, branchtext, 1, 1)
		
		draw.RoundedBox(0, 790, 200, 300, 40, rolecolor)
        draw.RoundedBox(0, 790, 240, 300, 40, roleuser)
		draw.SimpleText("Inquisitorius Head", "RANKSBranch", 940, 210, branchtext, 1)
		draw.SimpleText("Grand Inquisitor", "RANKSBranch", 940, 260, branchtext, 1, 1)
		
		draw.RoundedBox(15, 832, 47, 226, 46, roleuser)
		draw.RoundedBox(15, 835, 50, 220, 40, branch)
		draw.SimpleText("Imperial Inquisitorius", "RANKSMain", 870, 60, branchtext)
		draw.RoundedBox(15, 832, 297, 226, 46, roleuser)
		draw.RoundedBox(15, 835, 300, 220, 40, branch)
		draw.SimpleText("Inquisitorius Regiments", "RANKSMain", 860, 310, branchtext)
		
		draw.RoundedBox(0, 30, 425, 220, 50, rolecolor)
        draw.RoundedBox(0, 30, 475, 220, 50, roleuser)
		draw.SimpleText(IGRANKS.grandadmiralrank, "RANKSBranch", 140, 440, branchtext, 1)
		draw.SimpleText(IGRANKS.grandadmiralname, "RANKSBranch", 140, 500, branchtext, 1, 1)
		
		draw.RoundedBox(0, 300, 425, 220, 50, rolecolor)
        draw.RoundedBox(0, 300, 475, 220, 50, roleuser)
		draw.SimpleText(IGRANKS.grandmoffrank, "RANKSBranch", 410, 440, branchtext, 1)
		draw.SimpleText(IGRANKS.grandmoffname, "RANKSBranch", 410, 500, branchtext, 1, 1)
		
		draw.RoundedBox(0, 575, 425, 220, 50, rolecolor)
        draw.RoundedBox(0, 575, 475, 220, 50, roleuser)
		draw.SimpleText(IGRANKS.compnordirectorrank, "RANKSBranch", 685, 440, branchtext, 1)
		draw.SimpleText(IGRANKS.compnordirectorname, "RANKSBranch", 685, 500, branchtext, 1, 1)
		
		draw.RoundedBox(0, 845, 425, 220, 50, rolecolor)
        draw.RoundedBox(0, 845, 475, 220, 50, roleuser)
		draw.SimpleText(IGRANKS.grandgeneralrank, "RANKSBranch", 955, 440, branchtext, 1)
		draw.SimpleText(IGRANKS.grandgeneralname, "RANKSBranch", 955, 500, branchtext, 1, 1)
		
		draw.RoundedBox(15, 22, 567, 226, 56, roleuser)
		draw.RoundedBox(15, 25, 570, 220, 50, branch)
		draw.SimpleText("Imperial Navy Command", "RANKSMain", 40, 585, branchtext)
		draw.RoundedBox(15, 297, 567, 226, 56, roleuser)
		draw.RoundedBox(15, 300, 570, 220, 50, branch)
		draw.SimpleText("Regional Government", "RANKSMain", 330, 585, branchtext)
		draw.RoundedBox(15, 572, 567, 226, 56, roleuser)
		draw.RoundedBox(15, 575, 570, 220, 50, branch)
		draw.SimpleText("COMPNOR", "RANKSMain", 645, 585, branchtext)
		draw.RoundedBox(15, 847, 567, 226, 56, roleuser)
		draw.RoundedBox(15, 850, 570, 220, 50, branch)
		draw.SimpleText("Imperial Army Command", "RANKSMain", 865, 585, branchtext)
    end
	
	
   local CMDButton1 = vgui.Create("DButton", STRUCTFrame)
    CMDButton1:SetText("Senior Command")
	CMDButton1:SetTextColor(Color(255, 255, 255))
    CMDButton1:SetSize(160, 50)
    CMDButton1:SetFont("RANKSMain")
    CMDButton1:SetPos(25, 735)

    CMDButton1.Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(100, 100, 100, 170))
		if CMDButton1:IsHovered() then
        draw.RoundedBox(0, 0, 0, w, h, Color(160, 160, 160, 170))
		if CMDButton1:IsDown() then
		draw.RoundedBox(0, 0, 0, w, h, Color(0, 140, 0, 170))
    end
	end
    end

    CMDButton1.DoClick = function()
	snrpanel:MoveToFront()
    end
	
	local CMDButton2 = vgui.Create("DButton", STRUCTFrame)
    CMDButton2:SetText("Navy Command")
	CMDButton2:SetTextColor(Color(255, 255, 255))
    CMDButton2:SetSize(160, 50)
    CMDButton2:SetFont("RANKSMain")
    CMDButton2:SetPos(200, 735)

    CMDButton2.Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(100, 100, 100, 170))
		if CMDButton2:IsHovered() then
        draw.RoundedBox(0, 0, 0, w, h, Color(160, 160, 160, 170))
		if CMDButton2:IsDown() then
		draw.RoundedBox(0, 0, 0, w, h, Color(0, 140, 0, 170))
    end
	end
    end

    CMDButton2.DoClick = function()
	navypanel:MoveToFront()
    end
	
	local CMDButton3 = vgui.Create("DButton", STRUCTFrame)
    CMDButton3:SetText("Army Command")
	CMDButton3:SetTextColor(Color(255, 255, 255))
    CMDButton3:SetSize(160, 50)
    CMDButton3:SetFont("RANKSMain")
    CMDButton3:SetPos(375, 735)

    CMDButton3.Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(100, 100, 100, 170))
		if CMDButton3:IsHovered() then
        draw.RoundedBox(0, 0, 0, w, h, Color(160, 160, 160, 170))
		if CMDButton3:IsDown() then
		draw.RoundedBox(0, 0, 0, w, h, Color(0, 140, 0, 170))
    end
	end
    end

    CMDButton3.DoClick = function()
	armypanel:MoveToFront()
	end
	
	local CMDButton4 = vgui.Create("DButton", STRUCTFrame)
    CMDButton4:SetText("COMPNOR")
	CMDButton4:SetTextColor(Color(255, 255, 255))
    CMDButton4:SetSize(160, 50)
    CMDButton4:SetFont("RANKSMain")
    CMDButton4:SetPos(550, 735)

    CMDButton4.Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(100, 100, 100, 170))
		if CMDButton4:IsHovered() then
        draw.RoundedBox(0, 0, 0, w, h, Color(160, 160, 160, 170))
		if CMDButton4:IsDown() then
		draw.RoundedBox(0, 0, 0, w, h, Color(0, 140, 0, 170))
    end
	end
    end

    CMDButton4.DoClick = function()
	comppanel:MoveToFront()
    end
	
	local CMDButton5 = vgui.Create("DButton", STRUCTFrame)
    CMDButton5:SetText("Regional Government")
	CMDButton5:SetTextColor(Color(255, 255, 255))
    CMDButton5:SetSize(200, 50)
    CMDButton5:SetFont("RANKSMain")
    CMDButton5:SetPos(725, 735)

    CMDButton5.Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(100, 100, 100, 170))
		if CMDButton5:IsHovered() then
        draw.RoundedBox(0, 0, 0, w, h, Color(160, 160, 160, 170))
		if CMDButton5:IsDown() then
		draw.RoundedBox(0, 0, 0, w, h, Color(0, 140, 0, 170))
    end
	end
	end
	


    CMDButton5.DoClick = function()
	govpanel:MoveToFront()
    end
	
    local STRUCTButton1 = vgui.Create("DButton", STRUCTFrame)
    STRUCTButton1:SetText("Admin Menu")
	STRUCTButton1:SetTextColor(Color(255, 255, 255))
    STRUCTButton1:SetSize(160, 50)
    STRUCTButton1:SetFont("RANKSMain")
    STRUCTButton1:SetPos(1015, 735)

    STRUCTButton1.Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(25, 122, 248, 170))
		if STRUCTButton1:IsHovered() then
        draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 255, 170))
		if STRUCTButton1:IsDown() then
		draw.RoundedBox(0, 0, 0, w, h, Color(0, 140, 0, 170))
    end
	end
    end

    STRUCTButton1.DoClick = function()
	if LocalPlayer():IsSuperAdmin() then
        RunConsoleCommand("rankmenuopen")
		else 
		chat.AddText("Permission Denied!")
    end

end
end

net.Receive("NETOSTRUCTMenu", STRUCTMenuOpen)