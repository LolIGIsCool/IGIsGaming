--[[-------------------------------------------------------------------]]--[[
							  
	Copyright wiltOS Technologies LLC, 2021
	
	Contact: www.wiltostech.com
		
----------------------------------------]]--


local trigger = {}

trigger.Name = "NPC"

trigger.OnStart = function(self)

    local ent = ents.Create(self:GetVar("Friendly Class"))

    if IsValid(ent) then
        local pos = self:GetVar("Friendly Spawn Location")
        local ang = self:GetVar("Friendly Spawn Angle")

        local wep = self:GetVar("Friendly Weapon")
        local health = self:GetVar("Friendly Health")
        local model = self:GetVar("Friendly Model")

        if pos then
            ent:SetPos(pos + Vector(0,0, 25))
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
        ent:SetModel(model)
        self:SetVar("Friendly.Entity", ent)
    end
end

trigger.IsValid = function(subEvent)
    if subEvent:GetVar("Friendly.Dead", false) then
        if IsValid( subEvent:GetVar("Friendly.Entity")) then
            if subEvent:GetVar("Friendly.Entity"):Health() > 0 then
                subEvent:SetVar("Friendly.Dead", false)
                return false
            end
        end
        return true
    end
end

trigger.Hooks = {
    ["OnNPCKilled"] = function(subEvent, npc, ent, inflictor)
        if npc == subEvent:GetVar("Friendly.Entity") then
            subEvent:SetVar("Friendly.Dead", true)
        end
    end,
}

trigger.Vars = {
    {
        Name = "Friendly Class",
        Description = "",
        Type = "String",
        Default = "npc_citizen",
        Internal = false,
    },
    {
        Name = "Friendly Model",
        Description = "",
        Type = "String",
        Default = "models/Combine_Super_Soldier.mdl",
        Internal = false,
    },
    {
        Name = "Friendly Weapon",
        Description = "",
        Type = "String",
        Default = "weapon_ar2",
        Internal = false,
    },
    {
        Name = "Friendly Spawn Angle",
        Description = "",
        Type = "Angle",
        Default = Angle(0,0,0),
        Internal = false,
    },
    {
        Name = "Friendly Spawn Location",
        Description = "",
        Type = "Vector",
        Default = Vector(0,0,0),
        Internal = false,
    },
    {
        Name = "Friendly Health",
        Description = "",
        Type = "Int",
        Min = 1,
        Max = 1000,
        Internal = false,
    },
    {
        Name = "Friendly.Entity",
        Description = "",
        Type = "Entity",
        Internal = true,
    },
    {
        Name = "Friendly.Dead",
        Description = "",
        Default = false,
        Type = "Boolean",
        Internal = true,
    },
}

return trigger
