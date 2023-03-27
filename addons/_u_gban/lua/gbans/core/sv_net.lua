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
	
	File Information: This is our networking file. It's in charge of server to client communcation. 
		The old networking wasn't very good, so hopefully this one will work out better for all of us.
		
----------------------------------------]]--

util.AddNetworkString( "gBan.SendBans" )
util.AddNetworkString( "gBan.SendHistory" )
util.AddNetworkString( "gBan.BanBuffer" )
util.AddNetworkString( "gBan.UnBanBuffer" )


function gBan:SendBans( ply, continued )
	if not gBan.Bans then return end
	
	local num = 0
	local limit = 0
	local offset = -1
	local more = false
	local extension = false
	local total = table.Count( gBan.Bans )
	local transfer = gBan.Config.EntryAllocation
	
	if continued then
		offset = continued
		extension = true
	end

	if transfer >= total then
		transfer = total
	elseif offset + gBan.Config.EntryAllocation > total then
		transfer = total - offset
	end
	
	net.Start( "gBan.SendBans" )
		net.WriteBool( extension )
		net.WriteInt( transfer, 32 )
		for _, info in pairs( gBan.Bans ) do
			num = num + 1
			if num > offset then
				limit = limit + 1
				net.WriteString( info.name )
				net.WriteString( info.steamid )
				net.WriteString( info.admin )
				net.WriteString( info.admin_id )
				net.WriteString( info.reason )
				net.WriteInt( info.date, 32 )
				net.WriteInt( info.length, 32 )
				if limit >= gBan.Config.EntryAllocation then break end
			end
		end
	if num < table.Count( gBan.Bans ) then
		more = true
	end
	net.WriteBool( !more )
	net.Send( ply )
	
	if more then
		timer.Simple( 0.05, function() if IsValid( ply ) then gBan:SendBans( ply, num ) end end )
	else
		if ply.HistoryQueue then 
			gBan:SendHistory( ply )
		end
	end
	
end

function gBan:SendHistory( ply, continued )
	if not gBan.History then return end
	
	local num = 0
	local limit = 0
	local offset = -1
	local more = false
	local extension = false
	local total = 0
	for _, entry in pairs( gBan.History ) do
		if entry.state > 2 then
			total = total + 1
		end
	end
	local transfer = gBan.Config.EntryAllocation
	
	if continued then
		offset = continued
		extension = true
	end
	
	if transfer >= total then
		transfer = total
	elseif offset + gBan.Config.EntryAllocation > total then
		transfer = total - offset
	end

	net.Start( "gBan.SendHistory" )
		net.WriteBool( extension )
		net.WriteInt( transfer, 32 )
		for _, info in pairs( gBan.History ) do
			num = num + 1
			if num > offset then
				if info.state > 2 then
					limit = limit + 1
					net.WriteString( info.name )
					net.WriteString( info.steamid )
					net.WriteString( info.admin )
					net.WriteString( info.admin_id )
					net.WriteString( info.reason )
					net.WriteInt( info.date_banned, 32 )
					if info.unbanned_date then
						net.WriteInt( info.unbanned_date, 32 )
					else
						net.WriteInt( 0, 32 )
					end
					if not info.unbanned_by then
						net.WriteString( "CONSOLE" )
					else
						net.WriteString( info.unbanned_by )
					end
					if limit >= gBan.Config.EntryAllocation then break end
				end
			end
		end
	if num < total then
		more = true
	end
	net.WriteBool( !more )
	net.Send( ply )
	
	if more then
		timer.Simple( 0.05, function() if IsValid( ply ) then gBan:SendHistory( ply, num ) end end )
		return
	end

	ply.HistoryQueue = false
	
end

net.Receive( "gBan.BanBuffer", function( len, ply )

	if not gBan.Config.Hierarchy[ ply:GetUserGroup() ] then 
		gBan:AddChatMessage( ply, gBan:Translate( "NoAccess", gBan.Config.Language ) )
		return
	end

	local isid = net.ReadBool()
	local time = net.ReadInt( 32 )
	local reason = net.ReadString()	
	if isid then
		targetid = net.ReadString()
		local edit = net.ReadBool()
		GBAN_PLAYER_ID( ply, targetid, time, reason, edit )
	else
		targetid = net.ReadEntity()
		GBAN_PLAYER( ply, targetid, time, reason )
	end
	
end )

net.Receive( "gBan.UnBanBuffer", function( len, ply )

	if not gBan.Config.Hierarchy[ ply:GetUserGroup() ] then 
		gBan:AddChatMessage( ply, gBan:Translate( "NoAccess", gBan.Config.Language ) )
		return
	end

	local steamid = net.ReadString()
	GBAN_UNBAN( ply, steamid )
	
end )

net.Receive( "gBan.SendBans", function( len, ply )

	gBan:SendBans( ply )

end )

net.Receive( "gBan.SendHistory", function( len, ply )

	gBan:SendHistory( ply )

end )


function gBan:SyncData( ply ) 

	if gBan.Config.DelayHistory then
		ply.HistoryQueue = true
	else
		gBan:SendHistory( ply )
	end
    gBan:SendBans( ply )
	
end