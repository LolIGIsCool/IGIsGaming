--[[-------------------------------------------------------------------]]--[[
							  
	Copyright wiltOS Technologies LLC, 2021
	
	Contact: www.wiltostech.com
		
----------------------------------------]]--


local trigger = {}

trigger.Name = "DarkRP Player Kill"

trigger.OnStart = function(self)
    local ply = player.GetBySteamID(self:GetVar("SteamID"))
    local jobName = self:GetVar("Job")

    if ply then
        self:SetVar("Player.Entity", ply)
        local team = -1
        for index, jobData in pairs(RPExtraTeams) do
            if jobData.name == jobName then
                team = index
                break
            end
        end

        if team != -1 then
            ply:changeTeam(team, true, true, true)
        end
        timer.Simple(0.1, function()
            local wep = self:GetVar("Weapon")
            if wep then ply:Give(wep) end

            local health = self:GetVar("Health")
            if health then ply:SetHealth(health) end

            local loc = self:GetVar("Location")
            if loc then ply:SetPos(loc) end

            self:SetVar("Player.Spawned", true)
        end)
    end
end

trigger.IsValid = function(subEvent)
    if subEvent:GetVar("Player.Dead", false) then
        return true
    end
end

trigger.Hooks = {
    ["PlayerDeath"] = function(subEvent, ply)
        if ply == subEvent:GetVar("Player.Entity") then
            if subEvent:GetVar("Player.Spawned") then
                subEvent:SetVar("Player.Dead", true)
            end
        end
    end,
}

trigger.Vars = {
    {
        Name = "SteamID",
        Description = "",
        Type = "String",
        Internal = false,
    },
    {
        Name = "Job",
        Description = "",
        Type = "DarkRPJob",
        Default = "Citizen",
        Internal = false,
    },
    {
        Name = "Health",
        Description = "",
        Type = "Int",
        Internal = false,
    },
    {
        Name = "Weapon",
        Description = "",
        Type = "String",
        Default = "weapon_ar2",
        Internal = false,
    },
    {
        Name = "Location",
        Description = "",
        Type = "Vector",
        Internal = false,
    },
    {
        Name = "Player.Entity",
        Description = "",
        Type = "Entity",
        Internal = true,
    },
    {
        Name = "Player.Dead",
        Description = "",
        Default = false,
        Type = "Boolean",
        Internal = true,
    },
    {
        Name = "Player.Spawned",
        Description = "",
        Type = "Boolean",
        Default = false,
        Internal = true,
    }
}

return trigger, (!DarkRP)
