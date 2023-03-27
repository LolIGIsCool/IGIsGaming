
--[[-------------------------------------------------------------------]]--[[
							  
	Copyright wiltOS Technologies LLC, 2021
	
	Contact: www.wiltostech.com
		
----------------------------------------]]--


local trigger = {}

trigger.Name = "Bounds"

-- Check if the Vector is inside the 2D border of the sim area.
--
-- @param Table boundData
-- @param Vector vec
-- @return Bool inBorders
trigger.CheckInBorders2D = function(boundData, vec)
	local borderPointCount = table.Count(boundData.Corners)

	local j = borderPointCount
	local inBorders = false

	for i=1, borderPointCount do
		local borderI = boundData.PreparedBorderValues[i].v
		local borderJ = boundData.PreparedBorderValues[j].v

		if ((borderI.y<vec.y && borderJ.y>=vec.y || borderJ.y<vec.y && borderI.y>=vec.y)) then
			if (vec.y * boundData.PreparedBorderValues[i].m + boundData.PreparedBorderValues[i].c < vec.x) then
				inBorders = not inBorders
			end
	  	end

		j = i
	end

	return inBorders
end

-- Check if the given vector is inside the border of the sim area.
--
-- @param Vector vec
-- @return Bool inBorders
trigger.CheckInBorders = function(boundData, vec)
	local firstPoint = boundData.Corners[1]

	if vec.z - 50 < firstPoint.z + boundData.Height && vec.z + 50 > firstPoint.z then
		if trigger.CheckInBorders2D(boundData, vec) then
			return true
		end
	end

	return false
end

trigger.IsValid = function(subEvent)
    local boundData = subEvent:GetVar("Boundary")

    -- Maybe add some code it does not have to check every player?
    for _, ply in pairs(player.GetHumans()) do
        if trigger.CheckInBorders(boundData, ply:GetPos()) then
            return true
        end
    end
end

trigger.Vars = {
    {
        Name = "Boundary",
        Description = "",
        Type = "Bounds",
        Default = false,
        Internal = false,
    }
}

return trigger
