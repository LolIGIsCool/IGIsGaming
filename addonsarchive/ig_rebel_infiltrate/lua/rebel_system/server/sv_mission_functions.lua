
REBEL_FUNCTIONS = {} -- contains a list of generic functions that a host of missions can make use of
local soundFile = {
	[1] = "ambient/explosions/exp1.wav"
}

local giveKeyCard = function(ply, id)
	local succ, err = pcall(function() hideyoshiKeycards.func:allocateKeycard(ply, {id}) end)
	if err then print(err) end 
end

-- condition is a function that is ran on the theft in progress if it exists
local dropLocations =  {
	[1] = { ["location"] = Vector(-654.332275, -1147.558716, -6015.968750), ["instructions"] =  "Take the equipment to MH1"}, 
	[2] = { ["location"] = Vector(4970.228515625,494.54895019531,-5405.5966796875), ["instructions"] = "Take the equipment to MH2"}, 
	[3] = { ["location"] = Vector(-2535.9919433594,-2950.3098144531,-5552.9877929688), ["instructions"] = "Use this keycard and take the equipment to the railings in maintenance 101 ", ["condition"] = giveKeyCard, ["key"] = 3  }, 
	[4] = { ["location"] = Vector(49.132419586182,1383.6837158203,-6015.96875), ["instructions"] =  "Take the equipment to MH1"} ,
	[5] = { ["location"] = Vector(4408.4272460938,-1740.3835449219,-5271.6953125), ["instructions"] =  "Take the equipment to the storage area in tie bays"}
}

local rebelFound = function(ply)
	ULib.csay( _, ply:Nick().." is a rebel! execute them" )
end

local minDistance = 200

local playsoundEffect = function(id, ply) 
 sound.Play(soundFile[id], ply:GetPos(), 75, 100, 0.5)
end



function REBEL_FUNCTIONS:ReconOnStart(id, ply)
	if not IsValid(ply) then return end
	if not MISSIONS.Quests[id] then return end
	if not table.IsEmpty(MISSIONS.Quests[id].SubPoints) then 
		local newList = table.Copy(MISSIONS.Quests[id].SubPoints)
		ply:MultiplePoints(newList) 
	end
	MISSIONS.Quests[id].CurrentTarget = MISSIONS.Quests[id].MainPoint
	net.Start("RebelMissionSystemReceiveTarget")
	net.WriteVector(MISSIONS.Quests[id].MainPoint)
	net.WriteInt(MISSIONS.Quests[id].Radius, 15)
	net.Send(ply)

	-- Remove quest from the available quests to make sure another player doesn't get the same quest
	--ply:PrintMessage(HUD_PRINTTALK, MISSIONS.Quests[id].Instructions)
	ply:SendNewMissionDetails(MISSIONS.Quests[id].Instructions, MISSIONS.Quests[id].Time, MISSIONS.Quests[id].Reward, false)
	MISSIONS.InProgress[ply:SteamID64()] = table.Copy(MISSIONS.Quests[id])
	--MISSIONS.Quests[id] = nil
end

function REBEL_FUNCTIONS:ReconInProgress(ply)
	if not IsValid(ply) then return end
	if not MISSIONS.InProgress[ply:SteamID64()] then return end
	local key = ply:SteamID64()
	local timerIdentifier = ply:SteamID64().."_"..MISSIONS.InProgress[key].ID
	-- once the first point has been reached then there could be more points
	if table.Count(MISSIONS.InProgress[key].SubPoints) > 0 then 
		local pointsRemaining = ply:SelectNextPoint()
		if pointsRemaining != nil then 
			if not ply.ReachedReconArea then 
				ply.ReachedReconArea = true
				ply:StartRebelMissionCountdown()
			end
			ply:EmitSound(hackingsound['plant'], 150, 100, 1)
			MISSIONS.InProgress[key].CurrentTarget = pointsRemaining
			net.Start("RebelMissionSystemReceiveTarget")
			net.WriteVector(pointsRemaining)
			net.WriteInt(MISSIONS.InProgress[key].Radius, 15)
			net.Send(ply)
			if  MISSIONS.InProgress[key].Time and MISSIONS.InProgress[key].Time > 0 then 
				if not timer.Exists(timerIdentifier) then 
					timer.Create(timerIdentifier, MISSIONS.InProgress[key].Time , 1 , function()
						if not IsValid(ply) then return end
						if not MISSIONS.InProgress[key] then return end
						ply:RemoveSubPoints()
						MISSIONS.InProgress[key]:OnAbort(ply, "You failed to get all the objectives in the alloted time", true )
					end)
				end
			end
			return true
		end -- no more sub points exists so the mission is over
	end
	if timer.Exists(timerIdentifier) then timer.Remove(timerIdentifier) end
	--MISSIONS.InProgress[key].CurrentTarget  = MISSIONS.InProgress[key].MainPoint
	ply:RemoveSubPoints()
	--MISSIONS.Quests[ MISSIONS.InProgress[key].ID ] = MISSIONS.InProgress[key]
	ply:SH_AddPremiumPoints(MISSIONS.InProgress[key].Reward, "You have received "..MISSIONS.InProgress[key].Reward.. " for completing "..MISSIONS.InProgress[key].Name)
	MISSIONS.InProgress[key] = nil
	ply.ReachedReconArea = false 
	ply:EmitSound(hackingsound["cheer"])
	return false
