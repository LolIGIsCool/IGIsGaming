local Category = "Vehicle Utilities"

local function StandAnimation( vehicle, player )
	return player:SelectWeightedSequence( ACT_HL2MP_IDLE_PASSIVE )
end

local V = {
	Name = "Lava Skiff Standing Seat",
	Model = "models/nova/airboat_seat.mdl",
	Class = "prop_vehicle_prisoner_pod",
	Category = Category,
	Author = "niksacokica",
	Information = "Seat that makes the pilot stand.",
	Offset = 0,

	KeyValues = {
		vehiclescript = "scripts/vehicles/prisoner_pod.txt",
		limitview = "0"
	},
	
	Members = {
		HandleAnimation = StandAnimation
	}
}
list.Set( "Vehicles", "lava_skiff_stand", V )