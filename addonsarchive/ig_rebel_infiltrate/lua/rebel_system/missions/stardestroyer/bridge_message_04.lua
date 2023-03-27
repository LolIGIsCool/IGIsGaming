MISSION.Name = "Bridge infiltration"
MISSION.Instructions = "Go to the bridge and send an encrypted message" -- this is what the player will receive when they accept the mission
MISSION.Reward = 5000 -- credits the player will receive after a mission is completed
MISSION.Penalty = 10 -- if the player fails for whatever reason, the amount of credits taken away
MISSION.Time = 12 -- For Hacking missions, this time will be added onto the wait time for a timer, basically how much wiggleroom you want to give the player when hacking
MISSION.WaitTime = 10 -- this is the amount of time the rebel has to be inside the point (in seconds) use 0 for no waittime
MISSION.Radius = 50 -- how big is the zone the rebel has to get too
MISSION.MainPoint = Vector(-8422.0185546875,-243.97686767578,720.03125) -- if there is multiple points, this is the first one they are going to get on mission accept MUST BE A VECTOR
MISSION.Level = 4 -- when a level is completed, the next mission will be randomly selected from a level that is higher. 
MISSION.Type = "Hack" 
MISSION.Sound = "hack" -- sounds are keys in the sh_rebel.lua table. Make sure the corresponding sound is in that table
MISSION.CurrentTarget = nil
MISSION.EmitSound = "npc/scanner/scanner_electric1.wav"
MISSION.OnStart = REBEL_FUNCTIONS.HackingOnStart
-- returns whether the mission is still in progress
MISSION.InProgress = REBEL_FUNCTIONS.HackingInProgress

MISSION.OnAbort = REBEL_FUNCTIONS.HackingAbort


--local id, name = 0, "name"
--hideyoshiKeycards.func:allocateKeycard(Player, {id}) Player.BlackmarketDeployedKeycards[name] = true