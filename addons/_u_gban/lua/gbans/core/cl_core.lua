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
	File Information: The client core file. Just as important, although I'm only using it for one thing
	
----------------------------------------]]--

-- You may be wondering: why the hell do we need this ONE hook? Well, sometimes CheckPassword's hook isn't fast enough to kick the player if they're banned.
-- Not only that, but I've gotten reports that some addons are conflicting with CheckPassword's hook, and as a result don't even call the function.
-- This little think is going to run a command to check if the client is banned when they load.
	
hook.Add( "Think", "gBan.FailSafe", function()

	LocalPlayer():ConCommand( "gban_doublecheck" )
	hook.Remove( "Think", "gBan.FailSafe" )

end )