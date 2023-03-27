MISSION.Name = "Reactor Room Recon" -- name must be unqiue!!! Typically make the name that refer to the type of mission it is with the mission level
MISSION.Instructions = "Use this special rebel hacked keycard and go to the reactor room and place listening devices"-- What the players will receive, can be either vague instructions or precise instructions
MISSION.Reward = 2500-- what they get for completing the mission
MISSION.Penalty = 29-- if the mission is aborted for whatever reason they will be demoted this amount
MISSION.Time = 27-- if there are subpoints then this is the amount of time they have to get the rest
MISSION.Radius = 100-- how big is the zone the rebel has to get too
MISSION.MainPoint = Vector(-3875.24609375,-222.07000732422,-4863.96875)-- if there is multiple points, this is the first one they are going to get on mission accept MUST BE A VECTOR!
MISSION.SubPoints = {
	Vector(-3848.44140625,259.24615478516,-4863.96875), 
	Vector(-4145.1123046875,-323.24615478516,-4863.96875), 
	Vector(-4147.3618164063,323.24615478516,-4863.96875), 
	Vector(-5426.8876953125,745.060546875,-4863.96875)
} 
MISSION.Level = 3 -- when a level is completed, the next mission will be randomly selected from a level that is higher. 
MISSION.Type = "Recon"
MISSION.CurrentTarget = nil -- make this is the same vector as the main point
MISSION.KeyCardID = 9 -- Operations keycard
MISSION.SubType = "Infiltrate"
-- make sure these functions are the corresponding mission type functions. Very important
MISSION.OnStart = REBEL_FUNCTIONS.InfiltrateOnStart

MISSION.InProgress = REBEL_FUNCTIONS.ReconInProgress

MISSION.OnAbort = REBEL_FUNCTIONS.ReconAbort