if (CLIENT) then
    surface.CreateFont("ORArtilleryHUDFont", {
        font = "Arial", --  Use the font-name which is shown to you by your operating system Font Viewer, not the file name
        extended = false,
        size = 40,
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
        outline = false,
    })
end

hook.Add("CalcMainActivity", "ORGunPlatformArtillerySeatAnimOverride", function (ply, vel)
    local seat = ply:GetVehicle()

    if (not IsValid(seat) or not IsValid(seat:GetParent()) or seat:GetParent():GetClass() ~= "or_gun_platform_artillery") then return end

    ply.CalcIdeal = ACT_IDLE
    ply.CalcSeqOverride = ply:LookupSequence("pose_standing_02")

    return ply.CalcIdeal, ply.CalcSeqOverride
end)

hook.Add("CalcView", "ORGunPlatformArtilleryCameraOverride", function (ply, pos, angles, fov)
    local seat = LocalPlayer():GetVehicle()
    if IsValid(seat) and IsValid(seat:GetParent()) and (seat:GetParent():GetClass() == "or_gun_platform_artillery") and LocalPlayer():GetViewEntity() == LocalPlayer() then
        local Platform = seat:GetParent()
        local AimAttachment = Platform:GetAttachment(Platform:LookupAttachment("gunner_aim"))
        local FireMode = Platform:GetNWFloat("PlatformFireMode", 1 )
        local Camera = Platform:GetNWEntity( "Camera", 0 )
        if FireMode == 0 then
            local view = {
                origin = seat:GetParent():GetPos() + Vector(0,0,100) - angles:Forward() * 350,
                angles = angles,
                fov = fov,
                drawviewer = true
            }
            return view
        else if FireMode == 1 then
            local view = {
                origin = AimAttachment.Pos,
                angles = AimAttachment.Ang,
                fov = fov,
                drawviewer = true
            }
            return view
        else if FireMode == 2 then
            local view = {
                origin = Camera:GetPos(),
                angles = Angle(90,0,0),
                fov = fov,
                drawviewer = true
            }
            return view
        end
    end
        end
    end
end)

local function DrawCircle( X, Y )
    local radius = 20
    local segmentdist = 360 / ( 2 * math.pi * 20 / 2 )
    for a = 0, 360, segmentdist do
        surface.DrawLine( X + math.cos( math.rad( a ) ) * radius, Y - math.sin( math.rad( a ) ) * radius, X + math.cos( math.rad( a + segmentdist ) ) * radius, Y - math.sin( math.rad( a + segmentdist ) ) * radius )
        
        surface.DrawLine( X + math.cos( math.rad( a ) ) * radius, Y - math.sin( math.rad( a ) ) * radius, X + math.cos( math.rad( a + segmentdist ) ) * radius, Y - math.sin( math.rad( a + segmentdist ) ) * radius )
    end
end

local AzimuthReticleMaterial = Material( "vgui/or_artillery/azimuth_reticle.png")
local SpreadMarker = Material( "vgui/or_artillery/spread_marker.png")

