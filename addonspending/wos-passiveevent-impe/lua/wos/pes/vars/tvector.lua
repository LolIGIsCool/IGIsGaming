--[[-------------------------------------------------------------------]]--[[
							  
	Copyright wiltOS Technologies LLC, 2021
	
	Contact: www.wiltostech.com
		
----------------------------------------]]--


local variable = {
    Name = "TableVector",
    UseTool = true,
    IsValid = function(varTable, value)
        if table.Count(value) == 0 then return false end


        for index, vec in ipairs(value) do
            if not isvector(value) then
                return false
            end
        end

        return true
    end,
    DermaElement = function(varTable, value)
        local panel = vgui.Create("DPanel")
        panel.Values = value

        function panel:Paint(ww, hh)
            if istable(self.Values) then
                vecStr = ""
                local count = 0

                for _, vec in ipairs(self.Values) do
                    if isvector(vec) then
                        vecStr = vecStr .. "\n" .. tostring(vec)
                        count = count + 1
                    end
                end

                if vecStr != "" then
                    local w,h = draw.DrawText("Vector set at: " ..vecStr, nil, ww * 0.5, 5, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

                    if count*15 > hh then
                        self:SetHeight(count * 15)

                        self._catderma:InvalidateLayout( true )
                    end
                    return
                end
            end
            draw.SimpleText("Vector needs to be set!", nil, ww * 0.5, hh * 0.5, Color(255, 0, 0), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

        end
        return panel
    end,
    GetValue = function(panel)
        return panel.Values || {}
    end,

    PrimaryAttack = function(wep, ply, panel)
        panel.Values = panel.Values || {}
        local hitPos = ply:GetEyeTrace().HitPos
        if isvector(hitPos) then
            panel.Values[#panel.Values + 1] = hitPos
        end
    end,
    SecondaryAttack = function(wep, ply, panel)
        panel.Values = panel.Values || {}
        panel.Values[#panel.Values] = nil
    end,
    OnStart = function(subEvent, value, var)

        local val  = {}

        for index, vec in ipairs(value) do
            if !isvector(vec) then

                vec = Vector(vec)
                if vec then
                    val[index] = vec
                    continue
                end
            end
            val[index] = vec
        end
        subEvent:SetVar(var.Name, val)
    end,
    Draw3D = function(wep, ply, element)
        local tVec = element.Values || {}
        for index, vec in ipairs(tVec) do
            if not isvector(vec) then continue end

            local top = Vector(vec.x, vec.y, vec.z + 200)
		    render.DrawLine(vec, top, Color(255, 255, 255), false)
        end
    end
}

return variable
