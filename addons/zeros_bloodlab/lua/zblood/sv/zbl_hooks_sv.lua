if CLIENT then return end

// Here are some Hooks you can use for Custom Code
// If you need any more hooks just open a ticket or write me on steam

// This hook gets called before anything else and can be used to prevent a player from getting infected, no matter what
// Its a simpler version of zbl.config.ProtectionCheck
hook.Add("zbl_BlockInfection", "zbl_BlockInfection_Test", function(ply, vaccine_id)

    /*
    // Return true to block the player getting infected
    if ply:IsSuperAdmin() then
        return true
    end
    */

end)

// Called when a player gets infected
hook.Add("zbl_OnPlayerInfect", "zbl_OnPlayerInfect_Test", function(ply, vaccine_id)
    /*
    print("zbl_OnPlayerInfect")
    print("Player: " .. tostring(ply))
    print("VaccineID: " .. vaccine_id)
    print("-----------------------------")
    */
end)

// Called when a player injects another player
hook.Add("zbl_OnPlayerInject", "zbl_OnPlayerInject_Test", function(target, vaccine_id, inflictor)
    /*
    print("zbl_OnPlayerInject")
    print("Target: " .. tostring(target))
    print("Inflictor: " .. tostring(inflictor))
    print("VaccineID: " .. vaccine_id)
    print("-----------------------------")
    */
end)


// Called when a player cures another player
hook.Add("zbl_OnPlayerCurePlayer", "zbl_OnPlayerCurePlayer_Test", function(target, vaccine_id, inflictor)
    /*
    print("zbl_OnPlayerInject")
    print("Target: " .. tostring(target))
    print("Inflictor: " .. tostring(inflictor))
    print("VaccineID: " .. vaccine_id)
    print("-----------------------------")
    */
end)

// Called when a player gets a sample from a other player or entity
hook.Add("zbl_OnPlayerGetSample", "zbl_OnPlayerGetSample_Test", function(target, inflictor, sample_name, sample_identifier, sample_points)
    /*
    print("zbl_OnPlayerGetSample")
    print("Target: " .. tostring(target))
    print("Inflictor: " .. tostring(inflictor))
    print("Sample_name: " .. sample_name)
    print("Sample_identifier: " .. sample_identifier)
    print("Sample_points: " .. sample_points)
    print("-----------------------------")
    */
end)

// Called when a player gets cured
hook.Add("zbl_OnPlayerCured", "zbl_OnPlayerCured_Test", function(ply, vaccine_id)
    /*
    print("zbl_OnPlayerCured")
    print("Player: " .. tostring(ply))
    print("VaccineID: " .. vaccine_id)
    print("-----------------------------")
    */
end)

// Called when a player gets scanned by a fence
hook.Add("zbl_OnPlayerFenceScanned", "zbl_OnPlayerFenceScanned_Test", function(ply, fence_entity)

end)
