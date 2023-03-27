if (CLIENT) then return end
local CATEGORY_NAME = "IG Rebel System"

local name = function(ply)
	if not IsValid(ply) then 
		return "CONSOLE"
	else 
		return ply:Nick()
	end

end

function ulx.blacklistrebel(calling_ply, t) 

	local target = t[1]
	if not IsValid(target) then return end
	if MISSIONS.Blacklist[target:SteamID()] then return end
	MISSIONS.Blacklist[target:SteamID()] = true 
	local converted = util.TableToJSON(MISSIONS.Blacklist)
	file.Write("rebel_blacklist_data.json", converted)
	--calling_ply:PrintMessage(HUD_PRINTTALK, target:Nick().." has been blacklisted from rebel missions") 
	if not calling_ply:Nick() then 
		nick = "CONSOLE"
	else 
		nick = calling_ply:Nick()
	end
	RunConsoleCommand("ulx", "asay", nick, "has", "blacklisted", target:Nick(), "from", "being", "a", "rebel")
	if not ( MISSIONS.InProgress[target:SteamID64()] or MISSIONS.AwaitingResponse[target:SteamID64()]) then return end 

	MISSIONS.PlayerStartTime[target:EntIndex()] = nil 
	if MISSIONS.InProgress[target:SteamID64()] then 
		MISSIONS.InProgress[target:SteamID64()]:OnAbort(target, "You have been blacklisted from being a rebel")
	else 
		MISSIONS.AwaitingResponse[target:SteamID64()] = nil
		target:PrintMessage(HUD_PRINTTALK, "You are no longer able to participate as a rebel")
	end
end

local blacklist = ulx.command(CATEGORY_NAME, "ulx blacklistrebel", ulx.blacklistrebel ,"!blacklistrebel")

blacklist:defaultAccess( ULib.ACCESS_ADMIN )
blacklist:addParam{ type=ULib.cmds.PlayersArg }
blacklist:help( "blacklist a player. this kicks them of a mission if they are in one")


function ulx.removeRebelBlacklist(calling_ply, t)

	local target = t[1]
	if not IsValid(target) then return end
	if not MISSIONS.Blacklist[target:SteamID()] then return end
	MISSIONS.Blacklist[target:SteamID()] = nil 
	local converted = util.TableToJSON(MISSIONS.Blacklist)
	file.Write("rebel_blacklist_data.json", converted)

	if not calling_ply:Nick() then 
		nick = "CONSOLE"
	else 
		nick = calling_ply:Nick()
	end
	--calling_ply:PrintMessage(HUD_PRINTTALK, target:Nick().." has been removed from rebel missions") 
	RunConsoleCommand("ulx", "asay", nick, "has", "removed", target:Nick(), "from", "rebel", "blacklist")
end

local removeRebelBlacklist = ulx.command(CATEGORY_NAME, "ulx removeblacklist", ulx.removeRebelBlacklist , "!removeblacklist")

removeRebelBlacklist:defaultAccess( ULib.ACCESS_ADMIN )
removeRebelBlacklist:addParam{ type=ULib.cmds.PlayersArg }
removeRebelBlacklist:help( "enable player to participate in rebel missions")


function ulx.rebelhistory(ply)

	if table.Count(MISSIONS.CompleteHistory) < 1 then ply:PrintMessage(HUD_PRINTTALK, "No rebel history has been recorded") return end 
	net.Start("CompleteHistory")
	net.WriteTable(MISSIONS.CompleteHistory)
	net.Send(ply)
end

local history = ulx.command(CATEGORY_NAME, "ulx rebelhistory", ulx.rebelhistory , "!rebelhistory")
history:defaultAccess( ULib.ACCESS_ADMIN )
history:help( "show the date a player completed a rebel mission")

local findPlayer = function(steamid)
    local players = player.GetAll()
    for k = 1, #players do
        local v =  players[k]
        if steamid == v:SteamID64() then 
            return v
        end
    end
    return nil
end

function ulx.currentrebels(ply)
	print(table.Count(MISSIONS.CurrentRebelBlock))
 	if table.IsEmpty(MISSIONS.CurrentRebelBlock) then ply:PrintMessage(HUD_PRINTTALK, "No Active Rebels") return end
 	net.Start("AdminRequestForRebelList")
 	net.WriteTable(MISSIONS.CurrentRebelBlock)
 	net.Send(ply)
