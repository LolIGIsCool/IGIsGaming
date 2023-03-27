--[[-------------------------------------------------------------------]]--[[
							  
	Copyright wiltOS Technologies LLC, 2021
	
	Contact: www.wiltostech.com
		
----------------------------------------]]--



local variable = {
    Name = "Entity",
    IsValid = function(varTable, value)
        -- TODO


        if #varTable == 0 then
            return false
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
            local ent = dermaElement.Data
            --if IsValid(ent) then dermaElement:SetEntity(ent) end
            return dermaElement.Data
        end
    end,
    PrimaryAttack = function(wep, ply, dermaElement)
        dermaElement.Data = dermaElement.Data

        local ent = ply:GetEyeTrace().Entity
        if IsValid(ent) then
            dermaElement.Data = {
                Model = ent:GetModel(),
                Position = ent:GetPos(),
                Angle = ent:GetAngles(),
                Class = ent:GetClass(),
                // read var data
                // read bodygroup
                // read pose
            }
        end
    end,
    OnStart = function(subEvent, varData, var)
        if varData != {} then return end
        local entData = varData
        local ent = ents.Create(entData.Class || "prop_physics")
        if IsValid(ent) then
            ent:SetModel(entData.Model)
            ent:SetPos(entData.Position)
            ent:SetAngles(entData.Angle)

            ent:Spawn()
            ent:Activate()
            tEnts[#tEnts + 1] = ent
        end

        subEvent:SetVar(var.Name, ent)
        if #tEnts == 0 then
            return false
        end
    end,
    OnEnd = function(subEvent, varData, var)
        if IsValid(varData) then
            varData:Remove()
        end
    end,
}
return variable