end


function REBEL_FUNCTIONS:ReconAbort(ply, message, takeCredits)
	if not MISSIONS.InProgress[ply:SteamID64()] then return end
	local credits =  takeCredits
	local credits 
	if takeCredits == nil then credits = true else credits = takeCredits end
	if msg then ply:PrintMessage(HUD_PRINTTALK, msg) end
	--MISSIONS.InProgress[ply:SteamID64()].CurrentTarget = MISSIONS.InProgress[ply:SteamID64()].MainPoint
	--MISSIONS.Quests[MISSIONS.InProgress[ply:SteamID64()].ID] = MISSIONS.InProgress[ply:SteamID64()]
	ply.ReachedReconArea = false
	ply:AbortMission()
	if not ply.IsDead then 
		rebelFound(ply)
	else 
		ply.IsDead = nil
	end
	net.Start("StopRebelMission")
	net.Send(ply)
	-- subtract penalty from player
	if not credits then MISSIONS.InProgress[ply:SteamID64()] = nil return end
	if ply:SH_CanAffordPremium(-MISSIONS.InProgress[ply:SteamID64()].Penalty) then  
		ply:SH_AddPremiumPoints(-MISSIONS.InProgress[ply:SteamID64()].Penalty, "You have been deducted  "..MISSIONS.InProgress[ply:SteamID64()].Penalty.. " credits")
	end
	MISSIONS.InProgress[ply:SteamID64()] = nil
end

function REBEL_FUNCTIONS:ReconValidate(ply)
	local mission = MISSIONS.InProgress[ply:SteamID64()]
	if not mission or not IsValid(ply) then return false end
	if not mission.CurrentTarget or ply:GetPos():Distance(mission.CurrentTarget) > mission.Radius^2 then
		mission:OnAbort(ply, "Not inside radius zone, mission failed", true)
		return false
	end 
	return true
end



function REBEL_FUNCTIONS:TheftOnStart(id, ply)
	if not IsValid(ply) then return end
	if not MISSIONS.Quests[id] then return end

	MISSIONS.Quests[id].IsDelieveryingItem = false -- set to true when the player gets to the inital zone
	MISSIONS.Quests[id].CurrentTarget = MISSIONS.Quests[id].MainPoint
	MISSIONS.InProgress[ply:SteamID64()] = table.Copy(MISSIONS.Quests[id])
	local target
	local tempTable = table.Copy(dropLocations)
	local found = false
	for i = 1, table.Count(dropLocations) do
		local temp, key = table.Random(tempTable)
		if ply:GetPos():DistToSqr(temp["location"]) > minDistance^2 then 
			target = temp
			found = true
			break
		else 
			tempTable[key] = nil 
		end 
	end
	if not found then target = table.Random(dropLocations) end -- fuck it, cant find a good location so give em any of them

	MISSIONS.InProgress[ply:SteamID64()].DropLocation = target['location']
	MISSIONS.InProgress[ply:SteamID64()].DropLocationIntructions = target['instructions']
	if target.condition then 
		MISSIONS.InProgress[ply:SteamID64()].condition = target.condition 
		MISSIONS.InProgress[ply:SteamID64()].key = target.key
	end 
	net.Start("RebelMissionSystemReceiveTheftLocation")
	net.WriteVector(MISSIONS.Quests[id].MainPoint)
	net.WriteInt(MISSIONS.Quests[id].Radius, 15)
	net.Send(ply)
	ply:SendNewMissionDetails(MISSIONS.Quests[id].Instructions, MISSIONS.Quests[id].Time, MISSIONS.Quests[id].Reward, false)
	--ply:PrintMessage(HUD_PRINTTALK, MISSIONS.Quests[id].Instructions)
	--MISSIONS.Quests[id] = nil
