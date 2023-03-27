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

	File Information: You can import bans from your ULX list with this. Just make sure you enable it with the settings below.
----------------------------------------]]--

-- Set to true to enable the command
gBan.Config.EnableConversionCommand = true

-- Set your password for the command here. DO NOT LEAVE IT DEFAULT.
gBan.Config.ConversionPassword = "m_conv3pptoeOe333"

if not gBan.Config.EnableConversionCommand then return end

local Bans = 0;

function gBan:ConvertBan( steamid, nick, csteamid, time, reason, date )

	--print("Convert Ban Started")
	--print("SteamID check 1 = " .. steamid)
	local steam64 = util.SteamIDTo64( steamid )
	if self.Bans[ steam64 ] and not edit then return "steamid.duplicate" end
	--print("SteamID check 2 = " .. steamid)
	
	if not date then
		date = "1451606400"
	end
	
	local current_time = date or os.time()
	local ftime = time
	local time = ( time == 0 and 0 ) or current_time + time
	--print("SteamID check 3 = " .. steamid)
	if not nick then
		nick = "CONSOLE"
	end

	if not csteamid then
		csteamid = "CONSOLE"
	end
	
	if csteamid == "Consol" then
		csteamid = "CONSOLE"
	end
	
	if not reason then
		reason = "No metadata"
	end
	
	--print("SteamID check 4 = " .. steamid)
	local addToList = [[ INSERT INTO gban_list(target, target_id, target_uniqueid, target_ip, admin, admin_id, reason, date, length, server_id) VALUES('%s', '%s', '%s', '%s', '%s', '%s', '%s', '%s', '%s', '%s') ON DUPLICATE KEY UPDATE target_id=target_id ]]
	local addToHistory = [[ INSERT INTO gban_history(target, target_id, target_uniqueid, target_ip, admin, admin_id, reason, date_banned, state, unbanned_by, unbanned_date, server_id) VALUES('%s', '%s', '%s', '%s', '%s', '%s', '%s', '%s', '%s', '%s', '%s', '%s') ON DUPLICATE KEY UPDATE target_id=target_id ]]
	--print("SteamID check 5 = " .. steamid)
	http.Fetch("http://api.steampowered.com/ISteamUser/GetPlayerSummaries/v0002/?key=" .. self.Config.APIKey .. "&steamids=" .. steam64,
		function(body, len, headers, code)
			local playerinfo = util.JSONToTable(body)["response"]["players"][1]
			if not playerinfo then
				self:AddChatMessage( caller, self:Translate( "NonExist", self.Config.Language ) )
				return
			end
			--print("SteamID check 6 = " .. steamid)
			--print("Personaname = " .. playerinfo.personaname)
			--print("SteamID = " .. steamid)
			--print("SteamID64 = " .. steam64)
			--print("Nick = " .. nick)
			--print("CSteamID = " .. csteamid)
			--print("Reason = " .. reason)
			--print("Current Time = " .. current_time)
			--print("Time = " .. time)
			--print("SelfID = " .. self.ID)
			self:Query( addToList:format( self:Escape( playerinfo.personaname ), self:Escape( steamid ), self:Escape( steam64 ), "0.0.0.0", self:Escape( nick ), self:Escape( csteamid ), self:Escape( reason ), self:Escape( tostring( current_time ) ), self:Escape( tostring( time ) ), self.ID ))
			self:Query( addToHistory:format( self:Escape( playerinfo.personaname ), self:Escape( steamid ), self:Escape( steam64 ), "0.0.0.0", self:Escape( nick ), self:Escape( csteamid ), self:Escape( reason ), self:Escape( tostring( current_time ) ), ( time == 0 and "2" ) or "1", (time == 0 and "" or nick), self:Escape(tostring(time)), self.ID))
			self.Bans[ steam64 ] = { name = playerinfo.personaname, steamid = steamid, uniqueid = steam64, ipaddress = "0.0.0.0", admin = nick, admin_id = csteamid, reason = reason, date = current_time, length = time, server = self.ID }
			self.History[ #self.History + 1 ] = { name = playerinfo.personaname, steamid = steamid, uniqueid = steam64, ipaddress = "0.0.0.0", admin = nick, admin_id = csteamid, reason = reason, date_banned = current_time, state = (time == 0 and 2 or 1), unbanned_by = (time == 0 and "" or nick), unbanned_date = (time == 0 and 0 or length), server = gBan.ID}
			if not gBan.Config.EnableLogging then return end
			local text = gBan:Translate( "LogBan", gBan.Config.Language )
			text = text:Replace( "{name}", playerinfo.personaname )
			text = text:Replace( "{steamid}", csteamid )
			text = text:Replace( "{time}", tostring( ftime/60 ) )
			text = text:Replace( "{reason}", reason )
			print( "[gBan] (LOG) " .. text )
		end,
		function( error )
			print( "[gBan] Error banning '" .. steamid .. "' (" .. error .. ")" )
			print( "[gBan] " .. self:Translate( "APIKey", self.Config.Language ) )
		end	)

	net.Start( "gBan.AlertUpdate" )
	net.Broadcast()

	Bans = Bans + 1
end

function gBan:ImportULX()
	print("[gBan] Initializing ULX import..");
	for k, v in pairs( ULib.bans ) do
		--print(v.admin)
		if v.admin == nil then v.admin = "Admin not found" end

		--print("nig")
		local Admin = string.Explode( "(", v.admin )
		--print("Hello")
		local AdminName = Admin[1]
		--print(string.sub(Admin[2],1) or "Admin[2] not found" )
		if Admin[2] == nil then Admin[2] = "Console" end
		local AdminSteamID = string.sub(Admin[2],1,string.len(Admin[2]) -1)
		--print("1")
		local time
		local date = v.time
		--print("2")
		--print(v.unban)
		if v.unban == "0" then
			--print("boi1")
			time = 0
		else
			--print("boi2")
			--print(v.unban)
			--print(v.admin)
			time = -1*( date - v.unban )
		end
		--print("3")
		--print(time)
		if time < 0 then continue end
		--print("4")
		--print("Got to convertban")
		--print("K = " .. k )
		self:ConvertBan( k, AdminName, AdminSteamID, time, v.reason, date );
	end

	print('[gBan] Total Bans Converted: '..Bans );
	print('[gBan] Command disabled for current session. Disable the command in file for the future.');
	self.Config.EnableConversionCommand = false
end

concommand.Add( "gban_importulx", function( ply, cmd, args )

	if not gBan.Config.Hierarchy[ ply:GetUserGroup() ] then
		gBan:AddChatMessage( ply, gBan:Translate( "NoAccess", gBan.Config.Language ) )
		return
	end

	if not gBan.Config.EnableConversionCommand then
		gBan:AddChatMessage( ply, "This command has been disabled!" )
		return
	end

	local password = args[1]

	if password != gBan.Config.ConversionPassword then
		gBan:AddChatMessage( ply, "Invalid import password!" )
		return
	end

	gBan:ImportULX()

end )
