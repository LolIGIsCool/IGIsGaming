--[[-------------------------------------------------------------------]]--[[
							  
	Copyright wiltOS Technologies LLC, 2021
	
	Contact: www.wiltostech.com
		
----------------------------------------]]--


local event = {}
event.Name = "Or"
event.Description = "It will only fire once"


local orTable = {}

hook.Add("wOS.PES.EventEnd", "wOS.PES.OrNodeCleanup", function()
	orTable = {}
end)

event.OnStart = function(subEvent, oldSubEvent, event)
	if orTable[subEvent.ID] then
		timer.Simple(0, function()
			event:EndStage(subEvent.ID)
		end)
		return false
	end

	orTable[subEvent.ID] = true

	subEvent:SetVar("SubEvent.Finished", true)	

end

event.Triggers = {"SubEvent"}

return event
