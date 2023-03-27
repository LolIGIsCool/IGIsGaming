
--[[-------------------------------------------------------------------]]--[[
							  
	Copyright wiltOS Technologies LLC, 2021
	
	Contact: www.wiltostech.com
		
----------------------------------------]]--


local variable = {
    Name = "DarkRPJob",
    IsValid = function(varTable, value)

        return true
    end,
    DermaElement = function(varTable, varData)
        local element = vgui.Create("DComboBox")

        for index, jobData in pairs(RPExtraTeams) do
            element:AddChoice(jobData.name, jobData.name == varData)
        end

        return element
    end,
    GetValue = function(dermaElement)
        return dermaElement:GetSelected()
    end,
    OnStart = function(subEvent, varData, var)

    end,
    OnEnd = function(subEvent, varData, var)

    end,
}

return variable, (!DarkRP)
