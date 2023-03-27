util.AddNetworkString("SummeLib.Notification")

function SummeLibrary:Notify(ply, type, header, text)
    net.Start("SummeLib.Notification")
    net.WriteString(type or "info")
    net.WriteString(header or "UNDEFINED")
    net.WriteString(text or "UNDEFINED")
    net.Send(ply)
end