MISSION.Name = "Engine room hack 3"
MISSION.Instructions = "Go to the engine room and hack its console" -- this is what the player will receive when they accept the mission
MISSION.Reward = 2500 -- credits the player will receive after a mission is completed
MISSION.Penalty = 10 -- if the player fails for whatever reason, the amount of credits taken away
MISSION.Time = 8 -- For Hacking missions, this time will be added onto the wait time for a timer, basically how much wiggleroom you want to give the player when hacking
MISSION.WaitTime = 10 -- this is the amount of time the rebel has to be inside the point (in seconds) use 0 for no waittime
MISSION.Radius = 200 -- how big is the zone the rebel has to get too
MISSION.MainPoint = Vector(-4330.9770507813,-1399.2719726563,-5967.8647460938) -- if there is multiple points, this is the first one they are going to get on mission accept MUST BE A VECTOR
MISSION.SubPoints = {} -- Not used in a hacking mission
MISSION.Level = 3 -- when a level is completed, the next mission will be randomly selected from a level that is higher. 
MISSION.Type = "Hack" 
MISSION.CurrentTarget = nil
MISSION.Sound = "hack"
MISSION.OnStart = REBEL_FUNCTIONS.HackingOnStart
-- returns whether the mission is still in progress
MISSION.InProgress = REBEL_FUNCTIONS.HackingInProgress

MISSION.OnAbort = REBEL_FUNCTIONS.HackingAbort

