QUEST.Name = "IHC Personnel Guard"
QUEST.Instruction = "Guard IHC personnel for 10 minutes." -- %s will equal the amount
QUEST.Info = "Do your job, not very hard."
QUEST.Reward = 1200 -- credit reward
QUEST.Time = 0 -- how long, in seconds, a player has to complete the quest. 0 = infinite
QUEST.Amount = 600 -- how many actions required to complete quest
QUEST.Penalty = 100 -- penalty reward

-- called when a player accepts the quest
function QUEST:OnStarted(player, strQuest_ID, acceptedOnline)
    if (acceptedOnline) then
        QUEST_SYSTEM.AvailableQuests[strQuest_ID] = nil
        net.Start("QUEST_SYSTEM_Quest_Remove")
        net.WriteString(strQuest_ID)
        net.Broadcast()
    end

    player:QUEST_SYSTEM_Quest_UpdateQuest(strQuest_ID)
    player:QUEST_SYSTEM_Quest_UpdateProgress(0)
    player:QUEST_SYSTEM_ChatNotify("Mission", "You have begun your mission, best of luck. Type !abort to abort and !missioninfo for more information.")

    if (QUEST_SYSTEM.Quests[strQuest_ID]["Time"] > 0) then
        timer.Create(player.QUEST_SYSTEM_ActiveQuest .. "_" .. player:SteamID64(), QUEST_SYSTEM.Quests[strQuest_ID]["Time"], 1, function()
            if (IsValid(player)) then
                player:QUEST_SYSTEM_Quest_Abort()
            end
        end)
    end
end

-- called when a player finishes the quest
function QUEST:OnFinished(player)
    if (player.QUEST_SYSTEM_QuestProgress < QUEST_SYSTEM.Quests[player.QUEST_SYSTEM_ActiveQuest]["Amount"]) then return end

    if (timer.Exists(player.QUEST_SYSTEM_ActiveQuest .. "_" .. player:SteamID64())) then
        timer.Remove(player.QUEST_SYSTEM_ActiveQuest .. "_" .. player:SteamID64())
    end

    -- REWARD FUNCTION GOES HERE ^^^^
    player.QUEST_SYSTEM_ActiveQuest = nil
    player:QUEST_SYSTEM_Quest_UpdateProgress(0)
    net.Start("QUEST_SYSTEM_Quest_Finish")
    net.Send(player)
    player:EmitSound("vo/coast/odessa/male01/nlo_cheer01.wav")
    player:QUEST_SYSTEM_ChatNotify("Missions", "You have completed the mission, enjoy your reward.")
end

-- called when a player aborts(or time runs out) the quest
function QUEST:OnAborted(player)
    if (timer.Exists(player.QUEST_SYSTEM_ActiveQuest .. "_" .. player:SteamID64())) then
        timer.Remove(player.QUEST_SYSTEM_ActiveQuest .. "_" .. player:SteamID64())
    end

    player.QUEST_SYSTEM_ActiveQuest = nil
    player:QUEST_SYSTEM_Quest_UpdateProgress(0)
    net.Start("QUEST_SYSTEM_Quest_Finish")
    net.Send(player)
    player:QUEST_SYSTEM_ChatNotify("Missions", "Mission Aborted, better luck next time.")
end

if (SERVER) then
    local IHCMembers = {}

    local function getIHCMembers()
        IHCMembers = {}

        for k, v in pairs(player.GetAll()) do
            if v:GetRegiment() == "Imperial High Command" then
                table.insert(IHCMembers, v)
            end
        end
    end

    timer.Create("getIHCMembersTimer", 10, 0, getIHCMembers)

    local function guardingIHC()
        for k, v in pairs(player.GetAll()) do
            for a, b in pairs(IHCMembers) do
                if v:IsValid() and v.QUEST_SYSTEM_ActiveQuest == "guardply_ihc" then
                    if v:GetPos():Distance(b:GetPos()) < 100 then
                        v:QUEST_SYSTEM_Quest_UpdateProgress(v.QUEST_SYSTEM_QuestProgress + 1)

                        if (v.QUEST_SYSTEM_QuestProgress >= QUEST_SYSTEM.Quests[v.QUEST_SYSTEM_ActiveQuest]["Amount"]) then
                            v:QUEST_SYSTEM_Quest_Finish()
                        end
                    end
                end
            end
        end
    end

    timer.Create("isguardihc", 1, 0, guardingIHC)
end
