--[[-------------------------------------------------------------------]]--[[
							  
	Copyright wiltOS Technologies LLC, 2021
	
	Contact: www.wiltostech.com
		
----------------------------------------]]--


local variable = {
    Name = "List",
    IsValid = function(varTable, value)
        if not istable(value) then
            return false
        end

        for _, entry in pairs(value) do
            if not isstring(entry) then
                return false
            end
        end

        return true
    end,
    DermaElement = function(varTable, value)
        local listView = vgui.Create("DListView")
        listView:SetTall(200)
        listView:SetMultiSelect(true)
        
        if istable(value) then
            listView.SelectedValues = value
        elseif istable(varTable.Default) then
            listView.SelectedValues = varTable.Default
        else
            listView.SelectedValues = {}
        end

        if isstring(varTable.Header) then
            listView:AddColumn(varTable.Header)
        else
            listView:AddColumn("Multi-Select")
        end

        for _, entry in pairs(varTable.Values or {}) do
            local line = listView:AddLine(entry)
            if table.HasValue(listView.SelectedValues, entry) then
                line:SetSelected(true)
            end
        end

        function listView:OnRowRightClick(index, line)
            line:SetSelected(false)

            table.RemoveByValue(listView.SelectedValues, line:GetValue(1))
        end
        function listView:OnRowSelected(index, line)
            line:SetSelected(true)

            table.insert(listView.SelectedValues, line:GetValue(1))
            
            -- Keeping Everything active.
            for k, otherLine in pairs(self:GetLines()) do
                if table.HasValue(listView.SelectedValues, otherLine:GetValue(1)) then
                    otherLine:SetSelected(true)
                end
            end
        end

        return listView
    end,
    GetValue = function(listView)
        return listView.SelectedValues
    end
}

return variable