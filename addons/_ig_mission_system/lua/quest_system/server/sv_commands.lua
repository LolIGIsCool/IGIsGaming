concommand.Add("ig_spawnquestnpc", function(player)
    if not (player:IsValid() and player:IsSuperAdmin()) then
        print("You are not a superadmin or you are not a player")

        return
    end

    local dataTrace = {}
    dataTrace.start = player:EyePos()
    dataTrace.endpos = dataTrace.start + player:GetAimVector() * 85
    dataTrace.filter = player
    local entNPC = ents.Create("npc_questgiver")
    entNPC:SetPos(util.TraceLine(dataTrace).HitPos)
    entNPC:Spawn()
    player:QUEST_SYSTEM_ChatNotify("IGNPC", "Quest NPC spawned")
    print("Quest NPC spawned by" .. player:Nick())
end)

concommand.Add("ig_savequestnpc", function(player)
    if not (player:IsValid() and player:IsSuperAdmin()) then
        print("You are not a superadmin or you are not a player")

        return
    end

    local tblNPCs = {}

    for _, theentity in pairs(ents.FindByClass("npc_questgiver")) do
        theentity.Data = {
            ["pos"] = theentity:GetPos(),
            ["ang"] = theentity:GetAngles()
        }

        table.insert(tblNPCs, theentity.Data)
    end

    file.Write("npc_questgiver_"..game.GetMap()..".txt", util.TableToJSON(tblNPCs))
    player:QUEST_SYSTEM_ChatNotify("IGNPC", "Quest NPC saved")
    print("Quest NPCs saved by" .. player:Nick())
end)

concommand.Add("ig_clearquestnpc", function(player)
    if not (player:IsValid() and player:IsSuperAdmin()) then
        print("You are not a superadmin or you are not a player")

        return
    end

    for _, theentity in pairs(ents.FindByClass("npc_questgiver")) do
        theentity:Remove()
    end

    file.Delete("npc_questgiver_"..game.GetMap()..".txt")
    player:QUEST_SYSTEM_ChatNotify("IGNPC", "Quest NPCs cleared")
    print("Quest NPCs cleared by" .. player:Nick())
end)

concommand.Add("ig_spawnlottonpc", function(player)
    if not (player:IsValid() and player:IsSuperAdmin()) then
        print("You are not a superadmin or you are not a player")

        return
    end

    local dataTrace = {}
    dataTrace.start = player:EyePos()
    dataTrace.endpos = dataTrace.start + player:GetAimVector() * 85
    dataTrace.filter = player
    local entNPC = ents.Create("npc_lottogiver")
    entNPC:SetPos(util.TraceLine(dataTrace).HitPos)
    entNPC:Spawn()
end)

concommand.Add("ig_savelottonpc", function(player)
    if not (player:IsValid() and player:IsSuperAdmin()) then
        print("You are not a superadmin or you are not a player")

        return
    end

    local tblNPCs = {}

    for _, theentity in pairs(ents.FindByClass("npc_lottogiver")) do
        theentity.Data = {
            ["pos"] = theentity:GetPos(),
            ["ang"] = theentity:GetAngles()
        }

        table.insert(tblNPCs, theentity.Data)
    end
    player:QUEST_SYSTEM_ChatNotify("IGNPC", "Lotto NPCs saved")
    file.Write("npc_lottogiver_"..game.GetMap()..".txt", util.TableToJSON(tblNPCs))
end)

concommand.Add("ig_clearlottonpc", function(player)
    if not (player:IsValid() and player:IsSuperAdmin()) then
        print("You are not a superadmin or you are not a player")

        return
    end

    for _, theentity in pairs(ents.FindByClass("npc_lottogiver")) do
        theentity:Remove()
    end

    file.Delete("npc_lottogiver_"..game.GetMap()..".txt")
end)

concommand.Add("ig_reloadlottonpc", function(player)
    if not (player:IsValid() and player:IsSuperAdmin()) then
        print("You are not a superadmin or you are not a player")

        return
    end

    for _, theentity in pairs(ents.FindByClass("npc_lottogiver")) do
        theentity:Remove()
    end
    local tblNPCs = util.JSONToTable(file.Read("npc_lottogiver_"..game.GetMap()..".txt"))
    if (tblNPCs) then
        for _, dataNPC in pairs(tblNPCs) do
            local theentity = ents.Create("npc_lottogiver")
            theentity:SetPos(dataNPC["pos"])
            theentity:SetAngles(dataNPC["ang"])
            theentity:Spawn()
        end
    end
end)