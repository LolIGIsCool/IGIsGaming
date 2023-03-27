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

-- This is where you set the default language for your gBans.
-- You can add your own language by going to the wOS-languages folder and copying the format.
-- If you'd like to help translations, visit the gBans github and submit there!
gBan.Config.Language = "English"
gBan.SelectedLanguage = gBan.Config.Language