hook.Add( "HUDPaint", "ORGunPlatformArtilleryDrawHUD", function()
    local seat = LocalPlayer():GetVehicle()
    if IsValid(seat) and IsValid(seat:GetParent()) and (seat:GetParent():GetClass() == "or_gun_platform_artillery") then
        local Platform = seat:GetParent()
        local AimAttachment = Platform:GetAttachment(Platform:LookupAttachment(Platform:GetNWString("AimAttachmentName", 0)))
        local Gunner = LocalPlayer()
        local FireMode = Platform:GetNWFloat("PlatformFireMode", 1 )
        local Camera = Platform:GetNWEntity("Camera", 0)
        local ReloadTime = Platform:GetNWFloat("ReloadTime", 0)
        if FireMode == 1 then
            local trace = util.TraceLine( {
                start = AimAttachment.Pos,
                endpos = AimAttachment.Pos+AimAttachment.Ang:Forward()*99999,
                filter = Platform,
            } )
            local hitpos = trace.HitPos

            local scr = hitpos:ToScreen()

            surface.DrawCircle( scr.x, scr.y, 10, 255, 255, 255, 220 )
            surface.DrawCircle( ScrW()/2, ScrH()/2, 20, 230, 230, 230, 200 )
            draw.SimpleText( math.Round(Platform:GetPos():Distance( trace.HitPos )/52.49344, 1).." m", "ORArtilleryHUDFont", scr.x+20, scr.y-20, Color( 255, 255, 255, 255 ) )
        elseif FireMode == 2 then
            local trace = util.TraceLine( {
                start = Camera:GetPos(),
                endpos = Camera:GetPos() + Vector(0,0,-99999),
                filter = Camera,
            } )

            local hitpos = trace.HitPos

            local scr = hitpos:ToScreen()
            draw.SimpleText( math.Round((-AimAttachment.Ang.yaw % 360), 1).." °", "ORArtilleryHUDFont", scr.x+30, scr.y-60, Color( 255, 255, 255, 255 ) )
            draw.SimpleText( math.Round(Platform:GetPos():Distance( trace.HitPos )/52.49344, 1).." m", "ORArtilleryHUDFont", scr.x+20, scr.y-20, Color( 255, 255, 255, 255 ) )
            if math.Round(ReloadTime-CurTime(), 1) > 0 then
                draw.SimpleText( math.Round(ReloadTime-CurTime(), 1).." s", "ORArtilleryHUDFont", scr.x+30, scr.y+20, Color( 255, 255, 255, 255 ) )
            else draw.SimpleText( "Ready!", "ORArtilleryHUDFont", scr.x+30, scr.y+20, Color( 255, 255, 255, 255 ) ) end

            surface.SetMaterial( AzimuthReticleMaterial )
            surface.SetDrawColor(255,255,255,255)
            surface.DrawTexturedRect( ScrW()/2-384, ScrH()/2-384, 768, 768 )

            local start = AimAttachment.Pos:ToScreen()
            surface.DrawLine( start.x, start.y, ScrW()/2, ScrH()/2 )

        end
    end
end )

hook.Add("PostDrawTranslucentRenderables", "ORGunPlatformArtilleryDrawSpread", function()
    local seat = LocalPlayer():GetVehicle()
    if IsValid(seat) and IsValid(seat:GetParent()) and (seat:GetParent():GetClass() == "or_gun_platform_artillery") then
        local Platform = seat:GetParent()
        local AimAttachment = Platform:GetAttachment(Platform:LookupAttachment(Platform:GetNWString("AimAttachmentName", 0)))
        local Gunner = LocalPlayer()
        local FireMode = Platform:GetNWFloat("PlatformFireMode", 1 )
        local Camera = Platform:GetNWEntity("Camera", 0)
        local Ready = Platform:GetNWBool("Ready", 0)
        local ReloadTime = Platform:GetNWFloat("ReloadTime", 0)
        if Ready and FireMode == 2 then
            local trace = util.TraceLine( {
                start = Camera:GetPos(),
                endpos = Camera:GetPos() + Vector(0,0,-99999),
                filter = Camera,
            } )

            trace.HitPos.z = trace.HitPos.z+100
            
            cam.Start3D2D(trace.HitPos,angle_zero,1)
                if math.Round(ReloadTime-CurTime(), 1) < 0 then
                    surface.SetDrawColor(0,255,0,255)
                else surface.SetDrawColor(255,0,0,255) end
                surface.SetMaterial(SpreadMarker)
                local spread = Platform:GetPos():Distance(trace.HitPos)/Platform:GetNWFloat("Spread", 0)*1.5
                surface.DrawTexturedRect(-spread,-spread,spread*2,spread*2)
            cam.End3D2D()
        end
    end
end )