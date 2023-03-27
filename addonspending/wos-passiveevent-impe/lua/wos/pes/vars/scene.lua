--[[-------------------------------------------------------------------]]--[[
							  
	Copyright wiltOS Technologies LLC, 2021
	
	Contact: www.wiltostech.com
		
----------------------------------------]]--


local variable = {
    Name = "Scene",
    IsValid = function(varTable, value)
		local a = {}
		for index, data in ipairs(value or {}) do
			if !istable(data) then
				local ent = ents.GetByIndex(data)

				if IsValid(ent) then
					a[#a+1] = {
						Model = ent:GetModel(),
						Angles = ent:GetAngles(),
						Pos = ent:GetPos(),
					}
					ent:Remove()
				end
			end
		end
		-- who know that variable overrides don't update
		-- value = a doesn't work
		table.CopyFromTo( a, value )
        return true
    end,
    DermaElement = function(varTable, value)
        local button = vgui.Create("DButton")

		button.data = value or {}
		button:SetText("Record")

		local par = button
		
		button.DoClick = function(self)
			par = par:GetParent()

			local node = button:GetParent():GetParent():GetParent():GetParent():GetParent()

			local scenemodule = wOS.PES.Modules:Get("scene")

			if button:GetText() == "Record" then
				button.data = {}
				button:SetText("Recording ...")
				wOS.PES:GetActiveMenu():Hide()
				if scenemodule and scenemodule.StartRecording then
					scenemodule.StartRecording(button)
				end
			else
				button:SetText("Record")
				if scenemodule and scenemodule.StopRecording then
					wOS.PES.Modules:Get("scene").StopRecording(button)
				end
			end
		end

        return button
    end,
    GetValue = function(dermaElement)
        return dermaElement.data
    end
}
return variable
