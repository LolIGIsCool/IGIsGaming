--[[-------------------------------------------------------------------]]--[[
							  
	Copyright wiltOS Technologies LLC, 2021
	
	Contact: www.wiltostech.com
		
----------------------------------------]]--


local variable = {
    Name = "Angle",
    UseTool = true,
    IsValid = function(varTable, value)
        if not isangle(value) then
            return false
        end

        return true
    end,
    DermaElement = function(varTable, value)
        local panel = vgui.Create("DPanel")
        panel.Value = value

        function panel:Paint(ww, hh)
            if isangle(self.Value) then
                draw.SimpleText("Angle set at: " .. tostring(self.Value), nil, ww * 0.5, hh * 0.5, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            else
                draw.SimpleText("Angle needs to be set!", nil, ww * 0.5, hh * 0.5, Color(255, 0, 0), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            end
        end

        return panel
    end,
    GetValue = function(panel)
        return panel.Value
    end,

    PrimaryAttack = function(wep, ply, panel)
        local hitPos = EyeAngles()
        if isangle(hitPos) then
            panel.Value = hitPos
        end
    end,
    OnStart = function(subEvent, value, var)
        if !isangle(value) then

            local vec = Angle(value)
            if vec then
                subEvent:SetVar(var.Name, vec)
            end
        end
    end,
    Draw3D = function(wep, ply, element)
        local ang = element.Value
        if not isangle(vec) then return end

        local pos = EyePos()
		render.DrawLine(pos, pos + ang:Forward() * 30 , Color(255, 255, 255), false)
    end
}

return variable
