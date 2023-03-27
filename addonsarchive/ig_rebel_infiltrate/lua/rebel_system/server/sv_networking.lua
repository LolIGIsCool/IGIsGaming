util.AddNetworkString("RebelMissionSystemReceiveTarget")
util.AddNetworkString("RebelMissionSystemHackingTarget")
util.AddNetworkString("TargetHit")
util.AddNetworkString("AcceptRebelMission")
util.AddNetworkString("StopRebelMission")
util.AddNetworkString("RebelTargetAreaCountdown")
util.AddNetworkString("StopRebelHacking")
util.AddNetworkString("StopRebelTheftMission")
util.AddNetworkString("RebelMissionSystemReceiveTheftLocation")
util.AddNetworkString("RebelItemHit")
util.AddNetworkString("CL_Rebel_Gear_Stats")
util.AddNetworkString("RebelMissionAssingment")
util.AddNetworkString("DenyRebelAssignment")
util.AddNetworkString("RebelMissionInstructions")
util.AddNetworkString("AdminRequestForRebelList")
util.AddNetworkString("AdminRequestForRebelHistory")
util.AddNetworkString("CompleteHistory")
util.AddNetworkString("RebelMissionAborted")
util.AddNetworkString("RebelHUDAbort")
util.AddNetworkString("RebelMissionDetils")
util.AddNetworkString("BeginRebelCountdown")

local disallowedRegs = {
	["Imperial Security Bureau"] = true, 
	["Inferno Squad"] = true, 
	["Imperial Inquisitor"] = true, 
	["Imperial Marauder"] = true, 
	["Imperial Guard"] = true, 
	["Compforce"] = true
}

local questCompleted = function(ply)
	if not IsValid(ply) then return end
	local mission = MISSIONS.InProgress[ply:SteamID64()]
	if not mission then print('no mission in progress') return end 
	
	if mission:Validate(ply) == false then return end

	--missions are over!
	if string.lower(mission.Type) == "extraction" then 
		mission:InProgress(ply)
		return 
	end

	-- see if the player has completed the current mission, if the mission is over the player will get a new mission 
	if not mission:InProgress(ply) then 
		local nextMission = {}
		for k, v in pairs(MISSIONS.Quests) do
			if v.Level == mission.Level + 1  then 
				if v.SubType ~= nil and string.lower(v.SubType) == "infiltrate" then 
					if enableInfiltration['enable'] then 
						nextMission[k] = v
					end 
				else
					nextMission[k] = v
				end
			end
		end
		if table.IsEmpty(nextMission) == false then 
			local random = table.Random(nextMission)
			random:OnStart(random.ID, ply)
		else
			-- get one of the extraction missions
			local random = table.Random(MISSIONS.Extraction)
			random:OnStart(random.ID, ply)
		end 
	end

end
-- ran from the entity rebel gear when it is inside the mission radius 
hook.Add("CallMissionProgress", "TriggerRebelMissionProgress", function(ply)
	questCompleted(ply)
end)


net.Receive("TargetHit", function(len, ply)
	questCompleted(ply)
end)

-- called when the ply gets to the hacking location, will start a countdown
net.Receive("RebelTargetAreaCountdown", function(len, ply)
	local mission =  MISSIONS.InProgress[ply:SteamID64()]
	if not mission then return end
	if not mission.WaitTime or not mission.Time then return end -- if we dont have the numbers we will get an err trying to do math with non numbers
	ply.HackStart =  ( CurTime() - 1)
	ply:StartRebelMissionCountdown() -- causes the countdown on the player hud to start going down
	timer.Create(ply:SteamID64().."_"..mission.Name , mission.WaitTime + mission.Time, 1 , function()
		if not IsValid(ply) then return end
		if not  MISSIONS.InProgress[ply:SteamID64()] then return end
		MISSIONS.InProgress[ply:SteamID64()]:OnAbort(ply, "You failed to to hack the terminal in the allotted time", true)
		ply.HackStart = nil 
	end)
end)

net.Receive("RebelMissionAborted", function(len, ply)
	if not IsValid(ply) then return end 
	if not MISSIONS.InProgress[ply:SteamID64()] then return end 
	MISSIONS.InProgress[ply:SteamID64()]:OnAbort(ply, "Mission aborted", true)
end)

local acceptRebel = function(len, ply)
		-- get a mission
	if not MISSIONS.AwaitingResponse[ply:SteamID64()] then return end
	MISSIONS.AwaitingResponse[ply:SteamID64()] = nil
	if timer.Exists(ply:SteamID64().."_".."AwaitingResponse") then timer.Remove(ply:SteamID64().."_".."AwaitingResponse") end 
	if table.IsEmpty(MISSIONS.Quests) then ply:PrintMessage(HUD_PRINTTALK, "No missions available") return end
	if disallowedRegs[ply:GetRegiment()] then ply:PrintMessage(HUD_PRINTTALK, ply:GetRegiment().." are not allowed to participate") end
	local level1 = {}
	for k, v in pairs(MISSIONS.Quests) do 
		if v.Level == 1 and v.Type == "Hack" then 
			level1[k]=v
		end
	end
	if not level1 then print("No level one missions available") return end
	local randomMission = table.Random(level1)
	if not randomMission then return end
	-- need to store by ent id to be able to retrieve the player object in the timer loop created in sh_init.lua
	MISSIONS.PlayerStartTime[ply:EntIndex()] = CurTime() 
	MISSIONS.CurrentRebelBlock[ply:EntIndex()] = true
	randomMission:OnStart(randomMission.ID, ply)
