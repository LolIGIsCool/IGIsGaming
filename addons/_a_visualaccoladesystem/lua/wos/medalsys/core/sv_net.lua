--[[-------------------------------------------------------------------
	Server Networking File:
		File deals with all serverside networking
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

if SERVER then
	local tbl = {
		"wOS.Medals.Badges.SendAllBadges",
		"wOS.Medals.Badges.RequestData",
		"wOS.Medals.Badges.RequestBadgePos",
		"wOS.Medals.Badges.SendPlayerMedals",		
		"wOS.Medals.Badges.RegisterMedal",
		"wOS.Medals.DataStore.SaveMedal",
		"wOS.Medals.DataStore.DisplayMedals",
		"wOS.Medals.DataStore.SendMedalsBack",
		"wOS.Medals.DataStore.RevokeMedal",
		"wOS.Medals.SQL.RemoveMedal",
		"wOS.Medals.SQL.NoAccess",
		"wOS.Medals.OpenMedalMenu",
		"wOS.Medals.SpawnMedals",
		"wOS.Medals.Badges.Select",
		"wOS.Medals.Badges.Strip",
	}
	
	for i=1,table.Count(tbl) do
		util.AddNetworkString(tbl[i])
	end
end

net.Receive( "wOS.Medals.DataStore.SaveMedal", function( len, ply )
	
	if not table.HasValue( wOS.Medals.Config.AllowedULX, ply:GetUserGroup() ) then return end
	
	local steamid = net.ReadString()
	local target = player.GetBySteamID64( steamid )
	if not IsValid( target ) then return end
	
	local medal = net.ReadString()
	local data = wOS.Medals.Badges[ medal ]
	if not data then return end
	
	local reason = net.ReadString()
	
	local success = wOS.Medals.DataStore:AddNewMedal( target, medal, reason )
	
	if not success then
		ply:ChatPrint( "[wOS-Medals] An error occurred adding " .. medal .. " to " .. target:Nick() )
		return
	end
	
	for k, v in pairs( player.GetAll() ) do
		v:SendLua( [[ chat.AddText( wOS.Medals.Config.ChatAlertPrimaryClr, "[wOS-Medals] ", wOS.Medals.Config.ChatAlertSecondaryClr, "]] .. ply:Nick() .. [[ awarded a ]] .. data.Name .. [[ to ]] .. target:Nick() .. [[! Reason: ]] .. reason .. [[!")]] )
	end

	if target == ply then 
		wOS.Medals:SendPlayerMedals( ply )
		return 
	end
	
	wOS.Medals:SendPlayerMedals( target, ply )
	
	wOS.Medals:SendPlayerMedals( target )
	
end )

net.Receive("wOS.Medals.DataStore.RevokeMedal", function( len, ply )

	if not table.HasValue( wOS.Medals.Config.AllowedULX, ply:GetUserGroup() ) then return end

	local target = net.ReadString()
	if not target then return end
	target = player.GetBySteamID64( target )
	if not IsValid( target ) then return end
	
	local medal = net.ReadString()
	local data = wOS.Medals.Badges[ medal ]
	if not data then return end

	local success = wOS.Medals.DataStore:RevokeMedal( target, medal )

	if not success then
		ply:ChatPrint( "[wOS-Medals] An error occurred removing " .. medal .. " from " .. target:Nick() )
		return
	end
	
	ply:SendLua( [[ chat.AddText( wOS.Medals.Config.ChatAlertPrimaryClr, "[wOS-Medals] ", color_white, "You have revoked ", wOS.Medals.Config.ChatAlertSecondaryClr, "]] .. data.Name .. [[ medal successfully from ]] .. target:Nick() .. [[ !")]] )

	if target == ply then 
		wOS.Medals:SendPlayerMedals( ply )
		return 
	end
	
	target:SendLua( [[ chat.AddText( wOS.Medals.Config.ChatAlertPrimaryClr, "[wOS-Medals] Your ", wOS.Medals.Config.ChatAlertSecondaryClr, "]] .. data.Name .. [[ medal has been revoked by ]] .. target:Nick() .. [[")]] )
	
	wOS.Medals:SendPlayerMedals( target, ply )
	
	wOS.Medals:SendPlayerMedals( target )
	
end)

net.Receive( "wOS.Medals.DataStore.DisplayMedals", function( len, ply )
	
	local target = net.ReadEntity()
	if not IsValid( target ) then return end
	
	if target == ply then 
		wOS.Medals:SendPlayerMedals( ply )
		return 
	end
	
	wOS.Medals:SendPlayerMedals( target, ply )	

end )

net.Receive( "wOS.Medals.Badges.RequestData", function( len, ply )
	
	wOS.Medals.DataStore:LoadPlayerMedals( ply )
	
end )

net.Receive( "wOS.Medals.Badges.Select", function( len, ply )

	local name = net.ReadString()
	local reason = ply.AccoladeList[ name ]
	if not reason then return end
	
	local data = wOS.Medals.Badges[ name ]
	if not data then return end

	
	ply.SelectedMedals = ply.SelectedMedals or {}
	local slot = ( #ply.SelectedMedals < 1 and 1 ) or 2
	
	ply.SelectedMedals[ slot ] = {}
	ply.SelectedMedals[ slot ].Model = data.Model
	ply.SelectedMedals[ slot ].Skin = data.Skin
	ply.SelectedMedals[ slot ].Name = data.Name
	ply.SelectedMedals[ slot ].Reason = ply.AccoladeList[ name ]
	ply.SelectedMedals[ slot ].Positions = { Up = 9 - 5*slot, Right = 0, Forward = 6 }
	
	net.Start( "wOS.Medals.Badges.RequestBadgePos" )
		net.WriteEntity( ply )
		net.WriteTable( ply.SelectedMedals )
	net.Broadcast()
	
end )

net.Receive( "wOS.Medals.Badges.Strip", function( len, ply )

	local slot = net.ReadUInt(4)
	if slot < 1 then return end
	
	if not ply.SelectedMedals[ slot ] then return end
	ply.SelectedMedals[ slot ] = nil
	if slot == 1 then
		ply.SelectedMedals[ slot ] = table.Copy( ply.SelectedMedals[ slot + 1 ] )
		ply.SelectedMedals[ slot + 1 ] = nil
	end
	
	net.Start( "wOS.Medals.Badges.RequestBadgePos" )
		net.WriteEntity( ply )
		net.WriteTable( ply.SelectedMedals )
	net.Broadcast()
	
end )

net.Receive( "wOS.Medals.Badges.RequestBadgePos", function( len, ply )

	local slot = net.ReadUInt( 4 )
	if not ply.SelectedMedals[ slot ] then return end

	local positions = net.ReadTable()
	if not positions.Up or not positions.Right or not positions.Forward then return end
	
	ply.SelectedMedals[ slot ].Positions = table.Copy( positions )
	
	net.Start( "wOS.Medals.Badges.RequestBadgePos" )
		net.WriteEntity( ply )
		net.WriteTable( ply.SelectedMedals )
	net.Broadcast()
	
end )