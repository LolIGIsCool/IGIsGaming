--[[-------------------------------------------------------------------
	Medal System Shared Config File:
		Shared Config file for the medal system
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
wOS.Medals.Config = wOS.Medals.Config or {}

---------------------------------------------------------
----------------DO NOT EDIT ABOVE THIS LINE--------------
---------------------------------------------------------

---------------------------------------------------------
---------------------GENERAL SETTINGS--------------------
---------------------------------------------------------

-- This bool controls whether the interface shows all the player information at
-- the bottom left
wOS.Medals.Config.playerInformation = true

-- Controls whether to show the players money on the information
wOS.Medals.Config.playerMoney = false

-- Controls whether to show the players salary on the information
wOS.Medals.Config.playerSalary = false

---------------------------------------------------------
-----------------------RANK SETTINGS---------------------
---------------------------------------------------------

// Add ULX ranks that should be able to access awarding and revoking medals
// You should use the EXACT ULX group
wOS.Medals.Config.AllowedULX = {
	"superadmin",
	"Senior Developer",
	"admin",
	"Advisor",
	"Lead Event Master"
}

---------------------------------------------------------
-------------------COLOUR SCHEME SETTINGS----------------
---------------------------------------------------------
-- I personally think the colour scheme looks dope. But might as well give you the functionality...

-- Change the colour of the grey panel background
wOS.Medals.Config.BackgroundPanelClr = Color( 215, 222, 229, 150 )

-- Change the colour of the buttons when they are not hovered
wOS.Medals.Config.NormalButtonClr = Color( 65, 116, 175, 255 )

-- Change the colour of the buttons when they are hovered over
wOS.Medals.Config.HoverButtonClr = Color( 56, 101, 153, 255 )

-- Change the colour of the text inside buttons
wOS.Medals.Config.ButtonTxtClr = color_white

-- Change the colour of the list headers
wOS.Medals.Config.ListHeaderClr = Color( 65, 116, 175, 255 )

-- Change the text colour of the list headers
wOS.Medals.Config.ListHeaderTxtClr = color_white

-- The colour of the descriptive writing on the interface. 
--E.g. the description of medals
wOS.Medals.Config.LabelTxtClr = color_white

-- Changes the primary colour of the alerts in chat
wOS.Medals.Config.ChatAlertPrimaryClr = Color(66, 134, 244, 255)

-- Changes the secondary colour of the alerts in chat
wOS.Medals.Config.ChatAlertSecondaryClr = Color(255,255,255,255)

-- Changes the font of all the labels + buttons etc... check this link for default fonts
-- http://wiki.garrysmod.com/page/Default_Fonts
wOS.Medals.Config.ItfText = "DermaDefaultBold"

---------------------------------------------------------
-----------------------END OF CONFIG---------------------
---------------------------------------------------------