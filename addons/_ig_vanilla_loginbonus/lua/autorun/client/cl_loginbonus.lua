//Tells the server that the client is ready for the splash screen
hook.Add( "InitPostEntity", "VANILLALOGIN_hook_ClientReady", function()
    net.Start("VANILLALOGIN_net_ClientReady")
    net.SendToServer()
end )

//Pretty text for receving credits
net.Receive("VANILLALOGIN_net_PrettyText",function()
    local tbl = net.ReadTable()
    local exploded = string.Explode(" ",tbl.Reward1)

    if tonumber(tbl.Day) < 8 then
        if exploded[1] == "0" then
            chat.AddText(Color(255,255,255), "[", Color(105,193,238,255), "LOGIN BONUS - DAY: ", tostring(tbl.Day), Color(255,255,255),"] You have received: ", Color(105,193,238,255), tbl.Reward2, Color(255,255,255), ".")
        else
            chat.AddText(Color(255,255,255), "[", Color(105,193,238,255), "LOGIN BONUS - DAY: ", tostring(tbl.Day), Color(255,255,255),"] You have received: ", Color(105,193,238,255), tbl.Reward1, Color(255,255,255), ".")
        end
    else
        chat.AddText(Color(255,255,255), "[", Color(105,193,238,255), "LOGIN BONUS - STREAK: ", tostring(tbl.Day), Color(255,255,255),"] You have received: ", Color(105,193,238,255), tbl.Reward1, " and ", tbl.Reward2, Color(255,255,255), ".")
    end
end)

surface.CreateFont("vanilla_font_splashtitle", {
    font = "Proxima Nova Rg",
    size = ScreenScale(24),
    weight = 800
})
surface.CreateFont("vanilla_font_splashinfo", {
    font = "Proxima Nova Rg",
    size = ScreenScale(10),
    weight = 800
})
surface.CreateFont("vanilla_font_minibig", {
    font = "Proxima Nova Rg",
    size = ScreenScale(11),
    weight = 800
})
surface.CreateFont("vanilla_font_mini", {
    font = "Proxima Nova Rg",
    size = ScreenScale(5),
    weight = 800
})

