MISSION.Name = "Debrief Recon"-- name must be unqiue!!! Typically make the name that refer to the type of mission it is with the mission level
MISSION.Instructions = "Head to debrief and bug it" -- What the players will receive, can be either vague instructions or precise instructions
MISSION.Reward = 2500-- what they get for completing the mission
MISSION.Penalty = 1-- if the mission is aborted for whatever reason they will be demoted this amount
MISSION.Time = 30 -- if there are subpoints then this is the amount of time they have to get the rest
MISSION.Radius = 50-- how big is the zone the rebel has to get too
MISSION.MainPoint = Vector(-2389.22265625,216.64183044434,-5279.96875) -- if there is multiple points, this is the first one they are going to get on mission accept MUST BE A VECTOR!
MISSION.SubPoints = {
	Vector(-2310.7578125,727.88269042969,-5258.2797851563), 
	Vector(-2342.3781738281,-406.85363769531,-5252.6665039063), 
	Vector(-2346.1867675781,505.32287597656,-5381.2490234375), 
	Vector(-2387.5183105469,-280.45932006836,-5399.3334960938)
}
MISSION.Level = 3-- when a level is completed, the next mission will be randomly selected from a level that is higher. 
MISSION.Type = "Recon" -- used to make sure the player has actually completed the mission i.e make sure the player is in the recon zone
MISSION.CurrentTarget = nil -- make this is the same vector as the main point

-- make sure these functions are the corresponding mission type functions. Very important
MISSION.OnStart = REBEL_FUNCTIONS.ReconOnStart

MISSION.InProgress = REBEL_FUNCTIONS.ReconInProgress

MISSION.OnAbort = REBEL_FUNCTIONS.ReconAbort