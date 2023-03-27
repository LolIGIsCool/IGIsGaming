surface.CreateFont("PilotMenuFont", {
    font = "Roboto",
    size = 22
})

local function GetPlayersBlacklist(ply)
    if not (ply) then return end
    local blacklist = ply:GetNWString("blacklisted", "false")

    if blacklist == "true" then
        return "Yes"
    elseif blacklist == "false" then
        return "No"
    end
end

function OpenEMBlacklistMenu()
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
    headerLabel:SetText("EM Blacklist Menu")
    headerLabel:SetFont("PilotMenuFont")
    headerLabel:SetTextColor(Color(255, 255, 255, 255))
    local applicantList = vgui.Create("DListView", frame) --List of applicants
    applicantList:SetMultiSelect(false)
    applicantList:SetSize(500, 400)
    applicantList:SetPos(50, 50)
    applicantList:AddColumn("Name")
    applicantList:AddColumn("SteamID")
    applicantList:AddColumn("Regiment")
    applicantList:AddColumn("Blacklisted")
    applicantList.Paint = function()
        surface.SetDrawColor(255, 255, 255, 255)
        surface.DrawRect(0, 0, applicantList:GetWide(), applicantList:GetTall())
        surface.SetDrawColor(0, 0, 0, 255)
        surface.DrawOutlinedRect(0, 0, applicantList:GetWide(), applicantList:GetTall())
    end

    local buttonRevoke = vgui.Create("DButton", frame) --Revoke Button
    buttonRevoke:SetPos(frame:GetWide() - 300, frame:GetTall() - 70)
    buttonRevoke:SetSize(125, 25)
    buttonRevoke:SetText("Unblacklist")
    buttonRevoke:SetFont("PilotMenuFont")
    buttonRevoke:SetTextColor(Color(255, 255, 255, 255))

    -- The paint function
    buttonRevoke.Paint = function()
        surface.SetDrawColor(0, 0, 0, 255)
        surface.DrawRect(0, 0, buttonRevoke:GetWide(), buttonRevoke:GetTall())
    end

    buttonRevoke.DoClick = function()
        local selectedsteamid = applicantList:GetLine(applicantList:GetSelectedLine()):GetColumnText(2)
        net.Start("setplayerblacklist")
        net.WriteString("false")
        net.WriteString(selectedsteamid)
        net.SendToServer()
        frame:SetVisible(false)
    end

    local buttonAssign = vgui.Create("DButton", frame) --Assignment button
    buttonAssign:SetPos(frame:GetWide() - 450, frame:GetTall() - 70)
    buttonAssign:SetSize(110, 25)
    buttonAssign:SetText("Blacklist")
    buttonAssign:SetFont("PilotMenuFont")
    buttonAssign:SetTextColor(Color(255, 255, 255, 255))

    -- The paint function
    buttonAssign.Paint = function()
        surface.SetDrawColor(0, 0, 0, 255)
        surface.DrawRect(0, 0, buttonAssign:GetWide(), buttonAssign:GetTall())
    end

    buttonAssign.DoClick = function()
        local selectedsteamid = applicantList:GetLine(applicantList:GetSelectedLine()):GetColumnText(2)
        net.Start("setplayerblacklist")
        net.WriteString("true")
        net.WriteString(selectedsteamid)
        net.SendToServer()
        frame:SetVisible(false)
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

    --Rertrive info for applicant
    for _, v in pairs(player.GetAll()) do
        applicantList:AddLine(v:Nick(), v:SteamID(), v:GetRegiment(), GetPlayersBlacklist(v))
    end

    for _, line in pairs(applicantList:GetLines()) do
        function line:Paint(w, h)
            if GetPlayersBlacklist(player.GetBySteamID(line:GetValue(2))) == "Yes" and not self:IsHovered() then
                surface.SetDrawColor(240, 95, 95, 255)
                surface.DrawRect(0, 0, applicantList:GetWide(), applicantList:GetTall())
            elseif GetPlayersBlacklist(player.GetBySteamID(line:GetValue(2))) == "Yes" and self:IsHovered() then
                surface.SetDrawColor(220, 95, 95, 255)
                surface.DrawRect(0, 0, applicantList:GetWide(), applicantList:GetTall())
            elseif self:IsHovered() then
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

net.Receive("blacklistmenu", OpenEMBlacklistMenu)