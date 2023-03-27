AddCSLuaFile()

list.Set( "DesktopWindows", "igmenulibrary", {

	icon = "materials/shared/igmenuicon.png",
	title = "IG Menu Library",
	init = function( icon, window )
		window:Close()
		RunConsoleCommand("igmenulibrary")
	end
}  )

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

function LIBRARYMenuOpen()
    local LIBRARYFrame = vgui.Create("DFrame")
    LIBRARYFrame:SetSize(600, 500)
    LIBRARYFrame:SetPos(ScrW() / 2 - 300, ScrH() / 2 - 200)
    LIBRARYFrame:SetTitle("")
    LIBRARYFrame:SetBackgroundBlur(true)
    LIBRARYFrame:ShowCloseButton(false)
	LIBRARYFrame:SetDraggable( true )
    LIBRARYFrame:SetVisible(true)
    LIBRARYFrame:MakePopup()

    LIBRARYFrame.Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(25, 122, 248, 255))
    end

    local CenterPanel = vgui.Create("DPanel", LIBRARYFrame)
    CenterPanel:SetSize(LIBRARYFrame:GetWide() - 20, LIBRARYFrame:GetTall() - 50)
    CenterPanel:SetPos(10, 40)

    CenterPanel.Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(60, 60, 60, 255))
    end
	
    local header = vgui.Create("DLabel", LIBRARYFrame)
    header:SetPos(LIBRARYFrame:GetWide() / 3 - 120, 0)
    header:SetFont("RANKSTitle")
    header:SetText("Imperial Gaming Menu Library")
    header:SizeToContents()
    header:SetTextColor(Color(255, 255, 255, 255))
	local imp_img = vgui.Create( "DImage", LIBRARYFrame)
	imp_img:SetPos( 10,3 )
	imp_img:SetSize( 35, 35)
	imp_img:SetImage("materials/shared/implogo.png")
	
	local ig_img = vgui.Create( "DImageButton", LIBRARYFrame)
	ig_img:SetPos( 10,430 )
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
	local CButton = vgui.Create("DButton", LIBRARYFrame)
    CButton:SetTextColor(Color(255, 255, 255))
    CButton:SetText("X")
    CButton:SetFont("CloseCaption_Normal")
    CButton:SetSize(34, 24)
    CButton:SetPos(LIBRARYFrame:GetWide() - 40, 3)

    CButton.Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(60, 60, 60))
    end

    CButton.DoClick = function()
        LIBRARYFrame:Close()
    end
	
	local disclaimer = vgui.Create("DLabel", LIBRARYFrame)
    disclaimer:SetPos(40, 380)
    disclaimer:SetFont("RANKSMain")
    disclaimer:SetText("If a Menu doesn't open it means you lack the requirements to open it.")
    disclaimer:SizeToContents()
    disclaimer:SetTextColor(Color(255, 255, 255, 255))
	
	local eventmenu = vgui.Create("DPanel", LIBRARYFrame)
    eventmenu:SetSize(LIBRARYFrame:GetWide() - 60, LIBRARYFrame:GetTall() - 200)
    eventmenu:SetPos(30, 60)
	
	eventmenu.Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(30, 30, 30, 255))
    end
	
	local adminmenu = vgui.Create("DPanel", LIBRARYFrame)
    adminmenu:SetSize(LIBRARYFrame:GetWide() - 60, LIBRARYFrame:GetTall() - 200)
    adminmenu:SetPos(30, 60)
	
	adminmenu.Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(30, 30, 30, 255))
    end
	
	local utilitymenu = vgui.Create("DPanel", LIBRARYFrame)
    utilitymenu:SetSize(LIBRARYFrame:GetWide() - 60, LIBRARYFrame:GetTall() - 200)
    utilitymenu:SetPos(30, 60)
	
	utilitymenu.Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(30, 30, 30, 255))
    end
	
	--[[Utility Buttons]]--
	--[[Utility Buttons]]--
	--[[Utility Buttons]]--
	
	local STRUCTUREButton = vgui.Create("DButton", utilitymenu)
    STRUCTUREButton:SetText("Structure Menu")
	STRUCTUREButton:SetTextColor(Color(255, 255, 255))
    STRUCTUREButton:SetSize(160, 50)
    STRUCTUREButton:SetFont("RANKSMain")
    STRUCTUREButton:SetPos(20, 10)

    STRUCTUREButton.Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(25, 122, 248, 170))
		if STRUCTUREButton:IsHovered() then
        draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 255, 255))
		if STRUCTUREButton:IsDown() then
		draw.RoundedBox(0, 0, 0, w, h, Color(0, 255, 0, 255))
    end
	end
    end

    STRUCTUREButton.DoClick = function()
	LIBRARYFrame:Close()
	RunConsoleCommand("igstructuremenu")
    end
	
	local AOSButton = vgui.Create("DButton", utilitymenu)
    AOSButton:SetText("AOS Menu")
	AOSButton:SetTextColor(Color(255, 255, 255))
    AOSButton:SetSize(160, 50)
    AOSButton:SetFont("RANKSMain")
    AOSButton:SetPos(190, 10)

    AOSButton.Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(150, 150, 150, 170))
		if AOSButton:IsHovered() then
        draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 255, 255))
		if AOSButton:IsDown() then
		draw.RoundedBox(0, 0, 0, w, h, Color(0, 255, 0, 255))
    end
	end
    end

    AOSButton.DoClick = function()
	LIBRARYFrame:Close()
	RunConsoleCommand("igaosmenu")
    end
	
	local BOOKINGButton = vgui.Create("DButton", utilitymenu)
    BOOKINGButton:SetText("Booking Menu")
	BOOKINGButton:SetTextColor(Color(255, 255, 255))
    BOOKINGButton:SetSize(160, 50)
    BOOKINGButton:SetFont("RANKSMain")
    BOOKINGButton:SetPos(360, 10)

    BOOKINGButton.Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(0, 215, 215, 170))
		if BOOKINGButton:IsHovered() then
        draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 255, 255))
		if BOOKINGButton:IsDown() then
		draw.RoundedBox(0, 0, 0, w, h, Color(0, 255, 0, 255))
    end
	end
    end

    BOOKINGButton.DoClick = function()
	LIBRARYFrame:Close()
	RunConsoleCommand("igbookingmenu")
    end
	
	local REGLISTButton = vgui.Create("DButton", utilitymenu)
    REGLISTButton:SetText("Regiment List Menu")
	REGLISTButton:SetTextColor(Color(0, 0, 0))
    REGLISTButton:SetSize(160, 50)
    REGLISTButton:SetFont("RANKSMain")
    REGLISTButton:SetPos(20, 70)

    REGLISTButton.Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(255, 255, 255))
		if REGLISTButton:IsHovered() then
        draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 255, 255))
		if REGLISTButton:IsDown() then
		draw.RoundedBox(0, 0, 0, w, h, Color(0, 255, 0, 255))
    end
	end
    end

    REGLISTButton.DoClick = function()
	LIBRARYFrame:Close()
	RunConsoleCommand("ulx", "regimentlist")
    end
	
	local HUDButton = vgui.Create("DButton", utilitymenu)
    HUDButton:SetText("HUD Menu")
	HUDButton:SetTextColor(Color(255, 255, 255))
    HUDButton:SetSize(160, 50)
    HUDButton:SetFont("RANKSMain")
    HUDButton:SetPos(190, 70)

    HUDButton.Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(90, 90, 90, 255))
		if HUDButton:IsHovered() then
        draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 255, 255))
		if HUDButton:IsDown() then
		draw.RoundedBox(0, 0, 0, w, h, Color(0, 255, 0, 255))
    end
	end
    end

    HUDButton.DoClick = function()
	LIBRARYFrame:Close()
	RunConsoleCommand("holohud_menu")
    end
	
	--[[Event Buttons]]--
	--[[Event Buttons]]--
	--[[Event Buttons]]--
	
	local EVENTButton = vgui.Create("DButton", eventmenu)
    EVENTButton:SetText("Event Placings Menu")
	EVENTButton:SetTextColor(Color(255, 255, 255))
    EVENTButton:SetSize(160, 50)
    EVENTButton:SetFont("RANKSMain")
    EVENTButton:SetPos(20, 10)

    EVENTButton.Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(0, 180, 180, 255))
		if EVENTButton:IsHovered() then
        draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 255, 255))
		if EVENTButton:IsDown() then
		draw.RoundedBox(0, 0, 0, w, h, Color(0, 255, 0, 255))
    end
	end
    end

    EVENTButton.DoClick = function()
	LIBRARYFrame:Close()
	RunConsoleCommand("ulx", "eboard")
    end
	
	--[[Admin Buttons]]--
	--[[Admin Buttons]]--
	--[[Admin Buttons]]--
	
	local AWARNButton = vgui.Create("DButton", adminmenu)
    AWARNButton:SetText("Awarn Menu")
	AWARNButton:SetTextColor(Color(255, 255, 255))
    AWARNButton:SetSize(160, 50)
    AWARNButton:SetFont("RANKSMain")
    AWARNButton:SetPos(20, 10)

    AWARNButton.Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(255, 0, 0, 170))
		if AWARNButton:IsHovered() then
        draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 255, 255))
		if AWARNButton:IsDown() then
		draw.RoundedBox(0, 0, 0, w, h, Color(0, 255, 0, 255))
    end
	end
    end

    AWARNButton.DoClick = function()
	LIBRARYFrame:Close()
	RunConsoleCommand("awarn_newmenu")
    end
	
	local NOTICEButton = vgui.Create("DButton", adminmenu)
    NOTICEButton:SetText("Notice Menu")
	NOTICEButton:SetTextColor(Color(255, 255, 255))
    NOTICEButton:SetSize(160, 50)
    NOTICEButton:SetFont("RANKSMain")
    NOTICEButton:SetPos(190, 10)

    NOTICEButton.Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(180, 0, 0, 170))
		if NOTICEButton:IsHovered() then
        draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 255, 255))
		if NOTICEButton:IsDown() then
		draw.RoundedBox(0, 0, 0, w, h, Color(0, 255, 0, 255))
    end
	end
    end

    NOTICEButton.DoClick = function()
	LIBRARYFrame:Close()
	RunConsoleCommand("noticemenuopen")
    end
	
	local STRUCTRANKSButton = vgui.Create("DButton", adminmenu)
    STRUCTRANKSButton:SetText("STRUCTRanks Menu")
	STRUCTRANKSButton:SetTextColor(Color(255, 255, 255))
    STRUCTRANKSButton:SetSize(160, 50)
    STRUCTRANKSButton:SetFont("RANKSMain")
    STRUCTRANKSButton:SetPos(360, 10)

    STRUCTRANKSButton.Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(25, 122, 248, 170))
		if STRUCTRANKSButton:IsHovered() then
        draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 255, 255))
		if STRUCTRANKSButton:IsDown() then
		draw.RoundedBox(0, 0, 0, w, h, Color(0, 255, 0, 255))
    end
	end
    end

    STRUCTRANKSButton.DoClick = function()
	LIBRARYFrame:Close()
	RunConsoleCommand("rankmenuopen")
    end
	
	local PILOTButton = vgui.Create("DButton", adminmenu)
    PILOTButton:SetText("Pilot License Menu")
	PILOTButton:SetTextColor(Color(0, 0, 0))
    PILOTButton:SetSize(160, 50)
    PILOTButton:SetFont("RANKSMain")
    PILOTButton:SetPos(20, 70)

    PILOTButton.Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(255, 255, 255, 255))
		if PILOTButton:IsHovered() then
        draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 255, 255))
		if PILOTButton:IsDown() then
		draw.RoundedBox(0, 0, 0, w, h, Color(0, 255, 0, 255))
    end
	end
    end

    PILOTButton.DoClick = function()
	LIBRARYFrame:Close()
	RunConsoleCommand("ulx", "plicense")
    end
	
	local LIBRARYButton1 = vgui.Create("DButton", LIBRARYFrame)
    LIBRARYButton1:SetText("Admin Menus")
	LIBRARYButton1:SetTextColor(Color(255, 255, 255))
    LIBRARYButton1:SetSize(160, 50)
    LIBRARYButton1:SetFont("RANKSMain")
    LIBRARYButton1:SetPos(410, 430)

	LIBRARYButton1.Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(25, 122, 248, 170))
		if LIBRARYButton1:IsHovered() then
        if LocalPlayer():IsAdmin() then draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 255, 255)) else if not LocalPlayer():IsAdmin() then draw.RoundedBox(0, 0, 0, w, h, Color(200, 0, 0, 255)) 
			end
		end
		if LIBRARYButton1:IsDown() then
		if LocalPlayer():IsAdmin() then draw.RoundedBox(0, 0, 0, w, h, Color(0, 200, 0, 255)) else if not LocalPlayer():IsAdmin() then draw.RoundedBox(0, 0, 0, w, h, Color(200, 0, 0, 255)) 
			end
		end
    end
    end
	end

    LIBRARYButton1.DoClick = function()
	if LocalPlayer():IsAdmin() then
        adminmenu:MoveToFront()
		else chat.AddText("You're not an Administrator!")
    end

