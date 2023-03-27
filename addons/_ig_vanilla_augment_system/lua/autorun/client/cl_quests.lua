//------------------------PIN INFO--------------------\\
local pinTbl = {}
pinTbl.Name = ""
pinTbl.Type = ""
pinTbl.Reward = ""
pinTbl.Info = ""
pinTbl.Progress = ""
pinTbl.Amount = ""

//------------------------------SIDE BAR INFO--------------------\\

local sidebar = {}
sidebar.Name = "Click on a Quest"
sidebar.Type = "to read its information"
sidebar.Reward = ""
sidebar.Info = ""
sidebar.Progress = ""
sidebar.Amount = "1"

//EMPTY TABLE
local emptTbl = {}
emptTbl.Name = ""
emptTbl.Type = ""
emptTbl.Reward = ""
emptTbl.Info = ""
emptTbl.Progress = ""
emptTbl.Amount = ""

local dailyCol = Color(0, 146, 204)
local weeklyCol = Color(255, 158, 205)

//DATA!
local questData, weeklyData, plyData
net.Receive("VANILLAAUGMENTS_net_SendDailies",function()
    questData = net.ReadTable()

    if pinTbl.Name == "" then return end
    if pinTbl.Type == "Weekly" then return end

    for k, v in pairs(questData) do
        if v.Name == pinTbl.Name then
            table.Merge(pinTbl,v)
        end
    end

    if pinTbl.Progress == pinTbl.Amount then pinTbl.Name = "" end
end)
net.Receive("VANILLAAUGMENTS_net_SendWeeklies",function()
    weeklyData = net.ReadTable()

    if pinTbl.Name == "" then return end
    if pinTbl.Type == "Daily" then return end

    for k, v in pairs(weeklyData) do
        if v.Name == pinTbl.Name then
            table.Merge(pinTbl,v)
        end
    end

    if pinTbl.Progress == pinTbl.Amount then pinTbl.Name = "" end
end)
net.Receive("VANILLAAUGMENTS_net_SendPlayerData",function()
    plyData = net.ReadTable()
end)

function QuestHUD()
    sidebar.Name = "Click on a Quest"
    sidebar.Type = "to read its information"
    sidebar.Reward = ""
    sidebar.Info = ""
    sidebar.Progress = ""
    sidebar.Amount = "1"

    //Whole Frame
    local sFrame = vgui.Create("DFrame")
    sFrame:SetSize(ScrW() * 0.9, ScrH() * 0.9)
    sFrame:Center()
    sFrame:MakePopup()
    sFrame:SetTitle("")
    sFrame:NoClipping(true)
    sFrame:SetDraggable(false)
    sFrame.Paint = function(self, w, h)
        surface.SetDrawColor(Color(200, 200, 200, 220))
        surface.DrawRect(0,0,w,h)
    end

    local fx, fy = sFrame:GetSize()

    //Sidebar Frame
    local cFrame = vgui.Create("DPanel", sFrame)
    cFrame:SetSize(fx * 0.25, fy)
    cFrame:Dock(LEFT)
    cFrame:DockMargin(-10,-30,0,-30)
    cFrame.Paint = function(self, w, h)
    end

    local sx, sy = cFrame:GetSize()

