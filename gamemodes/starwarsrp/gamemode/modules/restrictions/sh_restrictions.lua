hook.Add("PlayerSpawnProp", "StopPropSpawns", function(ply)
    if ply:IsAdmin() or ply:IsUserGroup("Sudo") or ply:HasWeapon("weapon_physgun") or ply:HasWeapon("gmod_tool") then return true end

    return false
end)

hook.Add("PlayerSpawnRagdoll", "StopRagdollSpawns", function(ply)
    if ply:IsAdmin() then return true end

    return false
end)

hook.Add("PlayerSpawnNPC", "StopNPCSpawns", function(ply)
    if ply:IsAdmin() or ply:IsUserGroup("Sudo") then return true end

    return false
end)

hook.Add("PlayerSpawnEffect", "StopEffectSpawns", function(ply)
    if ply:IsAdmin() then return true end

    return false
end)

hook.Add("PlayerSpawnSENT", "StopSENTSpawns", function(ply)
    if ply:IsAdmin() or ply:SteamID() == "STEAM_0:0:52423713" then return true end

    return false
end)

hook.Add("PlayerSpawnVehicle", "StopVehicleSpawns", function(ply)
    if ply:IsAdmin() then return true end

    return false
end)

hook.Add("SpawnMenuOpen", "RestrictSpawnMenuAdmin", function(ply)
    if LocalPlayer():IsAdmin() or LocalPlayer():IsUserGroup("Sudo") or LocalPlayer():HasWeapon("weapon_physgun") then return end

    return false
end)

hook.Add("PlayerSpawnSWEP", "StopSWEPSpawnsTwo", function(ply)
    if ply:IsAdmin() then return true end

    return false
end)

hook.Add("PlayerGiveSWEP", "StopSWEPSpawningThree", function(ply)
    if ply:IsAdmin() then return true end

    return false
end)