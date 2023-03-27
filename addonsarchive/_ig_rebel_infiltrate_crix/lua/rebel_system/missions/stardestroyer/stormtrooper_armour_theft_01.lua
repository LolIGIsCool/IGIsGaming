MISSION.Name = "stormtrooper equipment theft" --String, MUST BE UNIQUE. No other mission name can be the same
MISSION.Instructions = "Go the stormtrooper bunks and steal some equipment"--String, this info is what the player receives on start of mission
MISSION.DropLocationIntructions = "Take the supplies to mh2" --String, this what the player receives when they got the equipment 
MISSION.Reward = 500 --INT
MISSION.Penalty = 10 --INT
MISSION.Time  = 90 --amount of time you have to take the equipment to the drop location
MISSION.Radius = 200 --how big is the zone the rebel has to get too
MISSION.MainPoint = Vector(-2980.6950683594,1778.412109375,-6015.96875) -- point to get the equipment from, MUST BE A VECTOR
MISSION.Level = 1 -- when a level is completed, the next mission will be randomly selected from a level that is higher. 
MISSION.Type = "Theft" -- used to make sure the player has droped the spawned entity in the DropLocation 
MISSION.CurrentTarget = nil --Make this the same as the mainpoint
MISSION.IsDelieveryingItem = false -- used in the inprogress function to determine whether there is another part of the mission to complete

MISSION.Model = "models/kingpommes/emperors_tower/imp_crates/imp_crate_single_closed_static.mdl"

MISSION.OnStart = REBEL_FUNCTIONS.TheftOnStart
-- returns whether the mission is still in progress
MISSION.InProgress = REBEL_FUNCTIONS.TheftInProgress

MISSION.OnAbort = REBEL_FUNCTIONS.TheftOnAbort