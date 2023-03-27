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
	
	File Information: This file automatically searches and includes files
		based on prefixes. Helps us for organizational purposes.
		
----------------------------------------]]--

local string = string
local file = file

local function _AddCSLuaFile( lua )

	if SERVER then
		AddCSLuaFile( lua )
	end
	
end

local function _include( load_type, lua )

	if load_type then
		include( lua )
		print( "[gBan] Successfully loaded file: " .. lua )
	end
	
end

function wOS:Autoloader()
	print( "[gBan] Loading files.." )
	local _,paths = file.Find( "gbans/*", "LUA")
	for __,folder in pairs( paths ) do
		for _,source in pairs( file.Find( "gbans/" .. folder .."/*.lua", "LUA"), true ) do
	
			local lua = "gbans/" .. folder .. "/" .. source
			
			if string.sub( source, 1, 3 ) == "sh_" then
				_AddCSLuaFile( lua )
				_include( SERVER, lua )
				_include( CLIENT, lua )
			elseif string.sub( source, 1, 3 ) == "cl_" then
				_AddCSLuaFile( lua )
				_include( CLIENT, lua )
			elseif string.sub( source, 1, 3 ) == "sv_" then
				_include( SERVER, lua )
			end
		
		end
	end
	
end

wOS:Autoloader()