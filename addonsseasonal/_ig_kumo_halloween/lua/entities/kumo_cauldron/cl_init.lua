include("shared.lua")
local spookn = 0
local boon = 0
local screamn = 0

function ENT:Draw()
    self:DrawModel()

    if (LocalPlayer():GetPos():Distance(self:GetPos()) < 1000) then
        local vecPos = self:GetPos()
        local vecAng = self:GetAngles()
        vecAng:RotateAroundAxis(vecAng:Up(), 90)
        vecAng:RotateAroundAxis(vecAng:Forward(), 90)
        local yourteam = LocalPlayer():GetNWString("halloweenteam", "none")
        local strTitle = "Spooky Cauldron"
        local strTitle2 = "Spooky Skeletons | " .. spookn .. " players"
        local strTitle3 = "Boo! Crew | " .. boon .. " players"
        local strTitle4 = "Scream Team | " .. screamn .. " players"
        if yourteam == "Spooky Skeletons" then
            strTitle2 = strTitle2.." (Your Team)"
        elseif yourteam == "Boo! Crew" then
            strTitle3 = strTitle3.." (Your Team)"
        elseif yourteam == "Scream Team" then
            strTitle4 = strTitle4.." (Your Team)"
        end
        surface.SetFont("QUEST_SYSTEM_ItemTitle")
        cam.Start3D2D(vecPos + Vector(0, 0, 76), vecAng, .25)
        draw.WordBox(0, -surface.GetTextSize(strTitle) / 2, -30, strTitle, "QUEST_SYSTEM_ItemTitle", Color(0, 0, 0, 200), color_white)
        cam.End3D2D()

        if yourteam == "none" then
            cam.Start3D2D(vecPos + Vector(0, 0, 69), vecAng, .25)
            draw.WordBox(0, -surface.GetTextSize("Press E on me to join a team!") / 2, -30, "Press E on me to join a team!", "QUEST_SYSTEM_ItemTitle", Color(0, 0, 0, 200), color_white)
            cam.End3D2D()
        else
            cam.Start3D2D(vecPos + Vector(0, 0, 69), vecAng, .25)
            draw.WordBox(0, -surface.GetTextSize(strTitle2) / 2, -30, strTitle2, "QUEST_SYSTEM_ItemTitle", Color(0, 0, 0, 200), Color(255, 0, 0, 255))
            cam.End3D2D()
            cam.Start3D2D(vecPos + Vector(0, 0, 62), vecAng, .25)
            draw.WordBox(0, -surface.GetTextSize(strTitle3) / 2, -30, strTitle3, "QUEST_SYSTEM_ItemTitle", Color(0, 0, 0, 200), Color(0, 255, 0, 255))
            cam.End3D2D()
            cam.Start3D2D(vecPos + Vector(0, 0, 55), vecAng, .25)
            draw.WordBox(0, -surface.GetTextSize(strTitle4) / 2, -30, strTitle4, "QUEST_SYSTEM_ItemTitle", Color(0, 0, 0, 200), Color(0, 0, 255, 255))
            cam.End3D2D()
        end
    end
end

net.Receive("OpenHalloweenChooser", function()
    Derma_Query("Choose your team! Be careful you only have one choice", "Haloween Team Chooser", "Spooky Skeletons", function()
        net.Start("JoinHalloweenTeam")
        net.WriteString("Spooky Skeletons")
        net.SendToServer()
    end, "Boo! Crew", function()
        net.Start("JoinHalloweenTeam")
        net.WriteString("Boo! Crew")
        net.SendToServer()
    end, "Scream Team", function()
        net.Start("JoinHalloweenTeam")
        net.WriteString("Scream Team")
        net.SendToServer()
    end, "Cancel", function() end)
end)

net.Receive("NetworkHalloweenPlayers", function()
    spookn = net.ReadUInt(16)
    boon = net.ReadUInt(16)
    screamn = net.ReadUInt(16)
end)