end

    local LIBRARYButton2 = vgui.Create("DButton", LIBRARYFrame)
    LIBRARYButton2:SetText("Utility Menus")
	LIBRARYButton2:SetTextColor(Color(255, 255, 255))
    LIBRARYButton2:SetSize(160, 50)
    LIBRARYButton2:SetFont("RANKSMain")
    LIBRARYButton2:SetPos(70, 430)

    LIBRARYButton2.Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(25, 122, 248, 170))
		if LIBRARYButton2:IsHovered() then
        draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 255, 170))
		if LIBRARYButton2:IsDown() then
		draw.RoundedBox(0, 0, 0, w, h, Color(0, 255, 0, 255))
    end
	end
    end

    LIBRARYButton2.DoClick = function()
	utilitymenu:MoveToFront()
    end

	local LIBRARYButton3 = vgui.Create("DButton", LIBRARYFrame)
    LIBRARYButton3:SetText("Event Menus")
	LIBRARYButton3:SetTextColor(Color(255, 255, 255))
    LIBRARYButton3:SetSize(160, 50)
    LIBRARYButton3:SetFont("RANKSMain")
    LIBRARYButton3:SetPos(240, 430)

	LIBRARYButton3.Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(25, 122, 248, 170))
		if LIBRARYButton3:IsHovered() then
        if LocalPlayer():IsAdmin() or LocalPlayer():IsEventMaster() then draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 255, 170)) else if not LocalPlayer():IsAdmin() or LocalPlayer():IsEventMaster() then draw.RoundedBox(0, 0, 0, w, h, Color(200, 0, 0, 255)) 
			end
		end
		if LIBRARYButton3:IsDown() then
		if LocalPlayer():IsAdmin() or LocalPlayer():IsEventMaster() then draw.RoundedBox(0, 0, 0, w, h, Color(0, 200, 0, 255)) else if not LocalPlayer():IsAdmin() or LocalPlayer():IsEventMaster() then draw.RoundedBox(0, 0, 0, w, h, Color(200, 0, 0, 255)) 
			end
		end
    end
    end
	end

    LIBRARYButton3.DoClick = function()
	if LocalPlayer():IsAdmin() or LocalPlayer():IsEventMaster() then
        eventmenu:MoveToFront()
	else chat.AddText("You're not an Event Master!")
    end

end
end




net.Receive("NETOIGLIBRARYMenu", LIBRARYMenuOpen)