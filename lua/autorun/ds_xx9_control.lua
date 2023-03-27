-- Created by P4sca1
-- Edited by KingPommes
-- Oni was here too.




if game.GetMap() ~= "rp_deathstar_v1_2" then return end
 
local cannonCount = 2
local cannonCache = {} // caching the cannons instead of finding them every tick safes much performance
local exitOffset = Vector(64, 0, 8)

local function IsValidCannon(cannon)
	local cannon = cannonCache[cannon]

	if cannon and IsValid(cannon.x) and IsValid(cannon.y) and IsValid(cannon.track) then
		return true
    end

    return false
end

if CLIENT then
    local inCannon = false
 
    net.Receive("DSEnterCannon", function(len, pl)
        inCannon = true
    end)
 
    net.Receive("DSLeaveCannon", function(len, pl)
        inCannon = false
    end)
	

	hook.Add("CalcVehicleView", "UpdateCannonView", function(vehicle, ply, view)
		if inCannon then
			local newView = {}
			
			--local offset = Vector(200, 0, 0)
			--local offsetAngle = view.angles
			--offset:Rotate(offsetAngle)
			
			newView.origin = view.origin + Vector(0, -400, 650)-- + offset
			newView.angles = view.angles
			
			return newView
		end 
	end)
end
 
if SERVER then
	hook.Add("Think", "UpdateCannonPos", function()
		for i = 0, cannonCount, 1 do
			-- create cache if it does not already exist or update it, if it is not valid anymore
			if !IsValidCannon(i) then
				cannonCache[i] = {}
				cannonCache[i]["x"] = ents.FindByName("xx9PropA" .. i)[1]
				cannonCache[i]["y"] = ents.FindByName("xx9PropB" .. i)[1]
				cannonCache[i]["track"] = ents.FindByName("xx9_" .. i)[1]

				-- if the cannon is still not valid after searching it, then skip it, because it does not exist
				if !IsValidCannon(i) then
					continue
				end
			end

			cannonCache[i]["x"]:SetAngles(Angle(cannonCache[i]["x"]:GetAngles().pitch, cannonCache[i]["track"]:GetAngles().yaw, cannonCache[i]["x"]:GetAngles().roll))
			cannonCache[i]["y"]:SetAngles(Angle(cannonCache[i]["track"]:GetAngles().pitch, cannonCache[i]["y"]:GetAngles().yaw, cannonCache[i]["y"]:GetAngles().roll))
		end
	end)

    util.AddNetworkString("DSEnterCannon")
 
    hook.Add("PlayerEnteredVehicle", "EnterCannon", function(ply, veh, role)
        if string.StartWith(veh:GetName(), "TLSeat") then
            net.Start("DSEnterCannon")
            net.Send(ply)
        end
    end)
 
    util.AddNetworkString("DSLeaveCannon")
 
    hook.Add("PlayerLeaveVehicle", "LeaveCannon", function(ply, veh)
        if string.StartWith(veh:GetName(), "TLSeat") then
            net.Start("DSLeaveCannon")
            net.Send(ply)

            ply:SetPos(veh:GetPos() + exitOffset)
        end
    end)
end