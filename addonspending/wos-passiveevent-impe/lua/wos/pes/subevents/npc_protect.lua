--[[-------------------------------------------------------------------]]--[[
							  
	Copyright wiltOS Technologies LLC, 2021
	
	Contact: www.wiltostech.com
		
----------------------------------------]]--



local event = {}

event.Name = "Protect NPC"
event.Description = "Keep the NPC Alive"
event.Triggers = {
    "NPC", "Timer"
}

local function SpawnNPC(subEvent)
    local class = subEvent:GetVar("Enemy Class")
    local wep = subEvent:GetVar("Enemy Weapon")
    local tPos = subEvent:GetVar("Enemy Spawn Location", {})
    local health = subEvent:GetVar("Enemy Health")
    local model = subEvent:GetVar("Enemy Model", "models/Combine_Super_Soldier.mdl")
    local spawnAmount = subEvent:GetVar("Enemy Count", 1)

    spawnAmount = math.min(spawnAmount, #tPos)

    local npcSpawned = false
    for x = 1, spawnAmount do
        local pos = tPos[math.random(#tPos)]
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

    if npcSpawned then
        subEvent:SetVar("Cooldown.Wave", CurTime() + subEvent:GetVar("Wave Cooldown") )
    end
end


event.OnStart = function(self)
    SpawnNPC(self)
end

event.Hooks = {
    ["Think"] = function(subEvent)
        if table.Count(subEvent:GetVar("Enemy.Entity", {})) == 0 then
            if subEvent:GetVar("Cooldown.Wave", 0) == 0 then
                SpawnNPC(subEvent)
            else
                if subEvent:GetVar("Cooldown.Wave", 0) < CurTime() then
                    SpawnNPC(subEvent)
                end
            end
		else
			if true then return end -- DISABLE THIS BROKEN CODE FOR NOW

			if subEvent:GetVar("Chase Cooldown", 0) < CurTime() then
				subEvent:SetVar("Chase Cooldown", 10 + CurTime())
				local pos = subEvent:GetVar("Friendly.Entity"):GetPos()

				for index, npc in pairs(subEvent:GetVar("Enemy.Entity", {})) do
					npc:SetSaveValue("m_vecLastPosition", pos)
					npc:SetSchedule(SCHED_FORCED_GO)
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
    {
        Name = "Wave Cooldown",
        Description = "Time between waves",
        Type = "Int",
        Default = 100,
    },
    {
        Name = "Cooldown.Wave",
        Description = "Time between waves",
        Type = "Float",
        Default = 0,
        Internal = true,
    },
	{
        Name = "Chase cooldown",
        Description = "Time between waves",
        Type = "Float",
        Default = 0,
        Internal = true,
    },
}

return event