end


function REBEL_FUNCTIONS:TheftInProgress(ply)
	if not IsValid(ply) then return end
	if not MISSIONS.InProgress[ply:SteamID64()] then return end
	local key = ply:SteamID64()
	local mission = MISSIONS.InProgress[key]
	local timerIdentifier = ply:SteamID64().."_"..MISSIONS.InProgress[key].ID

	if mission.IsDelieveryingItem == false then 
		ply:SendNewMissionDetails(mission.DropLocationIntructions, mission.Time, mission.Reward, true)
		mission.IsDelieveryingItem = true
		local target = mission.DropLocation
		local zone = mission.Radius
		if not target or not zone then mission:OnAbort(ply , "Error in mission details, contact Crix", false) end
		-- spawn item
		local carryitem = ents.Create("rebel_gear")
		carryitem:SetPos(ply:GetPos() + Vector(0, 0, 60))
		if mission.Model then carryitem:SetNWString("gearmodel",mission.Model) end
		carryitem:SetNWString("PlayerCarry", ply:SteamID64()) 
		carryitem:SetNWVector("TargetArea", target)
		carryitem:SetNWInt("TargetRadius", mission.Radius)
		carryitem:SetNWInt("PlayerIndex", ply:EntIndex())
		carryitem:Spawn()
		if mission.condition then 
			mission:condition(ply, mission.key)
		end
		if mission.Time > 0 then 
			timer.Create(ply:SteamID64().."_"..mission.ID, mission.Time, 1, function()
				if not IsValid(ply) then return end 
				if not MISSIONS.InProgress[ply:SteamID64()] then return end
				MISSIONS.InProgress[ply:SteamID64()]:OnAbort(ply, "You failed to get the gear to the location in time")
				carryitem:Remove()
			end)	
		end
		return true
	else 
		-- player has delievered the item
		if timer.Exists(ply:SteamID64().."_"..mission.ID) then timer.Remove(ply:SteamID64().."_"..mission.ID) end
		ply:SH_AddPremiumPoints(MISSIONS.InProgress[key].Reward, "You have received "..MISSIONS.InProgress[key].Reward.. " for completing "..MISSIONS.InProgress[key].Name)
		--mission.IsDelieveryingItem = false
		--MISSIONS.Quests[mission.ID] = mission
		MISSIONS.InProgress[key] = nil
		--playsoundEffect(1,ply)
		return false
	end


end

function REBEL_FUNCTIONS:TheftOnAbort(ply, message, takeCredits, advertise)
	if not IsValid(ply) then return end
	if not MISSIONS.InProgress[ply:SteamID64()] then return end
	local credits 
	if takeCredits == nil then credits = true else credits = takeCredits end
	local msg = message or nil
	if msg then ply:PrintMessage(HUD_PRINTTALK, msg) end
	--MISSIONS.InProgress[ply:SteamID64()].CurrentTarget = MISSIONS.InProgress[ply:SteamID64()].MainPoint
	--MISSIONS.Quests[MISSIONS.InProgress[ply:SteamID64()].ID] = MISSIONS.InProgress[ply:SteamID64()]
	ply:AbortMission()
	if not ply.IsDead then 
		rebelFound(ply)
	else 
		ply.IsDead = nil
	end
	net.Start("StopRebelTheftMission")
	net.Send(ply)

	if credits == false then MISSIONS.InProgress[ply:SteamID64()] = nil return end
	if ply:SH_CanAffordPremium(-MISSIONS.InProgress[ply:SteamID64()].Penalty) then  
		ply:SH_AddPremiumPoints(-MISSIONS.InProgress[ply:SteamID64()].Penalty, "You have been deducted "..MISSIONS.InProgress[ply:SteamID64()].Penalty.. " credits")
	end
	MISSIONS.InProgress[ply:SteamID64()] = nil
end 

function REBEL_FUNCTIONS:TheftValidate(ply)
	if not IsValid(ply) then return false end
	local mission =  MISSIONS.InProgress[ply:SteamID64()]
	if not mission then return false end
	if mission.IsDelieveryingItem == true then return true end
	if not mission.CurrentTarget or ply:GetPos():Distance(mission.CurrentTarget) > mission.Radius^2 then
		mission:OnAbort(ply, "Not inside radius zone, something went wrong. Contact Crix", true)
		return false 
	end 
	return true
end


