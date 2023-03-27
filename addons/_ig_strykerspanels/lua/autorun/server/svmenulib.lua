util.AddNetworkString("NETOIGLIBRARYMenu")

concommand.Add("igmenulibrary", function(ply)
    net.Start("NETOIGLIBRARYMenu")
    net.Send(ply)
end)

concommand.Add("igstructuremenu", function(ply)
    net.Start("NETOSTRUCTMenu")
    net.Send(ply)
end)

concommand.Add("igaosmenu", function(ply)
    if ply:IsAdmin() or ply:CanUseAOSSystem() then
        net.Start("AOSMenuMoose3")
        net.WriteTable(AOSPLAYERS)
        net.Send(ply)
    end
end)

concommand.Add("igbookingmenu", function(ply)
    if ply:GetRegiment() == "Imperial Navy" or ply:GetRegiment() == "Imperial Security Bureau" or ply:GetRegiment() == "Regional Government" or ply:GetRegiment() == "Imperial High Command" or ply:IsAdmin() then
        net.Start("netopenbookingmenu")
        net.WriteTable(hangarbookings)
        net.Send(ply)
    end
end)