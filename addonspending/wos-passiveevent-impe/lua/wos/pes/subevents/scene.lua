--[[-------------------------------------------------------------------]]--[[
							  
	Copyright wiltOS Technologies LLC, 2021
	
	Contact: www.wiltostech.com
		
----------------------------------------]]--


local event = {}
event.Name = "Scenery"
event.Description = "Load props into the map that has no collisions"

event.OnStart = function(self, oldSubEvent, event)
	local bool = self:GetVar("Load")

	local name = self:GetVar("Scene Name")

	local scenemod = wOS.PES.Modules:Get("scene")
	if scenemod.LoadScene then
		if bool then
			scenemod.LoadScene(name, self:GetVar("Scene"))
		else
			scenemod.UnloadScene(name)
		end
	end
    return true
end

event.Triggers = {"Instant"}

event.Vars = {
	{
		Name = "Scene Name",
		Description = "",
		Type = "String",
		Internal = false,
	},
	{
		Name = "Scene",
		Description = "",
		Type = "Scene",
		Internal = false,
	},
	{
		Name = "Load",
		Description = "",
		Default = false,
		Type = "Boolean",
		Internal = false,
	},
}

return event