end

local currentrebels = ulx.command(CATEGORY_NAME, "ulx currentrebels" ,ulx.currentrebels ,"!currentrebels")
currentrebels:defaultAccess( ULib.ACCESS_ADMIN )
currentrebels:help( "get the players that are currently rebels")

function ulx.kickrebel(calling_ply, t)

	local target = t[1]
	if not IsValid(target) then return end

	if not ( MISSIONS.InProgress[target:SteamID64()] or MISSIONS.AwaitingResponse[target:SteamID64()]) then calling_ply:PrintMessage(HUD_PRINTTALK, "Player is not a rebel") end 
	if  MISSIONS.AwaitingResponse[target:SteamID64()] then 
		 MISSIONS.AwaitingResponse[target:SteamID64()] = nil 
	else 
		MISSIONS.InProgress[target:SteamID64()]:OnAbort(target, "You have failed your mission", true)
	end
	calling_ply:PrintMessage(HUD_PRINTTALK, "Player has been kicked from their mission")
end

local kickrebel = ulx.command(CATEGORY_NAME, "ulx kickrebel", ulx.kickrebel, "!kickrebel")
kickrebel:defaultAccess( ULib.ACCESS_ADMIN )
kickrebel:addParam{ type=ULib.cmds.PlayersArg }
kickrebel:help( "removes player being participating as a rebel")

	
x =  file.Read("enableInfiltration.json")
if not x then 
	enableInfiltration = {['enable'] = true}
else 
	enableInfiltration = util.JSONToTable(x)
end 

function ulx.toggleinfiltrate(calling_ply)
	local nick = name(calling_ply)
	if enableInfiltration['enable'] then 
		enableInfiltration['enable'] = false 
		RunConsoleCommand("ulx", "asay", nick, "has", "disbaled", "infiltration", "missions")
	else 
		enableInfiltration['enable'] = true
		RunConsoleCommand("ulx", "asay", nick, "has", "enabled", "infiltration", "missions")
	end 
	local converted = util.TableToJSON(enableInfiltration)
	file.Write("enableInfiltration.json", converted)

end

local toggleinfiltration = ulx.command(CATEGORY_NAME, "ulx toggleinfiltration", ulx.toggleinfiltrate, "!toggleinfiltrate")
toggleinfiltration:defaultAccess( ULib.ACCESS_ADMIN )
toggleinfiltration:help( "toggle whether rebels can be given infiltration missions (missions that give key cards) ")


function ulx.resetmissions(ply)
	local nick = name(ply)
	RunConsoleCommand("ulx", "asay", nick, "has", "reset", "the", "rebel", "missions")
	hook.Run("ResetRebelMissionSystem") -- hook is defined in sh_init.lua in the root of rebel_system
	hook.Run("initializeMissionsEnvironment") -- hook is defined in sv_networking.lua in the root of rebel_system
end

local resetmissions = ulx.command(CATEGORY_NAME, "ulx resetmissions", ulx.resetmissions , "!resetmissions")
resetmissions:defaultAccess( ULib.ACCESS_ADMIN )
resetmissions:help( "resets the rebel missions, all active players will be removed at no penalty from their mission")


function ulx.runmissions(ply)
	local nick = name(ply)
	RunConsoleCommand("ulx", "asay",nick, "has", "started", "the", "rebel", "missions")
	hook.Run("BeginRebelInfiltration")
end

local runmission = ulx.command(CATEGORY_NAME, "ulx startrebelmission", ulx.runmissions, "!startmissions")
runmission:defaultAccess( ULib.ACCESS_ADMIN )
runmission:help( "rebel participates will be immediately selected")


function ulx.removefromcompletedlist(ply, t)
	local nick = name(ply)
	local target = t[1]
	if not target or not IsValid(target) then return end 
	if not MISSIONS.Completed[target:SteamID()] then return end 
	ply:PrintMessage(HUD_PRINTTALK, "Player can now do more missions")
	MISSIONS.Completed[target:SteamID()] = nil
end 

local allowplayer = ulx.command(CATEGORY_NAME, "ulx completedlist", ulx.removefromcompletedlist, "!completedlist")
allowplayer:defaultAccess( ULib.ACCESS_ADMIN )
allowplayer:help( "allow a player to become a rebel again")
allowplayer:addParam{ type=ULib.cmds.PlayersArg }