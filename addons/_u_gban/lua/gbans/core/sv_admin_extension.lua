--[[-------------------------------------------------------------------
	Global Ban! (gBan):
		A simple solution to banning.
			Powered by
						  _ _ _    ___  ____  
				__      _(_) | |_ / _ \/ ___| 
				\ \ /\ / / | | __| | | \___ \ 
				 \ V  V /| | | |_| |_| |___) |
				  \_/\_/ |_|_|\__|\___/|____/ 
											  
 _____         _                 _             _           
|_   _|__  ___| |__  _ __   ___ | | ___   __ _(_) ___  ___ 
  | |/ _ \/ __| '_ \| '_ \ / _ \| |/ _ \ / _` | |/ _ \/ __|
  | |  __/ (__| | | | | | | (_) | | (_) | (_| | |  __/\__ \
  |_|\___|\___|_| |_|_| |_|\___/|_|\___/ \__, |_|\___||___/
                                         |___/             
-------------------------------------------------------------------]]--[[
							  
	Lua Developer: King David
	Contact: http://steamcommunity.com/groups/wiltostech
	
	Web Developer: BearWoolley
	Contact: N/A

	Purchased at www.scriptfodder.com
	File Information: The shared ban functions so we can localize between different admin mods. 
	
----------------------------------------]]--

function GBAN_PLAYER( caller, target, time, reason )

	time = time or 0
	reason = (reason:len() > 1 and reason) or "Reason not specified."
	
	local nick = "CONSOLE"
	if caller:IsValid() then 
		if not gBan.Config.Hierarchy[ caller:GetUserGroup() ] then 
			gBan:AddChatMessage( caller, gBan:Translate( "NoAccess", gBan.Config.Language ) )
			return
		end
		nick = caller:Nick() 
		if not gBan.Config.CanBan( caller, target ) then
			gBan:AddChatMessage( caller, gBan:Translate( "TargetHigh", gBan.Config.Language ) )
			return
		end
	end

	gBan:PlayerBan( caller, target, tonumber( time ), reason )

	if not gBan.Config.EnableLogging then return end
	local text = gBan:Translate( "LogBan", gBan.Config.Language )
	text = text:Replace( "{name}", nick )
	text = text:Replace( "{steamid}", target:Nick() )
	text = text:Replace( "{time}", tostring( time ) )
	text = text:Replace( "{reason}", reason )
	print( "[gBan] (LOG) " .. text )
	
end

function GBAN_PLAYER_ID( caller, id, time, reason, edit )

	local isid, is64 = gBan:ValidSteamID( id ), gBan:ValidSteamID64( id )
	local steam64 
	id = id:upper()
	time = time or 0
	reason = ( reason:len() > 1 and reason ) or "Reason not specified."
	if isid then
		steam64 = util.SteamIDTo64( id )
	elseif is64 then
		steam64 = id
		id = util.SteamIDFrom64( id )
	else
		gBan:AddChatMessage( caller, gBan:Translate( "InvalidID", gBan.Config.Language ) )
		return	
	end
	
	local nick = "CONSOLE"
	if caller:IsValid() then 
		if not gBan.Config.Hierarchy[ caller:GetUserGroup() ] then 
			gBan:AddChatMessage( caller, gBan:Translate( "NoAccess", gBan.Config.Language ) )
			return
		end
		nick = caller:Nick() 
	end

	if gBan.Bans[ steam64 ] and not edit then
		gBan:AddChatMessage( caller, gBan:Translate( "AlreadyBanned", gBan.Config.Language ) )
		return
	end
	
	gBan:AddChatMessage( caller, gBan:Translate( "BanBuffer", gBan.Config.Language ) )
	gBan:PlayerBanID( caller, id, tonumber( time ), reason, edit )
	
end

function GBAN_UNBAN( caller, id )

	id = id:upper()
	
	local isid, is64 = gBan:ValidSteamID( id ), gBan:ValidSteamID64( id )
	local steam64 
	
	if isid then
		steam64 = util.SteamIDTo64( id )
	elseif is64 then
		steam64 = id
		id = util.SteamIDFrom64( id )
	else
		gBan:AddChatMessage( caller, gBan:Translate( "InvalidID", gBan.Config.Language ) )
		return	
	end

	local nick = "CONSOLE"
	if caller:IsValid() then 
		if not gBan.Config.Hierarchy[ caller:GetUserGroup() ] then 
			gBan:AddChatMessage( caller, gBan:Translate( "NoAccess", gBan.Config.Language ) )
			return
		end
		nick = caller:Nick() 
	end
	
	if not gBan.Bans[ steam64 ] then
		gBan:AddChatMessage( caller, gBan:Translate( "NotBanned", gBan.Config.Language ) )
		return
	end

	gBan:AddChatMessage( caller, gBan:Translate( "BanBuffer", gBan.Config.Language ) )
	gBan:PlayerUnban( caller, id )

	if not gBan.Config.EnableLogging then return end
	local text = gBan:Translate( "LogUnban", gBan.Config.Language )
	text = text:Replace( "{name}", nick )
	text = text:Replace( "{steamid}", id )
	print( "[gBan] (LOG) " .. text )
	
end

-- Lookup
function GBAN_LOOKUP( caller, id )

	id = id:upper()
	local steam64
	local isid, is64 = gBan:ValidSteamID( id ), gBan:ValidSteamID64( id )

	time = ( time and time ) or 0
	reason = ( reason or reason ) or "Reason not specified."

	if isid then
		steam64 = util.SteamIDTo64( id )
	elseif is64 then
		steam64 = id
		id = util.SteamIDFrom64( id )
	else
		gBan:AddChatMessage( caller, gBan:Translate( "InvalidID", gBan.Config.Language ) )
		return	
	end

	local active, unactive = 0, 0
	local name
	for _, data in pairs( gBan.History ) do
		if data.steamid == id then
			if data.state > 2 then
				unactive = unactive + 1
			else
				active = active + 1
			end
			if not name then
				name = data.name
			end
		end
		
	end
	
	if not name then 
		gBan:AddChatMessage( caller, "No player records found.")	
		return
	end
	
	gBan:AddChatMessage( caller, "Player (", Color(255, 255, 0), name, color_white, ") has ", Color(255, 255, 0), tostring(active), color_white, " active ban(s) and ", Color(255, 255, 0), tostring(unactive), color_white, " unactive ban(s).")

end