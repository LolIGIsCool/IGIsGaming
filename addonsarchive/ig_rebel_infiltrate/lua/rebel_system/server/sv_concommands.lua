
local findPlayerForBlacklist = function(playerName)
	for k, v in pairs(player.GetAll()) do
		stringStart, stringEnd = string.find(string.lower( v:Nick() ) , playerName )
		if stringStart then 
			return v 
		end
	end
	return nil 
end

concommand.Add("PlaySound", function(ply, cmd, args)
	ply:EmitSound(hackingsound["test"])
end)

concommand.Add("BlacklistRebel", function(ply, cmd, args)
	if not IsValid(ply) then return end
 	if not ( ply:IsAdmin() or ply:IsSuperAdmin() ) then return end 	
	if not args[1] then return end
	--[[-------------------------------------------------------------------------
	find player
	---------------------------------------------------------------------------]]
	local playerName = string.lower(args[1])
	local rebel = findPlayerForBlacklist(playerName)
	if not rebel then return end
	if MISSIONS.Blacklist[rebel:SteamID()] then return end
	MISSIONS.Blacklist[rebel:SteamID()] = true 

	--[[-------------------------------------------------------------------------
	write
	---------------------------------------------------------------------------]]
	local converted = util.TableToJSON(MISSIONS.Blacklist)
	file.Write("rebel_blacklist_data.json", converted)
	ply:PrintMessage(HUD_PRINTTALK, rebel:Nick().." has been blacklisted")

	--[[-------------------------------------------------------------------------
	remove player from current mission if active or waiting
	---------------------------------------------------------------------------]]
	if not ( MISSIONS.InProgress[rebel:SteamID64()] or MISSIONS.AwaitingResponse[rebel:SteamID64()]) then return end 
	MISSIONS.PlayerStartTime[rebel:EntIndex()] = nil 
	if MISSIONS.InProgress[rebel:SteamID64()] then 
		MISSIONS.InProgress[rebel:SteamID64()]:OnAbort(rebel, "You have been blacklisted from being a rebel")
	else 
		MISSIONS.AwaitingResponse[rebel:SteamID64()] = nil
	end

end)

concommand.Add("RemoveRebelFromBlacklist", function(ply, cmd, args)
	if not IsValid(ply) then return end
	if not ( ply:IsAdmin() or ply:IsSuperAdmin() ) then return end 
	if not args[1] then return end
	local playerName = string.lower(args[1])
	local rebel = findPlayerForBlacklist(playerName)
	if not rebel then return end  
	if not MISSIONS.Blacklist[rebel:SteamID()] then return end
	MISSIONS.Blacklist[rebel:SteamID()] = nil 
	local converted = util.TableToJSON(MISSIONS.Blacklist)
	file.Write("rebel_blacklist_data.json", converted)
	ply:PrintMessage(HUD_PRINTTALK, rebel:Nick().." has been removed from rebel blacklist") 

end)
local findPlayer = function(steamid)
	for k , v in pairs(player.GetAll()) do 
		if steamid == v:SteamID64() then 
			return v
		end
	end
	return nil
end



concommand.Add("RebelHistory", function(ply, cmd , args)
	if not IsValid(ply) then return end
	if not ( ply:IsAdmin() or ply:IsSuperAdmin() ) then return end 
	if table.Count(MISSIONS.CompleteHistory) < 1 then ply:PrintMessage(HUD_PRINTTALK, "No rebel history has been recorded") return end 
	net.Start("CompleteHistory")
	net.WriteTable(MISSIONS.CompleteHistory)
	net.Send(ply)
end)

concommand.Add("PrintHistory", function(ply, cmd, args)
	local x = MISSIONS.CompleteHistory[1]["date"]
	local date = string.Split(x, "-")
	local oldestDate = string.Split(date[2], "/")
	oldestDate[1] = string.Trim(oldestDate[1])
	PrintTable(oldestDate)

end)

concommand.Add("CurrentRebels", function(ply, cmd, args)
	if not IsValid(ply) then return end
 	if not ( ply:IsAdmin() or ply:IsSuperAdmin() ) then return end 
 	if table.Count(MISSIONS.InProgress) < 1 then ply:PrintMessage(HUD_PRINTTALK, "No active rebels") return end 
 	local rebelTable = {}
 	for k, v in pairs(MISSIONS.InProgress) do
 		local rebel = findPlayer(k)
 		if not rebel then break end
 		rebelTable[k] = rebel
 	end
 	if table.Count(rebelTable) < 1 then ply:PrintMessage(HUD_PRINTTALK, "No active rebels") return end 
 	net.Start("AdminRequestForRebelList")
 	net.WriteTable(rebelTable)
 	net.Send(ply)
end)

concommand.Add("ResetRebelMissions", function(ply, cmd, args)
	if not ( ply:IsSuperAdmin() ) then return end 
	hook.Run("ResetRebelMissionSystem") -- hook is defined in sh_init.lua in the root of rebel_system
	hook.Run("initializeMissionsEnvironment") -- hook is defined in sv_networking.lua in the root of rebel_system
end)


concommand.Add("GetCurrentPos", function(ply, cmd , args)
	local pos = ply:GetPos()
	print(pos.x..","..pos.y..","..pos.z)
end)