//--------------------------------MAIN QUEST CONTENT----------------------------------\\

    local mPanel = vgui.Create("DPanel",sFrame)
    mPanel:DockMargin(sx * 0.07,0,sx * 0.05,sy * 0.03)
    mPanel:Dock(FILL)

    mPanel:InvalidateParent( true )
    local x,y = mPanel:GetSize()

    local progBarLen = x / 1.8

    local qH = y / 8
    local qD = (y * 0.005)
    mPanel.Paint = function(self,w,h)
        //Daily 1
            //Frame
        surface.SetDrawColor(255, 255, 255, 200)
        surface.DrawRect(0,0,w,qH)

        //Quest Info
        surface.SetTextColor(100,100,100)
        surface.SetTextPos(w * 0.08,h * 0.05)
        surface.DrawText(questData[1].Name)
        if questData[1].Name ~= "Completed" then
                //Daily Text
            surface.SetTextColor(dailyCol)
            surface.SetTextPos(w * 0.01,h * 0.05)
            surface.DrawText("Daily")
                //Progress Bar
            surface.SetDrawColor(200,200,200)
            surface.DrawRect(w * 0.3,h * 0.055,progBarLen * (questData[1].Progress / questData[1].Amount), h * 0.02)
            surface.SetDrawColor(100,100,100)
            surface.DrawOutlinedRect(w * 0.3,h * 0.055,progBarLen, h * 0.02)
            surface.SetTextPos(w * 0.9,h * 0.05)
            surface.DrawText(questData[1].Progress .. " / " .. questData[1].Amount)
        end

        //Daily 2
        surface.SetDrawColor(255, 255, 255, 200)
        surface.DrawRect(0,qH + qD,w,qH)

        //Quest Info
        surface.SetTextColor(100,100,100)
        surface.SetTextPos(w * 0.08,h * 0.05 + (qH + qD))
        surface.DrawText(questData[2].Name)
        if questData[2].Name ~= "Completed" then
                //Daily Text
            surface.SetTextColor(dailyCol)
            surface.SetTextPos(w * 0.01,h * 0.05 + (qH + qD))
            surface.DrawText("Daily")
                //Progress Bar
            surface.SetDrawColor(200,200,200)
            surface.DrawRect(w * 0.3,h * 0.055 + (qH + qD),progBarLen * (questData[2].Progress / questData[2].Amount), h * 0.02)
            surface.SetDrawColor(100,100,100)
            surface.DrawOutlinedRect(w * 0.3,h * 0.055 + (qH + qD),progBarLen, h * 0.02)
            surface.SetTextPos(w * 0.9,h * 0.05 + (qH + qD))
            surface.DrawText(questData[2].Progress .. " / " .. questData[2].Amount)
        end

        //Daily 3
        surface.SetDrawColor(255, 255, 255, 200)
        surface.DrawRect(0,2 * (qH + qD),w,qH)

        //Quest Info
        surface.SetTextColor(100,100,100)
        surface.SetTextPos(w * 0.08,h * 0.05 + (2 * (qH + qD)))
        surface.DrawText(questData[3].Name)
        if questData[3].Name ~= "Completed" then
                //Daily Text
            surface.SetTextColor(dailyCol)
            surface.SetTextPos(w * 0.01,h * 0.05 + (2 * (qH + qD)))
            surface.DrawText("Daily")
                //Progress Bar
            surface.SetDrawColor(200,200,200)
            surface.DrawRect(w * 0.3,h * 0.055 + (2 * (qH + qD)),progBarLen * (questData[3].Progress / questData[3].Amount), h * 0.02)
            surface.SetDrawColor(100,100,100)
            surface.DrawOutlinedRect(w * 0.3,h * 0.055 + (2 * (qH + qD)),progBarLen, h * 0.02)
            surface.SetTextPos(w * 0.9,h * 0.05 + (2 * (qH + qD)))
            surface.DrawText(questData[3].Progress .. " / " .. questData[3].Amount)
        end

        //Daily 4
        surface.SetDrawColor(255, 255, 255, 200)
        surface.DrawRect(0,3 * (qH + qD),w,qH)

        //Quest Info
        surface.SetTextColor(100,100,100)
        surface.SetTextPos(w * 0.08,h * 0.05 + (3 * (qH + qD)))
        surface.DrawText(questData[4].Name)
        if questData[4].Name ~= "Completed" then
                //Daily Text
            surface.SetTextColor(dailyCol)
            surface.SetTextPos(w * 0.01,h * 0.05 + (3 * (qH + qD)))
            surface.DrawText("Daily")
                //Progress Bar
            surface.SetDrawColor(200,200,200)
            surface.DrawRect(w * 0.3,h * 0.055 + (3 * (qH + qD)),progBarLen * (questData[4].Progress / questData[4].Amount), h * 0.02)
            surface.SetDrawColor(100,100,100)
            surface.DrawOutlinedRect(w * 0.3,h * 0.055 + (3 * (qH + qD)),progBarLen, h * 0.02)
            surface.SetTextPos(w * 0.9,h * 0.05 + (3 * (qH + qD)))
            surface.DrawText(questData[4].Progress .. " / " .. questData[4].Amount)
        end

        //Weekly 1
        surface.SetDrawColor(255, 255, 255, 200)
        surface.DrawRect(0,4 * qH + 20 * qD,w,qH)

        //Quest Info
        surface.SetTextColor(100,100,100)
        surface.SetTextPos(w * 0.08,h * 0.05 + (4 * qH + 20 * qD))
        surface.DrawText(weeklyData[1].Name)
            //Weekly Text
        if weeklyData[1].Name ~= "Completed" then
            surface.SetTextColor(weeklyCol)
            surface.SetTextPos(w * 0.01,h * 0.05 + (4 * qH + 20 * qD))
            surface.DrawText("Weekly")
                //Progress Bar
            surface.SetDrawColor(200,200,200)
            surface.DrawRect(w * 0.3,h * 0.055 + (4 * qH + 20 * qD),progBarLen * (weeklyData[1].Progress / weeklyData[1].Amount), h * 0.02)
            surface.SetDrawColor(100,100,100)
            surface.DrawOutlinedRect(w * 0.3,h * 0.055 + (4 * qH + 20 * qD),progBarLen, h * 0.02)
            surface.SetTextPos(w * 0.9,h * 0.05 + (4 * qH + 20 * qD))
            surface.DrawText(weeklyData[1].Progress .. " / " .. weeklyData[1].Amount)
        end

        //Weekly 2
        surface.SetDrawColor(255, 255, 255, 200)
        surface.DrawRect(0,5 * qH + 21 * qD,w,qH)

        //Quest Info
        surface.SetTextColor(100,100,100)
        surface.SetTextPos(w * 0.08,h * 0.05 + (5 * qH + 21 * qD))
        surface.DrawText(weeklyData[2].Name)
            //Weekly Text
        if weeklyData[2].Name ~= "Completed" then
            surface.SetTextColor(weeklyCol)
            surface.SetTextPos(w * 0.01,h * 0.05 + (5 * qH + 21 * qD))
            surface.DrawText("Weekly")
                //Progress Bar
            surface.SetDrawColor(200,200,200)
            surface.DrawRect(w * 0.3,h * 0.055 + (5 * qH + 21 * qD),progBarLen * (weeklyData[2].Progress / weeklyData[2].Amount), h * 0.02)
            surface.SetDrawColor(100,100,100)
            surface.DrawOutlinedRect(w * 0.3,h * 0.055 + (5 * qH + 21 * qD),progBarLen, h * 0.02)
            surface.SetTextPos(w * 0.9,h * 0.05 + (5 * qH + 21 * qD))
            surface.DrawText(weeklyData[2].Progress .. " / " .. weeklyData[2].Amount)
        end

        //Weekly 3
        surface.SetDrawColor(255, 255, 255, 200)
        surface.DrawRect(0,6 * qH + 22 * qD,w,qH)
        //Quest Info
        surface.SetTextColor(100,100,100)
        surface.SetTextPos(w * 0.08,h * 0.05 + (6 * qH + 22 * qD))
        surface.DrawText(weeklyData[3].Name)
            //Weekly Text
        if weeklyData[3].Name ~= "Completed" then
            surface.SetTextColor(weeklyCol)
            surface.SetTextPos(w * 0.01,h * 0.05 + (6 * qH + 22 * qD))
            surface.DrawText("Weekly")
                //Progress Bar
            surface.SetDrawColor(200,200,200)
            surface.DrawRect(w * 0.3,h * 0.055 + (6 * qH + 22 * qD),progBarLen * (weeklyData[3].Progress / weeklyData[3].Amount), h * 0.02)
            surface.SetDrawColor(100,100,100)
            surface.DrawOutlinedRect(w * 0.3,h * 0.055 + (6 * qH + 22 * qD),progBarLen, h * 0.02)
            surface.SetTextPos(w * 0.9,h * 0.05 + (6 * qH + 22 * qD))
            surface.DrawText(weeklyData[3].Progress .. " / " .. weeklyData[3].Amount)
        end

        //OUTLINES
        surface.SetDrawColor(dailyCol)
        surface.DrawOutlinedRect(0,0,w,qH)
        surface.DrawOutlinedRect(0,qH + qD,w,qH)
        surface.DrawOutlinedRect(0,2 * qH + 2 * qD,w,qH)
        surface.DrawOutlinedRect(0,3 * qH + 3 * qD,w,qH)

        surface.SetDrawColor(weeklyCol)
        surface.DrawOutlinedRect(0,4 * qH + 20 * qD,w,qH)
        surface.DrawOutlinedRect(0,5 * qH + 21 * qD,w,qH)
        surface.DrawOutlinedRect(0,6 * qH + 22 * qD,w,qH)
    end

    //buton
    local d1Button = vgui.Create("DButton",mPanel)
    d1Button:SetPos(0,0)
    d1Button:SetSize(x,qH)
    d1Button:SetText("")
    d1Button.Paint = function() end
    d1Button.DoClick = function()
        if questData[1].Name ~= "Completed" then
            table.Merge(sidebar,questData[1])
        end
    end

    local d2Button = vgui.Create("DButton",mPanel)
    d2Button:SetPos(0,qH + qD)
    d2Button:SetSize(x,qH)
    d2Button:SetText("")
    d2Button.Paint = function() end
    d2Button.DoClick = function()
        if questData[2].Name ~= "Completed" then
            table.Merge(sidebar,questData[2])
        end
    end

    local d3Button = vgui.Create("DButton",mPanel)
    d3Button:SetPos(0,2 * (qH + qD))
    d3Button:SetSize(x,qH)
    d3Button:SetText("")
    d3Button.Paint = function() end
    d3Button.DoClick = function()
        if questData[3].Name ~= "Completed" then
            table.Merge(sidebar,questData[3])
        end
    end

    local d4Button = vgui.Create("DButton",mPanel)
    d4Button:SetPos(0,3 * (qH + qD))
    d4Button:SetSize(x,qH)
    d4Button:SetText("")
    d4Button.Paint = function() end
    d4Button.DoClick = function()
        if questData[4].Name ~= "Completed" then
            table.Merge(sidebar,questData[4])
        end
    end

    local w1Button = vgui.Create("DButton",mPanel)
    w1Button:SetPos(0,4 * qH + 20 * qD)
    w1Button:SetSize(x,qH)
    w1Button:SetText("")
    w1Button.Paint = function() end
    w1Button.DoClick = function()
        if weeklyData[1].Name ~= "Completed" then
            table.Merge(sidebar,weeklyData[1])
        end
    end

    local w2Button = vgui.Create("DButton",mPanel)
    w2Button:SetPos(0,5 * qH + 21 * qD)
    w2Button:SetSize(x,qH)
    w2Button:SetText("")
    w2Button.Paint = function() end
    w2Button.DoClick = function()
        if weeklyData[2].Name ~= "Completed" then
            table.Merge(sidebar,weeklyData[2])
        end
    end

    local w3Button = vgui.Create("DButton",mPanel)
    w3Button:SetPos(0,6 * qH + 22 * qD)
    w3Button:SetSize(x,qH)
    w3Button:SetText("")
    w3Button.Paint = function() end
    w3Button.DoClick = function()
        if weeklyData[3].Name ~= "Completed" then
            table.Merge(sidebar,weeklyData[3])
        end
    end

