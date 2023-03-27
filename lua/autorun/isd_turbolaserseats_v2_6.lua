-- Created upon the code similar to the one used in the Emperors_Tower map by P4sca1-
-- Edited by Oninoni and Airfox
-- Huge thanks to them!
 
if not (game.GetMap() == "rp_stardestroyer_v2_6" or game.GetMap() == "rp_stardestroyer_v2_6_inf") then return end
 
if CLIENT then
    -- Percentage of mouse slowdown. 0 is stopped 1 is 100%
    local mouseSlowdown = 0.1
 
    local inCannon = false

    local limit = 0

    local w = ScrW()
    local h = ScrH()

    local black = Color(0, 0, 0, 255)

    local lastTime = CurTime()
    local accumulatedTime = 0
    local blinkInterVal = 0.5
    local blink = 0
 
    net.Receive("VenatorEnterCannon", function(len, pl)
        inCannon = true
        lastTime = CurTime()
        accumulatedTime = 0
    end)
 
    net.Receive("VenatorLeaveCannon", function(len, pl)
        inCannon = false
    end)
   
    hook.Add("AdjustMouseSensitivity", "UpdateMouseSpeed", function(defaultSensitivity)
        if inCannon then
            return mouseSlowdown
        else
            return -1
        end
    end)

    net.Receive("VenatorCannonLimit", function(len, pl)
        limit = net.ReadInt(5)
    end)

    hook.Add("HUDPaint", "VenatorCannonHudDraw", function()
        if not inCannon then return end

        draw.RoundedBox(0, 0, 0, (w - h) / 2, h, black)
        draw.RoundedBox(0, w - (w - h) / 2, 0, (w - h) / 2, h, black)
            
        if limit == 0 then 
            draw.TexturedQuad({
                texture = surface.GetTextureID('models/KingPommes/starwars/Venator/tl_screen01'),
                x   = (w - h) / 2,
                y   = 0,
                w   = h,
                h   = h,
            })
        else
            draw.TexturedQuad({
                texture = surface.GetTextureID('models/KingPommes/starwars/Venator/tl_screen02'),
                x   = (w - h) / 2,
                y   = 0,
                w   = h,
                h   = h,
            })

            accumulatedTime = accumulatedTime + CurTime() - lastTime
            lastTime = CurTime()

            if accumulatedTime > blinkInterVal then
                accumulatedTime = accumulatedTime - blinkInterVal
                blink = (blink + 1) % 2 
			end

            if bit.band(limit, 1) > 0 and blink == 0 then
                draw.TexturedQuad({
                    texture = surface.GetTextureID('models/KingPommes/starwars/Venator/tl_arrow_down'),
                    x   = w * 0.5 - h * 0.04875 * 9.54,
                    y   = h * 0.571 - h * 0.04875,
                    w   = h * 0.0975 * 9.54,
                    h   = h * 0.0975 * 0.72
                })
            end
            if bit.band(limit, 2) > 0 and blink == 0 then
                draw.TexturedQuad({
                    texture = surface.GetTextureID('models/KingPommes/starwars/Venator/tl_arrow_up'),
                    x   = w * 0.5 - h * 0.04875 * 9.54,
                    y   = h * 0.4576 - h * 0.04875,
                    w   = h * 0.0975 * 9.54,
                    h   = h * 0.0975 * 0.72
                })
            end
            if bit.band(limit, 4) > 0 and blink == 1 then
                draw.TexturedQuad({
                    texture = surface.GetTextureID('models/KingPommes/starwars/Venator/tl_arrow_right'),
                    x   = w * 0.759 - h * 0.04875,
                    y   = h * 0.501 - h * 0.04875 * 1.22,
                    w   = h * 0.0975 * 0.56,
                    h   = h * 0.0975 * 1.22
                })
            end
            if bit.band(limit, 8) > 0 and blink == 1 then
                draw.TexturedQuad({
                    texture = surface.GetTextureID('models/KingPommes/starwars/Venator/tl_arrow_left'),
                    x   = w * 0.2661 - h * 0.04875,
                    y   = h * 0.501 - h * 0.04875 * 1.22,
                    w   = h * 0.0975 * 0.56,
                    h   = h * 0.0975 * 1.22
                })
            end
        end
    end)
end

