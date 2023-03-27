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
	
	File Information: This module exists to integrate TTT bans with gBans. It must be enabled in the config.
		
----------------------------------------]]--

if not gBan.Config.EnableTTT then return end

hook.Add("TTTKarmaLow", "gBans.CheckKarmaLow?", function( ply )

	local autoban = GetConVar( "ttt_karma_low_ban" ):GetBool()
	local persist = GetConVar( "ttt_karma_persist" ):GetBool()
	
	
	--These are TTT things that need to be done since we're overwriting the old Autokick function.
	if persist then
		local starting, kicklevel, max = GetConVar( "ttt_karma_starting" ):GetInt(), GetConVar( "ttt_karma_low_amount" ):GetInt(), GetConVar( "ttt_karma_max" ):GetInt()
		local k = math.Clamp( starting * 0.8, kicklevel * 1.1, max )
		ply:SetPData( "karma_stored", k )
		KARMA.RememberedPlayers[ ply:UniqueID() ] = k
    end
	--TTT standard variable to prevent normal disconnect functions from running.
	ply.karma_kicked = true
	
	--Now we get gBan in to work
	if autoban then
	
		local time = GetConVar( "ttt_karma_low_ban_minutes" ):GetInt()
		local reason = gBan:Translate( "TTTBanMessage", gBan.Config.Language )
		gBan:PlayerBan( nil, ply, time, reason )
		
   else
	-- We need to kick them anyway incase the server doesn't have autoban enabled.
		ServerLog( ply:Nick() .. " autokicked for low karma.\n")
		ply:Kick( "You have been automatically kicked for having low karma." )
	end
	
	-- We have to return false to prevent the game from trying to kick/ban the guy again. Silly game.
	return false
	
end )
