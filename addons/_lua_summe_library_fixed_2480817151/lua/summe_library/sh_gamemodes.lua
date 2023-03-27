local Player = FindMetaTable("Player")

function SummeLibrary:GetRank(ply)
    if DarkRP then
        local jobTable = ply:getJobTable()
        if not jobTable or jobTable == nil then return false end
        
        return jobTable.name or "NOT FOUND"
    end

    if nut then
        local char = ply:getChar()
        if not char then return false end

        local class = nut.class.list[char:getClass()]
        if not class then return false end

        return class.name or "NOT FOUND"
    end

    if ix then
        local char = ply:GetCharacter()
        if not char then return false end

        local class = ix.class.Get(char:GetClass())
        if not class then return false end

        return class.name or "NOT FOUND"
    end

    if YRP then
        return ply:YRPGetRoleName()
    end

    return false
end

function Player:IsInDarkRPJob(jobNameList)
    if not DarkRP then return false end

    local jobTable = self:getJobTable()
    if not jobTable or jobTable == nil then return false end

    for k, jobName in pairs(jobNameList) do
        if jobTable.name == jobName then
            return true
        end
    end
    return false
end

function Player:IsInDarkRPCat(jobCatList)
    if not DarkRP then return false end

    local jobTable = self:getJobTable()
    if not jobTable or jobTable == nil then return false end

    for k, jobCat in pairs(jobCatList) do
        if jobTable.category == jobCat then
            return true
        end
    end
    return false
end