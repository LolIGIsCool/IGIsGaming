--[[-------------------------------------------------------------------
	Medal System Item Registry:
		The place for the functions for registering medals
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
wOS.Medals.Badges = wOS.Medals.Badges or {}

local SortedBadges = SortedBadges or {}

function wOS.Medals:RegisterMedal( DATA )

	self.Badges[ DATA.Name ] = DATA
	
	SortedBadges[DATA.Name] = {}
	SortedBadges[DATA.Name].Name = DATA.Name
	SortedBadges[DATA.Name].Description = DATA.Description
	SortedBadges[DATA.Name].Model = DATA.Model
	SortedBadges[DATA.Name].Skin = DATA.Skin or 0
	SortedBadges[DATA.Name].OffsetAngle = DATA.OffsetAngle
	
	print("[wOS-Medals] Successfully registered: " .. DATA.Name )
	
end

---------------------------------------------------------
-------------------------ADD MEDALS----------------------
---------------------------------------------------------
hook.Add( "PlayerInitialSpawn", "wOS.Medals.SendAllBadges", function( ply )
	net.Start( "wOS.Medals.Badges.SendAllBadges" )
		net.WriteTable( SortedBadges )
	net.Send( ply )
end )