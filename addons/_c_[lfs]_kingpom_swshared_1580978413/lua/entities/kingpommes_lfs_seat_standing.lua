

local Category = "Map Utilities"

local function StandAnimation( vehicle, player )
	return player:SelectWeightedSequence( ACT_HL2MP_IDLE )
end

local Seat = {
	Name = "Standing Seat",
	Model = "models/kingpommes/starwars/misc/seats/seat_stand.mdl",
	Class = "prop_vehicle_prisoner_pod",
	Category = Category,

	Author = "KingPommes",
	Information = "Seat with a standing animation",
	Offset = 16,

	KeyValues = {
		vehiclescript = "scripts/vehicles/prisoner_pod.txt",
		limitview = "0"
	},
	Members = {
		HandleAnimation = StandAnimation
	}
}

list.Set( "Vehicles", "kingpommes_lfs_seat_standing", Seat )
