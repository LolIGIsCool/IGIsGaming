--[[-------------------------------------------------------------------]]--[[
							  
	Copyright wiltOS Technologies LLC, 2021
	
	Contact: www.wiltostech.com
		
----------------------------------------]]--


local event = {}
event.Name = "Text"
event.Description = "Send a message in chat"

event.OnStart = function(subEvent, oldSubEvent, event)

	local chatmodule = wOS.PES.Modules:Get("chat")

	if chatmodule and chatmodule.SendMessage then
    	chatmodule:SendMessage(subEvent:GetVar("Title Color"), subEvent:GetVar("Title Text"), color_white, ": ", subEvent:GetVar("Message Color"), subEvent:GetVar("Message Text"))
    end
    return true
end

event.Triggers = {"Instant"}

event.Vars = {
	{
		Name = "Title Color",
		Description = "",
		Type = "Color",
		Default = Color(0,0,0),
		Internal = false,
	},
	{
		Name = "Title Text",
		Description = "",
		Type = "String",
		Default = "",
		Internal = false,
	},
	{
		Name = "Message Color",
		Description = "",
		Type = "Color",
		Default = color_white,
		Internal = false,
	},
	{
		Name = "Message Text",
		Description = "",
		Type = "String",
		Default = "",
		Internal = false,
	}
}

return event
