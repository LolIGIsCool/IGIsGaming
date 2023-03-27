--[[-------------------------------------------------------------------]]--[[
							  
	Copyright wiltOS Technologies LLC, 2021
	
	Contact: www.wiltostech.com
		
----------------------------------------]]--


local variable = {
    Name = "Boolean",
    IsValid = function(varTable, value)
        if not isbool(value) then
            return false
        end

        return true
    end,
    DermaElement = function(varTable, value)
        local button = vgui.Create("DButton")
        button.Pressed = value

        local activeText = varTable.ActiveText or "Yes"
        local inactiveText = varTable.InactiveText or "No"

        button:SetText(button.Pressed and activeText or inactiveText)
        button.DoClick = function(pan)
            button.Pressed = not button.Pressed
            pan:SetText(button.Pressed and activeText or inactiveText)
        end

        return button
    end,
    GetValue = function(button)
        return button.Pressed
    end
}

return variable