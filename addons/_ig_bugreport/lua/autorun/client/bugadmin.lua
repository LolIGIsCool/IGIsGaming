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

function BUGADMINMenuOpen()
    local BUGADMINFRAME = vgui.Create("DFrame")
    BUGADMINFRAME:SetSize(1000, 500)
    BUGADMINFRAME:SetPos(ScrW() / 2 - 500, ScrH() / 2 - 250)
    BUGADMINFRAME:SetTitle("")
    BUGADMINFRAME:SetBackgroundBlur(true)
    BUGADMINFRAME:ShowCloseButton(false)
    BUGADMINFRAME:SetDraggable(true)
    BUGADMINFRAME:SetVisible(true)
    BUGADMINFRAME:MakePopup()

    BUGADMINFRAME.Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(25, 122, 248, 255))
    end

    local CenterPanel = vgui.Create("DPanel", BUGADMINFRAME)
    CenterPanel:SetSize(BUGADMINFRAME:GetWide() - 20, BUGADMINFRAME:GetTall() - 50)
    CenterPanel:SetPos(10, 40)

    CenterPanel.Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(60, 60, 60, 255))
    end

    local header = vgui.Create("DLabel", BUGADMINFRAME)
    header:SetPos(BUGADMINFRAME:GetWide() / 3 - 80, 0)
    header:SetFont("RANKSTitle")
    header:SetText("Imperial Gaming Bug Report Library")
    header:SizeToContents()
    header:SetTextColor(Color(255, 255, 255, 255))
    local imp_img = vgui.Create("DImage", BUGADMINFRAME)
    imp_img:SetPos(10, 3)
    imp_img:SetSize(35, 35)
    imp_img:SetImage("materials/shared/implogo.png")
    local ig_img = vgui.Create("DImageButton", BUGADMINFRAME)
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

    local CButton = vgui.Create("DButton", BUGADMINFRAME)
    CButton:SetTextColor(Color(255, 255, 255))
    CButton:SetText("X")
    CButton:SetFont("CloseCaption_Normal")
    CButton:SetSize(34, 24)
    CButton:SetPos(BUGADMINFRAME:GetWide() - 40, 3)

    CButton.Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(60, 60, 60))
    end

    CButton.DoClick = function()
        BUGADMINFRAME:Close()
    end

    local reportlist = vgui.Create("DListView", BUGADMINFRAME)
    reportlist:SetPos(30, 100)
    reportlist:SetSize(BUGADMINFRAME:GetWide() - 60, BUGADMINFRAME:GetTall() - 200)
    reportlist:AddColumn("Bug Reports - Right Click to Copy.")

    net.Receive("igbug_reports", function()
        local ReportTable = net.ReadTable()

        for k, v in pairs(ReportTable) do
            reportlist:AddLine(v)
        end
    end)

    function reportlist:OnRowRightClick(id, text)
        chat.AddText(Color(120, 120, 120), "[Report System] ", Color(150, 150, 150), "Copied report ID " .. id .. ".")
        SetClipboardText(text:GetColumnText(1))
    end
end

net.Receive("igbug_openadminpanel", BUGADMINMenuOpen)