function REBEL_FUNCTIONS:HackingOnStart(id , ply)
	if not IsValid(ply) then return end
	if not MISSIONS.Quests[id] then return end
	net.Start("RebelMissionSystemHackingTarget")
	net.WriteVector(MISSIONS.Quests[id].MainPoint)
	net.WriteInt(MISSIONS.Quests[id].Radius, 15)
	net.WriteUInt(MISSIONS.Quests[id].Time, 15)
	if MISSIONS.Quests[id].Sound then 
		net.WriteString(MISSIONS.Quests[id].Sound)
	else 
		net.WriteString("none")
	end 
	net.Send(ply)

	-- Remove quest from the available quests to make sure another player doesn't get the same quest
	--ply:PrintMessage(HUD_PRINTTALK, MISSIONS.Quests[id].Instructions)
	local totalTime = MISSIONS.Quests[id].Time +  MISSIONS.Quests[id].WaitTime
	ply:SendNewMissionDetails(MISSIONS.Quests[id].Instructions, totalTime, MISSIONS.Quests[id].Reward, false)
	MISSIONS.Quests[id].CurrentTarget = MISSIONS.Quests[id].MainPoint
	MISSIONS.InProgress[ply:SteamID64()] = table.Copy(MISSIONS.Quests[id])
	--MISSIONS.Quests[id] = nil
end

--Unlike the recon function, there isnt sub points so we can assume that once this is called the hack has been completed
function REBEL_FUNCTIONS:HackingInProgress(ply)
	if not IsValid(ply) then return end
	if not MISSIONS.InProgress[ply:SteamID64()] then return end
	local key = ply:SteamID64()
	if timer.Exists(key.."_"..MISSIONS.InProgress[key].Name) then timer.Remove(key.."_"..MISSIONS.InProgress[key].Name) end
	--MISSIONS.Quests[ MISSIONS.InProgress[key].ID ] = MISSIONS.InProgress[key]
	ply:SH_AddPremiumPoints(MISSIONS.InProgress[key].Reward, "You have received "..MISSIONS.InProgress[key].Reward.. " for completing "..MISSIONS.InProgress[key].Name)
	if MISSIONS.InProgress[ply:SteamID64()].Effect ~= nil then 
		local effect = EffectData()
		effect:SetMagnitude(MISSIONS.InProgress[ply:SteamID64()].Magnitude)
		effect:SetScale(MISSIONS.InProgress[ply:SteamID64()].Scale)
		effect:SetOrigin(MISSIONS.InProgress[ply:SteamID64()].MainPoint)
		util.Effect(MISSIONS.InProgress[ply:SteamID64()].Effect, effect)
	end
	if MISSIONS.InProgress[ply:SteamID64()].EmitSound then 
		ply:EmitSound(MISSIONS.InProgress[ply:SteamID64()].EmitSound)
	end

	MISSIONS.InProgress[key] = nil
	--playsoundEffect(1,ply)
	return false
end

function REBEL_FUNCTIONS:HackingAbort(ply, message, takeCredits, advertise)
	if not MISSIONS.InProgress[ply:SteamID64()] then return end
	local credits 
	if takeCredits == nil then credits = true else credits = takeCredits end
	local msg = message or nil
	if msg then ply:PrintMessage(HUD_PRINTTALK, msg) end
	--MISSIONS.InProgress[ply:SteamID64()].CurrentTarget = MISSIONS.InProgress[ply:SteamID64()].MainPoint
	--MISSIONS.Quests[MISSIONS.InProgress[ply:SteamID64()].ID] = MISSIONS.InProgress[ply:SteamID64()]
	ply:AbortMission()
	if not ply.IsDead then 
		rebelFound(ply)
	else 
		ply.IsDead = nil
	end
	net.Start("StopRebelHacking")
	net.Send(ply)
	-- subtract penalty from player

	if not credits then MISSIONS.InProgress[ply:SteamID64()] = nil return end

	if ply:SH_CanAffordPremium(-MISSIONS.InProgress[ply:SteamID64()].Penalty) then  
		ply:SH_AddPremiumPoints(-MISSIONS.InProgress[ply:SteamID64()].Penalty, "You have been deducted "..MISSIONS.InProgress[ply:SteamID64()].Penalty.. " credits")
	end
	MISSIONS.InProgress[ply:SteamID64()] = nil
end

function REBEL_FUNCTIONS:HackingValidate(ply)
	if not IsValid(ply) then return false end 
	local mission = MISSIONS.InProgress[ply:SteamID64()]
	if not mission then return false end
	if not ply.HackStart then
		mission:OnAbort(ply, "Mission somehow failed to properly register, contact Crix", true)
		return false	
	end 
	if CurTime() < ( ply.HackStart + mission.Time ) then 
		ply.HackStart = nil
		mission:OnAbort(ply, "you somehow completed the mission before the mininum amount of time, contact Crix", true)
		return false
	end

	return true

