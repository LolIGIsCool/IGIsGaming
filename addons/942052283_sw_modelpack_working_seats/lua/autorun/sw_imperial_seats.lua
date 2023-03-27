
-- Don't try to edit this file if you're trying to add new vehicles
-- Just make a new file and copy the format below.

local function AddVehicle( t, class )
	list.Set( "Vehicles", class, t )
end

local Category = "Star Wars Seats"

AddVehicle( {
	-- Required information
	Name = "Emperors Throne",
	Model = "models/KingPommes/starwars/misc/seats/palp_chair_full.mdl",
	Class = "prop_vehicle_prisoner_pod",
	Category = Category,

	-- Optional information
	Author = "KingPommes",
	Information = "Emperors Throne",

	KeyValues = {
		vehiclescript = "scripts/vehicles/prisoner_pod.txt"
	}
}, "emperors_throne" )

AddVehicle( {
	-- Required information
	Name = "Imperial Conferencechair",
	Model = "models/KingPommes/starwars/misc/seats/imp_chaira.mdl",
	Class = "prop_vehicle_prisoner_pod",
	Category = Category,

	-- Optional information
	Author = "KingPommes",
	Information = "Imperial Covfefe-chair",

	KeyValues = {
		vehiclescript = "scripts/vehicles/prisoner_pod.txt"
	}
}, "imperial_conference_chair" )

AddVehicle( {
	-- Required information
	Name = "Tarkins Conferencechair",
	Model = "models/KingPommes/starwars/misc/seats/imp_chairb.mdl",
	Class = "prop_vehicle_prisoner_pod",
	Category = Category,

	-- Optional information
	Author = "KingPommes",
	Information = "Tarkins Covfefe-chair",

	KeyValues = {
		vehiclescript = "scripts/vehicles/prisoner_pod.txt"
	}
}, "tarkins_conference_chair" )


AddVehicle( {
	-- Required information
	Name = "Senat Armchair",
	Model = "models/KingPommes/starwars/misc/seats/imp_armchair.mdl",
	Class = "prop_vehicle_prisoner_pod",
	Category = Category,

	-- Optional information
	Author = "KingPommes",
	Information = "Senat Armchair",

	KeyValues = {
		vehiclescript = "scripts/vehicles/prisoner_pod.txt"
	}
}, "senat_armchair" )

AddVehicle( {
	-- Required information
	Name = "Bridgecrew Seat",
	Model = "models/lordtrilobite/starwars/props/imp_chair01.mdl",
	Class = "prop_vehicle_prisoner_pod",
	Category = Category,

	-- Optional information
	Author = "Lord Trilobite",
	Information = "Bridgecrew Seat",

	KeyValues = {
		vehiclescript = "scripts/vehicles/prisoner_pod.txt"
	}
}, "bridgecrew_seat" )
