MISSION.Name = "Tribunal Recon"-- name must be unqiue!!! Typically make the name that refer to the type of mission it is with the mission level
MISSION.Instructions= "Go to the tribunal room and bug it" -- What the players will receive, can be either vague instructions or precise instructions
MISSION.Reward =2500-- what they get for completing the mission
MISSION.Penalty =50-- if the mission is aborted for whatever reason they will be demoted this amount
MISSION.Time =20-- if there are subpoints then this is the amount of time they have to get the rest
MISSION.Radius = 100-- how big is the zone the rebel has to get too
MISSION.MainPoint = Vector(4923.4965820313,883.54626464844,-5567.96875)-- if there is multiple points, this is the first one they are going to get on mission accept MUST BE A VECTOR!
MISSION.SubPoints = {
	Vector(5187.958984375,1096.7196044922,-5567.96875), 
	Vector(5187.427734375,1368.3043212891,-5567.96875), 
	Vector(4931.181640625,1451.3453369141,-5567.96875), 
	Vector(4668.0395507813,1334.2747802734,-5567.96875), 
	Vector(4668.0395507813,840.34924316406,-5567.96875)
}
MISSION.Level = 3 -- when a level is completed, the next mission will be randomly selected from a level that is higher. 
MISSION.Type = "Recon" -- used to make sure the player has actually completed the mission i.e make sure the player is in the recon zone
MISSION.CurrentTarget = nil -- make this is the same vector as the main point

-- make sure these functions are the corresponding mission type functions. Very important
MISSION.OnStart = REBEL_FUNCTIONS.ReconOnStart

MISSION.InProgress = REBEL_FUNCTIONS.ReconInProgress

MISSION.OnAbort = REBEL_FUNCTIONS.ReconAbort