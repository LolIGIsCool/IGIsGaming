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
	File Information: This is where all the ban functions are.
		I could've made one universal function but this helps me isolate errors the user may be experiencing.

----------------------------------------]]--

util.AddNetworkString( "gBan.AlertUpdate" )

function gBan:PlayerBan(caller, target, time, reason)

	local steam64 = target:SteamID64()
	local tsteamid = target:SteamID()
	if self.Bans[ steam64 ] then return "steamid.duplicate" end

	local current_time = os.time()
	local ftime = time
	local time = ( time == 0 and 0 ) or os.time() + (time * 60)

	local nick, steamid = "CONSOLE", "CONSOLE"
	if IsValid( caller ) then
		if not gBan.Config.Hierarchy[ caller:GetUserGroup() ] then
			gBan:AddChatMessage( caller, gBan:Translate( "NoAccess", gBan.Config.Language ) )
			return
		end
		nick = caller:Nick()
		steamid = caller:SteamID()
	end

	local tnick, tip = target:Nick(), target:IPAddress()

	if not reason then
		reason = "No reason specified."
	end

	if reason == "" then
		reason = "No reason specified."
	end

	local denyban = hook.Call( "gBan.ShouldPlayerBan", nil,
		{
			[ "Name" ] = tnick,
			[ "SteamID" ] = tsteamid,
			[ "SteamID64" ] = steam64,
			[ "IP" ] = tip,
			[ "Admin" ] = nick,
			[ "AdminID" ] = steamid,
			[ "Reason" ] = reason,
			[ "Duration" ] = ftime,
		}
	)

	if denyban then
		if type.istable( denyban ) then
			tnick = denyban[ "Name" ]
			tsteamid = denyban[ "SteamID" ]
			steam64 = denyban[ "SteamID64" ]
			tip = denyban[ "IP" ]
			nick = denyban[ "Admin" ]
			steamid = denyban[ "AdminID" ]
			reason = denyban[ "Reason" ]
			ftime = denyban[ "Duration" ]
			time = ( time == 0 and 0 ) or os.time() + (ftime * 60)
		else
			print( "[gBan] Failed to ban player " .. tnick .. " ( Action was denied by a hook )")
			return
		end
	end



	-- Queries
	local addToList = [[ INSERT INTO gban_list(target, target_id, target_uniqueid, target_ip, admin, admin_id, reason, date, length, server_id) VALUES('%s', '%s', '%s', '%s', '%s', '%s', '%s', '%s', '%s', '%s') ON DUPLICATE KEY UPDATE target_id=target_id ]]
	local addToHistory = [[ INSERT INTO gban_history(target, target_id, target_uniqueid, target_ip, admin, admin_id, reason, date_banned, state, unbanned_by, unbanned_date, server_id) VALUES('%s', '%s', '%s', '%s', '%s', '%s', '%s', '%s', '%s', '%s', '%s', '%s') ON DUPLICATE KEY UPDATE target_id=target_id ]]

	self:Query( addToList:format(self:Escape(tnick), self:Escape(tsteamid), self:Escape(steam64), self:Escape(tip), self:Escape(nick), self:Escape(steamid), self:Escape(reason), self:Escape(tostring(current_time)), self:Escape(tostring(time)), gBan.ID))
	self:Query( addToHistory:format(self:Escape(tnick), self:Escape(tsteamid), self:Escape(steam64), self:Escape(tip), self:Escape(nick), self:Escape(steamid), self:Escape(reason), self:Escape(tostring(current_time)), (time == 0 and "2") or "1", (time == 0 and "" or nick), self:Escape(tostring(time)), gBan.ID))
	self.Bans[ steam64 ] = {name = tnick, steamid = tsteamid, uniqueid = steam64, ipaddress = tip, admin = nick, admin_id = steamid, reason = reason, date = current_time, length = time, server = gBan.ID}
	self:AddChatMessage( false, Color(255, 0, 0), nick, color_white, " " .. self:Translate( "HasBanned", self.Config.Language ) .. " ", Color(255, 255, 0), tnick, color_white, " - " .. self:Translate( "Duration", self.Config.Language ) .. ": ", Color(255, 255, 0), (time == 0 and self:Translate( "Permanent", self.Config.Language ) or tostring(ftime)), color_white, (time == 0 and "! (" or " minutes! ("), Color(255, 255, 0), reason, color_white, ")" )
	self.History[#gBan.History + 1] = {name = tnick, steamid = tsteamid, uniqueid = steam64, ipaddress = tip, admin = nick, admin_id = steamid, reason = reason, date_banned = current_time, state = (time == 0 and 2 or 1), unbanned_by = (time == 0 and "" or nick), unbanned_date = (time == 0 and 0 or length), server = gBan.ID}

	local message = self:Translate( "BanMessage", self.Config.Language )
	message = message:Replace("{admin}", gBan.Bans[ steam64 ].admin )
	message = message:Replace("{reason}", reason)
	message = message:Replace("{date_banned}", os.date("%d/%m/%Y @ %X", current_time))
	message = message:Replace("{unban_date}", time == 0 and "Never" or os.date("%d/%m/%Y @ %X", time))
	target:Kick( message )

	net.Start( "gBan.AlertUpdate" )
	net.Broadcast()

end

-- PlayerID
function gBan:PlayerBanID( caller, steamid, time, reason, edit )

	local steam64 = util.SteamIDTo64( steamid )
	if self.Bans[ steam64 ] and not edit then return "steamid.duplicate" end

	local current_time = os.time()
	local ftime = time
	local time = ( time == 0 and 0 ) or current_time + (time * 60)

	for k, v in pairs( player.GetAll() ) do
		if v:SteamID64() == steam64 then
			gBan:PlayerBan( caller, v, ftime, reason )
			return
		end
	end

	local nick, csteamid = "CONSOLE", "CONSOLE"
	if IsValid( caller ) then
		if not gBan.Config.Hierarchy[ caller:GetUserGroup() ] then
			gBan:AddChatMessage( caller, gBan:Translate( "NoAccess", gBan.Config.Language ) )
			return
		end
		nick = caller:Nick()
		csteamid = caller:SteamID()
	end

	local denyban = hook.Call( "gBan.ShouldPlayerBanID", nil,
		{
			[ "SteamID" ] = steamid,
			[ "SteamID64" ] = steam64,
			[ "Admin" ] = nick,
			[ "AdminID" ] = csteamid,
			[ "Reason" ] = reason,
			[ "Duration" ] = ftime,
		}
	)

	if denyban then
		if type.istable( denyban ) then
			steamid = denyban[ "SteamID" ]
			steam64 = denyban[ "SteamID64" ]
			nick = denyban[ "Admin" ]
			csteamid = denyban[ "AdminID" ]
			reason = denyban[ "Reason" ]
			ftime = denyban[ "Duration" ]
			time = ( time == 0 and 0 ) or os.time() + (ftime * 60)
		else
			print( "[gBan] Failed to ban SteamID " .. steamid .. " ( Action was denied by a hook )")
			return
		end
	end

	local addToList = [[ INSERT INTO gban_list(target, target_id, target_uniqueid, target_ip, admin, admin_id, reason, date, length, server_id) VALUES('%s', '%s', '%s', '%s', '%s', '%s', '%s', '%s', '%s', '%s') ON DUPLICATE KEY UPDATE target_id=target_id ]]
	local addToHistory = [[ INSERT INTO gban_history(target, target_id, target_uniqueid, target_ip, admin, admin_id, reason, date_banned, state, unbanned_by, unbanned_date, server_id) VALUES('%s', '%s', '%s', '%s', '%s', '%s', '%s', '%s', '%s', '%s', '%s', '%s') ON DUPLICATE KEY UPDATE target_id=target_id ]]
	local UpdateToList
	local UpdateToHistory

	if edit then
		UpdateToList = [[ UPDATE gban_list SET target='%s', target_id='%s', target_uniqueid='%s', target_ip='%s', admin='%s', admin_id='%s', reason='%s', date='%s', length='%s', server_id='%s' WHERE target_id='%s']]
		UpdateToHistory = [[ UPDATE gban_history SET target='%s', target_id='%s', target_uniqueid='%s', target_ip='%s', admin='%s', admin_id='%s', reason='%s', date_banned='%s', state='%s', unbanned_by='%s', unbanned_date='%s', server_id='%s' WHERE target_id='%s' AND date_banned = ']] .. self.Bans[steam64].date .. [[']]
	end

	http.Fetch("http://api.steampowered.com/ISteamUser/GetPlayerSummaries/v0002/?key=" .. self.Config.APIKey .. "&steamids=" .. steam64,
		function(body, len, headers, code)
			local playerinfo = util.JSONToTable(body)["response"]["players"][1]
			if not playerinfo then
				self:AddChatMessage( caller, self:Translate( "NonExist", self.Config.Language ) )
				return
			end
			if edit then
				self:Query( UpdateToList:format( self:Escape( playerinfo.personaname ), self:Escape( steamid ), self:Escape( steam64 ), "0.0.0.0", self:Escape( nick ), self:Escape( csteamid ), self:Escape( reason ), self:Escape( tostring( current_time ) ), self:Escape( tostring( time ) ), self.ID, self:Escape( steamid )  ) )
				self:Query( UpdateToHistory:format( self:Escape( playerinfo.personaname ), self:Escape( steamid ), self:Escape( steam64 ), "0.0.0.0", self:Escape( nick ), self:Escape( csteamid ), self:Escape( reason ), self:Escape( tostring( current_time ) ), ( time == 0 and "2" ) or "1", (time == 0 and "" or nick), self:Escape(tostring(time)), self.ID, self:Escape( steamid ) ) )
			else
				self:Query( addToList:format( self:Escape( playerinfo.personaname ), self:Escape( steamid ), self:Escape( steam64 ), "0.0.0.0", self:Escape( nick ), self:Escape( csteamid ), self:Escape( reason ), self:Escape( tostring( current_time ) ), self:Escape( tostring( time ) ), self.ID ))
				self:Query( addToHistory:format( self:Escape( playerinfo.personaname ), self:Escape( steamid ), self:Escape( steam64 ), "0.0.0.0", self:Escape( nick ), self:Escape( csteamid ), self:Escape( reason ), self:Escape( tostring( current_time ) ), ( time == 0 and "2" ) or "1", (time == 0 and "" or nick), self:Escape(tostring(time)), self.ID))
			end
			self.Bans[ steam64 ] = { name = playerinfo.personaname, steamid = steamid, uniqueid = steam64, ipaddress = "0.0.0.0", admin = nick, admin_id = csteamid, reason = reason, date = current_time, length = time, server = self.ID }
			self:AddChatMessage( false, Color(255, 0, 0), nick, color_white, " " .. self:Translate( "HasBanned", self.Config.Language ) .. " ", Color(255, 255, 0), playerinfo.personaname, color_white, " - " .. self:Translate( "Duration", self.Config.Language ) .. ": ", Color(255, 255, 0), (time == 0 and self:Translate( "Permanent", self.Config.Language ) or tostring( ftime ) ), color_white, (time == 0 and "! (" or " minutes! ("), Color(255, 255, 0), reason, color_white, ")" )
			if not edit then
				self.History[ #self.History + 1 ] = { name = playerinfo.personaname, steamid = steamid, uniqueid = steam64, ipaddress = "0.0.0.0", admin = nick, admin_id = csteamid, reason = reason, date_banned = current_time, state = (time == 0 and 2 or 1), unbanned_by = (time == 0 and "" or nick), unbanned_date = (time == 0 and 0 or length), server = gBan.ID}
			else
				for k, data in pairs( self.History ) do
					if data.steamid == steamid then
						self.History[ k ] = { name = playerinfo.personaname, steamid = steamid, uniqueid = steam64, ipaddress = "0.0.0.0", admin = nick, admin_id = csteamid, reason = reason, date_banned = current_time, state = (time == 0 and 2 or 1), unbanned_by = (time == 0 and "" or nick), unbanned_date = (time == 0 and 0 or length), server = gBan.ID}
						break
					end
				end
			end
			if not gBan.Config.EnableLogging then return end
			local text = gBan:Translate( "LogBan", gBan.Config.Language )
			text = text:Replace( "{name}", playerinfo.personaname )
			text = text:Replace( "{steamid}", csteamid )
			text = text:Replace( "{time}", tostring( time ) )
			text = text:Replace( "{reason}", reason )
			print( "[gBan] (LOG) " .. text )
		end,
		function( error )
			print( "[gBan] Error banning '" .. steamid .. "' (" .. error .. ")" )
			print( "[gBan] " .. self:Translate( "APIKey", self.Config.Language ) )
		end	)

	net.Start( "gBan.AlertUpdate" )
	net.Broadcast()

end

function gBan:PlayerBan64(caller, steam64, time, reason)
	local steamid = util.SteamIDFrom64( steam64 )
	self:PlayerBanID( caller, steamid, time, reason, steam64 )
end

function gBan:PlayerUnban( caller, steamid )
	local steam64 = util.SteamIDTo64( steamid )
	if (not self.Bans[steam64]) then
		print("Player is already unbanned")
		if(IsValid(caller)) then
			caller:ChatPrint("Player is already unbanned")
		end
		return
	end
	print("test1")
	local nick = "CONSOLE" 	
	if IsValid(caller) then
		if not gBan.Config.Hierarchy[ caller:GetUserGroup() ] then
			gBan:AddChatMessage( caller, gBan:Translate( "NoAccess", gBan.Config.Language ) )
			return
		end
		nick = caller:Nick()
	end
	print("test2")

	local denyban = hook.Call( "gBan.ShouldPlayerUnban", nil,
		{
			[ "SteamID" ] = steamid,
			[ "SteamID64" ] = steam64,
			[ "Admin" ] = nick,
		}
	)

	if denyban then
		if type.istable( denyban ) then
			steamid = denyban[ "SteamID" ]
			steam64 = denyban[ "SteamID64" ]
			nick = denyban[ "Admin" ]
		else
			print( "[gBan] Failed to unban SteamID " .. steamid .. " ( Action was denied by a hook )")
			return
		end
	end
	print("test3")

	-- Remove from active list
	self:Query([[DELETE FROM gban_list WHERE target_id = ']] .. steamid .. [[']])

	print(nick)
	print(steamid)
	print(steam64)
	print(self.Bans[steam64].date)
	-- Edit history
	if not self.Bans[steam64] then
		self:Query([[UPDATE gban_history SET state = '3', unbanned_by = ']] .. nick .. [[', unbanned_date = ']] .. os.time() .. [[' WHERE target_id = ']] .. steamid .. [[' AND date_banned = ']] .. self.Bans[steam64].date .. [[']])
	else
		self:Query([[UPDATE gban_history SET state = ']] .. ((self.Bans[steam64].length == 0 and [[4]]) or [[3]]) .. [[', unbanned_by = ']] .. nick .. [[', unbanned_date = ']] .. os.time() .. [[' WHERE target_id = ']] .. steamid .. [[' AND date_banned = ']] .. self.Bans[steam64].date .. [[']])
	end

	-- History
	for k, v in pairs( self.History ) do
		if v.date_banned == self.Bans[steam64].date and v.steamid == steamid then
			self.History[k].state = self.History[k].state + 2
			self.History[k].unbanned_by = nick
		end
	end
	print("test4")

	-- Remove from local storage
	self.Bans[steam64] = nil

	-- Message
	if self.Config.APIKey then
	http.Fetch("http://api.steampowered.com/ISteamUser/GetPlayerSummaries/v0002/?key=" .. self.Config.APIKey .. "&steamids=" .. steam64,
		function(body, len, headers, code)
			local playerinfo = util.JSONToTable(body)["response"]["players"][1]
			if not playerinfo then
				self:AddChatMessage( caller, self:Translate( "NonExist", self.Config.Language ) )
				return
			end
			self:AddChatMessage(false, self:Translate( "Player", self.Config.Language ) .. " ", Color(255, 0, 0), nick, color_white, " " .. self:Translate( "HasUnBanned", self.Config.Language ) .. " ", Color(255, 255, 0), playerinfo.personaname )
			end,
			function(err)
					self:AddChatMessage(false, self:Translate( "Player", self.Config.Language ) .. " ", Color(255, 0, 0), "UNKNOWN", color_white, " " .. self:Translate( "HasUnBanned", self.Config.Language ) .. " ", Color(255, 255, 0), playerinfo.personaname )
			end
		)
	end


	net.Start( "gBan.AlertUpdate" )
	net.Broadcast()

end
