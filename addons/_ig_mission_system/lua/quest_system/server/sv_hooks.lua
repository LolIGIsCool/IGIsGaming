hook.Add("InitPostEntity", "QUEST_SYSTEM_SpawnNPCs", function()
    if (file.Exists("npc_questgiver_"..game.GetMap()..".txt", "DATA")) then
        local tblNPCs = util.JSONToTable(file.Read("npc_questgiver_"..game.GetMap()..".txt"))
        if (tblNPCs) then
        	for _, dataNPC in pairs(tblNPCs) do
            	local theentity = ents.Create("npc_questgiver")
            	theentity:SetPos(dataNPC["pos"])
            	theentity:SetAngles(dataNPC["ang"])
            	theentity:Spawn()
        	end
    	end
    end
end)

hook.Add("InitPostEntity", "QUEST_SYSTEM_SpawnLOTTONPCs", function()
    if (file.Exists("npc_lottogiver_"..game.GetMap()..".txt", "DATA")) then
        local tblNPCs = util.JSONToTable(file.Read("npc_lottogiver_"..game.GetMap()..".txt"))
        if (tblNPCs) then
            for _, dataNPC in pairs(tblNPCs) do
                local theentity = ents.Create("npc_lottogiver")
                theentity:SetPos(dataNPC["pos"])
                theentity:SetAngles(dataNPC["ang"])
                theentity:Spawn()
            end
        end
    end
end)

-- Quest --
hook.Add("PlayerInitialSpawn", "QUEST_SYSTEM_Quests_Available", function(player)
    timer.Simple(3, function()
        local questactive = player:GetPData("quest_active", false)
        local questid = player:GetPData("quest_id", nil)
        local questprogress = player:GetPData("quest_progress", 0)

        for _, quest in pairs(QUEST_SYSTEM.AvailableQuests) do
            net.Start("QUEST_SYSTEM_Quest_Add")
            net.WriteString(quest["ID"])
            net.Send(player)
        end

        if (questactive) and not questid == "trooper_patrol" then
            QUEST_SYSTEM.Quests[questid]:OnStarted(player, questid, false)
            player:QUEST_SYSTEM_Quest_UpdateProgress(tonumber(questprogress))
        elseif (questactive) and questid == "trooper_patrol" then
            QUEST_SYSTEM.Quests[questid]:OnStarted(player, questid, false)
        end 

        player:RemovePData("quest_active")
        player:RemovePData("quest_id")
        player:RemovePData("quest_progress")
    end)
end)    

hook.Add("PlayerDisconnected", "QUEST_SYSTEM_Quest_AbortSave", function(player)
    if (player.QUEST_SYSTEM_ActiveQuest) then
        player:SetPData("quest_active", true)
        player:SetPData("quest_id", player.QUEST_SYSTEM_ActiveQuest)
        player:SetPData("quest_progress", tonumber(player.QUEST_SYSTEM_QuestProgress))
    end

    player:QUEST_SYSTEM_Quest_Abort()
end)

hook.Add("IGPlayerSay", "AbortQuest", function(player, text)
    if (string.sub(string.lower(text), 1, 6) == "!abort") and (player.QUEST_SYSTEM_ActiveQuest) then
        player:QUEST_SYSTEM_Quest_Abort()
    end
end)

hook.Add("IGPlayerSay", "QuestInfoCMD", function(player, text)
    if (string.sub(string.lower(text), 1, 12) == "!missioninfo") and (player.QUEST_SYSTEM_ActiveQuest) then
        local playerquest = player.QUEST_SYSTEM_ActiveQuest

        if (QUEST_SYSTEM.Quests[playerquest]["Info"]) then
            player:QUEST_SYSTEM_ChatNotify("Missions", QUEST_SYSTEM.Quests[playerquest]["Info"])
        else
            player:QUEST_SYSTEM_ChatNotify("Missions", "No additional information given")
        end
    end
end)

hook.Add("InitPostEntity", "QUEST_SYSTEM_Quest_SpawnItems", function()
    for _, quest in pairs(QUEST_SYSTEM.Quests) do
        if (quest["Item"]) then
            QUEST_SYSTEM.Quest_SpawnItems(quest["ID"])
        end
    end
end)