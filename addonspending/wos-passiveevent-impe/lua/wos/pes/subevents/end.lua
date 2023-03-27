--[[-------------------------------------------------------------------]]--[[
							  
	Copyright wiltOS Technologies LLC, 2021
	
	Contact: www.wiltostech.com
		
----------------------------------------]]--


local event = {}
event.Name = "End"
event.Description = "Completely stops the event"

event.OnStart = function(_subEvent, oldSubEvent, event)
    for index, subEvent in pairs(event:GetActiveStages()) do
        if subEvent == oldSubEvent then continue end

        event:EndStage(subEvent.ID)
    end

    return true
end

event.Triggers = {}

return event
