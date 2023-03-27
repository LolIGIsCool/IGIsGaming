--[[-------------------------------------------------------------------]]--[[
							  
	Copyright wiltOS Technologies LLC, 2021
	
	Contact: www.wiltostech.com
		
----------------------------------------]]--


local variable = {
    Name = "Dropdown",
    IsValid = function(varTable, value)
        if not isstring(value) then
            return false
        end

        if value == "" then
            return false
        end

        return true
    end,
    DermaElement = function(varTable, value)
        local comboBox = vgui.Create("DComboBox")
        for _, choice in pairs(varTable.Values or {}) do
            comboBox:AddChoice(choice)
        end

        if isstring(value) then
            comboBox:SetValue(value)
        else
            if isstring(varTable.Default) then
                comboBox:SetValue(varTable.Default )
            end
        end

        return comboBox
    end,
    GetValue = function(comboBox)
        return comboBox:GetValue()
    end
}

return variable