net.Receive("VANILLALOGIN_net_OpenSplash",function()
    local dataTable = net.ReadTable()

    local shouldShow = false
    local nextbonus = {
        Day = 0,
        Reward1 = 0,
        Reward2 = 0
    }
    local kuchinawa = {
        Day = 999999
    }
    for k, v in pairs(vanillaIGLoginRewards) do
        if (v.Day == dataTable.currentStreak) and (v.Day > 7) then
            kuchinawa = v
            nextbonus = v
            shouldShow = true
            break
        end
    end
    if shouldShow == false then
        for k, v in pairs(vanillaIGLoginRewards) do
            if (v.Day > dataTable.currentStreak) and (v.Day > 7) then
                nextbonus = v
                break
            end
        end
    end

    local divider = Material("materials/vanilla/login/divider.png")
    local credits = Material("materials/vanilla/login/credits.png")
    local augment = Material("materials/vanilla/login/augment.png")
    local streak = Material("materials/vanilla/login/credaug.png")

    local colourTable = {
        background = Color(31,31,31,210),
        grid = Color(55,55,55,255),
        textcolour = Color(255,255,255,255),
        highlightcolour = Color(105,193,238,255),
        grey = Color(154,154,154,255)
    }

    //Base Frame
    local canvas = vgui.Create("DFrame")
    canvas:SetSize(ScrW(),ScrH())
    canvas:Center()
    canvas:MakePopup()
    canvas:SetDraggable(false)
    canvas:ShowCloseButton(false)
    canvas:SetTitle("")
    canvas.Paint = function(self,w,h)
        if dataTable.claimed == true then
            offset = -1
        elseif dataTable.day == 1 then
            offset = 0.025
        else
            offset = ((dataTable.day - 1) * 0.1) + 0.025
        end

        //background
        surface.SetDrawColor(colourTable.background)
        surface.DrawRect(0,0,w,h)

        //playermodel background
        surface.SetDrawColor(colourTable.grey)
        surface.DrawRect(w * 0.025,h * 0.15,w * 0.15,h * 0.4)

        surface.SetDrawColor(colourTable.textcolour)
        surface.DrawOutlinedRect(w * 0.025,h * 0.15,w * 0.15,h * 0.4,5)

        //playermodel text
        surface.SetTextColor(colourTable.textcolour)
        surface.SetFont("vanilla_font_splashinfo")
        surface.SetTextPos(w * 0.2,h * 0.2)
        surface.DrawText(string.upper(LocalPlayer():Nick()))

        surface.SetTextColor(colourTable.grey)
        surface.SetTextPos(w * 0.2,h * 0.25)
        surface.DrawText(string.upper(LocalPlayer():GetRegiment()))

        surface.SetTextColor(colourTable.textcolour)
        surface.SetTextPos(w * 0.2,h * 0.3)
        surface.DrawText(string.upper(LocalPlayer():GetRankName()))

        //streak text
        surface.SetTextColor(colourTable.textcolour)
        surface.SetTextPos(w * 0.2,h * 0.4)
        surface.DrawText("CURRENT STREAK: ")
        surface.SetTextColor(colourTable.grey)
        surface.DrawText(dataTable.currentStreak)

        surface.SetTextColor(colourTable.textcolour)
        surface.SetTextPos(w * 0.2,h * 0.45)
        surface.DrawText("LONGEST STREAK: ")
        surface.SetTextColor(colourTable.grey)
        surface.DrawText(dataTable.longestStreak)

        //divider
        surface.SetMaterial(divider)
        surface.SetDrawColor(colourTable.textcolour)
        surface.DrawTexturedRect(w * 0.475,h * 0.17,w * 0.015,h * 0.35)

        //News+Updates
        surface.SetTextColor(colourTable.highlightcolour)
        surface.SetTextPos(w * 0.54, h * 0.13)
        surface.SetFont("vanilla_font_minibig")
        surface.DrawText("NEWS + UPDATES")

        surface.SetDrawColor(colourTable.grey)
        surface.DrawRect(w * 0.54, h * 0.17,w * 0.43,h * 0.4)

        surface.SetDrawColor(colourTable.textcolour)
        surface.DrawOutlinedRect(w * 0.54, h * 0.17,w * 0.43,h * 0.4,5)

        //welcome text
        surface.SetTextColor(colourTable.textcolour)
        surface.SetFont("vanilla_font_splashtitle")
        surface.SetTextPos(w * 0.025,h * 0.025)
        surface.DrawText("WELCOME TO IMPERIAL GAMING")

        //-------------------------------------------------------------------------

        //daily bonus text
        surface.SetTextColor(colourTable.highlightcolour)
        surface.SetFont("vanilla_font_minibig")
        surface.SetTextPos(w * 0.025,h * 0.65)
        surface.DrawText("DAILY BONUS")

        surface.SetTextColor(colourTable.textcolour)

        //daily grid, this is where things get dirty.
        surface.SetTextPos(w * 0.025,h * 0.71) surface.SetFont("vanilla_font_minibig") surface.DrawText("DAY 1")
        draw.RoundedBox(10,w * 0.025,h * 0.75,w * 0.08,h * 0.21,colourTable.grid)
        surface.SetDrawColor(colourTable.textcolour) surface.SetMaterial(credits) surface.DrawTexturedRect(w * 0.042,h * 0.78,w * 0.05,h * 0.1)
        draw.SimpleText("1000 credits","vanilla_font_mini",w * 0.0625,h * 0.915,colourTable.textcolour,TEXT_ALIGN_CENTER,TEXT_ALIGN_TOP)
        if dataTable.day >= 1 then
            surface.SetDrawColor(colourTable.highlightcolour)
            surface.DrawOutlinedRect(w * 0.025,h * 0.75,w * 0.08,h * 0.21,5)
            draw.SimpleText("CLAIMED","vanilla_font_mini",w * 0.0625,h * 0.97,colourTable.textcolour,TEXT_ALIGN_CENTER,TEXT_ALIGN_TOP)
        end

        surface.SetTextPos(w * 0.125,h * 0.71) surface.SetFont("vanilla_font_minibig") surface.DrawText("DAY 2")
        draw.RoundedBox(10,w * 0.125,h * 0.75,w * 0.08,h * 0.21,colourTable.grid)
        surface.SetDrawColor(colourTable.textcolour) surface.SetMaterial(credits) surface.DrawTexturedRect(w * 0.142,h * 0.78,w * 0.05,h * 0.1)
        draw.SimpleText("2000 credits","vanilla_font_mini",w * 0.1625,h * 0.915,colourTable.textcolour,TEXT_ALIGN_CENTER,TEXT_ALIGN_TOP)
        if dataTable.day >= 2 then
            surface.SetDrawColor(colourTable.highlightcolour)
            surface.DrawOutlinedRect(w * 0.125,h * 0.75,w * 0.08,h * 0.21,5)
            draw.SimpleText("CLAIMED","vanilla_font_mini",w * 0.1625,h * 0.97,colourTable.textcolour,TEXT_ALIGN_CENTER,TEXT_ALIGN_TOP)
        end

        surface.SetTextPos(w * 0.225,h * 0.71) surface.SetFont("vanilla_font_minibig") surface.DrawText("DAY 3")
        draw.RoundedBox(10,w * 0.225,h * 0.75,w * 0.08,h * 0.21,colourTable.grid)
        surface.SetDrawColor(colourTable.textcolour) surface.SetMaterial(credits) surface.DrawTexturedRect(w * 0.242,h * 0.78,w * 0.05,h * 0.1)
        draw.SimpleText("3000 credits","vanilla_font_mini",w * 0.2625,h * 0.915,colourTable.textcolour,TEXT_ALIGN_CENTER,TEXT_ALIGN_TOP)
        if dataTable.day >= 3 then
            surface.SetDrawColor(colourTable.highlightcolour)
            surface.DrawOutlinedRect(w * 0.225,h * 0.75,w * 0.08,h * 0.21,5)
            draw.SimpleText("CLAIMED","vanilla_font_mini",w * 0.2625,h * 0.97,colourTable.textcolour,TEXT_ALIGN_CENTER,TEXT_ALIGN_TOP)
        end

        surface.SetTextPos(w * 0.325,h * 0.71) surface.SetFont("vanilla_font_minibig") surface.DrawText("DAY 4")
        draw.RoundedBox(10,w * 0.325,h * 0.75,w * 0.08,h * 0.21,colourTable.grid)
        surface.SetDrawColor(colourTable.textcolour) surface.SetMaterial(augment) surface.DrawTexturedRect(w * 0.338,h * 0.785,w * 0.055,h * 0.097)
        draw.SimpleText("1 augment point","vanilla_font_mini",w * 0.3625,h * 0.915,colourTable.textcolour,TEXT_ALIGN_CENTER,TEXT_ALIGN_TOP)
        if dataTable.day >= 4 then
            surface.SetDrawColor(colourTable.highlightcolour)
            surface.DrawOutlinedRect(w * 0.325,h * 0.75,w * 0.08,h * 0.21,5)
            draw.SimpleText("CLAIMED","vanilla_font_mini",w * 0.3625,h * 0.97,colourTable.textcolour,TEXT_ALIGN_CENTER,TEXT_ALIGN_TOP)
        end

        surface.SetTextPos(w * 0.425,h * 0.71) surface.SetFont("vanilla_font_minibig") surface.DrawText("DAY 5")
        draw.RoundedBox(10,w * 0.425,h * 0.75,w * 0.08,h * 0.21,colourTable.grid)
        surface.SetDrawColor(colourTable.textcolour) surface.SetMaterial(credits) surface.DrawTexturedRect(w * 0.442,h * 0.78,w * 0.05,h * 0.1)
        draw.SimpleText("4000 credits","vanilla_font_mini",w * 0.4625,h * 0.915,colourTable.textcolour,TEXT_ALIGN_CENTER,TEXT_ALIGN_TOP)
        if dataTable.day >= 5 then
            surface.SetDrawColor(colourTable.highlightcolour)
            surface.DrawOutlinedRect(w * 0.425,h * 0.75,w * 0.08,h * 0.21,5)
            draw.SimpleText("CLAIMED","vanilla_font_mini",w * 0.4625,h * 0.97,colourTable.textcolour,TEXT_ALIGN_CENTER,TEXT_ALIGN_TOP)
        end

        surface.SetTextPos(w * 0.525,h * 0.71) surface.SetFont("vanilla_font_minibig") surface.DrawText("DAY 6")
        draw.RoundedBox(10,w * 0.525,h * 0.75,w * 0.08,h * 0.21,colourTable.grid)
        surface.SetDrawColor(colourTable.textcolour) surface.SetMaterial(credits) surface.DrawTexturedRect(w * 0.542,h * 0.78,w * 0.05,h * 0.1)
        draw.SimpleText("5000 credits","vanilla_font_mini",w * 0.5625,h * 0.915,colourTable.textcolour,TEXT_ALIGN_CENTER,TEXT_ALIGN_TOP)
        if dataTable.day >= 6 then
            surface.SetDrawColor(colourTable.highlightcolour)
            surface.DrawOutlinedRect(w * 0.525,h * 0.75,w * 0.08,h * 0.21,5)
            draw.SimpleText("CLAIMED","vanilla_font_mini",w * 0.5625,h * 0.97,colourTable.textcolour,TEXT_ALIGN_CENTER,TEXT_ALIGN_TOP)
        end

        surface.SetTextPos(w * 0.625,h * 0.71) surface.SetFont("vanilla_font_minibig") surface.DrawText("DAY 7")
        draw.RoundedBox(10,w * 0.625,h * 0.75,w * 0.08,h * 0.21,colourTable.grid)
        surface.SetDrawColor(colourTable.textcolour) surface.SetMaterial(augment) surface.DrawTexturedRect(w * 0.638,h * 0.785,w * 0.055,h * 0.097)
        draw.SimpleText("2 augment points","vanilla_font_mini",w * 0.6625,h * 0.915,colourTable.textcolour,TEXT_ALIGN_CENTER,TEXT_ALIGN_TOP)
        if dataTable.day == 7 then
            surface.SetDrawColor(colourTable.highlightcolour)
            surface.DrawOutlinedRect(w * 0.625,h * 0.75,w * 0.08,h * 0.21,5)
            draw.SimpleText("CLAIMED","vanilla_font_mini",w * 0.6625,h * 0.97,colourTable.textcolour,TEXT_ALIGN_CENTER,TEXT_ALIGN_TOP)
        end

        //current day outline
        surface.SetDrawColor(colourTable.textcolour)
        surface.DrawOutlinedRect(w * offset,h * 0.75,w * 0.08,h * 0.21,5)

        //Streak bonus
        surface.SetTextColor(colourTable.highlightcolour)
        surface.SetFont("vanilla_font_minibig")
        surface.SetTextPos(w * 0.8,h * 0.65)
        surface.DrawText("NEXT STREAK BONUS")

        surface.SetTextColor(colourTable.textcolour)
        surface.SetTextPos(w * 0.8,h * 0.71) surface.SetFont("vanilla_font_minibig") surface.DrawText("DAY " .. nextbonus.Day)
        draw.RoundedBox(10,w * 0.8,h * 0.75,w * 0.175,h * 0.21,colourTable.grid)
        surface.SetDrawColor(colourTable.textcolour) surface.SetMaterial(streak) surface.DrawTexturedRect(w * 0.825,h * 0.78,w * 0.13,h * 0.1)
        draw.SimpleText(nextbonus.Reward1 .. " + " .. nextbonus.Reward2,"vanilla_font_mini",w * 0.885,h * 0.915,colourTable.textcolour,TEXT_ALIGN_CENTER,TEXT_ALIGN_TOP)
        if dataTable.currentStreak == kuchinawa.Day then
            surface.SetDrawColor(colourTable.highlightcolour)
            surface.DrawOutlinedRect(w * 0.8,h * 0.75,w * 0.175,h * 0.21,5)
            draw.SimpleText("CLAIMED","vanilla_font_mini",w * 0.885,h * 0.97,colourTable.textcolour,TEXT_ALIGN_CENTER,TEXT_ALIGN_TOP)
        end
        if shouldShow == true then
            surface.SetDrawColor(colourTable.textcolour)
            surface.DrawOutlinedRect(w * 0.8,h * 0.75,w * 0.175,h * 0.21,5)
        end
    end

    local hate = vgui.Create("DButton",canvas)
    hate:SetSize(ScrW() * 0.035, ScrW() * 0.035)
    hate:SetPos(ScrW() * 0.95, ScrH() * 0.025)
    hate:SetText("")
    hate.Paint = function(self,w,h)
        draw.RoundedBox( 10, 0, 0, w, h, colourTable.grid )
        draw.DrawText( "X", "vanilla_font_splashinfo", w * 0.475, h * 0.27, colourTable.textcolour, TEXT_ALIGN_CENTER)
    end
    hate.DoClick = function()
        canvas:Close()
    end

    local love = vgui.Create("DModelPanel",canvas)
    love:SetSize(ScrW() * 0.15,ScrH() * 0.4)
    love:SetPos(ScrW() * 0.025,ScrH() * 0.15)
    love:SetModel(LocalPlayer():GetModel())
    love:SetFOV(50)

    local pain = vgui.Create("DHTML",canvas)
    pain:SetSize(ScrW() * 0.4245,ScrH() * 0.391)
    pain:SetPos(ScrW() * 0.5425, ScrH() * 0.1749)
    pain:OpenURL( "https://imperialgaming.net/patchnotes/" )

    if dataTable.claimed == true then
        offset = -1
    elseif dataTable.day == 1 then
        offset = 0.025
    else
        offset = ((dataTable.day - 1) * 0.1) + 0.025
    end

    local worthlessness = vgui.Create("DButton",canvas)
    worthlessness:SetText("")
    worthlessness:SetSize(ScrW() * 0.08,ScrH() * 0.02)
    worthlessness:SetPos(ScrW() * offset,ScrH() * 0.97)
    worthlessness.DoClick = function()
        net.Start("VANILLALOGIN_net_RequestClaim")
        net.WriteBool(false)
        net.SendToServer()
        dataTable.claimed = true
        worthlessness:SetEnabled(false)
    end
    worthlessness.Paint = function(self, w, h)
        if dataTable.claimed == false then
            draw.RoundedBox( 10, 0, 0, w, h, colourTable.grid )
            draw.DrawText( "CLAIM", "vanilla_font_mini", w * 0.475, h * 0.1, colourTable.textcolour, TEXT_ALIGN_CENTER)
        end
    end

    local suffering = vgui.Create("DButton",canvas)
    suffering:SetText("")
    suffering:SetSize(ScrW() * 0.175,ScrH() * 0.02)
    suffering:SetPos(ScrW() * 0.8,ScrH() * 0.97)
    if dataTable.currentStreak ~= kuchinawa.Day or dataTable.claimed2 == true then
        suffering:SetEnabled(false)
        shouldShow = false
    end
    suffering.DoClick = function()
        net.Start("VANILLALOGIN_net_RequestClaim")
        net.WriteBool(true)
        net.SendToServer()
        shouldShow = false
        dataTable.claimed2 = true
        suffering:SetEnabled(false)
    end
    suffering.Paint = function(self, w, h)
        if dataTable.claimed2 == false and dataTable.currentStreak == kuchinawa.Day then
            draw.RoundedBox( 10, 0, 0, w, h, colourTable.grid )
            draw.DrawText( "CLAIM", "vanilla_font_mini", w * 0.475, h * 0.1, colourTable.textcolour, TEXT_ALIGN_CENTER)
        end
    end

end)
