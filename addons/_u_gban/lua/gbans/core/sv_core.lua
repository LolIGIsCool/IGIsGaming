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
	File Information: The core file! Protect the core! It's how gBans is gBans.
	
----------------------------------------]]--

util.AddNetworkString( "gBan.Message" )

gBan.Bans = {}
gBan.History = {}

function gBan:AddChatMessage( ply, ... )
	local text = ""
	
	if not ply then
		for k, v in pairs( {...} ) do
			if type( v ) == "string" then
				text = text .. v
			end
		end
		print( text )
	end
	
	local message = { Color(200, 200, 200), "[", gBan.Config.IDColor, "gBan", Color(200, 200, 200), "] ", color_white, ... }
	net.Start( "gBan.Message" )
	net.WriteTable( message )
	
	if ply then 
		net.Send( ply )
	else 
		net.Broadcast() 
	end
	
end

function gBan:ValidSteamID( steamid )

	return steamid:match( "^STEAM_%d:%d:%d+$" ) != nil
	
end

function gBan:ValidSteamID64( steam64 )

	return self:ValidSteamID( util.SteamIDFrom64( steam64 ) )

end

-- ServerIP
function gBan:ServerIP()

	return game.GetIPAddress() 
	
end

function gBan:AllowedToPlay( steam64, init, ply )

	local entry = self.Bans[ steam64 ]
	if not entry then return end
	if init then
		if entry.length != 0 and entry.length < os.time() then
			self:Query([[DELETE FROM gban_list WHERE target_id = ']] .. entry.steamid .. [[']])
			self:Query([[UPDATE gban_history SET state = '3' WHERE target_id = ']] .. entry.steamid .. [[' AND date_banned = ']] .. entry.date .. [[']])
			self.Bans[ steam64 ] = nil
			return 
		end	
		
		local message = self:Translate( "BanMessage", self.Config.Language )
		message = message:Replace("{admin}", entry.admin)
		message = message:Replace("{reason}", entry.reason)
		message = message:Replace("{date_banned}", os.date("%d/%m/%Y @ %X", entry.date))
		message = message:Replace("{unban_date}", entry.length == 0 and "Never" or os.date("%d/%m/%Y @ %X", entry.length))
		
		local consolemessage = self:Translate( "ConsoleMessage", self.Config.Language )
		consolemessage:Replace( "{name}", entry.name )
		consolemessage:Replace( "{steamid}", entry.steamid )
		print("[gBan] " .. consolemessage )
		hook.Call( "gBan.OnConnectionDenied", nil, entry, false, false )
		return false, message
	else
		if entry then
			if IsValid( ply ) then
				local message = self:Translate( "BanMessage", self.Config.Language )
				message = message:Replace("{admin}", entry.admin)
				message = message:Replace("{reason}", entry.reason)
				message = message:Replace("{date_banned}", os.date("%d/%m/%Y @ %X", entry.date))
				message = message:Replace("{unban_date}", entry.length == 0 and "Never" or os.date("%d/%m/%Y @ %X", entry.length))
				
				local consolemessage = self:Translate( "ConsoleMessage", self.Config.Language )
				consolemessage:Replace( "{name}", entry.name )
				consolemessage:Replace( "{steamid}", entry.steamid )
				print("[gBan] " .. consolemessage )
				print(ply:Nick())
				print(ply:SteamID())
				ply:Kick( message )
				return
			end
		end
	end
	
	if self.Config.IPBanning then
		local check, pip = false, ply:IPAddress()
		local pp = 1
		for ck, data in pairs( self.Bans ) do
			if data.ipaddress == pip then
				check = true
				pp = ck
				break
			end
		end
		if check then
			entry = self.Bans[ pp ]
			if init then
				local message = self:Translate( "BanMessage", self.Config.Language )
				message = message:Replace("{admin}", entry.admin)
				message = message:Replace("{reason}", entry.reason)
				message = message:Replace("{date_banned}", os.date("%d/%m/%Y @ %X", entry.date))
				message = message:Replace("{unban_date}", entry.length == 0 and "Never" or os.date("%d/%m/%Y @ %X", entry.length) )	

				local consolemessage = self:Translate( "ConsoleMessage", self.Config.Language )
				consolemessage:Replace( "{name}", ply:Nick() )
				consolemessage:Replace( "{steamid}", ply:SteamID() )
				print("[gBan] " .. consolemessage )
				hook.Call( "gBan.OnConnectionDenied", nil, entry, false, true )
				return false, message
			else
				local message = self:Translate( "BanMessage", self.Config.Language )
				message = message:Replace("{admin}", entry.admin)
				message = message:Replace("{reason}", entry.reason)
				message = message:Replace("{date_banned}", os.date("%d/%m/%Y @ %X", entry.date))
				message = message:Replace("{unban_date}", entry.length == 0 and "Never" or os.date("%d/%m/%Y @ %X", entry.length) )	

				local consolemessage = self:Translate( "ConsoleMessage", self.Config.Language )
				consolemessage:Replace( "{name}", ply:Nick() )
				consolemessage:Replace( "{steamid}", ply:SteamID() )
				print("[gBan] " .. consolemessage )
				ply:Kick( message )	
			end
		end
	end
	
	if self.Config.SharedFamilyBan then
		local familytroll, id = self:FamilyShareCheck( steam64 )
		if familytroll then
			entry = self.Bans[ id ]
			if entry.length != 0 and entry.length < os.time() then
				self:Query( [[DELETE FROM gban_list WHERE target_id = ']] .. entry.steamid .. [[']])
				self:Query( [[UPDATE gban_history SET state = '3' WHERE target_id = ']] .. entry.steamid .. [[' AND date_banned = ']] .. entry.date .. [[']])
				self.Bans[ id ] = nil
				return 
			end	
			if init then
				local message = self:Translate( "BanMessage", self.Config.Language )
				message = message:Replace("{admin}", entry.admin)
				message = message:Replace("{reason}", entry.reason)
				message = message:Replace("{date_banned}", os.date("%d/%m/%Y @ %X", entry.date))
				message = message:Replace("{unban_date}", entry.length == 0 and "Never" or os.date("%d/%m/%Y @ %X", entry.length) )	

				local consolemessage = self:Translate( "FamilyConsoleMessage", self.Config.Language )
				consolemessage:Replace( "{name}", entry.name )
				consolemessage:Replace( "{steamid}", entry.steamid )
				print("[gBan] " .. consolemessage )
				hook.Call( "gBan.OnConnectionDenied", nil, entry, steam64, false )
				return false, message
			else
				local message = self:Translate( "BanMessage", self.Config.Language )
				message = message:Replace("{admin}", entry.admin)
				message = message:Replace("{reason}", entry.reason)
				message = message:Replace("{date_banned}", os.date("%d/%m/%Y @ %X", entry.date))
				message = message:Replace("{unban_date}", entry.length == 0 and "Never" or os.date("%d/%m/%Y @ %X", entry.length) )	

				local consolemessage = self:Translate( "FamilyConsoleMessage", self.Config.Language )
				consolemessage:Replace( "{name}", entry.name )
				consolemessage:Replace( "{steamid}", entry.steamid )
				print("[gBan] " .. consolemessage )
				ply:Kick( message )	
			end
		end
	end
	
