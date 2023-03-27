MISSION.Name = "Security Deck Hack"
MISSION.Instructions = "Use this military security clearance card and go to the security deck and hack a transcript of all prisoners" -- this is what the player will receive when they accept the mission
MISSION.Reward = 5000 -- credits the player will receive after a mission is completed
MISSION.Penalty = 40 -- if the player fails for whatever reason, the amount of credits taken away
MISSION.Time = 12 -- For Hacking missions, this time will be added onto the wait time for a timer, basically how much wiggleroom you want to give the player when hacking
MISSION.WaitTime = 10 -- this is the amount of time the rebel has to be inside the point for
MISSION.Radius = 150 -- how big is the zone the rebel has to get too
MISSION.MainPoint = Vector(-2086.75390625,-3766.9670410156,-5439.96875) 
MISSION.Level = 4 -- when a level is completed, the next mission will be randomly selected from a level that is higher. 
MISSION.Type = "Hack" -- used to make sure the player has stayed in the zone for the minimum amount of time
MISSION.CurrentTarget = nil
MISSION.KeyCardID = 12 -- Military Security Clearance
MISSION.SubType = "Infiltrate"

MISSION.OnStart = REBEL_FUNCTIONS.InfiltrateOnStart
-- returns whether the mission is still in progress
MISSION.InProgress = REBEL_FUNCTIONS.HackingInProgress

MISSION.OnAbort = REBEL_FUNCTIONS.HackingAbort