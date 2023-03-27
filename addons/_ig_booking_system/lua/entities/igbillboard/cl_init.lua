include("shared.lua")

surface.CreateFont("epictvfont", {
    font = "Arial",
    size = 21,
    weight = 900,
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

surface.CreateFont("epicguifont", {
    font = "Arial",
    size = 14,
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

net.Receive("openbillboardsetter", function()
    local SWRPmenu = vgui.Create("DFrame")
    SWRPmenu:SetSize(300, 140)
    SWRPmenu:Center()
    SWRPmenu:MakePopup()
    SWRPmenu:SetBackgroundBlur(true)
    SWRPmenu:ShowCloseButton(false)
    SWRPmenu:SetVisible(true)

    SWRPmenu.Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(31, 34, 41, 255))
    end

    local CenterPanel = vgui.Create("DPanel", SWRPmenu)
    CenterPanel:SetSize(SWRPmenu:GetWide() - 20, SWRPmenu:GetTall() - 50)
    CenterPanel:SetPos(10, 40)

    -- 'function Frame:Paint( w, h )' works too
    CenterPanel.Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(44, 48, 56, 255)) -- Draw a red box instead of the frame
    end

    local Topbar = vgui.Create("DPanel", SWRPmenu)
    Topbar:SetText("SET BILLBOARD TEXT BELOW")
    Topbar:SetSize(800, 25)
    Topbar:SetPos(0, 0)

    -- 'function Frame:Paint( w, h )' works too
    Topbar.Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(44, 48, 56)) -- Draw a red box instead of the frame
    end

    local header = vgui.Create("DLabel", Topbar)
    header:SetPos(SWRPmenu:GetWide() / 2 - 69, 5)
    header:SetFont("epicguifont")
    header:SetText("SET BILLBOARD TEXT BELOW")
    header:SizeToContents()
    header:SetTextColor(Color(255, 255, 255, 255))
    local CButton = vgui.Create("DButton", SWRPmenu)
    CButton:SetTextColor(Color(60, 64, 82)) -- 13
    CButton:SetText("X")
    CButton:SetFont("CloseCaption_Normal")
    CButton:SetSize(40, 18)
    CButton:SetPos(SWRPmenu:GetWide() - 50, 3)

    CButton.Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(32, 36, 44))
    end

    CButton.DoClick = function()
        SWRPmenu:SetVisible(false)
    end

    local billboardmsgBox = vgui.Create("DTextEntry", SWRPmenu)
    billboardmsgBox:SetPos(0, 60)
    billboardmsgBox:SetSize(222.5, 50)
    billboardmsgBox:CenterHorizontal()
    billboardmsgBox:SetText("")

    billboardmsgBox.OnEnter = function(self)
        local stringlength = string.len(self:GetValue())

        if stringlength > 60 then
            chat.AddText("Your message is longer than 60 characters sorry.")
        end

        net.Start("setbillboardtxt")
        net.WriteString(self:GetValue())
        net.SendToServer()
        SWRPmenu:Close()
    end
end)

