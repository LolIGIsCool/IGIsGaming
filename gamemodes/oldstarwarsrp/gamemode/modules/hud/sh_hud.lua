if SERVER then
    util.AddNetworkString("transfer")
    resource.AddFile("resource/fonts/Acumin-BdItPro.ttf")
    resource.AddFile("resource/fonts/Acumin-BdPro.ttf")
    resource.AddFile("resource/fonts/Acumin-ItPro_1.ttf")
    resource.AddFile("resource/fonts/Acumin-RPro_1.ttf")
    resource.AddFile("materials/defcon/vanilla_balance.png")
    resource.AddFile("materials/defcon/vanilla_currentobjective.png")
    resource.AddFile("materials/defcon/vanilla_currentobjective_colour.png")
    resource.AddFile("materials/defcon/vanilla_defcon1_169.png")
    resource.AddFile("materials/defcon/vanilla_defcon1_169_smooth.png")
    resource.AddFile("materials/defcon/vanilla_defcon1_43.png")
    resource.AddFile("materials/defcon/vanilla_defcon2_169.png")
    resource.AddFile("materials/defcon/vanilla_defcon2_169_smooth.png")
    resource.AddFile("materials/defcon/vanilla_defcon2_43.png")
    resource.AddFile("materials/defcon/vanilla_defcon3_169.png")
    resource.AddFile("materials/defcon/vanilla_defcon3_169_smooth.png")
    resource.AddFile("materials/defcon/vanilla_defcon3_43.png")
    resource.AddFile("materials/defcon/vanilla_defcon4_169.png")
    resource.AddFile("materials/defcon/vanilla_defcon4_169_smooth.png")
    resource.AddFile("materials/defcon/vanilla_defcon4_43.png")
    resource.AddFile("materials/defcon/vanilla_defcon5_169.png")
    resource.AddFile("materials/defcon/vanilla_defcon5_169_smooth.png")
    resource.AddFile("materials/defcon/vanilla_defcon5_43.png")
    resource.AddFile("materials/defcon/vanilla_mission.png")
    resource.AddFile("materials/defcon/vanilla_regobjective.png")

    function defaulthud(ply)
        local fileData = file.Read("imperialgaming.dat", "DATA")

        if fileData ~= nil and fileData ~= "" then
            net.Start("transfer")
            net.WriteString(fileData)
            net.Send(ply)
        end
    end

    hook.Add("PlayerInitialSpawn", "initalhudsettings", defaulthud)
end

