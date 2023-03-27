--[[-------------------------------------------------------------------]]--[[
							  
	Copyright wiltOS Technologies LLC, 2021
	
	Contact: www.wiltostech.com
		
----------------------------------------]]--


local variable = {
    Name = "Color",
    IsValid = function(varTable, value)
        if not IsColor(value) then
            return false
        end

        return true
    end,
    DermaElement = function(varTable, value)
        local colorMixer = vgui.Create("DColorMixer")

        if IsColor(value) then
            colorMixer:SetColor(value)
        else
            colorMixer:SetColor(varTable.Default)
        end

        return colorMixer
    end,
    GetValue = function(colorMixer)
        return colorMixer:GetColor()
    end
}

return variable