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
	
	File Information: This module should hopefully allow CAC to integrate with gBan. You can enable/disable this in the config
		
----------------------------------------]]--

local self = {}
CAC.gBansBanSystem = CAC.MakeConstructor (self, CAC.BanSystem)

function self:ctor ()
end

-- IReadOnlyBanSystem
function self:GetId ()
	return "gBansBanSystem"
end

function self:GetName ()
	return "gBan"
end

function self:IsAvailable ()
	return istable (gBan)
end

-- IBanSystem
function self:Ban (target, time, reason, bannerId)

	time = time/60
	if time == math.huge then time = 0 end
	local banner = CAC.PlayerMonitor:GetUserEntity (bannerId) or nil -- In our cases, NIL will inicate it was a console ban and not a player.
	gBan:PlayerBanID( banner, target, time, reason )
	
end

function self:CanBanOfflineUsers ()
	return true
end

CAC.SystemRegistry:RegisterSystem ("BanSystem", CAC.gBansBanSystem ())