globalmh1booking = ""
globalmh2booking = ""
globaltiebooking = ""
globalmsgbooking = "Message Navy to make a Booking"
local blur = Material("pp/blurscreen")

local function DrawBlur(panel, amount)
    local x, y = panel:LocalToScreen(0, 0)
    local scrW, scrH = ScrW(), ScrH()
    surface.SetDrawColor(255, 255, 255)
    surface.SetMaterial(blur)

    for i = 1, 3 do
        blur:SetFloat("$blur", (i / 3) * (amount or 6))
        blur:Recompute()
        render.UpdateScreenEffectTexture()
        surface.DrawTexturedRect(x * -1, y * -1, scrW, scrH)
    end
end

net.Receive("netopenbookingmenu", function()
    local data = net.ReadTable()
	PrintTable(data)
    local mainFrame = vgui.Create("DFrame")
    mainFrame:SetSize(400, 320)
    mainFrame:SetDraggable(true)
    mainFrame:ShowCloseButton(true)
    mainFrame:SetTitle("Booking Menu")
    mainFrame:Center()
    mainFrame:MakePopup()

    mainFrame.Paint = function()
        DrawBlur(mainFrame, 10)
    end

    mainFrame:SetSkin("skin")
    local menuSheets = vgui.Create("DPropertySheet", mainFrame)
    menuSheets:Dock(FILL)

    menuSheets.Paint = function()
        draw.RoundedBox(0, 0, 20, menuSheets:GetWide(), menuSheets:GetTall() - 10, Color(44, 62, 80))
    end

    local regimentsSheet = vgui.Create("DPanel", menuSheets)

    regimentsSheet.Paint = function()
        draw.RoundedBox(0, 0, 0, regimentsSheet:GetWide(), regimentsSheet:GetTall(), Color(236, 240, 241))
    end

    local regimentList = vgui.Create("DListView", regimentsSheet)
    regimentList:SetMultiSelect(false)
    regimentList:SetPos(15, 10)
    regimentList:SetSize(340, 190)
    regimentList:AddColumn("Booked Regiments")
    for k, v in pairs(data) do
        regimentList:AddLine(v)
    end

    regimentList.OnRowRightClick = function(btn, line)
        local regimentOptions = DermaMenu()

        regimentOptions:AddOption("Delete Booking", function()
            Derma_Query("Are you sure that you want to delete this booking?", "Warning!", "Yes", function()
                net.Start("removeBooking")
                net.WriteString(regimentList:GetLine(regimentList:GetSelectedLine()):GetColumnText(1))
                net.SendToServer()
                regimentList:RemoveLine(line)
            end, "No")
        end)

        regimentOptions:Open()
    end

    local tipText = vgui.Create("DLabel", regimentsSheet)
    tipText:SetPos(60, 218)
    tipText:SetText("TIP: Use right click on the list to delete bookings.")
    tipText:SizeToContents()
    tipText:SetTextColor(Color(20, 20, 20))
    menuSheets:AddSheet("Bookings", regimentsSheet, "icon16/world.png")
    local newBooking = vgui.Create("DPanel", menuSheets)

    newBooking.Paint = function()
        draw.RoundedBox(0, 0, 0, newBooking:GetWide(), newBooking:GetTall(), Color(236, 240, 241))
    end

    local regimentsList = vgui.Create("DListView", newBooking)
    regimentsList:SetMultiSelect(false)
    regimentsList:SetPos(15, 10)
    regimentsList:SetSize(340, 190)
    regimentsList:AddColumn("Regiment name")

    for k, v in pairs(TeamTable) do
        regimentsList:AddLine(k)
    end

    local createBooking = vgui.Create("DButton", newBooking)
    createBooking:SetPos(125, 210)
    createBooking:SetSize(110, 35)
    createBooking:SetText("Create Booking")

    createBooking.DoClick = function()
        local regimenttobook = regimentsList:GetLine(regimentsList:GetSelectedLine()):GetColumnText(1)
		
        local locationOptions = DermaMenu()
        if game.GetMap() == "rp_stardestroyer_v2_7_inf" then
            Derma_Query("Choose a booking location", "", "MH1", function()
            net.Start("addnewBooking")
            net.WriteString(regimenttobook .. " - MH1")
            net.SendToServer()
        end, "MH2", function()
            net.Start("addnewBooking")
            net.WriteString(regimenttobook .. " - MH2")
            net.SendToServer()
        end, "TIE Bays", function()
            net.Start("addnewBooking")
            net.WriteString(regimenttobook .. " - TIE Bays")
            net.SendToServer()
        end)
        elseif game.GetMap() == "rp_titan_base_bananakin_ig" then
        Derma_Query("Choose a booking location", "", "Training Hangar Alpha", function()
            net.Start("addnewBooking")
            net.WriteString(regimenttobook .. " - Training Hangar Alpha")
            net.SendToServer()
        end, "Training Hangar Beta", function()
            net.Start("addnewBooking")
            net.WriteString(regimenttobook .. " - Training Hangar Beta")
            net.SendToServer()
        end, "Training Hangar Gamma", function()
            net.Start("addnewBooking")
            net.WriteString(regimenttobook .. " - Training Hangar Gamma")
            net.SendToServer()
        end, "Training Hangar Delta", function()
            net.Start("addnewBooking")
            net.WriteString(regimenttobook .. " - Training Hangar Delta")
            net.SendToServer()
        end)
    else
        Derma_Query("Choose a booking location", "", "Training Hangar Aurek", function()
            net.Start("addnewBooking")
            net.WriteString(regimenttobook .. " - Training Hangar Aurek")
            net.SendToServer()
        end, "Training Hangar Besh", function()
            net.Start("addnewBooking")
            net.WriteString(regimenttobook .. " - Training Hangar Besh")
            net.SendToServer()
        end, "Training Hangar Cresh", function()
            net.Start("addnewBooking")
            net.WriteString(regimenttobook .. " - Training Hangar Cresh")
            net.SendToServer()
        end, "Simulation Field", function()
            net.Start("addnewBooking")
            net.WriteString(regimenttobook .. " - Simulation Field")
            net.SendToServer()
        end)
    end

        locationOptions:Open()
        mainFrame:Close()
    end

    menuSheets:AddSheet("New Booking", newBooking, "icon16/world_add.png")
end)

net.Receive("receiveBooking",function()
    local booktype = net.ReadString()
    local booking = net.ReadString()
    if booktype == "MH1" then
        globalmh1booking = booking
    elseif booktype == "MH2" then
        globalmh2booking = booking
    elseif booktype == "TIE" then
        globaltiebooking = booking
    elseif booktype == "MSG" then
        globalmsgbooking = booking
    end
end)

net.Receive("receiveAllBooking",function()
    local bookmh1 = net.ReadString()
    local bookmh2 = net.ReadString()
    local booktie = net.ReadString()
    local bookmsg = net.ReadString()
    globalmh1booking = bookmh1
    globalmh2booking = bookmh2
    globaltiebooking = booktie
    globalmsgbooking = bookmsg
end)