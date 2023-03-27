QUEST.Name = "Run 1km"
QUEST.Instruction = "Get a bit of excercise in, go for a run!" -- %s will equal the amount
QUEST.Info = "Run 1km, what else can I say?"
QUEST.Reward = 100 -- credit reward
QUEST.Time = 600 -- how long, in seconds, a player has to complete the quest. 0 = infinite
QUEST.Amount = 1000 -- how many actions required to complete quest
QUEST.Penalty = 0 -- penalty reward

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
    player:QUEST_SYSTEM_ChatNotify("Quest", "You have begun your quest, best of luck. Type !abort to abort and !questinfo for more information.")

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
    player:QUEST_SYSTEM_ChatNotify("Quest", "You have completed the quest, enjoy your reward.")
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
    player:QUEST_SYSTEM_ChatNotify("Quest", "Quest Aborted, better luck next time.")
end

if (SERVER) then
    hook.Add("Move", "TrooperRunQuest", function(ply, move)
        if move:KeyDown(IN_SPEED) and ply:GetVelocity():Length() > 10 then
            if (ply:IsPlayer() and ply.QUEST_SYSTEM_ActiveQuest == "trooper_run") then
                ply:QUEST_SYSTEM_Quest_UpdateProgress(ply.QUEST_SYSTEM_QuestProgress + 0.0625)

                if (ply.QUEST_SYSTEM_QuestProgress >= QUEST_SYSTEM.Quests[ply.QUEST_SYSTEM_ActiveQuest]["Amount"]) then
                    ply:QUEST_SYSTEM_Quest_Finish()
                end
            end
        end
    end)
end