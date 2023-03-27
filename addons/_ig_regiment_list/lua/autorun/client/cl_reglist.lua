surface.CreateFont("PilotMenuFont", {
    font = "Roboto",
    size = 22
})

function OpenRegListMenu()
    local size = net.ReadUInt(32)
    local decompressed = util.Decompress(net.ReadData(size))
    local regimentplayers = util.JSONToTable(decompressed)
    local frame = vgui.Create("DPanel") --Create outline frame
    frame:SetSize(600, 550)
    frame:Center()
    frame:SetVisible(true)
    frame:MakePopup()

    -- frame background
    frame.Paint = function(self, w, g)
        surface.SetDrawColor(255, 255, 255, 255)
        surface.DrawRect(0, 0, 600, 550)
    end

    local headerBackground = vgui.Create("DLabel", frame)
    headerBackground:SetPos(0, 0)
    headerBackground:SetSize(600, 30)
    headerBackground:SetText("")

    function headerBackground:Paint(w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(35, 35, 35, 255))
    end

    local headerLabel = vgui.Create("DLabel", frame)
    headerLabel:SetPos(10, 5)
    headerLabel:SetSize(500, 25)
    headerLabel:SetText("Regiment List Menu | Your regiment has: "..#regimentplayers.." players in it")
    headerLabel:SetFont("PilotMenuFont")
    headerLabel:SetTextColor(Color(255, 255, 255, 255))
    local applicantList = vgui.Create("DListView", frame) --List of applicants
    applicantList:SetMultiSelect(false)
    applicantList:SetSize(500, 400)
    applicantList:SetPos(50, 50)
    applicantList:AddColumn("Name")
    applicantList:AddColumn("SteamID")
    applicantList:AddColumn("Rank")
    applicantList:AddColumn("Job Count (Sorter)")
    applicantList.Paint = function()
        surface.SetDrawColor(255, 255, 255, 255)
        surface.DrawRect(0, 0, applicantList:GetWide(), applicantList:GetTall())
        surface.SetDrawColor(0, 0, 0, 255)
        surface.DrawOutlinedRect(0, 0, applicantList:GetWide(), applicantList:GetTall())
    end

    applicantList.OnRowRightClick = function(btn, line)
        local playerOptions = DermaMenu()
        
        playerOptions:AddOption("Promote", function()
            net.Start("PromoteBySteamID")
            net.WriteString(applicantList:GetLine(applicantList:GetSelectedLine()):GetColumnText(2))
            print("steamid got")
            net.SendToServer()
            print(applicantList:GetLine(applicantList:GetSelectedLine()):GetColumnText(2))
            print("steamid sent")
        end)
        playerOptions:AddOption("Demote", function()
            net.Start("DemoteBySteamID")
            net.WriteString(applicantList:GetLine(applicantList:GetSelectedLine()):GetColumnText(2))
            net.SendToServer()
        end)
        playerOptions:AddOption("Kick from Regiment", function()
            net.Start("RemoveBySteamID")
            net.WriteString(applicantList:GetLine(applicantList:GetSelectedLine()):GetColumnText(2))
            net.SendToServer()
        end)

        playerOptions:Open()
    end


    local closeIcon = vgui.Create("DButton", frame)
    closeIcon:SetTextColor(Color(60, 64, 82))
    closeIcon:SetText("X")
    closeIcon:SetFont("CloseCaption_Normal")
    closeIcon:SetSize(22, 21)
    closeIcon:SetPos(578, 0)

    closeIcon.Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(32, 36, 44))
    end

    closeIcon.DoClick = function()
        frame:SetVisible(false)
    end

    for _, v in pairs(regimentplayers) do
        applicantList:AddLine(v[1], v[2], v[3], v[4])
    end

    for _, line in pairs(applicantList:GetLines()) do
        function line:Paint(w, h)
            if self:IsHovered() then
                surface.SetDrawColor(180, 200, 200, 255)
                surface.DrawRect(0, 0, applicantList:GetWide(), applicantList:GetTall())
            else
                surface.SetDrawColor(200, 200, 200, 255)
                surface.DrawRect(0, 0, applicantList:GetWide(), applicantList:GetTall())
            end
        end

        -- if you want to change the text font/color of the columns
        for _, column in pairs(line["Columns"]) do
            column:SetFont("DermaDefault")
            column:SetTextColor(Color(255, 255, 255, 255))
        end
    end
end

net.Receive("regimentlistmenu", OpenRegListMenu)