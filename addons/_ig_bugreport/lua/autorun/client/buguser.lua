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

local ReportReason = "nil"

function BUGMenuOpen()
    local BUGFRAME = vgui.Create("DFrame")
    BUGFRAME:SetSize(600, 500)
    BUGFRAME:SetPos(ScrW() / 2 - 300, ScrH() / 2 - 200)
    BUGFRAME:SetTitle("")
    BUGFRAME:SetBackgroundBlur(true)
    BUGFRAME:ShowCloseButton(false)
    BUGFRAME:SetDraggable(true)
    BUGFRAME:SetVisible(true)
    BUGFRAME:MakePopup()

    BUGFRAME.Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(25, 122, 248, 255))
    end

    local CenterPanel = vgui.Create("DPanel", BUGFRAME)
    CenterPanel:SetSize(BUGFRAME:GetWide() - 20, BUGFRAME:GetTall() - 50)
    CenterPanel:SetPos(10, 40)

    CenterPanel.Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(60, 60, 60, 255))
    end

    local header = vgui.Create("DLabel", BUGFRAME)
    header:SetPos(BUGFRAME:GetWide() / 3 - 120, 0)
    header:SetFont("RANKSTitle")
    header:SetText("Imperial Gaming Bug Reporter")
    header:SizeToContents()
    header:SetTextColor(Color(255, 255, 255, 255))
    local imp_img = vgui.Create("DImage", BUGFRAME)
    imp_img:SetPos(10, 3)
    imp_img:SetSize(35, 35)
    imp_img:SetImage("materials/shared/implogo.png")
    local ig_img = vgui.Create("DImageButton", BUGFRAME)
    ig_img:SetPos(10, 430)
    ig_img:SetSize(50, 50)
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

    local CButton = vgui.Create("DButton", BUGFRAME)
    CButton:SetTextColor(Color(255, 255, 255))
    CButton:SetText("X")
    CButton:SetFont("CloseCaption_Normal")
    CButton:SetSize(34, 24)
    CButton:SetPos(BUGFRAME:GetWide() - 40, 3)

    CButton.Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(60, 60, 60))
    end

    CButton.DoClick = function()
        BUGFRAME:Close()
    end

    local reasontext = vgui.Create("DLabel", BUGFRAME)
    reasontext:SetPos(40, 50)
    reasontext:SetSize(550, 50)
    reasontext:SetFont("RANKSMini")
    reasontext:SetText("Report your bug in the text box below | Once you are done PRESS ENTER to confirm then SUBMIT.")
    local reasonbox = vgui.Create("DTextEntry", BUGFRAME)
    reasonbox:SetPos(30, 100)
    reasonbox:SetSize(BUGFRAME:GetWide() - 60, BUGFRAME:GetTall() - 200)
    reasonbox:SetUpdateOnType(true)
    reasonbox:SetMultiline(false)
    reasonbox:SetText("")

    reasonbox.OnValueChange = function(changedtwo)
        ReportReason = changedtwo:GetValue()
    end

    local submittext = vgui.Create("DLabel", BUGFRAME)
    submittext:SetPos(270, 430)
    submittext:SetSize(280, 50)
    submittext:SetFont("RANKSMini")
    submittext:SetText("Misuse of this feature will result in punishment")
    local submitbutton = vgui.Create("DButton", BUGFRAME)
    submitbutton:SetText("Submit")
    submitbutton:SetPos(80, 430)
    submitbutton:SetFont("RANKSMain")
    submitbutton:SetSize(160, 50)

    submitbutton.DoClick = function()
        net.Start("igbug_reporthandler")
        net.WriteString(ReportReason)
        net.SendToServer()
        BUGFRAME:Close()
    end
end

net.Receive("igbug_openuserpanel", BUGMenuOpen)