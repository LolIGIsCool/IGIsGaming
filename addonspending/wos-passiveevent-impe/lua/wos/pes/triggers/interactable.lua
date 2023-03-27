--[[-------------------------------------------------------------------]]--[[
							  
	Copyright wiltOS Technologies LLC, 2021
	
	Contact: www.wiltostech.com
		
----------------------------------------]]--



local trigger = {}

trigger.Name = "Interactable"

trigger.IsValid = function(subEvent)
    if subEvent:GetVar("Entity.Interacted", 0) >= subEvent:GetVar("Interactable Entity Cap", 0) then
        return true
    end
end

trigger.Hooks = {
    ["PlayerUse"] = function(subEvent, ply, ent)
        local tEnts = subEvent:GetVar("Interactable Entity")
        if table.HasValue(tEnts, ent) then
            if not ent.WasPressed then
                subEvent:SetVar("Entity.Interacted", subEvent:GetVar("Entity.Interacted",0) + 1)
                ent.WasPressed = true
            end
        end
    end,
}

trigger.Vars = {
    {
        Name = "Entity.Interacted",
        Description = "",
        Type = "Int",
        Default = 0,
        Internal = true,
    },
    {
        Name = "Interactable Entity",
        Description = "Entitys that you press e on",
        Type = "TableEntity",
        Min = 1,
        Max = 5,
    },
    {
        Name = "Interactable Entity Cap",
        Description = "How many of the entities do you need to interactor with",
        Type = "Int",
        Default = 1,
        Min = 1,
        Max = 5,
    }
}

return trigger
