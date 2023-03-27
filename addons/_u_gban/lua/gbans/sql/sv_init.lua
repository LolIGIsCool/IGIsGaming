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
	
	File Information: This is the SQL Wrapper and initialization file for our SQL connections.
		Without this file we can't connect to the database. At least not pretty. Make sure your
			SQL details are entered in the config file!
----------------------------------------]]--

require( 'tmysql4' )

gBan.ConnectAttempts = 1
gBan.Connected = false
gBan.DB, gBan.error = tmysql.initialize( gBan.Config.SQL.Host, gBan.Config.SQL.Username, gBan.Config.SQL.Password, gBan.Config.SQL.Database, gBan.Config.SQL.Port or 3306 )

function gBan:Connect()
	print( "[gBan] Attempting database connection!" )

	if self.ConnectAttempts > 1 then
		print( "[gBan] Attempting to connect to database ( " .. self.ConnectAttempts .. " ) " )
	end
	
	if self.DB then
		self.Connected = true
		print( "[gBan] Connected to gBans database!" )
		self:Query( [[ CREATE TABLE IF NOT EXISTS gban_history(target varchar(30) NOT NULL, target_id varchar(30) NOT NULL, target_uniqueid varchar(255) NOT NULL, target_ip varchar(30) NOT NULL, admin varchar(30) NOT NULL, admin_id varchar(30) NOT NULL, reason text NOT NULL, date_banned int(20) NOT NULL, state int(1), unbanned_by varchar(30) NULL, unbanned_date int(20) NULL, server_id int(2) NOT NULL, id int(6) NOT NULL AUTO_INCREMENT, PRIMARY KEY(id))]] )
		self:Query( [[ CREATE TABLE IF NOT EXISTS gban_list(target varchar(30) NOT NULL, target_id varchar(30) NOT NULL, target_uniqueid varchar(255) NOT NULL, target_ip varchar(30) NOT NULL, admin varchar(30) NOT NULL, admin_id varchar(30) NOT NULL, reason text NOT NULL, date int(20) NOT NULL, length int(10) NOT NULL, server_id int(2) NOT NULL, PRIMARY KEY(target_id))]] )
		self:Query( [[ CREATE TABLE IF NOT EXISTS gban_serverlist(id int(2) AUTO_INCREMENT, host varchar(20) NOT NULL, name text NOT NULL, PRIMARY KEY(id))]] )
		self:Query( [[ ALTER TABLE `gban_history` ADD COLUMN `target_uniqueid` VARCHAR(255) NOT NULL AFTER `target_id`]] )
		self:Query( [[ ALTER TABLE `gban_list` ADD COLUMN `target_uniqueid` VARCHAR(255) NOT NULL AFTER `target_id`]] )
		self:Query( [[ ALTER TABLE 'gban_history' CONVERT TO CHARACTER SET utf8 COLLATE utf8_general_ci ]] )
		self:Query( [[ ALTER TABLE 'gban_list' CONVERT TO CHARACTER SET utf8 COLLATE utf8_general_ci ]] )
		self:Query( [[ ALTER TABLE 'gban_serverlist' CONVERT TO CHARACTER SET utf8 COLLATE utf8_general_ci ]] )
		self:GetData()
	elseif self.error then
		print( "[gBan] Could not connect to database! Connection will be attempted again in " .. self.Config.SQLRetry .. " seconds" )
		self.ConnectAttempts = self.ConnectAttempts + 1
		timer.Simple( self.Config.SQLRetry, function() self:Connect() end)
	end
	
end

function gBan:Escape( val )

	if self.Connected then
		return self.DB:Escape( val )
	else
		return val
	end
	
end

function gBan:Query( query, callback, id )

	if not self.Connected then
		local text = "[gBan] Failed to perform query: No connection to the database!"
		if id then
			text = text .. " Called query: " .. id
		end
		print( text )
		return
	end

	self.DB:Query( [[ SET CHARACTER SET utf8 ]] )
	return self.DB:Query( query, function( info )
		if callback then
			callback( info[1].data )
		end
	end )
	
end

function gBan:GetData()

	local function ObtainBans( data )
		print("[gBan] Retrieving bans...")
		gBan.Bans = {}
		for _,info in pairs( data ) do
			if not info.target_uniqueid or string.len( info.target_uniqueid ) < 1 then 
				info.target_uniqueid = util.SteamIDTo64( info.target_id ) 
			end
			gBan.Bans[ info.target_uniqueid ] = {name = info.target, steamid = info.target_id, uniqueid = info.target_uniqueid, ipaddress = info.ip, admin = info.admin, admin_id = info.admin_id, reason = info.reason, date = info.date, length = info.length, server = info.server_id}
		end
	end
	
	local function ObtainHistory( data )
		print("[gBan] Retrieving history...")
		gBan.History = {}
		for _,info in pairs( data ) do
			if not info.target_uniqueid or string.len( info.target_uniqueid ) < 1 then 
				info.target_uniqueid = util.SteamIDTo64( info.target_id ) 
			end
			local num = #gBan.History + 1
			gBan.History[ num ] = { name = info.target, steamid = info.target_id, uniqueid = info.target_uniqueid, ipaddress = info.ip, admin = info.admin, admin_id = info.admin_id, reason = info.reason, date_banned = info.date_banned, state = info.state, unbanned_by = info.unbanned_by, server = info.server_id }
			if info.unbanned_date then
				gBan.History[ num ].unbanned_date = info.unbanned_date
			end
		end
	end
	
	local function ObtainID( data )
		print("[gBan] Retrieving obtaining ID...")
		if data and #data > 0 then
			gBan.ID = data[1].id
		else
			gBan:Query( [[ SELECT COUNT(*) FROM gban_serverlist ]], function( results )
				gBan.ID = results[1][ "COUNT(*)" ] + 1
			end )
			
			gBan:Query( [[INSERT INTO gban_serverlist(host, name) VALUES(']] .. gBan:ServerIP() .. [[', ']] .. gBan:Escape( GetHostName() ) .. [[')]] )
		end
	end
	
	local query = [[ SELECT * FROM gban_list ]]
	local id = "Download active bans"

	self:Query( query, ObtainBans, id )
	
	query = [[ SELECT * from gban_history ]]
	id = "Download ban history"
	
	self:Query( query, ObtainHistory, id )
	
	if gBan.ID then return end
	query = [[ SELECT * FROM gban_serverlist WHERE host = ']] .. gBan:ServerIP() .. [[']]
	id = "Download server ID"
	
	self:Query( query, ObtainID, id )
	
end

