--[[-------------------------------------------------------------------]]--[[
							  
	Copyright wiltOS Technologies LLC, 2021
	
	Contact: www.wiltostech.com
		
----------------------------------------]]--
local event = {}

event.Name = "Capture Point"
event.Description = "Capture the Points"
event.Triggers = {
    "SubEvent"
}

event.OnStart = function(self)
    local tPos = self:GetVar("Locations")

    local range = self:GetVar("Capture Range")

    for index, pos in ipairs(tPos) do
        local ent = ents.Create("wos_pes_capture_point")
        ent:SetPos(pos)
        ent:Spawn()
        ent:SetCaptureRange(range || 100)
        ent.SubEvent = self
    end
end

event.OnEnd = function(self)
    for index, ent in ipairs(ents.FindByClass("wos_pes_capture_point")) do
        if IsValid(ent) then
            if ent.SubEvent == self then
                ent:Remove()
            end
        end
    end
end

event.Hooks = {
    ["wOS.PES.CapturePointCaptured"] = function(self, ent)
        if ent.SubEvent then
            if ent.SubEvent == self then
                local tPosCount = #self:GetVar("Locations")

                local count = self:GetVar("Points.Captured")

                count = count + 1

                if count == tPosCount then
                    self:SetVar("SubEvent.Finished", true)
                else
                    self:SetVar("Points.Captured", count)
                end
            end
        end
    end
}

event.Vars = {
    {
        Name = "Locations",
        Description = "",
        Type = "TableVector",
    },
    {
        Name = "Points.Captured",
        Internal = true,
        Type = "Int",
        Default = 0,
    },
    {
        Name = "Capture Range",
        Type = "Float",
        Min = 60,
        Max = 512,
        Default = 100,
    }
}

return event
