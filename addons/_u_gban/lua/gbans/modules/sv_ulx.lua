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
	
	File Information: With this we add ULX support. The commands will be integrated automatically if ULX is installed.
		If for WHATEVER reason you don't want ULX to be automatically integrated, go into the config and disable it.
		
----------------------------------------]]--

function gBan:RegisterULXCommands()
		print( "[gBan] Integrating ULX with gBan.." )
		if not ulx or gBan.Config.DisableULX then return end
		local category = "Utility"

		local function ulx_ban( caller, target, time, reason )
			if IsValid( caller ) then
				if caller.GetUserGroup then
					if not gBan.Config.Hierarchy[ caller:GetUserGroup() ] then 
						gBan:AddChatMessage( caller, gBan:Translate( "NoAccess", gBan.Config.Language ) )
						return
					end
				end
			end
			GBAN_PLAYER( caller, target, time, reason )
		end

		local ULXBan = ulx.command( category, "ulx ban", ulx_ban, "!ban" )
		ULXBan:addParam{ type = ULib.cmds.PlayerArg }
		ULXBan:addParam{ type = ULib.cmds.NumArg, hint = gBan:Translate( "ULXBanTime", gBan.Config.Language ), ULib.cmds.optional, ULib.cmds.allowTimeString, min = 0 }
		ULXBan:addParam{ type = ULib.cmds.StringArg, hint = gBan:Translate( "ULXBanReason", gBan.Config.Language ), ULib.cmds.optional, ULib.cmds.takeRestOfLine }
		ULXBan:defaultAccess( ULib.ACCESS_ALL )
		ULXBan:help( gBan:Translate( "ULXBan", gBan.Config.Language ) )

		local function ulx_banid( caller, steamid, time, reason )
			if IsValid( caller ) then
				if caller.GetUserGroup then
					if not gBan.Config.Hierarchy[ caller:GetUserGroup() ] then 
						gBan:AddChatMessage( caller, gBan:Translate( "NoAccess", gBan.Config.Language ) )
						return
					end
				end
			end
			GBAN_PLAYER_ID( caller, steamid, time, reason )
		end

		local ULXBanID = ulx.command( category, "ulx banid", ulx_banid, "!banid" )
		ULXBanID:addParam{ type = ULib.cmds.StringArg, hint = "SteamID or SteamID64" }
		ULXBanID:addParam{ type = ULib.cmds.NumArg, hint = gBan:Translate( "ULXBanTime", gBan.Config.Language ), ULib.cmds.optional, ULib.cmds.allowTimeString, min = 0 }
		ULXBanID:addParam{ type = ULib.cmds.StringArg, hint = gBan:Translate( "ULXBanReason", gBan.Config.Language ), ULib.cmds.optional, ULib.cmds.takeRestOfLine }
		ULXBanID:defaultAccess( ULib.ACCESS_ALL )
		ULXBanID:help( gBan:Translate( "ULXBanID", gBan.Config.Language ) )


		local function ulx_unban( caller, steamid )
			if IsValid( caller ) then
				if caller.GetUserGroup then
					if not gBan.Config.Hierarchy[ caller:GetUserGroup() ] then 
						gBan:AddChatMessage( caller, gBan:Translate( "NoAccess", gBan.Config.Language ) )
						return
					end
				end
			end
			GBAN_UNBAN( caller, steamid )
		end
		local ULXUnban = ulx.command( category, "ulx unban", ulx_unban, "!unban" )
		ULXUnban:addParam{ type = ULib.cmds.StringArg, hint = "SteamID or SteamID64" }
		ULXUnban:defaultAccess( ULib.ACCESS_ALL )
		ULXUnban:help( gBan:Translate( "ULXUnban", gBan.Config.Language ) )

		local function ulx_lookup( caller, steamid )
			if IsValid( caller ) then
				if caller.GetUserGroup then
					if not gBan.Config.Hierarchy[ caller:GetUserGroup() ] then 
						gBan:AddChatMessage( caller, gBan:Translate( "NoAccess", gBan.Config.Language ) )
						return
					end
				end
			end
			GBAN_LOOKUP( caller, steamid )
		end
		local ULXLookup = ulx.command( category, "ulx lookup", ulx_lookup, "!lookup" )
		ULXLookup:addParam{ type = ULib.cmds.StringArg, hint = "SteamID or SteamID64" }
		ULXLookup:defaultAccess( ULib.ACCESS_ALL )
		ULXLookup:help( gBan:Translate( "ULXLookup", gBan.Config.Language ) )
		print( "[gBan] Successfully integrated ULX with gBan!" )
end

hook.Add("InitPostEntity", "gBan.RegisterULX", function()
	
	timer.Simple( 120, function() gBan:RegisterULXCommands() end )
		
end )