function ENT:Draw()
    local dist = (LocalPlayer():GetShootPos() - self:GetPos()):Length()
    if (dist > 1500) then return end
    self:DrawModel()
    self:SetModelScale(1.15)
    -- Positions
    local d1 = Vector(6.5, 0, 37) -- position offset
    local d2 = Vector(6.5, 0.5, 27) -- position offset
    local d22 = Vector(6.5, 0.5, 26.5) -- position offset
    local d222 = Vector(6.5, 0.5, 19.5) -- position offset
    local d3 = Vector(6.5, 0.5, 12) -- position offset
    local d33 = Vector(6.5, 0.5, 12.5) -- position offset
    local d333 = Vector(6.5, 0.5, 4.5) -- position offset
    local d4 = Vector(6.5, 0.5, -3) -- position offset
    local d44 = Vector(6.5, 0.5, -3.5) -- position offset
    local d444 = Vector(6.5, 0.5, -10.5) -- position offset
    local d5 = Vector(6.5, 0.5, -18) -- position offset
    local d55 = Vector(6.5, 0.5, -18.5) -- position offset
    local d555 = Vector(6.5, 0.5, -25.5) -- position offset
    local dmsg = Vector(6.5, 0.5, -34) -- position offset
    local relevanttoboard = Angle(0, 90, 90) -- angle offset
    local bookedareas = {}
    -- Functions
    local function GetBoardPosition1(area)
        if game.GetMap() == "rp_stardestroyer_v2_7_inf" then
            if area == "mh1" then
                table.insert(bookedareas, 1, "mh1")
            elseif area == "mh2" then
                table.insert(bookedareas, "mh2")
            elseif area == "tie" then
                table.insert(bookedareas, "tie")
            end

            if area == bookedareas[1] then
                return d2
            elseif area == bookedareas[2] then
                return d3
            elseif area == bookedareas[3] then
                return d4
            end
        else
            if area == "sima" then
                table.insert(bookedareas, 1, "sima")
            elseif area == "simb" then
                table.insert(bookedareas, "simb")
            elseif area == "dockb" then
                table.insert(bookedareas, "dockb")
            elseif area == "tieb" then
                table.insert(bookedareas, "tieb")
            end

            if area == bookedareas[1] then
                return d2
            elseif area == bookedareas[2] then
                return d3
            elseif area == bookedareas[3] then
                return d4
            elseif area == bookedareas[4] then
                return d5
            end
        end
