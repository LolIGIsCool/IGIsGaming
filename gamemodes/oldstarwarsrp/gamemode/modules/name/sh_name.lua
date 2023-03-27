if CLIENT then
    local meta = FindMetaTable("Player")

    if not meta.OldNick then
        meta.OldNick = meta.Nick
    end

    function meta:Nick()
        return #self:GetNWString("gmName") > 0 and self:GetNWString("gmName") or self:OldNick()
    end

    function meta:GetName()
        return #self:GetNWString("gmName") > 0 and self:GetNWString("gmName") or self:OldNick()
    end

    function meta:Name()
        return #self:GetNWString("gmName") > 0 and self:GetNWString("gmName") or self:OldNick()
    end
end