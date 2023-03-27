--[[-------------------------------------------------------------------]]--[[
							  
	Copyright wiltOS Technologies LLC, 2021
	
	Contact: www.wiltostech.com
		
----------------------------------------]]--



local trigger = {}

trigger.Name = "SubEvent"

trigger.IsValid = function(subEvent)
    return subEvent:GetVar("SubEvent.Finished", false)
end

trigger.Vars = {
    {
        Name = "SubEvent.Finished",
        Description = "",
        Type = "Boolean",
        Default = false,
        Internal = true,
    }
}

return trigger
