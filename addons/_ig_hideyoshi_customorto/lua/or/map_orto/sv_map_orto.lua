util.AddNetworkString("HideyoshiOR.SetOrtoGround")

net.Receive("HideyoshiOR.SetOrtoGround", function(len, ply)
	sv_HideyoshiSetOrtoGround(ply, net.ReadString(), net.ReadString(), net.ReadTable())
end)

function sv_HideyoshiSetOrtoGround(ply, displacement, Material1, data)
    -- BEGONE LOSERS
    if !ply or !displacement or !Material1 or !data then return end
    --if !ply:IsUserGroup("superadmin") or !ply:IsUserGroup("developer") then return end
    if (Material1 == "error") then return end

    data.newMaterial = Material1
    sh_HideyoshiApplyChanges(ply, data, true)
end