end

        local function GetBoardPosition2(area)
            if area == bookedareas[1] then
                return d22
            elseif area == bookedareas[2] then
                return d33
            elseif area == bookedareas[3] then
                return d44
            elseif area == bookedareas[4] then
                return d55
            end
        end

        local function GetBoardPosition3(area)
            if area == bookedareas[1] then
                return d222
            elseif area == bookedareas[2] then
                return d333
            elseif area == bookedareas[3] then
                return d444
            elseif area == bookedareas[4] then
                return d555
            end
        end
        -- Variables
        local tiebooking = globaltiebooking
        local mh1booking = globalmh1booking
        local mh2booking = globalmh2booking
        local simabooking = GetGlobalString("simabooking")
        local simbbooking = GetGlobalString("simbbooking")
        local dockbooking = GetGlobalString("dockbooking")
        local tiehbbooking = GetGlobalString("tiehbbooking")
        local billboardmsg = globalmsgbooking
        -- Scaling
        local scale = 0.375 -- scale
        local scale2 = 0.285
        local scale2reg = 0.25
        local scale3 = 0.275
        local scale3len = string.len(billboardmsg)

        if scale3len > 45 and scale3len < 55 then
            scale3 = 0.225
        elseif scale3len > 56 and scale3len < 64 then
            scale3 = 0.2
        elseif scale3len > 65 then
            scale3 = 0.175
        else
            scale3 = 0.25
        end

        -- Title
        if game.GetMap() == "rp_stardestroyer_v2_7_inf" then
            cam.Start3D2D(self:LocalToWorld(d1), self:LocalToWorldAngles(relevanttoboard), scale)
            draw.DrawText("Star Destroyer Bookings", "epictvfont", 0, 0, Color(9, 147, 219), TEXT_ALIGN_CENTER)
            cam.End3D2D()

            -- MH1
            if mh1booking ~= "" then
                cam.Start3D2D(self:LocalToWorld(GetBoardPosition1("mh1")), self:LocalToWorldAngles(relevanttoboard), scale2)
                draw.DrawText("Main Hangar 1 - Booked By", "epictvfont", 0, 0, Color(255, 255, 255), TEXT_ALIGN_CENTER)
                cam.End3D2D()
                cam.Start3D2D(self:LocalToWorld(GetBoardPosition2("mh1")), self:LocalToWorldAngles(relevanttoboard), scale2)
                draw.RoundedBox(0.1, -117.5, 19, 235, 1.5, Color(255, 255, 255))
                cam.End3D2D()
                cam.Start3D2D(self:LocalToWorld(GetBoardPosition3("mh1")), self:LocalToWorldAngles(relevanttoboard), scale2reg)
                draw.DrawText(mh1booking, "epictvfont", 0, 0, Color(255, 255, 255), TEXT_ALIGN_CENTER)
                cam.End3D2D()
            end

            -- MH2
            if mh2booking ~= "" then
                cam.Start3D2D(self:LocalToWorld(GetBoardPosition1("mh2")), self:LocalToWorldAngles(relevanttoboard), scale2)
                draw.DrawText("Main Hangar 2 - Booked By", "epictvfont", 0, 0, Color(255, 255, 255), TEXT_ALIGN_CENTER)
                cam.End3D2D()
                cam.Start3D2D(self:LocalToWorld(GetBoardPosition2("mh2")), self:LocalToWorldAngles(relevanttoboard), scale2)
                draw.RoundedBox(0.1, -117.5, 19, 235, 1.5, Color(255, 255, 255))
                cam.End3D2D()
                cam.Start3D2D(self:LocalToWorld(GetBoardPosition3("mh2")), self:LocalToWorldAngles(relevanttoboard), scale2reg)
                draw.DrawText(mh2booking, "epictvfont", 0, 0, Color(255, 255, 255), TEXT_ALIGN_CENTER)
                cam.End3D2D()
            end

            -- TIE Bays
            if tiebooking ~= "" then
                cam.Start3D2D(self:LocalToWorld(GetBoardPosition1("tie")), self:LocalToWorldAngles(relevanttoboard), scale2)
                draw.DrawText("TIE Bays - Booked By", "epictvfont", 0, 0, Color(255, 255, 255), TEXT_ALIGN_CENTER)
                cam.End3D2D()
                cam.Start3D2D(self:LocalToWorld(GetBoardPosition2("tie")), self:LocalToWorldAngles(relevanttoboard), scale2)
                draw.RoundedBox(0.1, -117.5, 19, 235, 1.5, Color(255, 255, 255))
                cam.End3D2D()
                cam.Start3D2D(self:LocalToWorld(GetBoardPosition3("tie")), self:LocalToWorldAngles(relevanttoboard), scale2reg)
                draw.DrawText(tiebooking, "epictvfont", 0, 0, Color(255, 255, 255), TEXT_ALIGN_CENTER)
                cam.End3D2D()
            end
        elseif game.GetMap() == "rp_titan_base_bananakin_ig" then
            cam.Start3D2D(self:LocalToWorld(d1), self:LocalToWorldAngles(relevanttoboard), scale)
            draw.DrawText("Titan Base Bookings", "epictvfont", 0, 0, Color(9, 147, 219), TEXT_ALIGN_CENTER)
            cam.End3D2D()

            -- TRH A
            if simabooking ~= "" then
                cam.Start3D2D(self:LocalToWorld(GetBoardPosition1("sima")), self:LocalToWorldAngles(relevanttoboard), scale2)
                if game.GetMap() == "rp_titan_base_bananakin_ig" then
                draw.DrawText("Training Hangar Alpha - Booked By", "epictvfont", 0, 0, Color(255, 255, 255), TEXT_ALIGN_CENTER)
                else
                draw.DrawText("Training Hangar Aurek - Booked By", "epictvfont", 0, 0, Color(255, 255, 255), TEXT_ALIGN_CENTER)
                end
                cam.End3D2D()
                cam.Start3D2D(self:LocalToWorld(GetBoardPosition2("sima")), self:LocalToWorldAngles(relevanttoboard), scale2)
                draw.RoundedBox(0.1, -117.5, 19, 235, 1.5, Color(255, 255, 255))
                cam.End3D2D()
                cam.Start3D2D(self:LocalToWorld(GetBoardPosition3("sima")), self:LocalToWorldAngles(relevanttoboard), scale2reg)
                draw.DrawText(simabooking, "epictvfont", 0, 0, Color(255, 255, 255), TEXT_ALIGN_CENTER)
                cam.End3D2D()
            end

            -- TRH B
            if simbbooking ~= "" then
                cam.Start3D2D(self:LocalToWorld(GetBoardPosition1("simb")), self:LocalToWorldAngles(relevanttoboard), scale2)
                if game.GetMap() == "rp_titan_base_bananakin_ig" then
                draw.DrawText("Training Hangar Beta - Booked By", "epictvfont", 0, 0, Color(255, 255, 255), TEXT_ALIGN_CENTER)
                else
                draw.DrawText("Training Hangar Besh - Booked By", "epictvfont", 0, 0, Color(255, 255, 255), TEXT_ALIGN_CENTER)
                end
                cam.End3D2D()
                cam.Start3D2D(self:LocalToWorld(GetBoardPosition2("simb")), self:LocalToWorldAngles(relevanttoboard), scale2)
                draw.RoundedBox(0.1, -117.5, 19, 235, 1.5, Color(255, 255, 255))
                cam.End3D2D()
                cam.Start3D2D(self:LocalToWorld(GetBoardPosition3("simb")), self:LocalToWorldAngles(relevanttoboard), scale2reg)
                draw.DrawText(simbbooking, "epictvfont", 0, 0, Color(255, 255, 255), TEXT_ALIGN_CENTER)
                cam.End3D2D()
            end

            -- TRH G
            if dockbooking ~= "" then
                cam.Start3D2D(self:LocalToWorld(GetBoardPosition1("dockb")), self:LocalToWorldAngles(relevanttoboard), scale2)
                if game.GetMap() == "rp_titan_base_bananakin_ig" then
                draw.DrawText("Training Hangar Gamma - Booked By", "epictvfont", 0, 0, Color(255, 255, 255), TEXT_ALIGN_CENTER)
                else
                draw.DrawText("Training Hangar Cresh - Booked By", "epictvfont", 0, 0, Color(255, 255, 255), TEXT_ALIGN_CENTER)
                end
                cam.End3D2D()
                cam.Start3D2D(self:LocalToWorld(GetBoardPosition2("dockb")), self:LocalToWorldAngles(relevanttoboard), scale2)
                draw.RoundedBox(0.1, -117.5, 19, 235, 1.5, Color(255, 255, 255))
                cam.End3D2D()
                cam.Start3D2D(self:LocalToWorld(GetBoardPosition3("dockb")), self:LocalToWorldAngles(relevanttoboard), scale2reg)
                draw.DrawText(dockbooking, "epictvfont", 0, 0, Color(255, 255, 255), TEXT_ALIGN_CENTER)
                cam.End3D2D()
            end

            -- TRH D
            if tiehbbooking ~= "" then
                cam.Start3D2D(self:LocalToWorld(GetBoardPosition1("tieb")), self:LocalToWorldAngles(relevanttoboard), scale2)
                if game.GetMap() == "rp_titan_base_bananakin_ig" then
                draw.DrawText("Training Hangar Delta - Booked By", "epictvfont", 0, 0, Color(255, 255, 255), TEXT_ALIGN_CENTER)
                else
                draw.DrawText("Simulation Field - Booked By", "epictvfont", 0, 0, Color(255, 255, 255), TEXT_ALIGN_CENTER)
                end
                cam.End3D2D()
                cam.Start3D2D(self:LocalToWorld(GetBoardPosition2("tieb")), self:LocalToWorldAngles(relevanttoboard), scale2)
                draw.RoundedBox(0.1, -117.5, 19, 235, 1.5, Color(255, 255, 255))
                cam.End3D2D()
                cam.Start3D2D(self:LocalToWorld(GetBoardPosition3("tieb")), self:LocalToWorldAngles(relevanttoboard), scale2reg)
                draw.DrawText(tiehbbooking, "epictvfont", 0, 0, Color(255, 255, 255), TEXT_ALIGN_CENTER)
                cam.End3D2D()
            end
			
			else
			cam.Start3D2D(self:LocalToWorld(d1), self:LocalToWorldAngles(relevanttoboard), scale)
            draw.DrawText("Rishi Base Bookings", "epictvfont", 0, 0, Color(9, 147, 219), TEXT_ALIGN_CENTER)
            cam.End3D2D()

            -- Hanger A
            if simabooking ~= "" then
                cam.Start3D2D(self:LocalToWorld(GetBoardPosition1("sima")), self:LocalToWorldAngles(relevanttoboard), scale2)
                draw.DrawText("Training Hangar Aurek - Booked By", "epictvfont", 0, 0, Color(255, 255, 255), TEXT_ALIGN_CENTER)
                cam.End3D2D()
                cam.Start3D2D(self:LocalToWorld(GetBoardPosition2("sima")), self:LocalToWorldAngles(relevanttoboard), scale2)
                draw.RoundedBox(0.1, -117.5, 19, 235, 1.5, Color(255, 255, 255))
                cam.End3D2D()
                cam.Start3D2D(self:LocalToWorld(GetBoardPosition3("sima")), self:LocalToWorldAngles(relevanttoboard), scale2reg)
                draw.DrawText(simabooking, "epictvfont", 0, 0, Color(255, 255, 255), TEXT_ALIGN_CENTER)
                cam.End3D2D()
            end

            -- Hanger B
            if simbbooking ~= "" then
                cam.Start3D2D(self:LocalToWorld(GetBoardPosition1("simb")), self:LocalToWorldAngles(relevanttoboard), scale2)
                draw.DrawText("Training Hangar Besh - Booked By", "epictvfont", 0, 0, Color(255, 255, 255), TEXT_ALIGN_CENTER)
                cam.End3D2D()
                cam.Start3D2D(self:LocalToWorld(GetBoardPosition2("simb")), self:LocalToWorldAngles(relevanttoboard), scale2)
                draw.RoundedBox(0.1, -117.5, 19, 235, 1.5, Color(255, 255, 255))
                cam.End3D2D()
                cam.Start3D2D(self:LocalToWorld(GetBoardPosition3("simb")), self:LocalToWorldAngles(relevanttoboard), scale2reg)
                draw.DrawText(simbbooking, "epictvfont", 0, 0, Color(255, 255, 255), TEXT_ALIGN_CENTER)
                cam.End3D2D()
            end

            -- Hanger C
            if dockbooking ~= "" then
                cam.Start3D2D(self:LocalToWorld(GetBoardPosition1("dockb")), self:LocalToWorldAngles(relevanttoboard), scale2)
                draw.DrawText("Training Hangar Cresh - Booked By", "epictvfont", 0, 0, Color(255, 255, 255), TEXT_ALIGN_CENTER)
                cam.End3D2D()
                cam.Start3D2D(self:LocalToWorld(GetBoardPosition2("dockb")), self:LocalToWorldAngles(relevanttoboard), scale2)
                draw.RoundedBox(0.1, -117.5, 19, 235, 1.5, Color(255, 255, 255))
                cam.End3D2D()
                cam.Start3D2D(self:LocalToWorld(GetBoardPosition3("dockb")), self:LocalToWorldAngles(relevanttoboard), scale2reg)
                draw.DrawText(dockbooking, "epictvfont", 0, 0, Color(255, 255, 255), TEXT_ALIGN_CENTER)
                cam.End3D2D()
            end

            -- Sim Field
            if tiehbbooking ~= "" then
                cam.Start3D2D(self:LocalToWorld(GetBoardPosition1("tieb")), self:LocalToWorldAngles(relevanttoboard), scale2)
                draw.DrawText("Simulation Field - Booked By", "epictvfont", 0, 0, Color(255, 255, 255), TEXT_ALIGN_CENTER)
                cam.End3D2D()
                cam.Start3D2D(self:LocalToWorld(GetBoardPosition2("tieb")), self:LocalToWorldAngles(relevanttoboard), scale2)
                draw.RoundedBox(0.1, -117.5, 19, 235, 1.5, Color(255, 255, 255))
                cam.End3D2D()
                cam.Start3D2D(self:LocalToWorld(GetBoardPosition3("tieb")), self:LocalToWorldAngles(relevanttoboard), scale2reg)
                draw.DrawText(tiehbbooking, "epictvfont", 0, 0, Color(255, 255, 255), TEXT_ALIGN_CENTER)
                cam.End3D2D()
            end
        end

            cam.Start3D2D(self:LocalToWorld(dmsg), self:LocalToWorldAngles(relevanttoboard), scale3)
            draw.DrawText(billboardmsg, "epictvfont", 0, 0, Color(9, 147, 219), TEXT_ALIGN_CENTER)
            cam.End3D2D()
            bookedareas = {}
    end