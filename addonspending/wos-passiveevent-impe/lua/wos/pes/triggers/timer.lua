--[[-------------------------------------------------------------------]]--[[
							  
	Copyright wiltOS Technologies LLC, 2021
	
	Contact: www.wiltostech.com
		
----------------------------------------]]--



local trigger = {}

trigger.Name = "Timer"

trigger.OnStart = function(self)

    local time = self:GetVar("Time", 10) + CurTime()

    self:SetVar("Time.Var", time)
end

trigger.IsValid = function(subEvent)

    local time = subEvent:GetVar("Time.Var", 10)

    if subEvent:GetVar("Time.Var", 10) < CurTime() then
        return true
    end
end

trigger.Vars = {
    {
        Name = "Time.Var",
        Description = "",
        Type = "Float",
        Default = 100,
        Min = 5,
        Max = 1200,
        Internal = true,
    },
    {
        Name = "Time",
        Description = "",
        Type = "Float",
        Default = 100,
        Min = 5,
        Max = 1200,
        Internal = false,
    }
}

return trigger
