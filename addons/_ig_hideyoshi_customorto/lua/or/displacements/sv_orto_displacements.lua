util.AddNetworkString("HideyoshiOR.SetOrtoDisplacements")

net.Receive("HideyoshiOR.SetOrtoDisplacements", function(len, ply)
	sv_HideyoshiSetDisplacements(ply, net.ReadString(), net.ReadString(), net.ReadString(), net.ReadTable())
end)

function sv_HideyoshiSetDisplacements(ply, displacement, Material1, Material2, data)
    -- BEGONE LOSERS
    if !ply or !displacement or !Material1 or !Material2 or !data then return end
    --if !ply:IsUserGroup("superadmin") or !ply:IsUserGroup("developer") then return end
    if (Material1 == "error") or (Material2 == "error") then return end

    data.newMaterial = Material1
    data.newMaterial2 = Material2
    sh_HideyoshiApplyChanges(ply, data, true)
end