end

hook.Add( "CheckPassword", "gBan.BanMsg", function( steam64, _, _, _, _ )
	return gBan:AllowedToPlay( steam64, true )
end )

hook.Add( "Initialize", "gBan.Initialize", function()
	gBan:Connect()
	timer.Create( "gBan.RefreshData", gBan.Config.RefreshRate, 0, function() 
		gBan:GetData() 
		timer.Simple( 2, function() 		
			for _, ply in pairs( player.GetAll() ) do
				gBan:AllowedToPlay( ply:SteamID64(), false, ply )
			end
		end )
		net.Start( "gBan.AlertUpdate" )
		net.Broadcast()
	end )
end )

concommand.Add("gbanmanualinit", function()
	gBan:Connect()
	timer.Create( "gBan.RefreshData", gBan.Config.RefreshRate, 0, function() 
		gBan:GetData() 
		timer.Simple( 2, function() 		
			for _, ply in pairs( player.GetAll() ) do
				gBan:AllowedToPlay( ply:SteamID64(), false, ply )
			end
		end )
		net.Start( "gBan.AlertUpdate" )
		net.Broadcast()
	end )
end)

hook.Add( "IGPlayerSay", "gBan.OpenVGUI", function( ply, text )
	
	if text:lower() == "!gmenu" then	
		if not gBan.Config.Hierarchy[ ply:GetUserGroup() ] then 
			gBan:AddChatMessage( ply, gBan:Translate( "NoAccess", gBan.Config.Language ) )
			return
		end
		if not ply.MenuCooldown then
			ply.MenuCooldown = CurTime() - 1
		end
		if ply.MenuCooldown < CurTime() then
			gBan:SyncData( ply )
			ply.MenuCooldown = CurTime() + 1
		else
			gBan:AddChatMessage( ply, gBan:Translate( "MenuCooldown", gBan.Config.Language ) )
		end
		return ""
	end
	
end )

concommand.Add( "gban_information", function()
	print( "[gBan] You are currently using [Version 2.0]" )
	print( "" )
	print( "[gBan] Diagnostic information about modules: " )
	print( "[gBan] Console Logging: " .. tostring( gBan.Config.EnableTTT ) )	
	print( "[gBan] TTT Hook: " .. tostring( gBan.Config.EnableTTT ) )
	print( "[gBan] CAC Hook: " .. tostring( gBan.Config.EnableCAC ) )
	print( "[gBan] Family Shared Bans: " .. tostring( gBan.Config.SharedFamilyBan ) )
	print( "" )
	print( "[gBan] Diagnostic information about userdata:" )
	print( "[gBan] Size of Ban List: " .. table.Count( gBan.Bans ) )
	print( "[gBan] Size of History: " .. table.Count( gBan.History ) )	
	print( "[gBan] Table Allocation Limit: " .. gBan.Config.EntryAllocation )
	print( "[gBan] Delayed History Transmission: " .. tostring( gBan.Config.DelayHistory ) )
	
	if string.len( gBan.Config.APIKey ) < 1 then
		print( "[gBan] You have no Steam API Key in your config. Some functions will not be working properly." )
	end
	
end )

concommand.Add( "gban_doublecheck", function( ply, _, _, _ )
	gBan:AllowedToPlay( ply:SteamID64(), false, ply )
end )

concommand.Add( "gban_menu", function( ply, _, _, _ )
	if not gBan.Config.Hierarchy[ ply:GetUserGroup() ] then 
		gBan:AddChatMessage( ply, gBan:Translate( "NoAccess", gBan.Config.Language ) )
		return
	end
	if not ply.MenuCooldown then
		ply.MenuCooldown = CurTime() - 1
	end
	if ply.MenuCooldown < CurTime() then
		gBan:SyncData( ply )
		ply.MenuCooldown = CurTime() + 1
	else
		gBan:AddChatMessage( ply, gBan:Translate( "MenuCooldown", gBan.Config.Language ) )
	end
end )