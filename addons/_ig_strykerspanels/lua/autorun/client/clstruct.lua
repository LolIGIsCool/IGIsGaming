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

surface.CreateFont("RANKSMain", {
    font = "Roboto",
    size = 22
})

surface.CreateFont("RANKSMini", {
    font = "Roboto",
    size = 15
})

 --[[RANK2:AddChoice("engineerrank")
    RANK2:AddChoice("engineername")
    RANK2:AddChoice("iscrank1")
	RANK2:AddChoice("iscname1")
    RANK2:AddChoice("iscrank2")
	RANK2:AddChoice("iscname2")]]
	
local structoption = "nothin"
local structname = "nothin"

function RANKMenuOpen()
    local RANKFrame = vgui.Create("DFrame")
    RANKFrame:SetSize(490, 220)
    RANKFrame:SetPos(ScrW() / 2 - 250, ScrH() / 2 - 300)
    RANKFrame:SetTitle("")
    RANKFrame:SetBackgroundBlur(true)
    RANKFrame:ShowCloseButton(false)
	RANKFrame:SetDraggable( true )
    RANKFrame:SetVisible(true)
    RANKFrame:MakePopup()

    RANKFrame.Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(25, 122, 248, 255))
    end

    local CenterPanel = vgui.Create("DPanel", RANKFrame)
    CenterPanel:SetSize(RANKFrame:GetWide() - 20, RANKFrame:GetTall() - 50)
    CenterPanel:SetPos(10, 40)

    CenterPanel.Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(60, 60, 60, 255))
    end

    local header = vgui.Create("DLabel", RANKFrame)
    header:SetPos(RANKFrame:GetWide() / 2 - 215, 5)
    header:SetFont("RANKSTitle")
    header:SetText("Rank Structure Admin Menu")
    header:SizeToContents()
    header:SetTextColor(Color(255, 255, 255, 255))
	local Infoarea = vgui.Create("DLabel", RANKFrame)
    Infoarea:SetPos(15, 175)
    Infoarea:SetFont("RANKSMini")
    Infoarea:SetText("Select the Rank/Role you want to rename and then make sure once")
    Infoarea:SizeToContents()
    Infoarea:SetTextColor(Color(255, 255, 255, 255))
	local Infoarea2 = vgui.Create("DLabel", RANKFrame)
    Infoarea2:SetPos(15, 190)
    Infoarea2:SetFont("RANKSMini")
    Infoarea2:SetText("you type the new Rank/Name you press ENTER to confirm the change.")
    Infoarea2:SizeToContents()
    Infoarea2:SetTextColor(Color(255, 255, 255, 255))
	
    local CButton = vgui.Create("DButton", RANKFrame)
    CButton:SetTextColor(Color(255, 255, 255))
    CButton:SetText("X")
    CButton:SetFont("CloseCaption_Normal")
    CButton:SetSize(34, 24)
    CButton:SetPos(RANKFrame:GetWide() - 40, 3)

    CButton.Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(60, 60, 60))
    end

    CButton.DoClick = function()
        RANKFrame:Close()
    end

    --Select the NetStart--
    --------------------------------
    local RANK = vgui.Create("DButton", RANKFrame)
    RANK:SetText("Role Selection")
    RANK:SetPos(20, 60)
    RANK:SetSize(120, 50)
    RANK:SetFont("RANKSMain")
    RANK:SetTextColor(Color(255, 255, 255, 255))

    RANK.Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(25, 122, 248))
    end

    local RANK2 = vgui.Create("DComboBox", RANKFrame)
    RANK2:SetPos(20, 120)
    RANK2:SetSize(120, 50)
    RANK2:SetFont("epicfont")
    RANK2:SetValue("Options")
    -- Page of AHC Structure
        -- BCO Setup
        RANK2:AddChoice("battalionco439th")
        RANK2:AddChoice("battalionco275th")
        RANK2:AddChoice("battalionco107th")
        RANK2:AddChoice("battalionco501st")
    	RANK2:AddChoice("battalionco439thrank")
        RANK2:AddChoice("battalionco275thrank")
        RANK2:AddChoice("battalionco107thrank")
        RANK2:AddChoice("battalionco501strank")
        -- BCO Setup

        -- General Setup
        RANK2:AddChoice("general1rank")
        RANK2:AddChoice("general1name")
        RANK2:AddChoice("general2rank")
        RANK2:AddChoice("general2name")
        RANK2:AddChoice("general3rank")
        RANK2:AddChoice("general3name")
        RANK2:AddChoice("general4rank")
        RANK2:AddChoice("general4name")
        -- General Setup
    -- Page of AHC Structure

    -- Page of NHC Structure 
        RANK2:AddChoice("navy1rank")
        RANK2:AddChoice("navy1name")
        RANK2:AddChoice("navy2rank")
        RANK2:AddChoice("navy2name")
    -- Page of NHC Structure

    -- Page of COMPNOR Structure 
        RANK2:AddChoice("isbdirectorrank")
        RANK2:AddChoice("isbdirectorname")
        RANK2:AddChoice("isbrank1")
        RANK2:AddChoice("isbname1")
        RANK2:AddChoice("isbrank2")
        RANK2:AddChoice("isbname2")

        RANK2:AddChoice("IICommanderRank")
        RANK2:AddChoice("IICommanderName")
        RANK2:AddChoice("IIDirectorRank")
        RANK2:AddChoice("IIDirectorName")

    -- Page of COMPNOR Structure 

    -- Page of MAIN Structure 
        RANK2:AddChoice("sovprotrank")
        RANK2:AddChoice("sovprotname")
        RANK2:AddChoice("nhcheadrank")
        RANK2:AddChoice("nhcheadname")
        RANK2:AddChoice("administratorrank")
        RANK2:AddChoice("administratorname")
        RANK2:AddChoice("compnordirectorrank")
        RANK2:AddChoice("compnordirectorname")
        RANK2:AddChoice("ahcheadname")
        RANK2:AddChoice("ahcheadrank")
    -- Page of MAIN Structure 

    RANK2.Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(255, 255, 255, 255))
    end

    function RANK2:OnSelect(index, value, data)
        structoption = value
    end

    local RANKButton1 = vgui.Create("DButton", RANKFrame)
    RANKButton1:SetText("Assign Rank/Name")
    RANKButton1:SetSize(160, 50)
    RANKButton1:SetFont("epicfont")
    RANKButton1:SetPos(310, 120)

    RANKButton1.Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(255, 255, 255, 170))
    end

    RANKButton1.DoClick = function()
        net.Start("networkrankboard")
        net.WriteString(structoption)
        net.WriteString(structname)
        net.SendToServer()
    end

    --Set Custom Name of Person or Rank--
    --------------------------------
    local RANK3 = vgui.Create("DButton", RANKFrame)
    RANK3:SetText("Input Name/Rank")
    RANK3:SetPos(160, 60)
    RANK3:SetSize(140, 50)
    RANK3:SetFont("RANKSMain")
    RANK3:SetTextColor(Color(255, 255, 255, 255))

    RANK3.Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(25, 122, 248))
    end

    local RANK32 = vgui.Create("DTextEntry", RANKFrame)
    RANK32:SetPos(160, 120)
    RANK32:SetSize(140, 50)
    RANK32:SetText("[VACANT]")

    RANK32.OnEnter = function(self)
        structname = self:GetValue()
    end
	
	 local RANK4 = vgui.Create("DButton", RANKFrame)
    RANK4:SetText("Options Info")
    RANK4:SetPos(310, 60)
    RANK4:SetSize(160, 50)
    RANK4:SetFont("RANKSMain")
    RANK4:SetTextColor(Color(255, 255, 255, 255))

    RANK4.Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(25, 122, 248))
		if RANK4:IsHovered() then
        draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 255, 170))
		if RANK4:IsDown() then
		draw.RoundedBox(0, 0, 0, w, h, Color(0, 140, 0, 170))
    end
	end
    end
	
	RANK4.DoClick = function()
        gui.OpenURL("https://i.imgur.com/V3yZahO.png")
    end
end

net.Receive("NETORANKMenu", RANKMenuOpen)