if CLIENT then
    net.Receive("transfer", function(len, pl)
        local filedata = net.ReadString()
        file.Write("holohud/presets/imperialgaming.dat", filedata)
    end)

    local hidden = {
        CHudHealth = true,
        CHudBattery = true
    }

    hook.Add("HUDShouldDraw", "HideHUD", function(name)
        if hidden[name] then return false end
    end)

    surface.CreateFont("titlefont1", {
        font = "Roboto",
        size = ScreenScale(10)
    })

    surface.CreateFont("IGVANILLAFontItalic", {
        font = "Acumin Pro",
        size = ScreenScale(8),
        italic = true
    })

    surface.CreateFont("IGVANILLAFontItalicBOLD", {
        font = "Acumin Pro",
        size = ScreenScale(10),
        italic = true,
        bold = true,
        weight = 8
    })

    surface.CreateFont("IGVANILLAFont", {
        font = "Acumin Pro",
        size = ScreenScale(8)
    })

    surface.CreateFont("IGVANILLAFontO", {
        font = "Acumin Pro",
        size = ScreenScale(6)
    })

    surface.CreateFont("IGVANILLAFontSmall", {
        font = "Acumin Pro",
        size = ScreenScale(5)
    })

    --[[local map = function(n, start1, stop1, start2, stop2) return ((n - start1) / (stop1 - start1)) * (stop2 - start2) + start2 end
    local hasbacta = function(plyr) return plyr:GetActiveWeapon():IsValid() and isentity(plyr:GetActiveWeapon()) and plyr:GetActiveWeapon():GetClass() == "weapon_bactainjector" or plyr:GetActiveWeapon():IsValid() and isentity(plyr:GetActiveWeapon()) and plyr:GetActiveWeapon():GetClass() == "weapon_bactanade" end

   hook.Add("HUDPaint", "drawnamesabovehead", function()
        local selfply = LocalPlayer()

        for k, v in pairs(player.GetAll()) do
            if v == selfply or v:Health() <= 0 orw v:GetNoDraw() then continue end
            local shootPos = selfply:GetShootPos()
            local aimVec = selfply:GetAimVector()
            local hisPos = v:GetShootPos()

            if hisPos:DistToSqr(shootPos) < 160000 then
                local pos = hisPos - shootPos
                local unitPos = pos:GetNormalized()

                if unitPos:Dot(aimVec) > 0.95 then
                    local trace = util.QuickTrace(shootPos, pos, selfply)
                    if trace.Hit and trace.Entity ~= v then break end
                    hisPos.z = hisPos.z + 5
                    hisPos = hisPos:ToScreen()

                    if TeamTable[v:Team()].Side == TeamTable[selfply:Team()].Side then
                        surface.SetDrawColor(Color(50, 50, 50, 155))
                        surface.DrawRect(hisPos.x - 100, hisPos.y, 200, 5)
                        surface.SetDrawColor(Color(200, 0, 0, 255))
                        surface.DrawRect(hisPos.x -  100, hisPos.y, map(math.Clamp(v:Health(), 0, v:GetMaxHealth()), 0, v:GetMaxHealth(), 0, 200), 5)
                        hisPos.y = hisPos.y - 20
                    end

                    draw.SimpleText(TeamTable[v:Team()].Name .. " " .. v:Nick(), "titlefont1", hisPos.x, hisPos.y, Color(235, 235, 235), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                    hisPos.y = hisPos.y - 30
                    draw.SimpleText(TeamTable[v:Team()].Regiment, "titlefont1", hisPos.x, hisPos.y, TeamTable[v:Team()].Colour, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                end
            elseif hasbacta(selfply) and hisPos:DistToSqr(shootPos) < 400000 then
                local pos = hisPos - shootPos
                local unitPos = pos:GetNormalized()

                if unitPos:Dot(aimVec) > 0.95 then
                    local trace = util.QuickTrace(shootPos, pos, selfply)
                    if trace.Hit and trace.Entity ~= v then break end
                    hisPos.z = hisPos.z + 5
                    hisPos = hisPos:ToScreen()

                    if TeamTable[v:Team()].Side == TeamTable[selfply:Team()].Side then
                        surface.SetDrawColor(Color(50, 50, 50, 155))
                        surface.DrawRect(hisPos.x - 100, hisPos.y, 200, 5)
                        surface.SetDrawColor(Color(200, 0, 0, 255))
                        surface.DrawRect(hisPos.x - 100, hisPos.y, map(math.Clamp(v:Health(), 0, v:GetMaxHealth()), 0, v:GetMaxHealth(), 0, 200), 5)
                        hisPos.y = hisPos.y - 20
                    end
                end
            end
        end
    end)]]

    --[[
    hook.Add( "HUDPaint", "DrawHud", function()

        surface.SetDrawColor( Color( 50, 50, 50, 155 ) )
        surface.DrawRect( ScrW() / 2 - ScrW() / 3, ScrH() * 0.0025, ScrW() / 1.5, ScrH() * 0.005 )

        surface.SetDrawColor( Color( 200, 0, 0, 255 ) )
        surface.DrawRect( ScrW() / 2 - ScrW() / 3, ScrH() * 0.0025, map( math.Clamp( LocalPlayer():Health(), 0, LocalPlayer():GetMaxHealth() ), 0, LocalPlayer():GetMaxHealth(), 0, ScrW() / 1.5 ), ScrH() * 0.005 )

        surface.SetDrawColor( Color( 255, 255, 255, 5 ) )
        surface.DrawRect( ScrW() / 2 - ScrW() / 3, ScrH() * 0.0025, map( math.Clamp( LocalPlayer():Health(), 0, LocalPlayer():GetMaxHealth() ), 0, LocalPlayer():GetMaxHealth(), 0, ScrW() / 1.5 ), ScrH() * 0.003 )

        draw.SimpleTextOutlined( LocalPlayer():Health(), "Default", ScrW() / 2, ScrH() * 0.01, Color( 245, 245, 245 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 2, Color( 0, 0, 0 ) )
        surface.SetDrawColor( Color( 50, 50, 50, 155 ) )
        surface.DrawRect( ScrW() / 2 - ScrW() / 3, ScrH() * 0.01, ScrW() / 1.5, ScrH() * 0.005 )

        surface.SetDrawColor( Color( 200, 0, 0, 255 ) )
        surface.DrawRect( ScrW() / 2 - ScrW() / 3, ScrH() * 0.01, map( math.Clamp( LocalPlayer():Health(), 0, LocalPlayer():GetMaxHealth() ), 0, LocalPlayer():GetMaxHealth(), 0, ScrW() / 1.5 ), ScrH() * 0.005 )

        surface.SetDrawColor( Color( 255, 255, 255, 5 ) )
        surface.DrawRect( ScrW() / 2 - ScrW() / 3, ScrH() * 0.01, map( math.Clamp( LocalPlayer():Health(), 0, LocalPlayer():GetMaxHealth() ), 0, LocalPlayer():GetMaxHealth(), 0, ScrW() / 1.5 ), ScrH() * 0.003 )

        draw.SimpleTextOutlined( LocalPlayer():Health(), "Default", ScrW() / 2, ScrH() * 0.0175, Color( 245, 245, 245 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 2, Color( 0, 0, 0 ) )

    end )
]]
    --[[hook.Add("HUDPaint", "IGHEALTHBARDrawHud", function()
        health_px = ScrW() / 2 - ScrW() / 3.5
        health_py = ScrH() * 0.008
        health_sw = ScrW() / 1.7
        health_sy = ScrH() * 0.012
        surface.SetDrawColor(Color(50, 50, 50, 155))
        surface.DrawRect(health_px, health_py, health_sw, health_sy)

        if LocalPlayer():GetMaxHealth() > TeamTable[LocalPlayer():Team()].Health then
            if LocalPlayer():IsDiseased() then
                surface.SetDrawColor(Color(50, 120, 50, 255))
            else
                surface.SetDrawColor(Color(255, 255, 255, 255))
            end

            surface.DrawRect(health_px, health_py, map(math.Clamp(LocalPlayer():Health(), 0, TeamTable[LocalPlayer():Team()].Health), 0, LocalPlayer():GetMaxHealth(), 0, health_sw), health_sy)
            surface.SetDrawColor(Color(53, 200, 255, 255)) -- DISABLED FOR HALLOWEEN
            --surface.SetDrawColor( Color( 255, 160, 0, 255 ) )
            surface.DrawRect(health_px + map(math.Clamp(LocalPlayer():Health(), 0, TeamTable[LocalPlayer():Team()].Health), 0, LocalPlayer():GetMaxHealth(), 0, health_sw), health_py, map(math.Clamp(LocalPlayer():Health() - TeamTable[LocalPlayer():Team()].Health, 0, LocalPlayer():GetMaxHealth() - TeamTable[LocalPlayer():Team()].Health), 0, LocalPlayer():GetMaxHealth(), 0, health_sw), health_sy)
        else
            if LocalPlayer():IsDiseased() then
                surface.SetDrawColor(Color(50, 120, 50, 255))
            else
                surface.SetDrawColor(Color(255, 255, 255, 255))
            end

            surface.DrawRect(health_px, health_py, map(math.Clamp(LocalPlayer():Health(), 0, LocalPlayer():GetMaxHealth()), 0, LocalPlayer():GetMaxHealth(), 0, health_sw), health_sy)
        end

        draw.SimpleTextOutlined(LocalPlayer():Health() .. " / " .. LocalPlayer():GetMaxHealth(), "IGVANILLAFontItalic", ScrW() / 2, ScrH() * 0.02, Color(245, 245, 245), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, Color(15, 15, 15))
        surface.SetDrawColor(Color(255, 255, 255, 125))
        surface.DrawOutlinedRect(health_px, health_py, health_sw, health_sy)
    end)]]
    function GM:HUDDrawTargetID()
    end
    --[[ local unrapedtable = {"download/materials/defcon/vanilla_1_defcon.png", "download/materials/defcon/vanilla_2_defcon.png", "download/materials/defcon/vanilla_3_defcon.png", "download/materials/defcon/vanilla_4_defcon.png", "download/materials/defcon/vanilla_5_defcon.png", "download/materials/defcon/vanilla_balance.png", "download/materials/defcon/vanilla_currentobjective.png", "download/materials/defcon/vanilla_currentobjective_colour.png", "download/materials/defcon/vanilla_mission.png", "download/materials/defcon/vanilla_regobjective.png", "materials/defcon/vanilla_1_defcon.png", "materials/defcon/vanilla_2_defcon.png", "materials/defcon/vanilla_3_defcon.png", "materials/defcon/vanilla_4_defcon.png", "materials/defcon/vanilla_5_defcon.png", "materials/defcon/vanilla_balance.png", "materials/defcon/vanilla_currentobjective.png", "materials/defcon/vanilla_currentobjective_colour.png", "materials/defcon/vanilla_mission.png", "materials/defcon/vanilla_regobjective.png"}

    local function hudraped()
        local hudrapedcount = 0

        for k, v in pairs(unrapedtable) do
            if file.Exists(v, "GAME") then
                hudrapedcount = hudrapedcount + 1
            end
        end

        return hudrapedcount < 10
    end

    hook.Add("InitPostEntity", "HUDRAPENOTIFY", function()
        timer.Simple(15, function()
            if hudraped() then
                hook.Remove("HUDPaint", "IGHEALTHBARDrawHud")
                hook.Remove("HUDPaint", "IGVANILLADEFCON")
                hook.Remove("HUDPaint", "IGOBJPaintHUD")
                hook.Remove("HUDPaint", "QUEST_SYSTEM_Quest_Progress")
                hook.Remove("HUDDrawScoreBoard", "QUEST_SYSTEM_CreditsTabShow")
                hook.Remove("HUDPaint", "Compass")

                hook.Add("HUDPaint", "HUDRAPENOTIFY", function()
                    draw.SimpleText("TYPE 'cl_downloadfilter all;retry' IN YOUR CONSOLE (~) IF YOU ARE SEEING THIS MESSAGE", "Trebuchet24", ScrW() / 2, ScrH() / 2, Color(255, 0, 0), 1, 1)
                    chat.AddText(Color(255, 0, 0), "TYPE 'cl_downloadfilter all;retry' IN YOUR CONSOLE (~) IF YOU ARE SEEING THIS MESSAGE")
                end)

                hook.Add("HUDPaint", "HUDRAPENOTIFY2", function()
                    draw.SimpleText("TYPE 'cl_downloadfilter all;retry' IN YOUR CONSOLE (~) IF YOU ARE SEEING THIS MESSAGE", "Trebuchet24", ScrW() / 2 / 2, ScrH() / 2 / 2, Color(255, 0, 0), 1, 1)
                end)

                hook.Add("HUDPaint", "HUDRAPENOTIFY3", function()
                    draw.SimpleText("TYPE 'cl_downloadfilter all;retry' IN YOUR CONSOLE (~) IF YOU ARE SEEING THIS MESSAGE", "Trebuchet24", ScrW() / 2 * 1.5, ScrH() / 2 * 1.5, Color(255, 0, 0), 1, 1)
                end)
            end
        end)
    end)]]
end