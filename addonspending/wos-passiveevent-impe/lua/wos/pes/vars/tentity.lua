--[[-------------------------------------------------------------------]]--[[
							  
	Copyright wiltOS Technologies LLC, 2021
	
	Contact: www.wiltostech.com
		
----------------------------------------]]--



local variable = {
    Name = "TableEntity",
    IsValid = function(varTable, value)
        -- TODO


        if #varTable == 0 then
            return false
        end

        for index, data in ipairs(varTable) do
            local ent = ents.GetByIndex(data.Index)

            if IsValid(ent) then
                if ent:CreatedByMap() then
                    data = {
                        mapID = data.Index,
                    }
                end
            end
        end

        return true
    end,
    UseTool = true,
    DermaElement = function(varTable, varData)
        if !varData then varData = {} end
        local element = vgui.Create("DModelPanel")

        if IsValid(varData[1]) then
            --element:SetEntity(varData[1])
        end

        return element -- make multiple of these through a base panel
    end,
    GetValue = function(dermaElement)
        if dermaElement.Data then
            local ent = dermaElement.Data[1]
            --if IsValid(ent) then dermaElement:SetEntity(ent) end
            return dermaElement.Data
        end
    end,
    PrimaryAttack = function(wep, ply, dermaElement)
        dermaElement.Data = dermaElement.Data || {}

        local ent = ply:GetEyeTrace().Entity
        if IsValid(ent) then
            dermaElement.Data[#dermaElement.Data + 1] = {
                Model = ent:GetModel(),
                Position = ent:GetPos(),
                Angle = ent:GetAngles(),
                Class = ent:GetClass(),
                Index = ent:EntIndex()
                // read var data
                // read bodygroup
                // read pose
            }
        end
    end,
    OnStart = function(subEvent, varData, var)
        local tEnts = {}

        for index, entData in ipairs(varData || {}) do
            if entData.mapID then
                local ent = ents.GetByIndex(entData.mapID)
                if IsValid(ent) then
                    tEnts[#tEnts + 1] = ent
                end
            else
                local ent = ents.Create(entData.Class || "prop_physics")
                if IsValid(ent) then
                    ent:SetModel(entData.Model)
                    ent:SetPos(entData.Position)
                    ent:SetAngles(entData.Angle)

                    ent:Spawn()
                    ent:Activate()
                    tEnts[#tEnts + 1] = ent
                end
            end
        end
        subEvent:SetVar(var.Name, tEnts)
        if #tEnts == 0 then
            return false
        end
    end,
    OnEnd = function(subEvent, varData, var)
        for index, ent in ipairs(varData || {}) do
            if IsValid(ent) then
                ent:SetSaveValue( "m_bFadingOut", true )
                ent:Remove()
            end
        end
    end,
}
return variable
