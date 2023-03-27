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
	
	File Information: This is our client networking file. It let's the client know what to do 	
		when it receives the incredible information we'll be sending it.
		
----------------------------------------]]--

net.Receive( "gBan.Message", function( len )

	local message = net.ReadTable()
	chat.AddText( unpack( message ) )
	
end )

net.Receive( "gBan.SendBans", function( len )
	local extension = net.ReadBool()
	local limit = net.ReadInt( 32 )

	if not extension then
		gBan.FormattedBans = {}
		gBan.BanlistReady = false
	end

	for i = 1, limit do
		local name = net.ReadString()
		local steamid = net.ReadString()
		local admin = net.ReadString()
		local admin_id = net.ReadString()
		local reason = net.ReadString()
		local date = net.ReadInt( 32 )
		local length = net.ReadInt( 32 )
		
		gBan.FormattedBans[ #gBan.FormattedBans + 1 ] = { name .. " (" .. steamid .. ")", admin .. " (" .. admin_id .. ")", reason, tostring(os.date("%d/%m/%Y %X", date)):Left(string.len(tostring(os.date("%d/%m/%Y %X", date))) - 3), length == 0 and gBan:Translate( "Never", gBan.SelectedLanguage ) or tostring(os.date("%d/%m/%Y %X", length)):Left(string.len(tostring(os.date("%d/%m/%Y %X", date))) - 3), steamid, name }
	end
	local done = net.ReadBool()
	if done then
		gBan.BanlistReady = true
		gBan:OpenMenu()
	end
end )

net.Receive( "gBan.SendHistory", function( len )

	local extension = net.ReadBool()
	local limit = net.ReadInt( 32 )
	
	if not extension then
		gBan.FormattedHistory = {}
		gBan.HistoryReady = false
	end

	for i = 1, limit do
		local name = net.ReadString()
		local steamid = net.ReadString()
		local admin = net.ReadString()
		local admin_id = net.ReadString()
		local reason = net.ReadString()
		local date_banned = net.ReadInt( 32 )
		local unban_date = net.ReadInt( 32 )
		local unbanned_by = net.ReadString()
		
		gBan.FormattedHistory[#gBan.FormattedHistory + 1] = { name .. " (" .. steamid .. ")", admin .. " (" .. admin_id .. ")", reason, tostring(os.date("%d/%m/%Y %X", date_banned)):Left(string.len(tostring(os.date("%d/%m/%Y %X", date_banned))) - 3), ( unban_date == 0 and gBan:Translate( "Never", gBan.SelectedLanguage ) ) or tostring(os.date("%d/%m/%Y %X", unban_date)):Left(string.len(tostring(os.date("%d/%m/%Y %X", unban_date))) - 3), unbanned_by, steamid }
	end	
	local done = net.ReadBool()
	if done then
		gBan.HistoryReady = true
		if IsValid( gBan.MainFrame ) then
			gBan:OpenMenu()
		end
	end
end )

net.Receive( "gBan.AlertUpdate", function( len )
	gBan.HistoryUpdated = true
	gBan.BansUpdated = true
end )