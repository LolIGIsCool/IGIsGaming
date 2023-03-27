include('shared.lua')

function ENT:Draw()
    self:DrawModel()
    local pos = self:LocalToWorld(Vector(0, 0, 0))
	local ang = self:LocalToWorldAngles(Angle(0, 270, 90))

	cam.Start3D2D(pos, ang, 0.1)
		surface.SetDrawColor(24, 31, 41,220)
    	surface.DrawRect(-100, -650, 200, 100)
    	draw.SimpleText("Bail Console", "IG_Dynamic_Title", 0, -600, Color(255,255,255), 1, 1)
    cam.End3D2D()
end

lastBail = -1 * AikoBailSystem.Config.BailCooldown

net.Receive("AikoBailSystem.OpenBailMenu", function(len, ply)

    surface.SetFont( "Default" )
    local reason = net.ReadString()
    local bailtext = ""
    for k, v in ipairs(AikoBailSystem.Config.BailReasons) do
        if v[1] == reason then
            PrintTable(v)
            bailindex = k
            if v[2] then
                bailtext = v[2] .. " IMPERIAL CREDITS"
            else
                bailtext = "INELIGIBLE FOR BAIL"
            end
        end
    end

    local DMainPanel = vgui.Create("DFrame")
    DMainPanel:SetSize(250, 400)
    DMainPanel:MakePopup()
    DMainPanel:Center()
    DMainPanel:SetTitle("")
    local polygonPoints = {
        { x = 50, y = 0 },
        { x = 250, y = 0 },
        { x = 250, y = 400 },
        { x = 0, y = 400 },
        { x = 0, y = 50 },
    }
    DMainPanel.Paint = function(self, w, h)
        surface.SetDrawColor(80,80,80,250)
        draw.NoTexture()
        surface.DrawPoly(polygonPoints)

        surface.SetDrawColor(255,255,255,255)
        surface.DrawLine(w * 0.97,h * 0.07, w * 0.97, h * 0.6)
        surface.DrawLine(w * 0.97,h * 0.6, w * 0.93, h * 0.65)
        surface.DrawLine(w * 0.93,h * 0.65, w * 0.93, h * 0.915)

        draw.SimpleText("Bail Menu","Trebuchet24",w * 0.9,h * 0.07,Color( 255, 255, 255, 255 ),TEXT_ALIGN_RIGHT,TEXT_ALIGN_TOP)

        surface.SetTextColor(255,255,255)
        surface.SetFont("Trebuchet18")

        surface.SetTextPos(w * 0.02,h * 0.2)
        surface.DrawText("OFFENCE:")

        surface.SetTextPos(w * 0.02,h * 0.5)
        surface.DrawText("COST:")

        surface.SetTextColor(219,219,219)
        surface.SetTextPos(w * 0.02,h * 0.55)
        surface.DrawText(bailtext)
    end

    local BailOffenceText = vgui.Create("DLabel", DMainPanel)
    BailOffenceText:Dock(TOP)
    BailOffenceText:DockMargin(0,70,0,0)
    BailOffenceText:SetTextColor(Color(219,219,219))
    BailOffenceText:SetFont("Trebuchet18")
    BailOffenceText:SetText(string.upper(reason))
    BailOffenceText:SetAutoStretchVertical(true)
    BailOffenceText:SetWrap(true)

    local PayBail = vgui.Create("DButton", DMainPanel)
    PayBail:Dock(BOTTOM)
    PayBail:SetFont("Trebuchet18")
    PayBail:SetText("Pay Bail")

    PayBail.DoClick = function()

        DMainPanel:Close()

        if (lastBail + AikoBailSystem.Config.BailCooldown >= CurTime()  &&  !(LocalPlayer():IsSuperAdmin() or LocalPlayer():IsDeveloper())) then
            local minutesleft = string.format("%.0f",(lastBail + AikoBailSystem.Config.BailCooldown - CurTime())/60)
            chat.AddText(
                Color(255, 251, 0), "[",
                Color(210, 210, 210), "Bail System",
                Color(255, 251, 0), "] ",
                Color(180, 0, 0), "You must wait " .. minutesleft .. " minutes before being able to go for bail again."
            )
            return
        end
        lastBail = CurTime()

        if AikoBailSystem.Config.BailReasons[bailindex][2] == nil then
            chat.AddText(
                Color(255, 251, 0), "[",
                Color(210, 210, 210), "Bail System",
                Color(255, 251, 0), "] ",
                Color(180, 0, 0), "You cannot bail out of this one."
            )
            return
        end
        if LocalPlayer():SH_CanAffordPremium(AikoBailSystem.Config.BailReasons[bailindex][2]) then
            chat.AddText(
                Color(255, 251, 0), "[",
                Color(210, 210, 210), "Bail System",
                Color(255, 251, 0), "] ",
                Color(0, 180, 0), "You have paid your "..AikoBailSystem.Config.BailReasons[bailindex][2].." credits bail. Please wait for a member of a Security Regiment to release you."
            )
            net.Start("AikoBailSystem.PayBail")
            net.WriteUInt(bailindex, 8)
            net.SendToServer()
        else
            chat.AddText(
                Color(255, 251, 0), "[",
                Color(210, 210, 210), "Bail System",
                Color(255, 251, 0), "] ",
                Color(180, 0, 0), "You can not afford bail. You need "..AikoBailSystem.Config.BailReasons[bailindex][2].." credits."
            )
        end
    end
end)

net.Receive("AikoBailSystem.AddChat", function(_, _)
    local reason = net.ReadString()
    local target = net.ReadString()
    chat.AddText(
        Color(255, 251, 0), "[",
        Color(210, 210, 210), "Bail System",
        Color(255, 251, 0), "] ",
        Color(197, 197, 197), "Player ",
        Color(0, 185, 0), target,
        Color(197, 197, 197), " has bailed themselves out for ",
        Color(185, 0, 0), reason .. ". ",
        Color(197, 197, 197), "Make your way to the brig to release them."
    )
end)