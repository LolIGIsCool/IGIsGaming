--[[-------------------------------------------------------------------
	Medal System Loader:
		The main loader for this addon
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
							  
	Copyright wiltOS Technologies LLC, 2018
	
	Contact: www.wiltostech.com
		
----------------------------------------]]--

wOS = wOS or {}
wOS.Medals = wOS.Medals or {}

if SERVER then
	AddCSLuaFile( "wos/medalsys/loader/loader.lua" )
end

include( "wos/medalsys/loader/loader.lua" )
