-- Created by Oninoni
-- Based on Code by Syphadias
-- Huge thanks to them!

-- This has to match the map Name
if not (game.GetMap() == "rp_mos_mesric_v2_2" or game.GetMap() == "rp_mos_mesric_v2_1") then return end

-- The Ammount of Bacta Tanks that are used
local bactaCount = 2

-- The Name of the prop_vehicle_prisoner_pod without its suffix (e.g. bacta1, bacta2, ... -> bacta)
local entityName = "bacta"

-- Bacta Seat Don't fricking touch anything below this line!
local Category = "Map Utilities"
local function StandAnimation( vehicle, player )
	return player:SelectWeightedSequence( ACT_GMOD_NOCLIP_LAYER )
end
local V = {
    Name = "Bacta Tank Seat",
	Model = "models/lordtrilobite/starwars/props/bactatankb.mdl",
    Class = "prop_vehicle_prisoner_pod",
    Category = Category,
 
    Author = "Syphadias, Oninoni",
    Information = "Seat with custom animation",
    Offset = 16,
 
    KeyValues = {
        vehiclescript = "scripts/vehicles/prisoner_pod.txt",
        limitview = "0"
    },
    Members = {
        HandleAnimation = StandAnimation
    }
}
list.Set( "Vehicles", "bacta_seat", V )
 
if SERVER then
    local seatCache = {}
    local function IsValidSeat(seat)
        local seat = seatCache[seat]
     
        if seat and IsValid(seat) then
			return true
        end
     
        return false
    end
	
	hook.Add("Think", "UpdateseatPosBacta", function()
		for i = 1, bactaCount, 1 do
			if !IsValidSeat(i) then
				seatCache[i] = ents.FindByName(entityName .. i)[1]

				if !IsValidSeat(i) then
					continue
				end
			end

			seatCache[i]:SetVehicleClass("bacta_seat")
		end
	end)
end