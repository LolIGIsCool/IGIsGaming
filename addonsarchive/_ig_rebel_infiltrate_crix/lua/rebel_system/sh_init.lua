
local validateFuncs = {
	["theft"] = REBEL_FUNCTIONS.TheftValidate, 
	["recon"] = REBEL_FUNCTIONS.ReconValidate, 
	["hack"] = REBEL_FUNCTIONS.HackingValidate, 
	["extraction"] = REBEL_FUNCTIONS.HackingValidate
} 

local missionFiles = function(folder)
	local files, _ = file.Find("rebel_system/missions/"..folder.."/*.lua", "LUA")
	for _, file in ipairs(files) do 
		local mission_id = string.gsub(file, ".lua", "")
		MISSION = {}
		include("rebel_system/missions/"..folder.."/"..file)
		MISSION.ID = mission_id
		if string.lower(MISSION.Type) == "extraction" then 
			MISSION.Validate = validateFuncs["extraction"]
			MISSIONS.Extraction[mission_id] = MISSION
		else
			local missionType = string.Trim(string.lower(MISSION.Type))
			if validateFuncs[missionType] then 
				MISSION.Validate = validateFuncs[missionType]
				MISSIONS.Quests[mission_id] = MISSION
			end
		end
		MISSION = nil
	end
	timer.Create("CheckRebelMissionRuntimeStatus", 60, 0,function()
		-- v is the curtime that was recorded at start of mission select
		-- k is the entity ID
		if table.Count(MISSIONS.PlayerStartTime) > 0 then 
			for k, v in pairs(MISSIONS.PlayerStartTime) do
				if ( v + 1800 ) < CurTime() then -- check to see if 30 minutes have passed from mission acceptance
					local ply = Entity(k)
					MISSIONS.PlayerStartTime[k] = nil
					if not IsValid(ply) then return end 
					if not MISSIONS.InProgress[ply:SteamID64()] then return end
					MISSIONS.AwaitingResponse[ply:SteamID64()] = nil
					MISSIONS.InProgress[ply:SteamID64()]:OnAbort(ply, "You took too long to complete your missions", true)
				end
			end
		end
	end)
end


local loadMissions = function()	
	MISSIONS.Quests = {}
	MISSIONS.InProgress = {}
	MISSIONS.AwaitingResponse = {}
	MISSIONS.Extraction = {}
	MISSIONS.Completed = {} -- when a user completes all missions they are added to this to prevent them from being selected again
	MISSIONS.PlayerStartTime = {}
	MISSIONS.CompleteHistory = {} -- a complete history of the users that completed 
	MISSIONS.Blacklist = {}
	MISSIONS.CurrentRebelBlock = {} -- stores who is currently a rebel with the current block of rebels. Reset every time a new batch is selected
	if game.GetMap() == "rp_stardestroyer_v2_5_inf" then
		missionFiles("stardestroyer")
		return 
	end
	if game.GetMap() == "gm_flatgrass" then 
		missionFiles("stardestroyer") -- just wanna check if everything is loading -_-
		return 
	end

end

local findPlayer = function(steamid)
	for k , v in pairs(player.GetAll()) do 
		if steamid == v:SteamID64() then 
			return v
		end
	end
	return nil
end

local resetMissions = function()
	for k, v in pairs(MISSIONS.InProgress) do
		local ply = findPlayer(k)
		if not IsValid(ply) then continue end
		v:OnAbort(ply, "Missions have been reset, you will not lose points", false)
	end
	loadMissions()
end

if (SERVER) then 
	loadMissions() 
	hook.Add("ResetRebelMissionSystem", "RebelMissionSystemReset", resetMissions)
end
