local meta = FindMetaTable("Player")

function meta:SetPlayerName(name)
    local MooseSetPlayerName = hook.Call("MooseSetPlayerName", GAMEMODE, self, name)
    self:SetNWString("gmName", name)
    self:SetIGData("name", name)
end

if not meta.OldNick then
    meta.OldNick = meta.Nick
end

function meta:GetPlayerName()
    return self:GetNWString("gmName", self:OldNick())
end

function meta:Nick()
    return self:GetPlayerName()
end

function meta:GetName()
    return self:GetPlayerName()
end

function meta:Name()
    return self:GetPlayerName()
end

hook.Add("PlayerInitialSpawn", "FixNames", function(ply)
    ply:SetNWString("gmName", ply:GetIGData("name", ply:OldNick()))
end)