end




net.Receive("AcceptRebelMission", acceptRebel)

net.Receive("DenyRebelAssignment", function(len, ply)
	MISSIONS.AwaitingResponse[ply:SteamID64()] = nil 
	if timer.Exists(ply:SteamID64().."_".."AwaitingResponse") then timer.Remove(ply:SteamID64().."_".."AwaitingResponse") end 
end)

hook.Add("AcceptRebelMission", "AcceptRebelMission01", acceptRebel)

hook.Add( "PlayerDisconnected", "CheckRebelStatus", function(ply)
   	if MISSIONS.InProgress[ply:SteamID64()] or MISSIONS.AwaitingResponse[ply:SteamID64()] then 
   		ply.IsDead = nil
   		MISSIONS.PlayerStartTime[ply:EntIndex()] = nil
   		if MISSIONS.InProgress[ply:SteamID64()] then 
   			MISSIONS.InProgress[ply:SteamID64()]:OnAbort(ply, "")
   		else
   			 MISSIONS.AwaitingResponse[ply:SteamID64()] = nil
   		end
   	end 
end )

hook.Add("PlayerDeath", "RebelDied", function(vic, inflictor, attacker)
	if not MISSIONS.InProgress[vic:SteamID64()] then return end
	vic.IsDead= true 
	MISSIONS.InProgress[vic:SteamID64()]:OnAbort(vic, "You died. Mission failed", true)
end)

local missionInstructions = function(ply)
	if not MISSIONS.InProgress[ply:SteamID64()] then return end 
	local missionType = MISSIONS.InProgress[ply:SteamID64()].Type
	if not missionType then return end
	if string.lower(missionType) == "theft" then 
		if MISSIONS.InProgress[ply:SteamID64()].IsDelieveryingItem then 
			--ply:PrintMessage(HUD_PRINTTALK, MISSIONS.InProgress[ply:SteamID64()].DropLocationIntructions)
			net.Start("RebelMissionInstructions")
			net.WriteString(MISSIONS.InProgress[ply:SteamID64()].DropLocationIntructions)
			net.Send(ply)
		else 
			--ply:PrintMessage(HUD_PRINTTALK, MISSIONS.InProgress[ply:SteamID64()].Instructions)
			net.Start("RebelMissionInstructions")
			net.WriteString(MISSIONS.InProgress[ply:SteamID64()].Instructions)
			net.Send(ply)
		end
		return 
	end
	net.Start("RebelMissionInstructions")
	net.WriteString(MISSIONS.InProgress[ply:SteamID64()].Instructions)
	net.Send(ply)
	--ply:PrintMessage(HUD_PRINTTALK, MISSIONS.InProgress[ply:SteamID64()].Instructions)

end


hook.Add("PlayerSay", "RebelAccept", function(ply, txt)
	if not IsValid(ply) then return end  
	if string.lower( txt ) ~= "!rebelmission" then return end 
	if MISSIONS.AwaitingResponse[ply:SteamID64()] or MISSIONS.InProgress[ply:SteamID64()] then 
		if MISSIONS.AwaitingResponse[ply:SteamID64()] then 
			net.Start("RebelMissionAssingment")
			net.Send(ply)
		else
			missionInstructions(ply)
		end
	end 
	return false -- prevents the command from being printed
end)


local historyIndex = 0
local historyTableLimit = 11 -- how many entries do you wanna save in the json file
hook.Add("AddToRebelHistory", "AddToHistory", function(ply)
	local Timestamp = os.time()
	local TimeString = os.date( "%H:%M:%S-%d/%m/%Y" , Timestamp )
	local newHistory = {
		['name'] = ply:Nick(), 
		['date'] = TimeString
	}
	if table.Count(MISSIONS.CompleteHistory) < historyTableLimit then 
		table.insert(MISSIONS.CompleteHistory, newHistory)
	else
		if historyIndex == 0 then 
			-- find the oldest date in the history table and replace. as well as keep the index for future overwritting
			local date = string.Split(MISSIONS.CompleteHistory[1]['date'], "-")
			local oldestDate = string.Split(date[2], "/")
			local currentDay = tonumber(oldestDate[1])
			local currentMonth = tonumber(oldestDate[2])
			local currentYear = tonumber(oldestDate[3])
			local foundIndex = false
			for k, v in ipairs(MISSIONS.CompleteHistory) do
				local x = string.Split(v['date'], "-")
				local currentDate = string.Split(x[2], "/")
				if tonumber(currentDate[3])  < currentYear then 
					historyIndex = k
					currentYear = currentDate[3]
					currentMonth = currentDate[2]
					currentDay = currentDate[1]
					foundIndex = true
				end 
				if tonumber(currentDate[2]) < currentMonth then 
					historyIndex = k
					foundIndex = true
					currentYear = currentDate[3]
					currentMonth = currentDate[2]
					currentDay = currentDate[1]
				end
				if tonumber(currentDate[1]) < currentDay then 
					historyIndex = k 
					foundIndex = true
					currentYear = currentDate[3]
					currentMonth = currentDate[2]
					currentDay = currentDate[1]
				end 
			end
			if not foundIndex then historyIndex = 1	end
		else 
			if historyIndex + 1 < historyTableLimit	 then 
				historyIndex = historyIndex + 1 
			else 
				historyIndex = 1
			end 
		end
		table.insert(MISSIONS.CompleteHistory, historyIndex, newHistory)
	end
	local converted = util.TableToJSON(MISSIONS.CompleteHistory)
	file.Write("rebel_history_data.json", converted)
end)

