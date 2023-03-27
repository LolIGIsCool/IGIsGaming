MISSION.Name = "Imperial Pilots Theft"
MISSION.Instructions = "Go to the pilots quarters and steal some armour" -- tells the player where to get the equipment from
MISSION.DropLocationIntructions = "Take the armour to MH1" -- tells the player where to take the eqipment
MISSION.Reward = 1000
MISSION.Penalty = 10
MISSION.Time = 90 -- amount of time you have to take the equipment to the drop location
MISSION.Radius = 100 -- how big is the zone the rebel has to get too
MISSION.MainPoint = Vector(4835.520508, -308.237823, -5743.968750) -- point to get the equipment from
MISSION.Level = 2 -- when a level is completed, the next mission will be randomly selected from a level that is higher. 
MISSION.Type = "Theft" -- used to make sure the player has droped the spawned entity in the DropLocation 
MISSION.CurrentTarget = nil
MISSION.IsDelieveryingItem = false -- used in the inprogress function to determine whether there is another part of the mission to complete

MISSION.Model = "models/kingpommes/emperors_tower/imp_crates/imp_crate_single_closed_static.mdl"

MISSION.OnStart = REBEL_FUNCTIONS.TheftOnStart
-- returns whether the mission is still in progress
MISSION.InProgress = REBEL_FUNCTIONS.TheftInProgress

MISSION.OnAbort = REBEL_FUNCTIONS.TheftOnAbort