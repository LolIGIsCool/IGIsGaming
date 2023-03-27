-- Oni was here


if game.GetMap() ~= "rp_deathstar" then return end
 
local Category = "Map Utilities"
local function StandAnimation( vehicle, player )
	return player:SelectWeightedSequence( ACT_HL2MP_IDLE )
end
local V = {
    Name = "Hyperspace Map Seat",
	Model = "models/lordtrilobite/starwars/props/bactatankb.mdl",
    Class = "prop_vehicle_prisoner_pod",
    Category = Category,
 
    Author = "Syphadias, Oninoni",
    Information = "Seat with custom animation",
    Offset = 0,
 
    KeyValues = {
        vehiclescript = "scripts/vehicles/prisoner_pod.txt",
        limitview = "0"
    },
    Members = {
        HandleAnimation = StandAnimation
    }
}
list.Set( "Vehicles", "hyperspace_seat", V )
 
if CLIENT then
	local inHyperspaceMap = false
	local cursor = nil
	
    net.Receive("DeathstarSetHyperspacePlayer", function(len, pl)
        inHyperspaceMap = true
		cursor = net.ReadEntity()
    end)
 
    net.Receive("DeathstarResetHyperspacePlayer", function(len, pl)
        inHyperspaceMap = false
    end)
	
	hook.Add("CalcView", "UpdateHyperspaceMapView", function(ply, origin, angles, fov, znear, zfar)
		if not inHyperspaceMap then return end
		if not IsValid(cursor) then return end
		
		local view = {}
		
		view.origin = cursor:GetPos() + Vector(64, 0, 80)
		view.angles = angles + Angle(15, 45, 0)
		view.fov = fov
		view.drawviewer = true
		
		return view
	end)
end

if SERVER then
	util.AddNetworkString("DeathstarSetHyperspacePlayer")
	util.AddNetworkString("DeathstarResetHyperspacePlayer")

	local lastPlayer = nil
	
	hook.Add("Think", "DeathstarUpdateHyperspacePlayer", function()
		local players = ents.FindByName("galaxymapuser")
		
		if not #player == 1 and lastPlayer then
			net.Start("DeathstarResetHyperspacePlayer")
			net.Send(lastPlayer)
			
			lastPlayer = nil
			return
		end
		
		local ply = players[1]
		
		if ply == lastPlayer then return end
		
		if lastPlayer then
			net.Start("DeathstarResetHyperspacePlayer")
			net.Send(lastPlayer)
			
			lastPlayer = nil
			return
		end
		
		lastPlayer = ply
		
		local cursors = ents.FindByName("Tgt1")
		if #cursors ~= 1 then return end
		
		net.Start("DeathstarSetHyperspacePlayer")
			net.WriteEntity(cursors[1])
		net.Send(lastPlayer)
	end)
	
	hook.Add("Think", "UpdateseatPosHyperspace", function()
		local seats = ents.FindByName("MapSeat")
		
		if #seats ~= 1 then return end
		
		seats[1]:SetVehicleClass("hyperspace_seat")
	end)
end