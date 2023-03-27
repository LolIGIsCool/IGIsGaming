--[[-------------------------------------------------------------------]]--[[
							  
	Copyright wiltOS Technologies LLC, 2021
	
	Contact: www.wiltostech.com
		
----------------------------------------]]--


local variable = {
    Name = "String",
    IsValid = function(varData, value)
        if not isstring(value) then
            return false
        end

        if value == "" then
            return false
        end

        return true
    end,
    DermaElement = function(varTable, value)
        local textentry = vgui.Create("DTextEntry")

        if varTable.AllowMultiLine then
            textentry:SetMultiline(true)
            textentry:SetHeight(40)
        end

        textentry:SetText(value or varTable.Default or "")

        return textentry
    end,
    GetValue = function(dermaElement)
        return dermaElement:GetValue()
    end
}
return variable
