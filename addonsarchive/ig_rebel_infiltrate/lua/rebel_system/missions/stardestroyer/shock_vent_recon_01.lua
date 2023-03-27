MISSION.Name = "Recon 1"-- name must be unqiue!!! Typically make the name that refer to the type of mission it is with the mission level
MISSION.Instructions = "Bug the vents near and around shock, you have 10 seconds from the first bug placed to complete the mission"-- What the players will receive, can be either vague instructions or precise instructions
MISSION.Reward = 500 -- what they get for completing the mission
MISSION.Penalty = 10 -- if the mission is aborted for whatever reason they will be demoted this amount
MISSION.Time = 10 -- if there are subpoints then this is the amount of time they have to get the rest, in seconds
MISSION.Radius = 100 -- how big is the zone the rebel has to get too
MISSION.MainPoint = Vector(113.02235412598,-2473.8122558594,-5567.96875)-- if there is multiple points, this is the first one they are going to get on mission accept MUST BE A VECTOR!
MISSION.SubPoints = {
	Vector(-331.58972167969,-2476.3854980469,-5567.96875), 
	Vector(-949.259765625,-2477.3662109375,-5567.96875)
}
MISSION.Level = 1 -- when a level is completed, the next mission will be randomly selected from a level that is higher. 
MISSION.Type = "Recon" -- used to make sure the player has actually completed the mission i.e make sure the player is in the recon zone
MISSION.CurrentTarget = nil-- make this is the same vector as the main point

-- make sure these functions are the corresponding mission type functions. Very important
MISSION.OnStart = REBEL_FUNCTIONS.ReconOnStart

MISSION.InProgress = REBEL_FUNCTIONS.ReconInProgress

MISSION.OnAbort = REBEL_FUNCTIONS.ReconAbort