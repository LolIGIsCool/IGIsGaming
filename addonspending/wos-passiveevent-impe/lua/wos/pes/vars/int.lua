--[[-------------------------------------------------------------------]]--[[
							  
	Copyright wiltOS Technologies LLC, 2021
	
	Contact: www.wiltostech.com
		
----------------------------------------]]--


local variable = {
    Name = "Int",
    IsValid = function(varTable, value)
        if not isnumber(value) then
            return false
        end
        return true
    end,
    DermaElement = function(varTable, value)
        local numberWang = vgui.Create("DNumberWang")
        numberWang:SetDecimals(0)

        if isnumber(varTable.Min) then
            numberWang:SetMin(varTable.Min)
        end

        if isnumber(varTable.Max) then
            numberWang:SetMax(varTable.Max)
        end

        if isnumber(value) then
            numberWang:SetValue(value)
        else
            numberWang:SetValue(varTable.Default)
        end

        return numberWang
    end,
    GetValue = function(numberWang)
        return numberWang:GetValue()
    end
}

return variable