hook.Add("Aiko.PlayerRFAd", "CancelRebelMission", function(o_steamid, offender_steamid, offence)
	local ply = player.GetBySteamID(util.SteamIDTo64( offender_steamid ))
	if not IsValid(ply) then return end
	if not ( MISSIONS.InProgress[ply:SteamID64()] or MISSIONS.AwaitingResponse[ply:SteamID64()] ) then return end 
	if MISSIONS.InProgress[ply:SteamID64()] then 
		MISSIONS.InProgress[ply:SteamID64()]:OnAbort(ply, "You were found out! You have done the rebellion a great disservice", true)
	else 
		MISSIONS.AwaitingResponse[ply:SteamID64()] = nil
	end
end)

local rebelApplicant = function(rebel)
	if MISSIONS.AwaitingResponse[rebel:SteamID64()] or MISSIONS.InProgress[rebel:SteamID64()] then return end 
	MISSIONS.AwaitingResponse[rebel:SteamID64()] = true
	rebel:PrintMessage(HUD_PRINTTALK, "Congratulations on infiltrating the empire. Use !rebelmission to receive your mission instructions")
	if not timer.Exists(rebel:SteamID64().."_".."AwaitingResponse") then 
		timer.Create(rebel:SteamID64().."_".."AwaitingResponse", 120, 1 , function()
			if not IsValid(rebel) then return end 
			if not MISSIONS.AwaitingResponse[rebel:SteamID64()] then return end 
			MISSIONS.PlayerStartTime[rebel:SteamID64()] = nil
			MISSIONS.AwaitingResponse[rebel:SteamID64()] = nil 
			rebel:PrintMessage(HUD_PRINTTALK, "failed to make up your mind in time")
		end)
	end
end

local loadBlacklistedPlayers = function()
	local f = file.Read("rebel_blacklist_data.json")
	if not f then return end
	local lst = util.JSONToTable(f)
	if not lst then return end
	MISSIONS.Blacklist = lst
end

local loadRebelHistory = function()
	local f = file.Read("rebel_history_data.json")
	if not f then return end 
	local lst = util.JSONToTable(f)
	if not lst then return end
	MISSIONS.CompleteHistory = lst
end

local filterBlacklistedPlayers = function()
	local playerList = player.GetAll()
	if table.Count(playerList) < 1 then return nil end -- change to 20 before release
	local newList = {}
	local count = 0
	for k, v in ipairs(playerList) do
		if v:GetRegiment() == "nil" or v:GetRank() == 0  then continue end
		local clearance =  tonumber(v:GetClearance() , 10)
		if not clearance then continue end
		local id = v:SteamID()
		if not ( MISSIONS.Blacklist[id] or MISSIONS.Completed[id] ) and not (disallowedRegs[v:GetRegiment()]) and ( clearance >1 and clearance < 5) then 
			count = count + 1	
			newList[count] = v
		end
	end
	if count < 1 then return nil end
	return newList
end

local timerFunc = function()
	if globaldefconn < 5 then return end -- dont make new rebels during an event
	if getdiseasesys == true then return end
	MISSIONS.CurrentRebelBlock = {}
	local playerList = filterBlacklistedPlayers()
	if playerList == nil then return end
	local newRebels = math.Round( (table.Count(playerList) * 0.04) ) + 1 
	for i = 1 , newRebels do
		local rebel, key = table.Random(playerList) 
		rebelApplicant(rebel)
		playerList[key] = nil
	end

end

hook.Add("initializeMissionsEnvironment", "rebelEnvironment", function()
	-- the loading of the quests is always first, essentially if there are no quests at this point there is no point in creating the timer
	loadBlacklistedPlayers()
	loadRebelHistory()
	if table.IsEmpty(MISSIONS.Quests) == false then 
		timer.Create("PuffyPandaSelectNewRebels", 3600 , 0, function()
			local succ, err = pcall(function() timerFunc() end)
			if err then print(err) end
		end)
	end
end)
hook.Add("BeginRebelInfiltration", "rebelEnvironment", function()
	timerFunc()
end)
hook.Run("initializeMissionsEnvironment")
