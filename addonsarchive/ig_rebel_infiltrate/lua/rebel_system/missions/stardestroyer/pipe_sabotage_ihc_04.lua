MISSION.Name = "Pipe Sabotage 4"
MISSION.Instructions = "Go to pipes near the ladders in IHC and disable them" -- this is what the player will receive when they accept the mission
MISSION.Reward = 5000 -- credits the player will receive after a mission is completed
MISSION.Penalty = 10 -- if the player fails for whatever reason, the amount of credits taken away
MISSION.Time = 12 -- For Hacking missions, this time will be added onto the wait time for a timer, basically how much wiggleroom you want to give the player when hacking
MISSION.WaitTime = 10 -- this is the amount of time the rebel has to be inside the point (in seconds) use 0 for no waittime
MISSION.Radius = 50 -- how big is the zone the rebel has to get too
MISSION.MainPoint = Vector(-9760.4091796875,-537.60919189453,32.03125) -- if there is multiple points, this is the first one they are going to get on mission accept MUST BE A VECTOR
MISSION.SubPoints = {} -- Not used in a hacking mission
MISSION.Level = 4 -- when a level is completed, the next mission will be randomly selected from a level that is higher. 
MISSION.Type = "Hack" 
MISSION.CurrentTarget = nil
MISSION.Sound = "pipe"
MISSION.Effect = "SMOKE"
MISSION.Magnitude = 0.025
MISSION.Scale = 0.1
MISSION.EmitSound = "ambient/explosions/explode_3.wav"
MISSION.OnStart = REBEL_FUNCTIONS.HackingOnStart
-- returns whether the mission is still in progress
MISSION.InProgress = REBEL_FUNCTIONS.HackingInProgress

MISSION.OnAbort = REBEL_FUNCTIONS.HackingAbort

