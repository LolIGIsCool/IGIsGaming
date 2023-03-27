--[[-------------------------------------------------------------------]]--[[
							  
	Copyright wiltOS Technologies LLC, 2021
	
	Contact: www.wiltostech.com
		
----------------------------------------]]--


local variable = {
    Name = "Vector",
    UseTool = true,
    IsValid = function(varTable, value)
        if not isvector(value) then
            return false
        end

        return true
    end,
    DermaElement = function(varTable, value)
        local panel = vgui.Create("DPanel")
        panel.Value = value

        function panel:Paint(ww, hh)
            if isvector(self.Value) then
                draw.SimpleText("Vector set at: " .. tostring(self.Value), nil, ww * 0.5, hh * 0.5, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            else
                draw.SimpleText("Vector needs to be set!", nil, ww * 0.5, hh * 0.5, Color(255, 0, 0), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            end
        end

        return panel
    end,
    GetValue = function(panel)
        return panel.Value
    end,

    PrimaryAttack = function(wep, ply, panel)
        local hitPos = ply:GetEyeTrace().HitPos
        if isvector(hitPos) then
            panel.Value = hitPos
        end
    end,
    OnStart = function(subEvent, value, var)
        if !isvector(value) then

            local vec = Vector(value)
            if vec then
                subEvent:SetVar(var.Name, vec)
            end
        end
    end,
    Draw3D = function(wep, ply, element)
        local vec = element.Value
        if not isvector(vec) then return end

        local top = Vector(vec.x, vec.y, vec.z + 200)
		render.DrawLine(vec, top, Color(255, 255, 255), false)
    end
}

return variable
