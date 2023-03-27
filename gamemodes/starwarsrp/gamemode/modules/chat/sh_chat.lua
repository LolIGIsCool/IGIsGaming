if CLIENT then
    CreateConVar("kumo_chatstamp", 0, FCVAR_ARCHIVE, "Hide chat time stamps")
    CreateConVar("kumo_forumoff", 0, FCVAR_ARCHIVE, "Hide all forum notifications")

    hook.Add("OnPlayerChat", "NoChat", function(ply, text) return true end)

    net.Receive("SendChatMessage", function()
        if GetConVar("kumo_chatstamp"):GetBool() then
            local tablechat = net.ReadTable()
            local servertime = net.ReadString()
            table.insert(tablechat, 1, Color(240, 240, 240, 255))
            table.insert(tablechat, 2, servertime)
            chat.AddText(unpack(tablechat))
        else
            local tablechat = net.ReadTable()
            chat.AddText(unpack(tablechat))
        end
    end)
end