--[[-------------------------------------------------------------------
	Medal System Main Loader:
		The super main loader for this addon
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

local root = "wos/medalsys"

if SERVER then	
	AddCSLuaFile( root .. "/core/cl_net.lua" )
	AddCSLuaFile( root .. "/core/cl_derma.lua" )
	AddCSLuaFile( root .. "/core/cl_core.lua" )
	AddCSLuaFile( root .. "/config/sh_config.lua" )
	include( root .. "/config/sv_config.lua" )
end

include( root .. "/config/sh_config.lua" )

if SERVER then

	include( root .. "/core/sv_core.lua" )
	include( root .. "/core/sv_net.lua" )
	include( root .. "/core/sv_item_registry.lua" )
	include( root .. "/core/sv_medal_register.lua" )
	
	if wOS.Medals.SQL.MySQL then
		include( root .. "/mysqloo/sv_mysqloo_funcs.lua" )
		include( root .. "/wrappers/medal_mysql.lua" )	
	else
		include( root .. "/wrappers/medal_data.lua" )		
	end
	
else

	include( root .. "/core/cl_core.lua" )
	include( root .. "/core/cl_net.lua" )
	include( root .. "/core/cl_derma.lua" )

end