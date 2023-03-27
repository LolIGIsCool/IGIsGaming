--[[-------------------------------------------------------------------]]--[[
							  
	Copyright wiltOS Technologies LLC, 2021
	
	Contact: www.wiltostech.com
		
----------------------------------------]]--



local variable = {
    Name = "Bounds",
    IsValid = function(varTable, value)
        return true
    end,
    UseTool = true,
    DermaElement = function(varTable, value)
        if not istable(value) then value = {} end
        local dermaElement = vgui.Create("DPanel")
        dermaElement.Corners = value.Corners or {}

        local heightSelector = vgui.Create("DNumberWang", dermaElement)
        heightSelector:DockMargin(6,2,6,2)
        heightSelector:SetTall(30)
        heightSelector:Dock(LEFT)
        heightSelector:SetDecimals(0)
        heightSelector:SetValue(value.Height or 200)
        dermaElement.HeightSelector = heightSelector

        function dermaElement:PerformLayout(ww, hh)
            heightSelector:SetWide(ww * 0.25)
        end
        function dermaElement:Paint(ww, hh)
            draw.SimpleText("Height", nil, ww * 0.45, hh * 0.5, Color(0,0,0), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)

            draw.SimpleText("|", nil, ww * 0.5, hh * 0.5, Color(0,0,0), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

            draw.SimpleText("Corners: " .. #(dermaElement.Corners), nil, ww * 0.55, hh * 0.5, Color(0,0,0), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        end

        return dermaElement
    end,
    GetValue = function(dermaElement)
        -- Return Debug Format Template
        local value = {
            Corners = dermaElement.Corners or {},
            Height = math.floor(dermaElement.HeightSelector:GetValue()),
        }

        -- Prepare values for more effiecient use.
        value.PreparedBorderValues = {}
        for i, borderPoint in pairs(value.Corners) do
            value.PreparedBorderValues[i] = {
                v = borderPoint
            }
        end

	    local j = table.Count(value.Corners)
        for i=1, table.Count(value.Corners) do
            local borderI = value.PreparedBorderValues[i].v
            local borderJ = value.PreparedBorderValues[j].v

            if borderJ.y == borderI.y then
                value.PreparedBorderValues[i].c = borderI.x
                value.PreparedBorderValues[i].m = 0
            else
                value.PreparedBorderValues[i].c = borderI.x - (borderI.y * borderJ.x) / (borderJ.y - borderI.y) + (borderI.y * borderI.x) / (borderJ.y - borderI.y)
                value.PreparedBorderValues[i].m = (borderJ.x - borderI.x) / (borderJ.y - borderI.y);
            end

            j = i
        end

        return value
    end,

    PrimaryAttack = function(wep, ply, dermaElement)
        local hitPos = ply:GetEyeTrace().HitPos
        if isvector(hitPos) then
            table.insert(dermaElement.Corners, hitPos)
        end
    end,
    SecondaryAttack = function(wep, ply, dermaElement)
	    dermaElement.Corners[#(dermaElement.Corners)] = nil
    end,

    OnStart = function(subEvent, varData, var)

    end,
    OnEnd = function(subEvent, varData, var)

    end,
}

local function DrawBorders(points, height, color)
	local prev = nil
	local prevtop = nil
	local first = nil
	local firsttop = nil

	for _, vec in pairs(points) do
		if not first then first = vec end

		local top = Vector(vec.x, vec.y, first.z + height)
		vec.z = first.z
		if not firsttop then firsttop = top end

		render.DrawLine(vec, top, color, false)

		if prev then
			render.DrawLine(vec, prev, color, false)
		end

		if prevtop then
			render.DrawLine(top, prevtop, color, false)
		end

		prevtop = top
		prev = vec
	end

	if prev and first then
		render.DrawLine(prev, first, color, false)
	end
	if prevtop and firsttop then
		render.DrawLine(prevtop, firsttop, color, false)
	end
end

variable.Draw3D = function(wep, ply, element)
    DrawBorders(element.Corners, element.HeightSelector:GetValue(), Color(255, 255, 255))
end
return variable
