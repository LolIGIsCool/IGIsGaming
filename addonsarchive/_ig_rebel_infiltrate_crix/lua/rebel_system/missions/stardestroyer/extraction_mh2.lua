MISSION.Name = "Extraction from MH2"
MISSION.Instructions = "Go to the MH2 vent and await extraction" -- this is what the player will receive when they accept the mission
MISSION.Reward = 6000 -- credits the player will receive after a mission is completed
MISSION.Penalty = 20 -- if the player fails for whatever reason, the amount of credits taken away
MISSION.Time = 30 -- For Hacking missions, this time will be added onto the wait time for a timer, basically how much wiggleroom you want to give the player when hacking
MISSION.WaitTime = 10 -- this is the amount of time the rebel has to be inside the point for
MISSION.Radius = 50 -- how big is the zone the rebel has to get too
MISSION.MainPoint = Vector(5184.0034179688,-680.01171875,-5567.96875) 
MISSION.SubPoints = {} -- Not used in a hacking mission
MISSION.Level = 1 -- when a level is completed, the next mission will be randomly selected from a level that is higher. 
MISSION.Type = "Extraction" -- used to make sure the player has stayed in the zone for the minimum amount of time
MISSION.CurrentTarget = nil
MISSION.Sound = "battle"


MISSION.OnStart = REBEL_FUNCTIONS.ExtractionOnStart
-- returns whether the mission is still in progress
MISSION.InProgress = REBEL_FUNCTIONS.ExtractionInProgress

MISSION.OnAbort = REBEL_FUNCTIONS.ExtractionOnAbort