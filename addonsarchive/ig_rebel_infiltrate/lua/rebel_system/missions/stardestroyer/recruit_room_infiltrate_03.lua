MISSION.Name  = "Recruit Recon 03" -- name must be unqiue!!! Typically make the name that refer to the type of mission it is with the mission level
MISSION.Instructions ="Use this keycard to go into the recruit room and bug it for the rebellion" -- What the players will receive, can be either vague instructions or precise instructions
MISSION.Reward = 2500 -- what they get for completing the mission
MISSION.Penalty = 20 -- if the mission is aborted for whatever reason they will be demoted this amount
MISSION.Time = 20 -- if there are subpoints then this is the amount of time they have to get the rest
MISSION.Radius = 50-- how big is the zone the rebel has to get too
MISSION.MainPoint = Vector(-267.09985351563,-2647.1486816406,-5567.96875) -- if there is multiple points, this is the first one they are going to get on mission accept MUST BE A VECTOR!
MISSION.SubPoints = {
	Vector(116.98790740967,-2646.8840332031,-5567.96875),
	Vector(367.96875,-2960.873046875,-5567.96875), 
	Vector(598.91845703125,-2906.50390625,-5503.96875), 
	Vector(-54.266613006592,-3338.5021972656,-5567.96875)
}
MISSION.Level = 3 -- when a level is completed, the next mission will be randomly selected from a level that is higher. 
MISSION.Type = "Recon" -- used to make sure the player has actually completed the mission i.e make sure the player is in the recon zone
MISSION.CurrentTarget = nil -- make this is the same vector as the main point
MISSIONS.KeyCardID = 3
-- make sure these functions are the corresponding mission type functions. Very important
MISSION.OnStart = REBEL_FUNCTIONS.InfiltrateOnStart

MISSION.InProgress = REBEL_FUNCTIONS.ReconInProgress

MISSION.OnAbort = REBEL_FUNCTIONS.ReconAbort