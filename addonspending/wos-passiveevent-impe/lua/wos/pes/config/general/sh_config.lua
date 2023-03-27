--[[-------------------------------------------------------------------]]--[[
							  
	Copyright wiltOS Technologies LLC, 2021
	
	Contact: www.wiltostech.com
		
----------------------------------------]]--


wOS = wOS or {}
wOS.PES = wOS.PES or {}
wOS.PES.Config = wOS.PES.Config or {}

// What user groups can create new events?
wOS.PES.Config.CreateEventUsersgroup = {
	["superadmin"] = true,
}

// How often should we roll for a random event to happen, if there are any on the server?
wOS.PES.Config.RandomInterval = 2400