//--------------------------------SIDEBAR CONTENT----------------------------------\\
    //Sidebar Panel 1 - QUESTS text
    local sb1 = vgui.Create("DPanel", cFrame)
    sb1:Dock(TOP)
    sb1:SetSize(sx, sy * 0.2)
    sb1:InvalidateParent()
    sb1.Paint = function(self,w,h)
        surface.SetDrawColor(255, 255, 255, 200)
        surface.DrawRect(0,0,w,h)

        surface.SetTextColor(102, 205, 217,255)
        surface.SetFont("GModToolName")
        surface.SetTextPos(w * 0.21,h * 0.15)
        surface.DrawText("QUESTS")
    end

    //reset augments button
    local sb1x,sb1y = sb1:GetSize()
    local hate = vgui.Create("DButton",sb1)
    hate:SetPos(sb1x * 0.05, sb1y * 0.6)
    hate:SetSize(sb1x * 0.4,sb1y * 0.3)
    hate:SetText("")
    hate.Paint = function(self,w,h)
        draw.SimpleText( "REROLL WEEKLY", "GModToolHelp", w / 2,h / 2, Color(102, 205, 217,255), TEXT_ALIGN_CENTER,  TEXT_ALIGN_BOTTOM )
        draw.SimpleText( "[10k credits]", "GModToolHelp", w / 2,h / 2, Color(102, 205, 217,255), TEXT_ALIGN_CENTER,  TEXT_ALIGN_TOP )

        surface.SetDrawColor(102, 205, 217,255)
        surface.DrawOutlinedRect(0,0,w,h)
    end
    hate.DoClick = function()
        sFrame:Close()

        //open are you sure menu
        local ays = vgui.Create("DFrame")
        ays:SetSize(ScrW() * 0.3, ScrH() * 0.3)
        ays:Center()
        ays:MakePopup()
        ays:SetTitle("")
        ays:NoClipping(true)
        ays:SetDraggable(false)
        ays.Paint = function(self, w, h)
            surface.SetDrawColor(Color(255, 255, 255, 200))
            surface.DrawRect(0,0,w,h)

            draw.SimpleText( "ARE YOU SURE?", "GModToolName", w / 2,h * 0.1, Color(102, 205, 217,255), TEXT_ALIGN_CENTER,  TEXT_ALIGN_TOP )
            draw.SimpleText( "Rerolling your weekly quests will cost 10,000 credits", "GModToolHelp", w / 2,h * 0.5, Color(100,100,100,255), TEXT_ALIGN_CENTER,  TEXT_ALIGN_BOTTOM )
            draw.SimpleText( "and will only reroll non-completed quests.", "GModToolHelp", w / 2,h * 0.5, Color(100,100,100,255), TEXT_ALIGN_CENTER,  TEXT_ALIGN_TOP )
        end

        local aysx,aysy = ays:GetSize()

        local yes = vgui.Create("DButton",ays)
        yes:SetSize(aysx * 0.3, aysy * 0.2)
        yes:SetPos(aysx * 0.15, aysy * 0.7)
        yes:SetText("")
        yes.Paint = function(self,w,h)
            draw.SimpleText( "YES", "GModToolHelp", w / 2,h / 2, Color(102, 205, 217,255), TEXT_ALIGN_CENTER,  TEXT_ALIGN_CENTER )

            surface.SetDrawColor(102, 205, 217,255)
            surface.DrawOutlinedRect(0,0,w,h)
        end
        yes.DoClick = function()
            net.Start("VANILLAAUGMENTS_net_RerollQuests")
            net.WriteBool(true)
            net.SendToServer()
            ays:Close()
        end

        local no = vgui.Create("DButton",ays)
        no:SetSize(aysx * 0.3, aysy * 0.2)
        no:SetPos(aysx * 0.55, aysy * 0.7)
        no:SetText("")
        no.Paint = function(self,w,h)
            draw.SimpleText( "NO", "GModToolHelp", w / 2,h / 2, Color(102, 205, 217,255), TEXT_ALIGN_CENTER,  TEXT_ALIGN_CENTER )

            surface.SetDrawColor(102, 205, 217,255)
            surface.DrawOutlinedRect(0,0,w,h)
        end
        no.DoClick = function()
            ays:Close()
        end
    end

    local pain = vgui.Create("DButton",sb1)
    pain:SetPos(sb1x * 0.55, sb1y * 0.6)
    pain:SetSize(sb1x * 0.4,sb1y * 0.3)
    pain:SetText("")
    pain.Paint = function(self,w,h)
        draw.SimpleText( "REROLL DAILY", "GModToolHelp", w / 2,h / 2, Color(102, 205, 217,255), TEXT_ALIGN_CENTER,  TEXT_ALIGN_BOTTOM )
        draw.SimpleText( "[5k credits]", "GModToolHelp", w / 2,h / 2, Color(102, 205, 217,255), TEXT_ALIGN_CENTER,  TEXT_ALIGN_TOP )

        surface.SetDrawColor(102, 205, 217,255)
        surface.DrawOutlinedRect(0,0,w,h)
    end
    pain.DoClick = function()
        sFrame:Close()

        //open are you sure menu
        local ays = vgui.Create("DFrame")
        ays:SetSize(ScrW() * 0.3, ScrH() * 0.3)
        ays:Center()
        ays:MakePopup()
        ays:SetTitle("")
        ays:NoClipping(true)
        ays:SetDraggable(false)
        ays.Paint = function(self, w, h)
            surface.SetDrawColor(Color(255, 255, 255, 200))
            surface.DrawRect(0,0,w,h)

            draw.SimpleText( "ARE YOU SURE?", "GModToolName", w / 2,h * 0.1, Color(102, 205, 217,255), TEXT_ALIGN_CENTER,  TEXT_ALIGN_TOP )
            draw.SimpleText( "Rerolling your daily quests will cost 5,000 credits", "GModToolHelp", w / 2,h * 0.5, Color(100,100,100,255), TEXT_ALIGN_CENTER,  TEXT_ALIGN_BOTTOM )
            draw.SimpleText( "and will only reroll non-completed quests.", "GModToolHelp", w / 2,h * 0.5, Color(100,100,100,255), TEXT_ALIGN_CENTER,  TEXT_ALIGN_TOP )
        end

        local aysx,aysy = ays:GetSize()

        local yes = vgui.Create("DButton",ays)
        yes:SetSize(aysx * 0.3, aysy * 0.2)
        yes:SetPos(aysx * 0.15, aysy * 0.7)
        yes:SetText("")
        yes.Paint = function(self,w,h)
            draw.SimpleText( "YES", "GModToolHelp", w / 2,h / 2, Color(102, 205, 217,255), TEXT_ALIGN_CENTER,  TEXT_ALIGN_CENTER )

            surface.SetDrawColor(102, 205, 217,255)
            surface.DrawOutlinedRect(0,0,w,h)
        end
        yes.DoClick = function()
            net.Start("VANILLAAUGMENTS_net_RerollQuests")
            net.WriteBool(false)
            net.SendToServer()
            ays:Close()
        end

        local no = vgui.Create("DButton",ays)
        no:SetSize(aysx * 0.3, aysy * 0.2)
        no:SetPos(aysx * 0.55, aysy * 0.7)
        no:SetText("")
        no.Paint = function(self,w,h)
            draw.SimpleText( "NO", "GModToolHelp", w / 2,h / 2, Color(102, 205, 217,255), TEXT_ALIGN_CENTER,  TEXT_ALIGN_CENTER )

            surface.SetDrawColor(102, 205, 217,255)
            surface.DrawOutlinedRect(0,0,w,h)
        end
        no.DoClick = function()
            ays:Close()
        end
    end

    //Sidebar Panel 2 - Quest information

    local sb2 = vgui.Create("DPanel", cFrame)
    sb2:Dock(FILL)
    sb2:DockMargin(0,30,0,30)
    sb2:SetSize(sx, sy * 0.6)

    //MiniPanel
    local mp1 = vgui.Create("DPanel", sb2)
    mp1:SetSize(sx,sy * 0.15)
    mp1:Dock(TOP)

    mp1:InvalidateParent( true )
    local mpx, mpy = mp1:GetSize()
    mp1.Paint = function()

        //Quest Name
        surface.SetFont("GModToolSubtitle")

        surface.SetTextColor(100,100,100,255)
        surface.SetTextPos(mpx * 0.1,mpy * 0.54)
        surface.DrawText(sidebar.Name .. " - ")

        if sidebar.Type == "Weekly" then
            surface.SetTextColor(weeklyCol)
        else
            surface.SetTextColor(dailyCol)
        end
        surface.DrawText(sidebar.Type)
    end

    //Quest Description
    local sDesc = vgui.Create("DLabel", sb2)
    sDesc:Dock(TOP)
    sDesc:SetText("")
    sDesc:DockMargin(mpx * 0.1,mpy * 0.62,mpx * 0.1,0)
    sDesc:SetWrap(true)
    sDesc:SetTextColor(Color(100, 100, 100))
    sDesc:SetFont("GModToolHelp")
    sDesc:SetAutoStretchVertical(true)

    sb2.Paint = function(self,w,h)
        surface.SetDrawColor(255, 255, 255, 200)
        surface.DrawRect(0,0,w,h)

        //Quest Rewards
        if sidebar.Name ~= "Click on a Quest" then
            surface.SetFont("GModToolHelp")
            surface.SetTextColor(102, 205, 217,255)
            surface.SetTextPos(mpx * 0.1,mpy * 1)
            surface.DrawText("Rewards:")
            surface.SetTextPos(mpx * 0.1,mpy * 1.5)
            surface.DrawText("Conditions:")
            surface.SetTextPos(mpx * 0.1,mpy * 2)
            surface.DrawText("Progress:")

            surface.SetTextPos(mpx * 0.1,mpy * 1.13)
            surface.SetTextColor(100, 100, 100,255)
            surface.DrawText(sidebar.Reward)
            sDesc:SetText(sidebar.Info)

            //Progress Bar
            local progBarLen2 = mpx / 1.6

            surface.SetDrawColor(200,200,200)
            surface.DrawRect(mpx * 0.1,mpy * 2.15,progBarLen2 * (sidebar.Progress / sidebar.Amount),mpy / 8)
            surface.SetDrawColor(100,100,100)
            surface.DrawOutlinedRect(mpx * 0.1,mpy * 2.15,progBarLen2,mpy / 8)
            surface.SetTextPos(mpx * 0.8,mpy * 2.155)
            surface.DrawText(sidebar.Progress .. " / " .. sidebar.Amount)
        end
    end

    local sBuy = vgui.Create("DButton", sb2)
    sBuy:SetText("")
    sBuy:SetSize(mpx,mpy * 0.3)
    sBuy:Dock(BOTTOM)
    sBuy:DockMargin(mpx * 0.1,mpy * 0.1,mpx * 0.1,mpy * 0.2)
    sBuy.Paint = function(self,w,h)
        if tonumber(sidebar.Progress) == tonumber(sidebar.Amount) then
            draw.SimpleText( "Collect Reward", "GModToolHelp", w / 2,h / 2, Color(102, 205, 217,255), TEXT_ALIGN_CENTER,  TEXT_ALIGN_CENTER )

            surface.SetDrawColor(102, 205, 217,255)
            surface.DrawOutlinedRect(0,0,w,h)
        end
    end
    sBuy.DoClick = function()
        if sidebar.Name ~= "Click on a Quest" then
            net.Start("VANILLAAUGMENTS_net_CollectionAttempt")
            net.WriteTable(sidebar)
            net.SendToServer()
        end
    end

    local sPin = vgui.Create("DButton", sb2)
    sPin:SetText("")
    sPin:SetSize(mpx,mpy * 0.3)
    sPin:Dock(BOTTOM)
    sPin:DockMargin(mpx * 0.1,mpy * 0.1,mpx * 0.1,mpy * 0.1)
    sPin.Paint = function(self,w,h)
        if sidebar.Name ~= "Click on a Quest" and sidebar.Progress ~= sidebar.Amount then
            if sidebar.Name ~= pinTbl.Name then
                draw.SimpleText( "Pin Quest", "GModToolHelp", w / 2,h / 2, Color(102, 205, 217,255), TEXT_ALIGN_CENTER,  TEXT_ALIGN_CENTER )
            else
                draw.SimpleText( "Unpin Quest", "GModToolHelp", w / 2,h / 2, Color(102, 205, 217,255), TEXT_ALIGN_CENTER,  TEXT_ALIGN_CENTER )
            end

            surface.SetDrawColor(102, 205, 217,255)
            surface.DrawOutlinedRect(0,0,w,h)
        end
    end
    sPin.DoClick = function()
        if (sidebar.Name ~= "Click on a Quest") and sidebar.Progress ~= sidebar.Amount then
            if sidebar.Name ~= pinTbl.Name then
                table.Merge(pinTbl,sidebar)
            else
                table.Merge(pinTbl,emptTbl)
            end
        end
    end

    //sidebar Panel 3 - Skill points

    local sb3 = vgui.Create("DPanel", cFrame)
    sb3:Dock(BOTTOM)
    sb3:SetSize(sx, sy * 0.2)
    sb3.Paint = function(self,w,h)
        surface.SetDrawColor(255, 255, 255, 200)
        surface.DrawRect(0,0,w,h)

        draw.SimpleText( "Augment Points: " .. plyData.Points, "GModToolSubtitle", w / 2,h / 1.8, Color(100, 100, 100,255), TEXT_ALIGN_CENTER,  TEXT_ALIGN_CENTER )
        draw.SimpleText( "Imperial Credits: " .. LocalPlayer():SH_GetPremiumPoints(), "GModToolSubtitle", w / 2,h / 2.8, Color(100, 100, 100,255), TEXT_ALIGN_CENTER,  TEXT_ALIGN_CENTER )
    end
