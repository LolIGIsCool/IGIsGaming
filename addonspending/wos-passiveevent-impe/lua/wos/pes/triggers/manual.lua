--[[-------------------------------------------------------------------]]--[[
							  
	Copyright wiltOS Technologies LLC, 2021
	
	Contact: www.wiltostech.com
		
----------------------------------------]]--



local trigger = {}

trigger.Name = "Manual"

trigger.IsValid = function(subEvent)
    return subEvent:GetVar("AdminComplete", false)
end

trigger.Hooks = {
    ["PlayerSay"] = function(subEvent, ply, txt, teamOnly)
        if ply:IsAdmin() then
            if txt == "!event complete" then
                subEvent:SetVar("AdminComplete", true)
                return true
            end
        end
    end,
}

trigger.Vars = {
    {
        Name = "AdminComplete",
        Description = "",
        Type = "Boolean",
        Default = false,
        Internal = true,
    }
}

return trigger
