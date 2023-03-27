--[[-------------------------------------------------------------------]]--[[
							  
	Copyright wiltOS Technologies LLC, 2021
	
	Contact: www.wiltostech.com
		
----------------------------------------]]--

























































































































































wOS = wOS || {}
wOS.PES = wOS.PES || {}
wOS.PES.Triggers = wOS.PES.Triggers || {}
wOS.PES.Triggers.Data = wOS.PES.Triggers.Data || {}
wOS.PES.SubEvents = wOS.PES.SubEvents || {}
wOS.PES.SubEvents.Data = wOS.PES.SubEvents.Data || {}

net.Receive("wOS.PES.Triggers.Sync",function()
    wOS.PES.Triggers.Data = net.ReadTable()
end)

net.Receive("wOS.PES.SubEvents.Sync",function()
    wOS.PES.SubEvents.Data = net.ReadTable()
end)

function wOS.PES.NetworkEvent(event)
    if not event then return end
    net.Start("wOS.PES.EventHeader")
        net.WriteString(event.Name)
        net.WriteString(event.oldname)
        net.WriteDouble(#event.subEvents)
        net.WriteDouble(event.random or -1)
    net.SendToServer()

    for index, data in pairs(event.subEvents) do -- Possible crash here
        net.Start("wOS.PES.SubEvent")
            net.WriteString(event.Name)
            net.WriteDouble(index)
            net.WriteTable(data)
        net.SendToServer()
    end
end

function wOS.PES.RequestEventList(callback)

    callback = callback or function() end

    net.Start("wOS.PES.EventList")
        net.WriteString("")
    net.SendToServer()

    net.Receive("wOS.PES.EventList",function()
        local missionNames = net.ReadTable()
        callback(missionNames)
    end)
end

function wOS.PES.RequestEventData(name, callback)
    if not name then return end

    callback = callback or function() end

    local checksum = CurTime() -- To make sure the packet we have is from the right button click

    net.Start("wOS.PES.RequestEventData")
        net.WriteString(name)
        net.WriteDouble(checksum)
    net.SendToServer()

    local event = {
        Name = name,
        subEvents = {},
        Count = 0,
    }

    net.Receive("wOS.PES.EventHeader",function()
        local dChecksum = net.ReadDouble()
        if dChecksum != checksum then return end
        event.MaxCount = net.ReadDouble()
        event.random = net.ReadDouble()
        if event.Count != 0 then
            if event.Count == event.MaxCount then
                callback(event)
            end
        end
    end)

    net.Receive("wOS.PES.RequestEventData",function()
        local dChecksum = net.ReadDouble()
        if dChecksum != checksum then return end

        event.Count = event.Count + 1
        local index = net.ReadDouble()
        local data = net.ReadTable()
        event.subEvents[index] = data
        if event.MaxCount then
            if event.Count == event.MaxCount then
                callback(event)
            end
        end

    end)

end

function wOS.PES.RequestEventStart(eventName)
    if not eventName then return end
    net.Start("wOS.PES.RequestEventStart")
        net.WriteString(eventName)
    net.SendToServer()
end
