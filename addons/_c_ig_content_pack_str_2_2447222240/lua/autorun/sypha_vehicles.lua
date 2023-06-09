local Category = "Syphadias"

local function StandAnimation( vehicle, player )
	return player:SelectWeightedSequence( ACT_HL2MP_IDLE_PASSIVE ) 
end

local V = {
	Name = "Syphas Custom Seat",
	Model = "models/nova/airboat_seat.mdl",
	Class = "prop_vehicle_prisoner_pod",
	Category = Category,

	Author = "Syphadias",
	Information = "Seat by Syphadias with custom animation",
	Offset = 16,

	KeyValues = {
		vehiclescript = "scripts/vehicles/prisoner_pod.txt",
		limitview = "0"
	},
	Members = {
		HandleAnimation = StandAnimation,
	}
}
list.Set( "Vehicles", "sypha_seat", V )
