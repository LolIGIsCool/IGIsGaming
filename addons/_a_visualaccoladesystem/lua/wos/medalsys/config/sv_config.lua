--[[-------------------------------------------------------------------
	Medal System Serverside Config File:
		Config file for the medal system all serverside
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
wOS.Medals.SQL = wOS.Medals.SQL or {}
wOS.Medals.Config = wOS.Medals.Config or {}

---------------------------------------------------------
----------------DO NOT EDIT ABOVE THIS LINE--------------
---------------------------------------------------------

---------------------------------------------------------
----------------------GENERAL SETTINGS-------------------
---------------------------------------------------------

-- Command used to open the interface
wOS.Medals.Config.OpenCommand = "!medals"

---------------------------------------------------------
------------------------SQL SETTINGS---------------------
---------------------------------------------------------

-- Whether to use mysqloo module or use text-based storage. Using mysqloo allows
-- cross server retrieval of medal information
wOS.Medals.SQL.MySQL = false

-- Server host for mysqloo database
wOS.Medals.SQL.Host = "localhost"

-- Server port for mysqloo database
wOS.Medals.SQL.Port = 3306

-- Database name for mysqloo database
wOS.Medals.SQL.Database = "wos-vas"

-- Username to log into mysqloo database
wOS.Medals.SQL.Username = "root"

-- Password to log into mysqloo database
wOS.Medals.SQL.Password = ""

-- The socket for the database. If you don't know what this is, don't touch it
wOS.Medals.SQL.Socket = ""