end
net.Receive("VANILLAAUGMENTS_net_OpenQuestMenu", QuestHUD)

function DrawQuestHUD()
    if pinTbl.Name ~= "" then

        local x,y = ScrW() * 0.8,ScrH() * 0.6
        _G.vanillaBlurPanel(x, y, ScrW() * 0.19, ScrH() * 0.08, Color(0,0,0,80));

        local progBarLen = ScrW() * 0.13

        surface.SetDrawColor(20,20,20)
        surface.DrawRect(x + ScrW() * 0.005,y + ScrH() * 0.055,progBarLen,ScrH() * 0.01)

        if pinTbl.Type == "Weekly" then
            surface.SetDrawColor(weeklyCol)
            surface.SetTextColor(weeklyCol)
        else
            surface.SetDrawColor(dailyCol)
            surface.SetTextColor(dailyCol)
        end

        surface.SetFont("GModToolHelp")
        surface.SetTextPos(x + ScrW() * 0.005,y + ScrH() * 0.02)
        surface.DrawText(pinTbl.Name .. " - " .. pinTbl.Type)

        surface.DrawRect(x + ScrW() * 0.005,y + ScrH() * 0.055,progBarLen * (pinTbl.Progress / pinTbl.Amount),ScrH() * 0.01)
        surface.SetTextPos(x + ScrW() * 0.145,y + ScrH() * 0.052)
        surface.DrawText(pinTbl.Progress .. " / " .. pinTbl.Amount)
    end
end
hook.Add( "HUDPaint", "VANILLAAUGMENTS_hook_DrawQuestHUD", DrawQuestHUD)

net.Receive("VANILLAAUGMENTS_net_QuestComplete",function()
    quest = net.ReadString()
    weekly = net.ReadBool()

    if weekly then
        chat.AddText( Color(255,255,255), "[" , weeklyCol, "QUEST", Color(255,255,255), "] You have completed the weekly quest: ", weeklyCol, quest, Color(255,255,255), "." )
    else
        chat.AddText( Color(255,255,255), "[" , dailyCol, "QUEST", Color(255,255,255), "] You have completed the daily quest: ", dailyCol, quest, Color(255,255,255), "." )
    end
    surface.PlaySound("garrysmod/save_load4.wav")
end)
net.Receive("VANILLAAUGMENTS_net_WeekComplete",function()
    chat.AddText( Color(255,255,255), "[" , weeklyCol, "QUEST", Color(255,255,255), "] You have completed all weekly quests. Therefore, you will receive: ", weeklyCol, "5000 credits, 5000 xp, and 5 augment points", Color(255,255,255), "." )
    surface.PlaySound("garrysmod/save_load4.wav")
end)
