MISSION.Name = "Extraction Officer Block"
MISSION.Instructions = "Go to the back of the officer block and await extraction" -- this is what the player will receive when they accept the mission
MISSION.Reward = 6000 -- credits the player will receive after a mission is completed
MISSION.Penalty = 10 -- if the player fails for whatever reason, the amount of credits taken away
MISSION.Time = 30 -- For Hacking missions, this time will be added onto the wait time for a timer, basically how much wiggleroom you want to give the player when hacking
MISSION.WaitTime = 10 -- this is the amount of time the rebel has to be inside the point for
MISSION.Radius = 100 -- how big is the zone the rebel has to get too
MISSION.MainPoint = Vector(597.26702880859,-4510.63671875,-4863.96875) -- if there is multiple points, this is the first one they are going to get on mission accept MUST BE A VECTOR
MISSION.Level = 1 
MISSION.Type = "Extraction"
MISSION.CurrentTarget = nil
MISSION.Sound = "heart" -- the sound is the key in the table in sh_rebel.lua under lua/autorun
MISSION.OnStart = REBEL_FUNCTIONS.ExtractionOnStart
-- returns whether the mission is still in progress
MISSION.InProgress = REBEL_FUNCTIONS.ExtractionInProgress

MISSION.OnAbort = REBEL_FUNCTIONS.ExtractionOnAbort