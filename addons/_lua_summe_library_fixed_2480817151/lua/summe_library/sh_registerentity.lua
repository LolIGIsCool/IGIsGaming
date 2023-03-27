local t

--[[function SummeLibrary:RegisterTool(tool)
    local o = weapons.GetStored("gmod_tool").Tool["duplicator"]
    o.Mode				= tool.Mode

    for v, k in SortedPairs(tool) do
        o[v] = k
    end

    o:CreateConVars()
    weapons.GetStored("gmod_tool").Tool[tool.Mode] = o
end]]--