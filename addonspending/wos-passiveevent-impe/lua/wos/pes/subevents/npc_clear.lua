--[[-------------------------------------------------------------------]]--[[
							  
	Copyright wiltOS Technologies LLC, 2021
	
	Contact: www.wiltostech.com
		
----------------------------------------]]--



local event = {}

event.Name = "NPC Clear"
event.Description = "Keep the NPC Alive"
event.Triggers = {
    "SubEvent", "Timer"
}

local function SpawnNPC(subEvent)
    local class = subEvent:GetVar("Enemy Class")
    local wep = subEvent:GetVar("Enemy Weapon")
    local tPos = subEvent:GetVar("Enemy Spawn Location", {})
    local health = subEvent:GetVar("Enemy Health")
    local model = subEvent:GetVar("Enemy Model", "models/Combine_Super_Soldier.mdl")

    local spawnAmount = #tPos

    local npcSpawned = false
    for x = 1, spawnAmount do
        local pos = tPos[x]
        local ent = ents.Create(class)
        if IsValid(ent) then
            if pos then
                ent:SetPos(pos)
            end
            if ang then
                ent:SetAngles(ang)
            end

            if wep then
                ent:Give(wep)
            end

            if health then
                ent:SetHealth(health)
            end
            ent:SetModel(model)
            ent:Spawn()
            ent:Activate()

            npcSpawned = true
            local tEnt = subEvent:GetVar("Enemy.Entity", {})
            tEnt[#tEnt + 1] = ent

            subEvent:SetVar("Enemy.Entity", tEnt)
        end
    end
end

event.OnStart = function(self)
    SpawnNPC(self)
end

event.Hooks = {
    ["Think"] = function(subEvent)
        local tEnt = subEvent:GetVar("Enemy.Entity")
        if tEnt then
            if table.Count(tEnt) == 0 then
                subEvent:SetVar("SubEvent.Finished", true)
            end

            for index, npc in ipairs(tEnt) do
                if !IsValid(npc) then
                    --table.RemoveByValue(subEvent:GetVar("Enemy.Entity", {}), npc)
                end
            end
        end
    end,
    ["OnNPCKilled"] = function(subEvent, npc, ent, inflictor)
        if table.HasValue(subEvent:GetVar("Enemy.Entity", {}), npc) then
            table.RemoveByValue(subEvent:GetVar("Enemy.Entity", {}), npc)
        end
    end
}

event.Vars = {
    {
        Name = "Enemy Class",
        Description = "",
        Type = "String",
        Default = "npc_combine_s",
        Internal = false,
    },
    {
        Name = "Enemy Weapon",
        Description = "",
        Type = "String",
        Default = "weapon_ar2",
        Internal = false,
    },
    {
        Name = "Enemy Spawn Location",
        Description = "",
        Type = "TableVector",
        Internal = false,
    },
    {
        Name = "Enemy Health",
        Description = "",
        Type = "Int",
        Min = 1,
        Max = 1000,
        Internal = false,
    },
    {
        Name = "Enemy Model",
        Description = "",
        Type = "String",
        Default = "models/Combine_Super_Soldier.mdl",
    },
    {
        Name = "Enemy.Entity",
        Description = "",
        Type = "TableEntity",
        Internal = true,
    },
}

return event
