PrecacheParticleSystem( "explosion_huge_k" )

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

hook.Add("CalcMainActivity", "40kFieldGunSeatAnimOverride", function (ply, vel)
    local seat = ply:GetVehicle()

    if (not IsValid(seat) or not IsValid(seat:GetParent()) or seat:GetParent():GetClass() ~= "sent_40k_fieldcannon") then return end

    ply.CalcIdeal = ACT_WALK_RELAXED
    ply.CalcSeqOverride = ply:LookupSequence("cwalk_all")

    return ply.CalcIdeal, ply.CalcSeqOverride
end)

hook.Add("UpdateAnimation", "40kFieldGunSeatAnimWalk", function ( ply, velocity, maxSeqGroundSpeed )
	local seat = ply:GetVehicle()
    if IsValid(seat) and IsValid(seat:GetParent()) and (seat:GetParent():GetClass() == "sent_40k_fieldcannon") then
        local Fieldcannon = seat:GetParent()
        local HorizontalMovement = Fieldcannon:GetNWFloat("HorizontalMovement", 0)
        local FrontalMovement = Fieldcannon:GetNWFloat("FrontalMovement", 0)
        ply:SetPoseParameter("move_x", FrontalMovement)
		ply:SetPoseParameter("move_y", HorizontalMovement)
	end
end)

hook.Add("CalcView", "40kFieldGunCameraOverride", function (ply, pos, angles, fov)
    local seat = LocalPlayer():GetVehicle()
    if IsValid(seat) and IsValid(seat:GetParent()) and (seat:GetParent():GetClass() == "sent_40k_fieldcannon") and LocalPlayer():GetViewEntity() == LocalPlayer() then
        local Fieldcannon = seat:GetParent()
        local AimMode1 = Fieldcannon:GetNWFloat("AimMode", 0 )
        if AimMode1 == 0 then
            local view = {
                origin = ply:GetPos() + Vector(0,0,70),
                angles = angles,
                fov = fov,
                drawviewer = true
            }
            return view
       	elseif AimMode1 == 1 then
            local view = {
                origin = Fieldcannon:GetPos() + Vector(0,0,90) - angles:Forward() * 250,
                angles = angles,
                fov = fov,
                drawviewer = true
            }
            return view
        end


    end
end)

hook.Add( "HUDPaint", "40kFieldGunDrawHUD", function()
    local seat = LocalPlayer():GetVehicle()
    if IsValid(seat) and IsValid(seat:GetParent()) and (seat:GetParent():GetClass() == "sent_40k_fieldcannon") then
        local Fieldcannon = seat:GetParent()
        local BolterAmmo = Fieldcannon:GetNWFloat("BolterAmmo", 0)
        local Weapon = Fieldcannon:GetNWFloat("Weapon", 0)
        local ReloadTime = Fieldcannon:GetNWFloat("ReloadTime", 0)
        local Ready = Fieldcannon:GetNWBool("Ready", 0)
        local AmmoTypeFieldcannon = Fieldcannon:GetNWString("AmmoTypeFieldcannon", 0)
        local AutocannonAmmo = Fieldcannon:GetNWFloat("AutocannonAmmo", 0)
        local ModePlasmacannon = Fieldcannon:GetNWString("ModePlasmacannon", 0)
        local AimAttachment = Fieldcannon:GetAttachment(Fieldcannon:LookupAttachment(Fieldcannon:GetNWString("AimAttachment", 0)))
            local trace = util.TraceLine( {
                start = AimAttachment.Pos,
                endpos = AimAttachment.Pos+AimAttachment.Ang:Forward()*99999,
                filter = Fieldcannon,
            } )
            local hitpos = trace.HitPos

            local scr = hitpos:ToScreen()

            surface.SetDrawColor(255,255,100,255)
            surface.DrawCircle( scr.x, scr.y, 10, 255, 255, 255, 220 )
            surface.DrawCircle( scr.x, scr.y, 11, 255, 255, 255, 220 )
            surface.DrawCircle( ScrW()/2, ScrH()/2, 20, 230, 230, 230, 100 )
            surface.DrawCircle( ScrW()/2, ScrH()/2, 21, 230, 230, 230, 100 )

            draw.SimpleText( math.Round(AimAttachment.Pos:Distance( trace.HitPos )/52.49344, 1).." m", "ORArtilleryHUDFont", scr.x+20, scr.y-20, Color( 255, 255, 255, 255 ) )
            if Weapon == 0 then
            	draw.SimpleText( AmmoTypeFieldcannon, "ORArtilleryHUDFont", scr.x+20, scr.y-60, Color( 255, 255, 255, 255 ) )
            	if Ready then
            		draw.SimpleText( "Ready", "ORArtilleryHUDFont", scr.x+20, scr.y+20, Color( 255, 255, 255, 255 ) )
            	else 
            		draw.SimpleText( math.Clamp(math.Round(ReloadTime-CurTime(), 1), 0, 60).." s", "ORArtilleryHUDFont", scr.x+20, scr.y+20, Color( 255, 255, 255, 255 ) )
            	end
            elseif Weapon == 1 then
            	if Ready then
            		draw.SimpleText( AutocannonAmmo.." rnds", "ORArtilleryHUDFont", scr.x+20, scr.y+20, Color( 255, 255, 255, 255 ) )
            	else
            		draw.SimpleText( math.Clamp(math.Round(ReloadTime-CurTime(), 1), 0, 60).." s", "ORArtilleryHUDFont", scr.x+20, scr.y+20, Color( 255, 255, 255, 255 ) )
            	end
            elseif Weapon == 2 or Weapon == 3 then
            	if Ready then
            		draw.SimpleText( BolterAmmo.." rnds", "ORArtilleryHUDFont", scr.x+20, scr.y+20, Color( 255, 255, 255, 255 ) )
            	else 
            		draw.SimpleText( math.Clamp(math.Round(ReloadTime-CurTime(), 1), 0, 60).." s", "ORArtilleryHUDFont", scr.x+20, scr.y+20, Color( 255, 255, 255, 255 ) )
            	end
            elseif Weapon == 5 then
            	if Ready then
            		draw.SimpleText( "Ready", "ORArtilleryHUDFont", scr.x+20, scr.y+20, Color( 255, 255, 255, 255 ) )
            	else 
            		draw.SimpleText( math.Clamp(math.Round(ReloadTime-CurTime(), 1), 0, 60).." s", "ORArtilleryHUDFont", scr.x+20, scr.y+20, Color( 255, 255, 255, 255 ) )
            	end
            elseif Weapon == 6 then
            	draw.SimpleText( ModePlasmacannon, "ORArtilleryHUDFont", scr.x+20, scr.y-60, Color( 255, 255, 255, 255 ) )
            	if Ready then
            		draw.SimpleText( "Ready", "ORArtilleryHUDFont", scr.x+20, scr.y+20, Color( 255, 255, 255, 255 ) )
            	else 
            		draw.SimpleText( math.Clamp(math.Round(ReloadTime-CurTime(), 1), 0, 60).." s", "ORArtilleryHUDFont", scr.x+20, scr.y+20, Color( 255, 255, 255, 255 ) )
            	end
            end
    end
end )

--local AimAttachment = Fieldcannon:GetNWString("AimAttachment", 0)