--[[-------------------------------------------------------------------]]--[[
							  
	Copyright wiltOS Technologies LLC, 2021
	
	Contact: www.wiltostech.com
		
----------------------------------------]]--


local event = {}

event.Name = "Strip Weapon"
event.Description = "Strip a Weapon from everyone"
event.Triggers = {
    "Instant"
}

event.OnStart = function(self)
    local wep = self:GetVar("Weapon Class")


    if self:GetVar("Strip all Weapons") then
        for index, ply in ipairs(player.GetAll()) do
            ply:StripWeapons()
        end
    else
        for index, ply in ipairs(player.GetAll()) do
            if ply:HasWeapon(wep) then
                ply:StripWeapon(wep)
            end
        end
    end
end

event.Vars = {
    {
        Name = "Weapon Class",
        Description = "",
        Type = "String",
        Default = "weapon_pistol",
    },
    {
        Name = "Strip all Weapons",
        Description = "Strip all weapons",
        Type = "Boolean",
        Default = false,
    }
}

return event
