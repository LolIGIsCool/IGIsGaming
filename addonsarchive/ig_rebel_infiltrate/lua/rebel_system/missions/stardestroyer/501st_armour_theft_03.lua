MISSION.Name = "501st equipment theft" --String, MUST BE UNIQUE. No other mission name can be the same
MISSION.Instructions = "Go to the 501st bunks and take some guns"--String, this info is what the player receives on start of mission
MISSION.Reward = 2500 --INT
MISSION.Penalty = 40 --INT
MISSION.Time  = 90 --amount of time you have to take the equipment to the drop location
MISSION.Radius = 150 --how big is the zone the rebel has to get too
MISSION.MainPoint = Vector(-2390.1176757813,1246.9553222656,-4863.96875) -- point to get the equipment from, MUST BE A VECTOR
MISSION.Level = 3 -- when a level is completed, the next mission will be randomly selected from a level that is higher. 
MISSION.Type = "Theft" -- used to make sure the player has droped the spawned entity in the DropLocation 
MISSION.CurrentTarget = nil --Make this the same as the mainpoint
MISSION.IsDelieveryingItem = false -- used in the inprogress function to determine whether there is another part of the mission to complete

MISSION.Model = "models/kingpommes/emperors_tower/imp_crates/imp_crate_single_closed_static.mdl"

MISSION.OnStart = REBEL_FUNCTIONS.TheftOnStart
-- returns whether the mission is still in progress
MISSION.InProgress = REBEL_FUNCTIONS.TheftInProgress

MISSION.OnAbort = REBEL_FUNCTIONS.TheftOnAbort