if SERVER then
    -- Number of Cannons/Seats per side
    local cannonCount = 2
    
    -- Limits of movement in degrees for the guns.
    local gunLimits = {}
    -- Number represents the row of the gun.
    gunLimits[1] = {
		-- Values: 0 == Cannon idle direction
		--		  >0 == Front
		--        <0 == Back
        -- Frontal Yaw Limit
        maxYaw = 130,
        -- Back Yaw Limit
        minYaw = -70,
        -- Upper View Limit
        maxPitch = 5,
        -- Lower View Limit
        minPitch = -70
    }
    gunLimits[2] = {
        maxYaw = 145,
        minYaw = -80,
        maxPitch = 5,
        minPitch = -70
    }

    local cannonCache = {}
    local seatCache = {}
 
    util.AddNetworkString("VenatorEnterCannon")
 
    hook.Add("PlayerEnteredVehicle", "EnterCannon", function(ply, veh, role)
        if string.StartWith(veh:GetName(), "turbolaserseat_") then
            net.Start("VenatorEnterCannon")
            net.Send(ply)
        end
    end)
 
    util.AddNetworkString("VenatorLeaveCannon")
 
    hook.Add("PlayerLeaveVehicle", "LeaveCannon", function(ply, veh)
        if string.StartWith(veh:GetName(), "turbolaserseat_") then
            net.Start("VenatorLeaveCannon")
            net.Send(ply)
        end
    end)
 
    local function IsValidSeat(seat)
        local seat = seatCache[seat]
     
        if seat and IsValid(seat) then
            return true
        end
     
        return false
    end
     
    local function IsValidCannon(cannon)
        local cannon = cannonCache[cannon]
     
        if cannon and IsValid(cannon.x) and IsValid(cannon.y) and IsValid(cannon.track) then
            return true
        end
     
        return false
    end
 
    util.AddNetworkString("VenatorCannonLimit")
	local oldLimit = {}

    hook.Add("Think", "UpdateseatPos", function()
        for i = 1, cannonCount * 2, 1 do
            if !IsValidSeat(i) then
                seatCache[i] = ents.FindByName("turbolaserseat_" .. i)[1]
 
                if !IsValidSeat(i) then
                    continue
                end
            end
 
            seatCache[i]:SetVehicleClass("phx_seat2")
       
            if !IsValidCannon(i) then
                cannonCache[i] = {}
                cannonCache[i]["x"] = ents.FindByName("cannon_x" .. i)[1]
                cannonCache[i]["y"] = ents.FindByName("cannon_y" .. i)[1]
                cannonCache[i]["track"] = ents.FindByName("cannon_track" .. i)[1]
     
                if !IsValidCannon(i) then
                    continue
                end
            end
 
            local angles = cannonCache[i]["track"]:GetAngles()
            local pitch = angles.pitch
            local yaw = angles.yaw + 90
			if yaw > 180 then yaw = yaw - 360 end
            local limit = 0
 
            local iCorrected = math.floor((i + 1) / 2)
            
            if pitch > gunLimits[iCorrected].maxPitch or pitch < gunLimits[iCorrected].minPitch then
 
                if pitch < gunLimits[iCorrected].minPitch then
                    pitch = gunLimits[iCorrected].minPitch
                    limit = limit + 1
                else
                    pitch = gunLimits[iCorrected].maxPitch
                    limit = limit + 2
                end
            end
 
            if i % 2 == 1 then
                yaw = -yaw % 360 - 180
            end
			
            if yaw < gunLimits[iCorrected].minYaw or yaw > gunLimits[iCorrected].maxYaw then
 
                if yaw < gunLimits[iCorrected].minYaw then
                    yaw = gunLimits[iCorrected].minYaw
                    limit = limit + 4
                else
                    yaw = gunLimits[iCorrected].maxYaw
                    limit = limit + 8
                end
            end
 
            if i % 2 == 1 then
                yaw = -yaw + 180
            end

            local driver = seatCache[i]:GetDriver()

            if oldLimit[i] ~= limit and IsValid(driver) and driver:IsPlayer() then
                net.Start("VenatorCannonLimit")
                    net.WriteInt(limit, 5)
                net.Send(seatCache[i]:GetDriver())

                oldLimit[i] = limit
            end
 
            cannonCache[i]["x"]:SetAngles(Angle(
                cannonCache[i]["x"]:GetAngles().pitch,
                yaw - 90,
                cannonCache[i]["x"]:GetAngles().roll
            ))
 
            cannonCache[i]["y"]:SetAngles(Angle(
                pitch,
                cannonCache[i]["y"]:GetAngles().yaw,
                cannonCache[i]["y"]:GetAngles().roll
            ))
        end
    end)
end