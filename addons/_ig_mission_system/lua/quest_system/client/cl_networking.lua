-- Misc --
net.Receive("QUEST_SYSTEM_ChatNotify_Player", function(len)
    local strType = net.ReadString()
    local strMsg = net.ReadString()
    local vecCol = color_black

    if (LocalPlayer().Team) then
        vecCol = team.GetColor(LocalPlayer():Team())
    end

    chat.AddText(vecCol, "[", color_white, strType, vecCol, "] ", color_white, strMsg)
    chat.PlaySound()
end)

-- Quests --
net.Receive("QUEST_SYSTEM_Quest_Add", function(len)
    local strQuest_ID = net.ReadString()
    QUEST_SYSTEM.AvailableQuests[strQuest_ID] = QUEST_SYSTEM.Quests[strQuest_ID]
end)

net.Receive("QUEST_SYSTEM_Quest_Remove", function(len)
    local strQuest_ID = net.ReadString()
    QUEST_SYSTEM.AvailableQuests[strQuest_ID] = nil
end)

net.Receive("QUEST_SYSTEM_Quest_Progress", function(len)
    local numQuest_Progress = net.ReadInt(32)
    LocalPlayer().QUEST_SYSTEM_QuestProgress = numQuest_Progress
end)

net.Receive("QUEST_SYSTEM_Quest_Client", function(len)
    local strQuest_ID = net.ReadString()
    timer.Create(strQuest_ID, QUEST_SYSTEM.Quests[strQuest_ID]["Time"], 1, function() end)
    LocalPlayer().QUEST_SYSTEM_ActiveQuest = strQuest_ID
end)

net.Receive("QUEST_SYSTEM_Quest_Finish", function(len)
    if (timer.Exists(LocalPlayer().QUEST_SYSTEM_ActiveQuest)) then
        timer.Remove(LocalPlayer().QUEST_SYSTEM_ActiveQuest)
    end

    LocalPlayer().QUEST_SYSTEM_ActiveQuest = nil
end)