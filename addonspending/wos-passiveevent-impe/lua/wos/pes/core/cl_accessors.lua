--[[-------------------------------------------------------------------]]--[[
							  
	Copyright wiltOS Technologies LLC, 2021
	
	Contact: www.wiltostech.com
		
----------------------------------------]]--

























































































































































wOS = wOS or {}
wOS.PES = wOS.PES or {}

wOS.PES.Triggers = wOS.PES.Triggers || {}
wOS.PES.Triggers.Data = wOS.PES.Triggers.Data || {}

wOS.PES.SubEvents = wOS.PES.SubEvents || {}
wOS.PES.SubEvents.Data = wOS.PES.SubEvents.Data || {}

function wOS.PES.Triggers:GetAll()
    return self.Data
end

function wOS.PES.Triggers:Get(name)
    if not name then return end
    return self.Data[name]
end

function wOS.PES.SubEvents:GetAll()
    return self.Data
end

function wOS.PES.SubEvents:Get(name)
    if not name then return end
    return self.Data[name]
end