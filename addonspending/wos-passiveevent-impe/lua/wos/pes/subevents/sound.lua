--[[-------------------------------------------------------------------]]--[[
							  
	Copyright wiltOS Technologies LLC, 2021
	
	Contact: www.wiltostech.com
		
----------------------------------------]]--


local event = {}
event.Name = "Sound"

event.Description = "Play a sound"

event.OnStart = function(subEvent, oldSubEvent, event)

	local soundmodule = wOS.PES.Modules:Get("sound")
	if soundmodule and soundmodule.Play then
		soundmodule.Play( subEvent:GetVar("Sound") )
	end

	return true
end

event.Triggers = {"Instant"}

event.Vars = {
	{
		Name = "Sound",
		Description = "",
		Type = "String",
		Default = "",
		Internal = false,
	}
}

return event