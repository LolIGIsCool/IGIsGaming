gProtect = gProtect or {}

local function overrideCPPI()
    local ENTITY = FindMetaTable("Entity")
    local PLAYER = FindMetaTable("Player")

    ENTITY.oldCPPIGetOwner = ENTITY.oldCPPIGetOwner or ENTITY.CPPIGetOwner
    function ENTITY:CPPIGetOwner()
        local result = gProtect.GetOwner(self)
        
        if isstring(result) and isfunction(ENTITY.oldCPPIGetOwner) then result = self:oldCPPIGetOwner() end

        return (isstring(result) and nil or result), 200
    end

    function PLAYER:CPPIGetFriends()
        local friends_tbl = CLIENT and gProtect.BuddiesData or gProtect.TouchPermission
        local sid = self:SteamID()
        local found_friends = {}
        local result = {}

        if friends_tbl[sid] then
            for k, v in pairs(friends_tbl[sid]) do
                if !istable(v) then continue end
                for sid, v in pairs(v) do
                    found_friends[sid] = true
                end
            end
        end

        for k, v in pairs(found_friends) do
            table.insert(result, k)
        end
        
        return result
    end

    if SERVER then
        ENTITY.oldCPPISetOwner = ENTITY.oldCPPISetOwner or ENTITY.CPPISetOwner
        function ENTITY:CPPISetOwner(ply)
            if isfunction(ENTITY.oldCPPISetOwner) then
                self:oldCPPISetOwner(ply)
            end

            if !IsValid(ply) then return end
            gProtect.SetOwner(ply, self)
        end

        function ENTITY:CPPICanTool(ply, tool)            
            return gProtect.HandlePermissions(ply, self, "gmod_tool")
        end
    
        function ENTITY:CPPICanPhysgun(ply)
            return gProtect.HandlePermissions(ply, self, "weapon_physgun")
        end
    
        function ENTITY:CPPICanPickup(ply)
            return gProtect.HandlePermissions(ply, self, "weapon_physcannon")
        end
    
        function ENTITY:CPPICanPunt(ply)
            return !gProtect.GetConfig("DisableGravityGunPunting", "gravitygunsettings")
        end
    end
end

timer.Simple(3, function()
    overrideCPPI()
end)