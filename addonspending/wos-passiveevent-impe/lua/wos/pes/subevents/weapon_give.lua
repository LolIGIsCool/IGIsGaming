--[[-------------------------------------------------------------------]]--[[
							  
	Copyright wiltOS Technologies LLC, 2021
	
	Contact: www.wiltostech.com
		
----------------------------------------]]--


local event = {}

event.Name = "Give Weapons"
event.Description = "Give Weapons to everyone"
event.Triggers = {
    "Instant"
}

event.OnStart = function(self)
    local wep = self:GetVar("Weapon Class")

    for index, ply in ipairs(player.GetAll()) do
        ply:Give(wep)
    end
end

event.Vars = {
    {
        Name = "Weapon Class",
        Description = "",
        Type = "String",
        Default = "weapon_pistol",
    },
}

return event
