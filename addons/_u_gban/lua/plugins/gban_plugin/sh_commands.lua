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
	
	File Information: This plugin will allow gBan to become usable through the serverguard menu. 
		Finally, serverguard support!
		
----------------------------------------]]--


--
-- The ban command.
--

local command = {};

command.help				= "Globally ban a player from all servers.";
command.command 			= "globalban";
command.arguments 			= {"player", "length"};
command.optionalArguments	= {"reason"};
command.permissions 		= {"Ban", "Permaban"};

function command:Execute(player, silent, arguments)

	local target, length, reason = arguments[1], arguments[2], table.concat( arguments, " ", 3 )
	
	if (target and length) then
		if CLIENT then	--Just had to include the client just in case. I'm not really sure how serverguard treats these
			net.Start( "gBan.BanBuffer" )
				net.WriteBool( false )
				net.WriteInt( length )
				net.WriteString( reason )
				net.WriteEntity( player )
			net.SendToServer()
		else
			GBAN_PLAYER( player, target, length, reason )
		end
	end
	
end;

function command:ContextMenu(player, menu, rankData)
	local banMenu, menuOption = menu:AddSubMenu("Globally Ban Player");
	
	banMenu:SetSkin("serverguard");
	menuOption:SetImage("icon16/delete.png");
	
	for k, v in pairs(serverguard.banLengths) do
		local option = banMenu:AddOption(v[1], function()
			Derma_StringRequest("Ban Reason", "Specify ban reason.", "", function(text)
				serverguard.command.Run("ban", false, player:Name(), v[2], text);
			end, function(text) end, "Accept", "Cancel");
		end);
		
		option:SetImage("icon16/clock.png");
	end;

	local option = banMenu:AddOption("Custom", function()
		Derma_StringRequest("Ban Length", "Specify ban length in minutes.", "", function(length)
			Derma_StringRequest("Ban Reason", "Specify ban reason.", "", function(text)
				serverguard.command.Run("ban", false, player:Name(), tonumber(length), text);
			end);
		end, function(text) end, "Accept", "Cancel");
	end);
		
	option:SetImage("icon16/clock.png");
end;

serverguard.command:Add(command);

--
-- The unban command.
--

local command = {};

command.help				= "Globally unban a player. ( Must have been globally banned )";
command.command 			= "globalunban";
command.arguments 			= {"steamid"};
command.permissions 		= {"Unban"};

function command:Execute(player, silent, arguments)
	local steamID = arguments[1];
	local steam64 = util.SteamIDTo64( steamID )
	if SERVER then
		if not gBan.Bans[ steam64 ] then
			gBan:AddChatMessage( player, gBan:Translate( "NotBanned", gBan.Config.Language ) )
		else
			gBan:AddChatMessage( player, gBan:Translate( "BanBuffer", gBan.Config.Language ) )
			gBan:PlayerUnban( player, steam64 )
		end;
	else
		net.Start( "gBan.UnBanBuffer" )
			net.WriteString( steam64 )
		net.SendToServer()
	end
end;

serverguard.command:Add(command);