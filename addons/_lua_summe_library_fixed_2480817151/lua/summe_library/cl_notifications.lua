SummeLibrary:CreateFont("Notification.Header", ScrH() * .03)
SummeLibrary:CreateFont("Notification.Text", ScrH() * .015)

function SummeLibrary:Notify(type, header, text_)

    local width, height = ScrW() * 0.25, ScrH() * 0.1

    local barStatus = 0
    local speedBar = 1

    local color = SummeLibrary:GetColor("white")
    local bgColor = SummeLibrary:GetColor("grey")
    if type == "info" then
        color = SummeLibrary:GetColor("blue")
    elseif type == "warning" then
        color = SummeLibrary:GetColor("red")
    elseif type == "success" then
        color = SummeLibrary:GetColor("green")
    end

    local main = vgui.Create("DPanel")
    main:SetPos(ScrW() * 0.74, ScrH() * 0.85)
    main:SetSize(width, height)
    main:SetDrawOnTop(true)
    main:SetAlpha(0)

    main:AlphaTo(255, 0.75, 0)
    main:AlphaTo(0, 0.75, 4.5 + 0.75)

    function main:Paint(w, h)

        barStatus = math.Clamp(barStatus + (speedBar / 5) * FrameTime(), 0, 1)

        local x, y = self:LocalToScreen()

        BSHADOWS.BeginShadow()
            draw.RoundedBox(4, x, y, w, h, bgColor)
            draw.RoundedBox(20, x, y * 1.113, w * barStatus, h * .05, color)
        BSHADOWS.EndShadow(1, 1, 2, 200, 0, 0)

        draw.DrawText(header, "Notification.Header", w * .01, h * .01, color, TEXT_ALIGN_LEFT)
    end

    function main:PerformLayout()
        self:SetPos(ScrW() * 0.74, ScrH() * 0.85)
        self:SetSize(width, height)
    end

    local text = vgui.Create("RichText", main)
    text:Dock(FILL)
    text:DockMargin(width * 0.01, height * 0.35, width * 0.01, height * 0.05)
    text:AppendText(text_)
    text:SetVerticalScrollbarEnabled(false)
    function text:PerformLayout()
        self:SetFontInternal("Notification.Text")
    end

    timer.Simple(3, function()
        local x, y = main:GetPos()
        main:MoveTo(x * 3, y, 3, 2)

        timer.Simple(4, function()
            main:Remove()
        end)
    end)
    
    MsgC(Color(255,255,255), "\n")
    MsgC(color, "INFORMATION:\n")
    MsgC(Color(255,255,255), header.. " | ".. text_.. "\n")
    MsgC(Color(255,255,255), "\n")

    surface.PlaySound("garrysmod/balloon_pop_cute.wav")
end

net.Receive("SummeLib.Notification", function(len)
    SummeLibrary:Notify(net.ReadString(), net.ReadString(), net.ReadString())
end)