-- Based on code provided for gm_eperors_tower by P4sca1
-- Adapted by KingPommes for Venator and ISD
-- Oni was here too.


if game.GetMap() ~= "rp_venator_extensive_v1_4" then return end
 
local masterCount = 2
local cannonCount = 8 + masterCount --plus two master seats
local cannonCache = {} --caching the cannons instead of finding them every tick safes much performance
local turretCache = {}
local exitOffset = Vector(-32, 32, 8)

local cannonX = "TLXAxis"
local cannonY = "TLYAxis"
local cannonTrack = "TLTrack"
local cannonSeat = "TLSeat"

local viewOffsetForward = 128
local viewOffsetUp = 0

local function IsValidCannon(cannon)
	local cannon = cannonCache[cannon]

	if cannon and IsValid(cannon.x) and IsValid(cannon.y) and IsValid(cannon.track) and IsValid(cannon.seat) then
		return true
    end

    return false
end

if CLIENT then
    local inCannon = false
	local turret
 
    net.Receive("DSEnterCannon", function(len, pl)
        inCannon = true
		turret = net.ReadEntity()
    end)
 
    net.Receive("DSLeaveCannon", function(len, pl)
        inCannon = false
		turret = nil
    end)
	

	hook.Add("CalcVehicleView", "UpdateCannonView", function(vehicle, ply, view)
		if inCannon then
			local newView = {}
			if (turret:GetModel() == "models/lordtrilobite/starwars/props/imp_chair01_cis.mdl") then
				newView.origin = vehicle:GetPos() + vehicle:GetForward() * 100 + vehicle:GetRight() * -1000 + vehicle:GetUp() * -15000
				newView.angles = newView.angles
			elseif (turret:GetModel() == "models/kingpommes/starwars/venator/turbolaser_seat_venator.mdl") then
				newView.origin = vehicle:GetPos() + vehicle:GetForward() * 100 + vehicle:GetRight() * -2500 + vehicle:GetUp() * -2600
				newView.angles = newView.angles
			else
				newView.origin = turret:GetPos() + turret:GetForward() * viewOffsetForward + turret:GetUp() * viewOffsetUp
				newView.angles = newView.angles
			end
			return newView
		end
	end)
end
 
if SERVER then
	hook.Add("Think", "UpdateCannonPos", function()
		for i = 1, cannonCount , 1 do
			
				-- create cache if it does not already exist or update it, if it is not valid anymore			
				if !IsValidCannon(i) then
				
					cannonCache[i] = {}
					if (i <= cannonCount - masterCount) then
						cannonCache[i]["x"] = ents.FindByName(cannonX .. i)[1]
						cannonCache[i]["y"] = ents.FindByName(cannonY .. i)[1]
						cannonCache[i]["track"] = ents.FindByName(cannonTrack .. i)[1]
						cannonCache[i]["seat"] = ents.FindByName(cannonSeat .. i)[1]
					else
						cannonCache[i]["seat"] = ents.FindByName(cannonSeat .. i)[1]
						cannonCache[i]["x"] = cannonCache[i]["seat"]
						cannonCache[i]["y"] = cannonCache[i]["seat"]
						cannonCache[i]["track"] = cannonCache[i]["seat"]
						continue
					end
					
					if IsValid(cannonCache[i]["seat"]) then
						cannonCache[i]["seat"]:SetVehicleClass("phx_seat2")
					end
				
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
        if string.StartWith(veh:GetName(), cannonSeat) then
            net.Start("DSEnterCannon")
			local turret
			for i = 1, cannonCount, 1 do
				if (cannonCache[i]["seat"] == veh) then
					turret = cannonCache[i]["y"]
					break
				end
			end
			net.WriteEntity(turret)
            net.Send(ply)
			ply:CrosshairEnable()
		end
		
		if (!IsValid(veh.applied)) then
			if (veh:GetKeyValues()["hammerid"] ~= 0) then
				if (veh:GetModel() == "models/kingpommes/starwars/misc/seats/turbolaser_seat.mdl") then
					veh:SetVehicleClass("phx_seat2")
					veh.applied = true
				end
			end
		end
    end)
 
    util.AddNetworkString("DSLeaveCannon")
 
    hook.Add("PlayerLeaveVehicle", "LeaveCannon", function(ply, veh)
		if (string.StartWith(veh:GetName(), cannonSeat)) then
			net.Start("DSLeaveCannon")
			net.Send(ply)
	
			ply:SetPos(veh:GetPos() + veh:GetForward() * exitOffset.x + veh:GetRight() * exitOffset.y + veh:GetUp() * exitOffset.z)
			return
		end
		if (veh:GetKeyValues()["hammerid"] ~= 0) then
			ply:SetPos(veh:GetPos() + veh:GetRight() * -32)
		end
    end)
end