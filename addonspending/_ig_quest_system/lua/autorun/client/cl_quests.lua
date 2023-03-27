-- They can change their quest table clientside but it will do shit all to help them lmao
net.Receive("NetworkQuestStuff", function()
    local questprog = net.ReadTable()
    LocalPlayer().questprogress = questprog
end)

local drawingvoice = false

net.Receive("NetworkVoiceChange", function()
    local smh = net.ReadString()

    if drawingvoice then
        hook.Remove("PostDrawTranslucentRenderables", "voicedistance")
    end

    drawingvoice = true

    hook.Add("PostDrawTranslucentRenderables", "voicedistance", function()
        cam.Start3D()
        local dis = math.sqrt(tonumber(smh))
        render.SetColorMaterial()
        render.DrawSphere(LocalPlayer():GetPos(), -dis, 20, 20, Color(255, 0, 0, 40))
        cam.End3D()
    end)

    timer.Simple(2, function()
        hook.Remove("PostDrawTranslucentRenderables", "voicedistance")
        drawingvoice = false
    end)
end)

net.Receive("NetworkQuestSound", function()
    sound.PlayFile("sound/questvictory.mp3", "", function(station)
        if (IsValid(station)) then
            station:Play()
        end
    end)
end)

net.Receive("OpenF7Quest", function()
    local QuestFrame = vgui.Create("DFrame")
    QuestFrame:SetSize(ScrW() / 1.25, ScrH() / 2)
    QuestFrame:Center()
    QuestFrame:SetTitle("")
    QuestFrame:SetVisible(true)
    QuestFrame:SetDraggable(false)
    QuestFrame:ShowCloseButton(true)
    QuestFrame:MakePopup()

    function QuestFrame:Paint(w, h)
        draw.RoundedBox(8, 0, 0, w, h, Color(0, 0, 0, 200))
    end

    local QLabel1 = vgui.Create("DLabel", QuestFrame)
    QLabel1:SetSize(QuestFrame:GetWide(), QuestFrame:GetTall() * 0.1)
    QLabel1:SetPos(QuestFrame:GetWide() / 2.55, QuestFrame:GetTall() * 0.1)
    QLabel1:SetText("")
    QLabel1:SetFont("Trebuchet24")
    local QLabel2 = vgui.Create("DLabel", QuestFrame)
    QLabel2:SetSize(QuestFrame:GetWide(), QuestFrame:GetTall() * 0.13)
    QLabel2:SetPos(QuestFrame:GetWide() / 2.55, QuestFrame:GetTall() * 0.13)
    QLabel2:SetText("")
    QLabel2:SetFont("Trebuchet24")
    local QLabel3 = vgui.Create("DLabel", QuestFrame)
    QLabel3:SetSize(QuestFrame:GetWide(), QuestFrame:GetTall() * 0.16)
    QLabel3:SetPos(QuestFrame:GetWide() / 2.55, QuestFrame:GetTall() * 0.16)
    QLabel3:SetText("")
    QLabel3:SetFont("Trebuchet24")
    local QLabel4 = vgui.Create("DLabel", QuestFrame)
    QLabel4:SetSize(QuestFrame:GetWide(), QuestFrame:GetTall() * 0.19)
    QLabel4:SetPos(QuestFrame:GetWide() / 2.55, QuestFrame:GetTall() * 0.19)
    QLabel4:SetText("")
    QLabel4:SetFont("Trebuchet24")
    local QLabel5 = vgui.Create("DLabel", QuestFrame)
    QLabel5:SetSize(QuestFrame:GetWide(), QuestFrame:GetTall() * 0.19)
    QLabel5:SetPos(QuestFrame:GetWide() / 2.55, QuestFrame:GetTall() * 0.23)
    QLabel5:SetText("")
    QLabel5:SetFont("Trebuchet24")
    local QuestList = vgui.Create("DListView", QuestFrame)
    QuestList:SetSize(QuestFrame:GetWide() / 3, QuestFrame:GetTall() / 1.25)
    QuestList:SetPos(QuestFrame:GetWide() / 20, QuestFrame:GetTall() * 0.1)
    QuestList:SetMultiSelect(false)
    QuestList:SetDataHeight(25)
    QuestList:AddColumn("Quest")

    QuestList.OnRowSelected = function(panel, rowIndex, row)
        if IGCATEGORYQUESTS[row:GetValue(2)][LocalPlayer().questprogress[row:GetValue(2)].Level].LVL == 4 then
            QLabel1:SetText(row:GetValue(1))
            QLabel2:SetText("Progress: Quest Completed")
            QLabel3:SetText("Instructions: Quest Completed")
            QLabel4:SetText("TIPS: Quest Completed")
            QLabel5:SetText("Reward: Quest Completed")
        else
            QLabel1:SetText(row:GetValue(1))
            QLabel2:SetText("Progress: " .. LocalPlayer().questprogress[row:GetValue(2)].Progress .. "/" .. IGCATEGORYQUESTS[row:GetValue(2)][LocalPlayer().questprogress[row:GetValue(2)].Level].Amount)
            QLabel3:SetText("Instructions: " .. IGCATEGORYQUESTS[row:GetValue(2)][LocalPlayer().questprogress[row:GetValue(2)].Level].Instructions)
            QLabel4:SetText(IGCATEGORYQUESTS[row:GetValue(2)][LocalPlayer().questprogress[row:GetValue(2)].Level].Tips)
            QLabel5:SetText("Reward: " .. IGCATEGORYQUESTS[row:GetValue(2)][LocalPlayer().questprogress[row:GetValue(2)].Level].LVL .. " quest points")
        end
    end

    function QuestList:Paint(w, h)
        -- dont need anything
    end

    for k, v in pairs(IGCATEGORYQUESTS) do
        QuestList:AddLine(IGCATEGORYQUESTS[k][LocalPlayer().questprogress[k].Level].Name, k)

        for k, v in pairs(QuestList:GetLines()) do
            function v:Paint(w, h)
                if v:IsHovered() and v:IsSelected() then
                    surface.SetDrawColor(90, 90, 90, 200)
                    surface.DrawRect(0, 0, QuestList:GetWide(), QuestList:GetTall())
                elseif v:IsHovered() then
                    surface.SetDrawColor(100, 100, 100, 200)
                    surface.DrawRect(0, 0, QuestList:GetWide(), QuestList:GetTall())
                elseif v:IsSelected() then
                    surface.SetDrawColor(100, 100, 100, 200)
                    surface.DrawRect(0, 0, QuestList:GetWide(), QuestList:GetTall())
                else
                    surface.SetDrawColor(60, 60, 60, 200)
                    surface.DrawRect(0, 0, QuestList:GetWide(), QuestList:GetTall())
                end
            end

            for _, column in pairs(v["Columns"]) do
                column:SetFont("Trebuchet24")

                if string.match(column:GetValue(1), "Completed") then
                    column:SetTextColor(Color(100, 255, 100, 255))
                else
                    column:SetTextColor(Color(255, 255, 255, 255))
                end
            end
        end
    end
end)

