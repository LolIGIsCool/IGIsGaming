MISSION.Name = "Bounty Hunter Equipment Theft" --MUST BE UNIQUE. No other mission name can be the same
MISSION.Instructions = "Go to the bounty hunter lounge wtih this keycard and take some of their equipment" --String, this info is what the player receives on start of mission
MISSION.Reward = 1000--INT
MISSION.Penalty = 10--INT
MISSION.Time  = 90--amount of time you have to take the equipment to the drop location
MISSION.Radius  = 100--how big is the zone the rebel has to get too
MISSION.MainPoint  = Vector(4849.06640625,492.21221923828,-5743.96875)-- point to get the equipment from, MUST BE A VECTOR
MISSION.Level = 2 -- when a level is completed, the next mission will be randomly selected from a level that is higher. 
MISSION.Type = "Theft" -- used to make sure the player has droped the spawned entity in the DropLocation 
MISSION.CurrentTarget = nil --Make this the same as the mainpoint
MISSION.IsDelieveryingItem = false -- used in the inprogress function to determine whether there is another part of the mission to complete
MISSION.KeyCardID = 17 --"Imperial Contracted Bounty Hunter ID"
MISSION.SubType = "Infiltrate"
MISSION.Model = "models/kingpommes/emperors_tower/imp_crates/imp_crate_single_closed_static.mdl"

MISSION.OnStart = REBEL_FUNCTIONS.InfiltrateOnStart
-- returns whether the mission is still in progress
MISSION.InProgress = REBEL_FUNCTIONS.TheftInProgress

MISSION.OnAbort = REBEL_FUNCTIONS.TheftOnAbort