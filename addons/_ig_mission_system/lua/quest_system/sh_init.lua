function QUEST_SYSTEM.LoadQuests()
    QUEST_SYSTEM.Quests = {}
    QUEST_SYSTEM.AvailableQuests = {}

    if game.GetMap() == "rp_deathstar_v1_2" then
        local files, _ = file.Find("quest_system/shared/quests/deathstar/*.lua", "LUA")

        for _, file in ipairs(files) do
            local strQuest_ID = string.gsub(file, ".lua", "")

            if (SERVER) then
                AddCSLuaFile("quest_system/shared/quests/deathstar/" .. file)
            end

            QUEST = {}
            include("quest_system/shared/quests/deathstar/" .. file)
            QUEST.ID = strQuest_ID
            QUEST_SYSTEM.Quests[strQuest_ID] = QUEST
            QUEST = nil
        end
    elseif game.GetMap() == "rp_stardestroyer_v2_6_inf" then
        local files, _ = file.Find("quest_system/shared/quests/stardestroyer/*.lua", "LUA")

        for _, file in ipairs(files) do
            local strQuest_ID = string.gsub(file, ".lua", "")

            if (SERVER) then
                AddCSLuaFile("quest_system/shared/quests/stardestroyer/" .. file)
            end

            QUEST = {}
            include("quest_system/shared/quests/stardestroyer/" .. file)
            QUEST.ID = strQuest_ID
            QUEST_SYSTEM.Quests[strQuest_ID] = QUEST
            QUEST = nil
        end
    elseif game.GetMap() == "rp_lothal" then
        local files, _ = file.Find("quest_system/shared/quests/lothal/*.lua", "LUA")

        for _, file in ipairs(files) do
            local strQuest_ID = string.gsub(file, ".lua", "")

            if (SERVER) then
                AddCSLuaFile("quest_system/shared/quests/lothal/" .. file)
            end

            QUEST = {}
            include("quest_system/shared/quests/lothal/" .. file)
            QUEST.ID = strQuest_ID
            QUEST_SYSTEM.Quests[strQuest_ID] = QUEST
            QUEST = nil
        end
    else
        local files, _ = file.Find("quest_system/shared/quests/event/*.lua", "LUA")

        for _, file in ipairs(files) do
            local strQuest_ID = string.gsub(file, ".lua", "")

            if (SERVER) then
                AddCSLuaFile("quest_system/shared/quests/event/" .. file)
            end

            QUEST = {}
            include("quest_system/shared/quests/event/" .. file)
            QUEST.ID = strQuest_ID
            QUEST_SYSTEM.Quests[strQuest_ID] = QUEST
            QUEST = nil
        end
    end
end

hook.Add("Initialize", "QUEST_SYSTEM_RegisterQuestsaye", function()
    QUEST_SYSTEM.LoadQuests()
end)

function LoadULXQTable()
    ulx_quest_table = {}
    if (QUEST_SYSTEM.Quests) then
        for k, v in pairs(QUEST_SYSTEM.Quests) do
            table.insert(ulx_quest_table, tostring(v.ID))
        end
    else
        timer.Simple(3, LoadULXQTable)
    end
end

LoadULXQTable()
