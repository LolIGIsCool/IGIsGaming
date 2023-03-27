--[[-------------------------------------------------------------------
	Medal System Serverside Core:
		The core functions for the server side
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
							  
	Copyright wiltOS Technologies LLC, 2018
	
	Contact: www.wiltostech.com
		
----------------------------------------]]--

wOS = wOS or {}
wOS.Medals = wOS.Medals or {}

resource.AddWorkshop( "1431052732" )

local meta = FindMetaTable( "Player" )

function wOS.Medals:SendPlayerMedals( ply, target )
	if ply:IsBot() then ply.AccoladeList = {} end
	local count = table.Count( ply.AccoladeList )
	net.Start( "wOS.Medals.Badges.SendPlayerMedals" )
	net.WriteEntity( ply )
	net.WriteUInt( count, 32 )
	for medal, reason in pairs( ply.AccoladeList ) do
		net.WriteString( medal )
		net.WriteString( reason )
	end
	if target and target != ply then
		net.Send( target )
	else
		net.Send( ply )	
	end
end

hook.Add("IGPlayerSay", "wOS.Medals:receiveChatCommand", function( ply, text, dteam )
	local text = string.Left( text, #wOS.Medals.Config.OpenCommand )
	if text == wOS.Medals.Config.OpenCommand  then
		ply:SelectWeapon( "keys" )
		net.Start( "wOS.Medals.OpenMedalMenu" )
		net.Send( ply )
		return ""
	end
end)
 
--Let's change this to use auto fill in the future
concommand.Add("wos_revokemedals", function( ply, cmd, args )
	if file.Exists(args[1] ..".txt" , "DATA") then
		file.Delete(args[1]..".txt")
	else
		print("[wOS-Medals] Player file not found!")
	end
	
end, nil, "wos_revokeMedals <player name>")

concommand.Add("wos_listIDs", function()
	for k, v in pairs(player.GetAll()) do
		print("Name: " .. v:Nick() .. "			SteamID64: " .. v:SteamID64())
	end
end)