--[[-------------------------------------------------------------------]]--[[
							  
	Copyright wiltOS Technologies LLC, 2021
	
	Contact: www.wiltostech.com
		
----------------------------------------]]--


local event = {}

event.Name = "Map Change"
event.Description = "Change the map"
event.Triggers = {"Instant"}

event.OnStart = function(self)
	
	local map = self:GetVar("Map")
	local event = self:GetVar("Event")

	local mapModule = wOS.PES.Modules:Get("map")

	if mapModule.Maps then
		if table.HasValue(mapModule.Maps, map) then
			mapModule.ChangeMap(map, event)
		end	
	end

	return true
end

event.Vars = {
	{
		Name = "Map",
		Description = "",
		Values = wOS.PES.Modules:Get("map").Maps,
		Type = "Dropdown",
		Internal = false,
	},
	{
		Name = "Event",
		Description = "",
		Type = "String",
		Internal = false,
	}
}

return event