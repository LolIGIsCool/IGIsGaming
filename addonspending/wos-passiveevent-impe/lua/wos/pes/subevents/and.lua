--[[-------------------------------------------------------------------]]--[[
							  
	Copyright wiltOS Technologies LLC, 2021
	
	Contact: www.wiltostech.com
		
----------------------------------------]]--

local event = {}
event.Name = "And"
event.Description = "All inputs must fire for this to continue"


local andTable = {}

hook.Add("wOS.PES.EventEnd", "wOS.PES.AndNodeCleanup", function()
	andTable = {}
end)

event.OnStart = function(subEvent, oldSubEvent, event)

	if !andTable[subEvent.ID] then
		local tempData = {}

		for index, subevent in pairs(event.subEvents) do
			if subevent.Triggers then
				for triggerName, nodeIDTbl in pairs(subevent.Triggers) do
					if table.HasValue(nodeIDTbl, subEvent.ID) then
						tempData[subevent.ID] = false
					end
				end
			end
		end

		andTable[subEvent.ID] = tempData
	end

	andTable[subEvent.ID][oldSubEvent.ID] = true

	if table.HasValue(andTable[subEvent.ID], false) then
		timer.Simple(0, function()
			event:EndStage(subEvent.ID)
		end)
		return false
	end

	subEvent:SetVar("SubEvent.Finished", true)
end

event.Triggers = {"SubEvent"}

return event
