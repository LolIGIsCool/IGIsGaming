if SERVER then util.AddNetworkString("SummeLib.Messages.Chat") end

function SummeLibrary:Chat(ply, addon, ...)

    if SERVER then
        net.Start("SummeLib.Messages.Chat")
        net.WriteString(addon)
        net.WriteTable({...})
        net.Send(ply)
    else
        local addonData = SummeLibrary.Addons[addon] or SummeLibrary.Addons["main"]
        local args = { ... } 

        chat.AddText(addonData.color, addonData.name, Color(90,90,90)," » ", Color(255,255,255), unpack(args))
    end
end

if CLIENT then
    net.Receive("SummeLib.Messages.Chat", function(len)
        local addonData = SummeLibrary.Addons[net.ReadString()] or SummeLibrary.Addons["main"]
        local args = net.ReadTable()

        chat.AddText(addonData.color, addonData.name, Color(90,90,90)," » ", Color(255,255,255), unpack(args))
    end)
end