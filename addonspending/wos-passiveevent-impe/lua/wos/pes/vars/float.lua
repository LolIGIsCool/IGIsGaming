--[[-------------------------------------------------------------------]]--[[
							  
	Copyright wiltOS Technologies LLC, 2021
	
	Contact: www.wiltostech.com
		
----------------------------------------]]--


local variable = {
    Name = "Float",
    IsValid = function(varTable, value)
        if not isnumber(value) then
            return false
        end

        return true
    end,
    DermaElement = function(varTable, value)
        local numSlider = vgui.Create("DNumSlider")

        if isnumber(varTable.Min) then
            numSlider:SetMin(varTable.Min)
        end

        if isnumber(varTable.Max) then
            numSlider:SetMax(varTable.Max)
        end

        if isnumber(value) then
            numSlider:SetValue(value)
        else
            numSlider:SetValue(varTable.Default)
        end

        return numSlider
    end,
    GetValue = function(numSlider)
        return numSlider:GetValue()
    end
}

return variable
