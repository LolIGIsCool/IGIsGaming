MISSION.Name = "Security Area Recon"-- name must be unqiue!!! Typically make the name that refer to the type of mission it is with the mission level
MISSION.Instructions ="Plant listening devices around the security deck for the rebellion"-- What the players will receive, can be either vague instructions or precise instructions
MISSION.Reward = 1000 -- what they get for completing the mission
MISSION.Penalty = 10 -- if the mission is aborted for whatever reason they will be demoted this amount
MISSION.Time = 45 -- if there are subpoints then this is the amount of time they have to get the rest
MISSION.Radius = 100 -- how big is the zone the rebel has to get too
MISSION.MainPoint = Vector(-1807.96875,-2073.9194335938,-5439.96875)-- if there is multiple points, this is the first one they are going to get on mission accept MUST BE A VECTOR!
MISSION.SubPoints = {
	Vector(-1584.03125,-1616.03125,-5439.96875), 
	Vector(-1807.96875,-1008.03125,-5439.96875), 
	Vector(-1839.2893066406,-720.03125,-5439.96875), 
	Vector(-1807.96875,-2831.6313476563,-5439.96875)
}
MISSION.Level = 2 -- when a level is completed, the next mission will be randomly selected from a level that is higher. 
MISSION.Type = "Recon" -- used to make sure the player has actually completed the mission i.e make sure the player is in the recon zone
MISSION.CurrentTarget = nil -- make this is the same vector as the main point

-- make sure these functions are the corresponding mission type functions. Very important
MISSION.OnStart = REBEL_FUNCTIONS.ReconOnStart

MISSION.InProgress = REBEL_FUNCTIONS.ReconInProgress

MISSION.OnAbort = REBEL_FUNCTIONS.ReconAbort