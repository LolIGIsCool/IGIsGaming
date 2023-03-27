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
	
	File Information: This module exists to stop players who are sharing from a banned player from connecting.
		Must be enabled in the config.
		
----------------------------------------]]--

--Family Sharing Function
function gBan:FamilyShareCheck( steam64 )

	--These two conditions should basically never happen, but a fail safe none-the-less
	if gBan.Config.APIKey == "" then return false, "none" end
	if not gBan.Config.SharedFamilyBan then return false, "none" end
	
	
	http.Fetch( "https://api.steampowered.com/IPlayerService/IsPlayingSharedGame/v1?key=".. gBan.Config.APIKey .."&steamid=".. steam64 .."&appid_playing=4000",
		function( body )
			local familyinfo = util.JSONToTable(body)
	        if not familyinfo["response"]["lender_steamid"] then return false, "none" end

	        local lenderId = familyinfo["response"]["lender_steamid"]
			if lenderId != "0" then
				if gBan.Bans[ lenderID ] then
					return true, lenderID
				end
			end
			return false, "none"
		end,
		function(err)
			gBan:AddChatMessage(false, "Player (", Color(255, 255, 0), "Unknown", color_white, ") has been unbanned by ", Color(255, 0, 0), nick)
		end
		)
	return false, "none"
	
end

