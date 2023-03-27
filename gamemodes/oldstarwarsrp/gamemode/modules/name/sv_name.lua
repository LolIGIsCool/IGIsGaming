local meta = FindMetaTable("Player")

function meta:SetPlayerName(name)
    hook.Call("MooseSetPlayerName", GAMEMODE, self, name)
    self:SetNWString("gmName", name)
    self:SetJData("name", name)
end

function meta:GetPlayerName()
    return self:GetJData("name", self:OldNick())
end

if not meta.OldNick then
    meta.OldNick = meta.Nick
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
    ply:SetNWString("gmName", ply:GetJData("name", ""))
end)