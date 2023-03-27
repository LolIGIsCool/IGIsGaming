--[[-------------------------------------------------------------------]]--[[
							  
	Copyright wiltOS Technologies LLC, 2021
	
	Contact: www.wiltostech.com
		
----------------------------------------]]--


local event = {}
event.Name = "Explosion"
event.Description = ""

event.OnStart = function(subEvent)
    local effectdata = EffectData()
    local vec = subEvent:GetVar("Explosion Position")

    effectdata:SetOrigin(vec)
    util.Effect( "HelicopterMegaBomb", effectdata, true, true )
end

event.Triggers = {
    "Instant",
}

event.Vars = {
    {
        Name = "Explosion Size",
        Description = "The size of the Explosion",
        Type = "Float",
        Default = 40,
        Min = 20,
        Max = 100,
    },
    {
        Name = "Explosion Position",
        Description = "The Position of the Explosion",
        Type = "Vector",
        Default = Vector(0,0,0),
    }
}

return event