end




function REBEL_FUNCTIONS:ExtractionOnStart(id, ply)
	if not IsValid(ply) then return end 
	if not MISSIONS.Extraction[id] then return end

	net.Start("RebelMissionSystemHackingTarget")
	net.WriteVector(MISSIONS.Extraction[id].MainPoint)
	net.WriteInt(MISSIONS.Extraction[id].Radius, 15)
	net.WriteUInt(MISSIONS.Extraction[id].Time, 15)
	net.WriteString(MISSIONS.Extraction[id].Sound)
	net.Send(ply)

	MISSIONS.InProgress[ply:SteamID64()] = table.Copy(MISSIONS.Extraction[id])
	--ply:PrintMessage(HUD_PRINTTALK, MISSIONS.Extraction[id].Instructions)
	local totalTime = MISSIONS.Extraction[id].Time + MISSIONS.Extraction[id].WaitTime
	ply:SendNewMissionDetails(MISSIONS.Extraction[id].Instructions, totalTime, MISSIONS.Extraction[id].Reward, false)
end


function REBEL_FUNCTIONS:ExtractionInProgress(ply)
	if not IsValid(ply) then return end 
	if not MISSIONS.InProgress[ply:SteamID64()] then return end
	local key = ply:SteamID64()
	if timer.Exists(key.."_"..MISSIONS.InProgress[key].Name) then timer.Remove(key.."_"..MISSIONS.InProgress[key].Name) end
	ply:SH_AddPremiumPoints(MISSIONS.InProgress[key].Reward, "You have received "..MISSIONS.InProgress[key].Reward.. " for completing "..MISSIONS.InProgress[key].Name)
	ply:PrintMessage(HUD_PRINTTALK, "Well done! You have completed all your missions!")
	ply:AbortMission()
	MISSIONS.Completed[ply:SteamID()] = true
	MISSIONS.InProgress[ply:SteamID64()] = nil
	ply:Kill()
	RunConsoleCommand("ulx", "frespawn", ply:Nick())
	hook.Run("AddToRebelHistory", ply)
	return false
end

function REBEL_FUNCTIONS:ExtractionOnAbort(ply, message, takeCredits, advertise)
	if not IsValid(ply) then return end 
	if not MISSIONS.InProgress[ply:SteamID64()] then return end
	local credits 
	if takeCredits == nil then credits = true else credits = takeCredits end
	ply:AbortMission()
	if not ply.IsDead then 
		rebelFound(ply)
	else 
		ply.IsDead = nil
	end
	local msg = message or nil
	if msg then ply:PrintMessage(HUD_PRINTTALK, msg) end
	local mission = MISSIONS.InProgress[ply:SteamID64()]
	if not takeCredits then MISSIONS.InProgress[ply:SteamID64()] = nil return end 
	if ply:SH_CanAffordPremium(-MISSIONS.InProgress[ply:SteamID64()].Penalty) then  
		ply:SH_AddPremiumPoints(-MISSIONS.InProgress[ply:SteamID64()].Penalty, "You have been deducted "..MISSIONS.InProgress[ply:SteamID64()].Penalty.. " credits")
	end
	MISSIONS.InProgress[ply:SteamID64()] = nil
end

local onstartFuncs = {
	["recon"] = {["start"] = REBEL_FUNCTIONS.ReconOnStart}, 
	["theft"] = {["start"] = REBEL_FUNCTIONS.TheftOnStart}, 
	["hack"] = {["start"] = REBEL_FUNCTIONS.HackingOnStart}, 
	["extraction"] = {["start"] = REBEL_FUNCTIONS.ExtractionOnStart}
}



--basically a wraper for any mission type that requires a keycard in order to be able to use the mission
function REBEL_FUNCTIONS:InfiltrateOnStart(id, ply)
	if not IsValid(ply) then return end
	if not MISSIONS.Quests[id] then return end
	local mission = MISSIONS.Quests[id]
	if not mission.KeyCardID then 
		print("mission details are incorrect") 
		onstartFuncs[string.lower(string.Trim(mission.Type))]:start(id, ply)
	else 
		hideyoshiKeycards.func:allocateKeycard(ply, {mission.KeyCardID}) 
		ply.BlackmarketDeployedKeycards["rebel_infiltrate_keycard"] = true
		onstartFuncs[string.lower(string.Trim(mission.Type))]:start(id, ply)
	end
	
end 