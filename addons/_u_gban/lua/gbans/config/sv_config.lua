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

	THIS IS WHERE YOU'RE GOING TO CUSTOMIZE HOW GBAN WORKS!
	FEEL FREE TO EDIT THIS FILE, AND FEEL FREE TO ASK QUESTIONS
	IF SOMETHING IS CONFUSING.

----------------------------------------]]--

if not gBan.Config then
	gBan.Config = {}
end

-- Your MySQL Connection info
gBan.Config.SQL = {

}

-- How long before we retry connecting to the database assuming we failed? IN SECONDS ( Def. 30 seconds )
gBan.Config.SQLRetry = 30

-- Enable this if you want gBan to log events into the console
gBan.Config.EnableLogging = true

-- API Key. This is now an integral part of the system and IS required. It's extremely easy to get one.
-- You can find your steam key at: https://steamcommunity.com/dev/apikey
gBan.Config.APIKey = "3DEBBF9FC570A1FDBEEF9DBE20499173"

-- Enable this if you want gBan to check family shared accounts for bans
-- This will NOT work without a steam API key above. Make sure you have one!
gBan.Config.SharedFamilyBan = false

-- Enable this if you want gBan to check the IP of a player for bans. Keep in mind this will ONLY work if the player was banned in the server and not through the steamID.
-- Keep in mind this will increase load on the server if you have a lot of banned players! You may also wrongfully ban players who play on public domains!
gBan.Config.IPBanning = true

-- Enable this if you want gBan to sync with TTT Karma bans
-- You should only have this enabled if you're hosting a TTT server ( duh )
gBan.Config.EnableTTT = false

-- Enable this if you want gBan to sync with CAKE Anti Cheat
-- Only enable this if you have !cake Anti Cheat installed, otherwise you will see errors!
gBan.Config.EnableCAC = false

-- Enable this if, for whatever reason, you don't want ULX Bans to be global across servers.
-- If this is enabled, you will have to use gBan's manual functions to ban globally.
-- Highly advise not enabling this unless you have a very, very, VERY particular reason for doing it.
gBan.Config.DisableULX = false

-- How often you want the server to refresh it's data from your database IN SECONDS ( Def. 300 seconds )
-- If you're experiencing server performance issues, increase this number to reduce strain on the server.
gBan.Config.RefreshRate = 180

-- The limit of how many entries an allocated table will contain when sent to the client. IE: A table of 500 will be split into 5 tables of 100 entries. ( Def. 100 entries )
-- This is mainly used for ban lists that are EXTREMELY LARGE to prevent high loads on the client
-- If you're experiencing server performance issues or NET errors, try LOWERING this number.
-- If you don't know what you're doing, it's better not to touch this :)
gBan.Config.EntryAllocation = 100

-- If your server is having instability while using gBans or you have a ban list of over 10,000 entries ( Wow! ) then
-- set this to true. It will delay the history being sent to the client until AFTER the bans are synced. Be aware that the
-- client will not immediately be able to open the ban menu with this delay.
gBan.Config.DelayHistory = false

-- This controls if a user has permission to ban someone
-- Higher the value, higher the priority
-- If a value is the same in two ranks, those two are matched with power and cannot ban one another
-- DO NOT ADD THE DEFAULT USERS HERE OR THEY WILL HAVE ACCESS TO ADMIN SETTINGS AND BAN PLAYERS
-- I REPEAT, DO NOT PUT DEFAULT USER GROUPS HERE! THIS IS HIERARCHY FOR PEOPLE WHO ARE ADMINS ONLY!
gBan.Config.Hierarchy = {
  ["Owner"] = 6,
  ["Founder"] = 5,
  ["Community Manager"] = 6,
  ["Community Event Manager"] = 5,  
  ["Server Manager"] = 5,
  ["Server Event Manager"] = 5,
  ["superadmin"] = 5,
  ["Advisor"] = 4,
  ["advisor"] = 4,
  ["Senior Admin"] = 4,
  ["admin"] = 3,
  ["Senior Moderator"] = 3,
  ["Moderator"] = 3,
  ["Junior Moderator"] = 3,
  ["Trial Moderator"] = 3,
  ["Lead Event Master"] = 4,
  ["Senior Event Master"] = 3,
  ["Event Master"] = 3,
  ["Junior Event Master"] = 3,
  ["Trial Event Master"] = 3,
  ["Junior Event Master"] = 3,
  ["Community Developer"] = 3,
  ["Senior Developer"] = 3,
  ["Developer"] = 3,
}

-- The color of gBan tags in chat. If you don't like the color red, change it up!
gBan.Config.IDColor = Color( 69, 120, 190 )

-- If you don't know how to edit this and you're using ulx, keep it the same.
gBan.Config.CanBan = function( ply, vic )

	if not gBan.Config.Hierarchy[ ply:GetNWString( "usergroup" ) ] then return false end

	if gBan.Config.Hierarchy[ ply:GetNWString("usergroup") ] >= ( gBan.Config.Hierarchy[ vic:GetNWString( "usergroup" ) ] or 0 ) then return true end

	return false

end