net.Receive("OpenSkillQuest", function()
    local Skillframe = vgui.Create("DFrame")
    Skillframe:SetSize(ScrW() *0.9,ScrH()*0.5)
    Skillframe:Center()
    Skillframe:MakePopup()
    Skillframe:SetTitle("Skills Menu")

    function Skillframe:Paint(w, h)
        draw.RoundedBox(8, 0, 0, w, h, Color(0, 0, 0, 200))
    end

    local DScrollPanel = vgui.Create("DScrollPanel", Skillframe)
    DScrollPanel:SetSize(Skillframe:GetWide() - 5, Skillframe:GetTall() - 60)
    DScrollPanel:Center()
    local DButtoner = DScrollPanel:Add("DButton")
    DButtoner:SetText("Progress Combat Line")
    DButtoner:SetTextColor(Color(50, 200, 50))
    DButtoner:SetFont("Trebuchet24")
    DButtoner:SetPos(Skillframe:GetWide()*0.1,0)
    DButtoner:SetSize(Skillframe:GetWide()*0.25,Skillframe:GetTall()*0.08)

    function DButtoner.DoClick()
        net.Start("RequestSkillProgress")
        net.WriteString("C")
        net.SendToServer()
        Skillframe:Close()
    end

    function DButtoner:Paint(w, h)
        draw.RoundedBox(8, 0, 0, w, h, Color(0, 0, 0, 200))
    end

    local DButtoner2 = DScrollPanel:Add("DButton")
    DButtoner2:SetText("Progress Profits Line")
    DButtoner2:SetTextColor(Color(50, 200, 50))
    DButtoner2:SetFont("Trebuchet24")
    DButtoner2:SetPos(Skillframe:GetWide()*0.4,0)
    DButtoner2:SetSize(Skillframe:GetWide()*0.25,Skillframe:GetTall()*0.08)

    function DButtoner2.DoClick()
        net.Start("RequestSkillProgress")
        net.WriteString("P")
        net.SendToServer()
        Skillframe:Close()
    end

    function DButtoner2:Paint(w, h)
        draw.RoundedBox(8, 0, 0, w, h, Color(0, 0, 0, 200))
    end

        local DButtoner3 = DScrollPanel:Add("DButton")
    DButtoner3:SetText("Progress Utility Line")
    DButtoner3:SetTextColor(Color(50, 200, 50))
    DButtoner3:SetFont("Trebuchet24")
    DButtoner3:SetPos(Skillframe:GetWide()*0.7,0)
    DButtoner3:SetSize(Skillframe:GetWide()*0.25,Skillframe:GetTall()*0.08)

    function DButtoner3.DoClick()
        net.Start("RequestSkillProgress")
        net.WriteString("U")
        net.SendToServer()
        Skillframe:Close()
    end

    function DButtoner3:Paint(w, h)
        draw.RoundedBox(8, 0, 0, w, h, Color(0, 0, 0, 200))
    end

    local questprogressc = LocalPlayer():GetNWInt("igprogressc", 0)
    local questprogressp = LocalPlayer():GetNWInt("igprogressp", 0)
    local questprogressu = LocalPlayer():GetNWInt("igprogressu", 0)

    for i = 1, #IGCSKILLS do
        local DButton = DScrollPanel:Add("DLabel")
        DButton:SetText(IGCSKILLS[i].Name)
        DButton:SetFont("Trebuchet18")

        if tonumber(questprogressc) >= tonumber(i) then
            DButton:SetTextColor(Color(50, 200, 50))
        else
            DButton:SetTextColor(Color(255, 255, 255))
        end

        DButton:SetPos(Skillframe:GetWide()*0.1, i * Skillframe:GetTall() / 8)
        DButton:SizeToContents()
        local DButton2 = DScrollPanel:Add("DLabel")
        DButton2:SetText(IGCSKILLS[i].Desc)
        DButton2:SetFont("Trebuchet18")

        if tonumber(questprogressc) >= tonumber(i) then
            DButton2:SetTextColor(Color(50, 200, 50))
        else
            DButton2:SetTextColor(Color(255, 255, 255))
        end

        local staysized1,staysized2 = DButton:GetPos()

        DButton2:SetPos(staysized1, (i * Skillframe:GetTall() / 8) + ScrH()*0.01353125)
        DButton2:SizeToContents()
        local DButton3 = DScrollPanel:Add("DLabel")
        DButton3:SetText("Cost: " .. IGCSKILLS[i].Cost .. " quest points")
        DButton3:SetFont("Trebuchet18")

        if tonumber(questprogressc) >= tonumber(i) then
            DButton3:SetTextColor(Color(50, 200, 50))
        else
            DButton3:SetTextColor(Color(255, 255, 255))
        end

        DButton3:SetPos(staysized1, (i * Skillframe:GetTall() / 8) + ScrH()*0.01353125*2)
        DButton3:SizeToContents()
    end

    for i = 1, #IGPSKILLS do
        local DButton = DScrollPanel:Add("DLabel")
        DButton:SetText(IGPSKILLS[i].Name)
        DButton:SetFont("Trebuchet18")

        if tonumber(questprogressp) >= tonumber(i) then
            DButton:SetTextColor(Color(50, 200, 50))
        else
            DButton:SetTextColor(Color(255, 255, 255))
        end

        DButton:SetPos(Skillframe:GetWide()*0.4, i * Skillframe:GetTall() / 8)
        DButton:SizeToContents()
        local DButton2 = DScrollPanel:Add("DLabel")
        DButton2:SetText(IGPSKILLS[i].Desc)
        DButton2:SetFont("Trebuchet18")

        if tonumber(questprogressp) >= tonumber(i) then
            DButton2:SetTextColor(Color(50, 200, 50))
        else
            DButton2:SetTextColor(Color(255, 255, 255))
        end

        local staysized1,staysized2 = DButton:GetPos()

        DButton2:SetPos(staysized1, (i * Skillframe:GetTall() / 8) + ScrH()*0.01353125)
        DButton2:SizeToContents()
        local DButton3 = DScrollPanel:Add("DLabel")
        DButton3:SetText("Cost: " .. IGPSKILLS[i].Cost .. " quest points")
        DButton3:SetFont("Trebuchet18")

        if tonumber(questprogressp) >= tonumber(i) then
            DButton3:SetTextColor(Color(50, 200, 50))
        else
            DButton3:SetTextColor(Color(255, 255, 255))
        end

        DButton3:SetPos(staysized1, (i * Skillframe:GetTall() / 8) + ScrH()*0.01353125*2)
        DButton3:SizeToContents()
    end

    for i = 1, #IGUSKILLS do
        local DButton = DScrollPanel:Add("DLabel")
        DButton:SetText(IGUSKILLS[i].Name)
        DButton:SetFont("Trebuchet18")

        if tonumber(questprogressu) >= tonumber(i) then
            DButton:SetTextColor(Color(50, 200, 50))
        else
            DButton:SetTextColor(Color(255, 255, 255))
        end

        DButton:SetPos(Skillframe:GetWide()*0.7, i * Skillframe:GetTall() / 8)
        DButton:SizeToContents()
        local DButton2 = DScrollPanel:Add("DLabel")
        DButton2:SetText(IGUSKILLS[i].Desc)
        DButton2:SetFont("Trebuchet18")

        if tonumber(questprogressu) >= tonumber(i) then
            DButton2:SetTextColor(Color(50, 200, 50))
        else
            DButton2:SetTextColor(Color(255, 255, 255))
        end

        local staysized1,staysized2 = DButton:GetPos()

        DButton2:SetPos(staysized1, (i * Skillframe:GetTall() / 8) + ScrH()*0.01353125)
        DButton2:SizeToContents()
        local DButton3 = DScrollPanel:Add("DLabel")
        DButton3:SetText("Cost: " .. IGUSKILLS[i].Cost .. " quest points")
        DButton3:SetFont("Trebuchet18")

        if tonumber(questprogressu) >= tonumber(i) then
            DButton3:SetTextColor(Color(50, 200, 50))
        else
            DButton3:SetTextColor(Color(255, 255, 255))
        end

        DButton3:SetPos(staysized1, (i * Skillframe:GetTall() / 8) + ScrH()*0.01353125*2)
        DButton3:SizeToContents()
    end
end)